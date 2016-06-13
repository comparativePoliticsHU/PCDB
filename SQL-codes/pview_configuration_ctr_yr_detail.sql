CREATE OR REPLACE VIEW public.configuration_ctr_yr_detail
AS
SELECT ctr_id, ctr_ccode, year, sdate, edate, config_duration, 
	cab_id, cab_sdate, cab_hog_n, cab_care, pty_hog, cab_sts_ttl, 
	lh_id, lh_sdate, uh_id, uh_sdate, 
	prselc_id, prs_sdate, prs_n, pty_prs, 
	cab_lh_sts_shr, cab_uh_sts_shr, 
	vto_lh, vto_uh, vto_prs, vto_pts, vto_jud, vto_elct, vto_terr, vto_sum
	FROM
		(SELECT ctr_id, sdate, in_year AS year
			FROM config_data.view_configuration_duration_in_year
		) AS CONFIGURATION_DURATION_IN_YEAR
	LEFT OUTER JOIN
		(SELECT * 
			FROM public.configuration_detail
		) AS CONFIGURATION_DETAIL
	USING(ctr_id, sdate, year)
	WHERE (ctr_id::NUMERIC*100000000+(
			DATE_PART('year', sdate)*10000
			+DATE_PART('month', sdate)*100
			+DATE_PART('day', sdate)
		))::NUMERIC 
		IN 
		(SELECT (ctr_id::NUMERIC*100000000+(
				DATE_PART('year', sdate)*10000
				+DATE_PART('month', sdate)*100
				+DATE_PART('day', sdate)
			))::NUMERIC AS ctr_yr_identifier
			FROM 
				(SELECT ctr_id, sdate, config_weight_in_year, year
					FROM config_data.view_config_weight_in_year
				) AS ALL_CONFIGS_WITH_WEIGHTS
			RIGHT OUTER JOIN
				(SELECT ctr_id, 
					MAX(config_weight_in_year) AS config_weight_in_year, 
					MAX(year) AS year
					FROM config_data.view_config_weight_in_year
					GROUP BY ctr_id, year
				) AS CONFIGS_WITH_HIGHEST_WEIGHT_IN_YEAR 
				-- assummes perfect uniqeness of weights within years
			USING(ctr_id, year, config_weight_in_year)
		)
ORDER BY ctr_id, year;