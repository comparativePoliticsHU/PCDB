CREATE OR REPLACE VIEW beta_version.view_configurations_in_year
AS
WITH matches -- flags country-years for which matching configuration(s) exists as TRUE (else FALSE) 
	AS (
	SELECT ctr_id, year, COALESCE(matched, NULL, FALSE) AS matched -- matched is defined as FALSE if NULL 
		FROM
			(SELECT ctr_id, year::NUMERIC(4,0) FROM
					(SELECT DATE_PART('year', year::date) AS year
						FROM generate_series( -- generate series of years from lowest recorded to current year
							(SELECT min(sdate) FROM beta_version.mv_configuration_events), 
							(SELECT current_date),
							INTERVAL '1 year') AS year
					) AS YEARS
				, -- compute cross-product of all countries an series of years yields country-year matrix
					(SELECT DISTINCT ctr_id FROM beta_version.mv_configuration_events) AS COUNTRIES
				-- ORDER BY ctr_id, year -- (omission increases efficiency)
			) AS COUNTRY_YEARS
		FULL OUTER JOIN -- joins complete list of country-years with country-year combinations enlisted in confuguration_events
			(SELECT DISTINCT ctr_id, year, TRUE::BOOLEAN AS matched 
				FROM beta_version.mv_configuration_events 
				-- ORDER BY ctr_id, year -- (omission increases efficiency)
			) AS DATA -- get all configurations from materialized view
		USING(ctr_id, year)
	) -- WITH as matches 
SELECT ctr_id, year, sdate, edate, DATE_PART('year', sdate) AS syear, DATE_PART('year', edate) AS eyear 
	FROM  beta_version.mv_configuration_events
	WHERE (ctr_id, year) -- conditions on country-year combinations enlisted in confuguration_events 
		IN (SELECT DISTINCT ON (ctr_id, year) ctr_id, year FROM matches WHERE matched = TRUE) 
UNION -- for all country-year combinations not enlisted in confuguration_events, select temporally closest configuration with lower start year than current year as 'then still active' configuration
SELECT MATCHES.ctr_id as ctr_id, MATCHES.year AS year, max(sdate) AS sdate, max(edate) AS edate, DATE_PART('year', max(sdate)) AS syear, DATE_PART('year', max(edate)) AS eyear 
	FROM
	(SELECT ctr_id, year, max(sdate) AS sdate, max(edate) AS edate
		FROM beta_version.mv_configuration_events 
		GROUP BY ctr_id, year
		-- ORDER BY ctr_id, year -- (omission increases efficiency)
	) AS MAX_SDATE
, 
	(SELECT ctr_id, year FROM matches WHERE matched = FALSE) AS MATCHES
WHERE MAX_SDATE.ctr_id = MATCHES.ctr_id
AND MAX_SDATE.year < MATCHES.year
GROUP BY MATCHES.year, MATCHES.ctr_id
ORDER BY ctr_id, year, sdate;
 