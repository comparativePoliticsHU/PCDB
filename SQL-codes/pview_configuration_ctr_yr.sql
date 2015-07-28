CREATE OR REPLACE VIEW public.configuration_ctr_yr
AS
SELECT CONFIG.ctr_id, DURATION_W.year, CONFIG.sdate, CONFIG.edate, 
	cab_id, lh_id, uh_id, prselc_id,
	cab_sts_ttl, cab_lh_sts_shr, cab_uh_sts_shr,
	vto_lh, vto_uh, vto_prs, vto_pts, vto_jud, vto_elct, vto_terr, vto_sum,
	config_duration_in_year, 
	COALESCE(config_weight_in_year,1)::NUMERIC(7,5) AS config_weight_in_year, 
	config_duration
FROM
	(SELECT * 
		FROM
			(SELECT DISTINCT ctr_id, sdate, in_year AS year, config_duration_in_year
				FROM config_data.view_configuration_duration_in_year
				ORDER BY ctr_id, in_year
			) AS CONFIGURATION_DURATION_IN_YEAR
		LEFT OUTER JOIN
			(SELECT ctr_id, sdate, config_weight_in_year, year
				FROM config_data.view_config_weight_in_year
			) AS ALL_CONFIGS_WITH_WEIGHTS
		USING(ctr_id, year, sdate)
		ORDER BY ctr_id, year, sdate NULLS FIRST
	) AS DURATION_W
,
	(SELECT * FROM public.configuration) AS CONFIG
		
WHERE 	DURATION_W.ctr_id = CONFIG.ctr_id
AND	DURATION_W.sdate = CONFIG.sdate
AND (DURATION_W.year::numeric+0.1*COALESCE(config_weight_in_year,1))
	IN 
	(SELECT (year::numeric+0.1*config_weight_in_year) AS ctr_yr_identifier
		FROM 
			(SELECT ctr_id, 
				MAX(config_weight_in_year) AS config_weight_in_year, 
				MAX(year) AS year
				FROM config_data.view_config_weight_in_year
				GROUP BY ctr_id, year
			) AS CONFIGS_WITH_HIGHEST_WEIGHT_IN_YEAR
	)
ORDER BY ctr_id, year, sdate;
