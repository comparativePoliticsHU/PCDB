CREATE OR REPLACE VIEW config_data.view_config_weight_in_year
AS
SELECT ctr_id, sdate, year, config_duration_in_year, year_duration,
	(config_duration_in_year::NUMERIC/year_duration::NUMERIC) AS config_weight_in_year
	FROM
		(SELECT ctr_id, sdate, config_duration_in_year, in_year AS year
			FROM config_data.view_configuration_duration_in_year
		) AS CONFIGURATION_DURATION_IN_YEAR
	LEFT OUTER JOIN
		(SELECT ctr_id, SUM(config_duration_in_year) AS year_duration, in_year AS year
			FROM config_data.view_configuration_duration_in_year
			GROUP BY ctr_id, in_year
		) AS YEAR_DURATION
	USING(ctr_id, year);