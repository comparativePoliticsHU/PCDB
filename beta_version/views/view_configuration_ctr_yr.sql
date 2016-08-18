CREATE OR REPLACE VIEW beta_version.view_configuration_ctr_yr
AS 
WITH
configs AS (SELECT * FROM beta_version.mv_configuration_events) , -- WITH AS configs
country_years AS (SELECT ctr_id, year::NUMERIC(4,0) FROM -- cross-product of all countries and series of years
			(SELECT DATE_PART('year', years::date) AS year
				FROM generate_series( (SELECT min(sdate) FROM configs), (SELECT current_date), INTERVAL '1 year') AS years
			) AS YEARS
			, (SELECT DISTINCT ctr_id FROM configs) AS COUNTRIES ) , -- WITH AS country_years
 matches AS (SELECT ctr_id, year, COALESCE(matched, NULL, FALSE) AS matched 
			FROM country_years
		FULL OUTER JOIN -- joins complete list of country-years with country-year combinations enlisted in confuguration_events
			(SELECT DISTINCT ctr_id, year, TRUE::BOOLEAN AS matched FROM configs ) AS DATA 
		USING(ctr_id, year) ) , -- WITH as matches 
configs_in_year AS (SELECT ctr_id, year, sdate, edate, 
			DATE_PART('year', sdate) AS syear, DATE_PART('year', edate) AS eyear 
				FROM  configs
				WHERE (ctr_id, year) -- conditions on country-year combinations enlisted in confuguration_events 
					IN (SELECT DISTINCT ON (ctr_id, year) ctr_id, year FROM matches WHERE matched = TRUE) 
			UNION -- for all country-year combinations not enlisted in confuguration_events, select temporarily most proximate configuration with lower start year than current year as 'then still active' configuration
			SELECT MATCHES.ctr_id as ctr_id, MATCHES.year AS year, max(sdate) AS sdate, max(edate) AS edate, 
				DATE_PART('year', max(sdate)) AS syear, DATE_PART('year', max(edate)) AS eyear 
				FROM
				(SELECT ctr_id, year, max(sdate) AS sdate, max(edate) AS edate
					FROM configs GROUP BY ctr_id, year ) AS MAX_SDATE
				, 
				(SELECT ctr_id, year FROM matches WHERE matched = FALSE ) AS MATCHES
				WHERE MAX_SDATE.ctr_id = MATCHES.ctr_id
				AND MAX_SDATE.year < MATCHES.year
				GROUP BY MATCHES.year, MATCHES.ctr_id ) , -- WITH as configs_in_year
durations AS (SELECT ctr_id, sdate, edate, year, ((edate+1)-sdate)::INT AS duration_in_year 
			FROM configs_in_year 
			WHERE syear = eyear
		UNION
		SELECT ctr_id, sdate, edate, syear AS year, 
			(TO_TIMESTAMP(''|| syear::INT+1 ||'-01-01', 'YYYY-MM-DD')::DATE-sdate) AS duration_in_year -- duration from start day in start year to first day of next year gives duration in year of start
			FROM configs_in_year
			WHERE syear < eyear -- for configurations that do end in later year than that in which they started 
		UNION
		SELECT ctr_id, sdate, edate, eyear AS year, 
			(edate-TO_TIMESTAMP(''|| eyear::INT-1 ||'-12-31', 'YYYY-MM-DD')::DATE) AS duration_in_year -- duration from last  day of year before end year to end day in end year gives duration in year of end
			FROM configs_in_year 
			WHERE syear < eyear -- for configurations that do end in later year than that in which they started
		UNION
		SELECT ctr_id, sdate, edate, year, 
			(SELECT count(*) 
				FROM   generate_series(
				TO_TIMESTAMP(''|| year::INT ||'-01-01', 'YYYY-MM-DD')::DATE,
				TO_TIMESTAMP(''|| year::INT ||'-12-31', 'YYYY-MM-DD')::DATE, 
				'1 day') d(the_day)
			) AS duration_in_year -- duration from first to last day gives duration in year(s) between start and end year
			FROM configs_in_year
			WHERE year != syear -- for configurations that span over a complete year
			AND year != eyear 
		) -- WITH AS durations
SELECT 	ctr_id, 
	representative_configs.year::NUMERIC,
	representative_configs.sdate, configs.edate,
	configs.cab_id, configs.lh_id, configs.lhelc_id, configs.uh_id, configs.prselc_id
FROM
	configs -- get all configurations from materialized view
	RIGHT OUTER JOIN 
		(SELECT ctr_id, year, sdate, duration_in_year
			FROM durations
			WHERE (ctr_id, year, duration_in_year) -- conditions on country's configuration with longest duration in a given year
				IN (SELECT DISTINCT ctr_id, year, max(duration_in_year) 
					OVER (PARTITION BY ctr_id, year) AS duration_in_year
					FROM durations)
			AND (ctr_id, year, sdate) -- selects configuration with lower start date if two configurations have exact same duration in one given year
				IN (SELECT DISTINCT ctr_id, year, min(sdate) 
					OVER (PARTITION BY ctr_id, year, duration_in_year) AS duration_in_year 
					FROM durations) )  AS representative_configs
	USING(ctr_id, sdate)
ORDER BY ctr_id, REPRESENTATIVE_CONFIGS.year;