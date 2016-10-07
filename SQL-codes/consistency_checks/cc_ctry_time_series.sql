CREATE OR REPLACE VIEW config_data.cc_ctry_time_series
AS 
SELECT ctr_id, year_diff_ctr, ctr_rows_in_time_series,
	SIGN(year_diff_ctr - ctr_rows_in_time_series)::INT AS mismatch
FROM
	(SELECT DISTINCT ctr_id, (MAX(end_in_year)+1 - MIN(start_in_year))::INT AS year_diff_ctr 
		FROM config_data.view_configuration_year_duplicates
		GROUP BY ctr_id
	) YEAR_DIFF_CY
JOIN
	(SELECT ctr_id, COUNT(in_year)::INT AS ctr_rows_in_time_series
		FROM
			(SELECT DISTINCT ctr_id, in_year
				FROM config_data.view_configuration_year_duplicates
			) DISTINCT_CY_DUPLICATES
		GROUP BY ctr_id
	) N_ROWS_IN_TIME_SERIES
USING(ctr_id)
ORDER BY ctr_id;
