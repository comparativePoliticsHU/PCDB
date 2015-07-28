CREATE OR REPLACE VIEW config_data.cc_no_cab_uh_sts_shr
AS
SELECT ctr_id, sdate, CONFIGS.cab_id, 
	CONFIGS.uh_id, cab_uh_sts_shr
	FROM
		(SELECT ctr_id, sdate, cab_id, uh_id, cab_uh_sts_shr
			FROM config_data.view_cab_uh_sts_shr
		) CAB_UH_STS_SHR
	FULL JOIN
		(SELECT ctr_id, sdate, prselc_id, uh_id, lh_id, cab_id, year, edate
			FROM config_data.mv_configuration_events
		) CONFIGS
	USING (ctr_id, sdate)
	WHERE cab_uh_sts_shr IS NULL 
	AND CONFIGS.cab_id IS NOT NULL 
	AND CONFIGS.uh_id IS NOT NULL
ORDER BY ctr_id, sdate NULLS FIRST;