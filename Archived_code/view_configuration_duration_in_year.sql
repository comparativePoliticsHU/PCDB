CREATE OR REPLACE VIEW config_data.view_configuration_duration_in_year
AS 
SELECT ctr_id, sdate, edate, in_year, 
	config_duration_in_year
FROM
(
SELECT ctr_id, sdate, edate, start_in_year AS in_year,
	((edate+1)-sdate)::INT AS config_duration_in_year
	FROM config_data.view_configuration_year_duplicates
	WHERE start_in_year = end_in_year
UNION 
SELECT ctr_id, sdate, edate, start_in_year AS in_year,
	(TO_TIMESTAMP(''|| start_in_year::INT+1 
	||'-01-01', 'YYYY-MM-DD')::DATE-sdate) 
		AS config_duration_in_year
	FROM config_data.view_configuration_year_duplicates
	WHERE start_in_year < end_in_year
UNION 
SELECT ctr_id, sdate, edate, end_in_year AS in_year,
	(edate-TO_TIMESTAMP(''|| end_in_year::INT-1 
	||'-12-31', 'YYYY-MM-DD')::DATE) 
		AS config_duration_in_year
	FROM config_data.view_configuration_year_duplicates
	WHERE start_in_year < end_in_year
UNION 
SELECT ctr_id, sdate, edate, in_year,
	(SELECT count(*) 
		FROM   generate_series(
		TO_TIMESTAMP(''|| in_year::INT ||'-01-01', 'YYYY-MM-DD')::DATE,
		TO_TIMESTAMP(''|| in_year::INT ||'-12-31', 'YYYY-MM-DD')::DATE, 
		'1 day') d(the_day)
	) AS config_duration_in_year
	FROM config_data.view_configuration_year_duplicates
	WHERE in_year != start_in_year
	AND in_year != end_in_year 
ORDER BY ctr_id, in_year, sdate
) AS CONFIG_YEAR_DUPLICATES;