CREATE OR REPLACE VIEW config_data.cc_no_cab_lh_sts_shr
AS
SELECT ctr_id, sdate, 
	CONFIGS.cab_id, CONFIGS.lh_id, cab_lh_sts_shr
	FROM
		(SELECT ctr_id, sdate, cab_id, lh_id, cab_lh_sts_shr
			FROM config_data.view_cab_lh_sts_shr
		) CAB_LH_STS_SHR
	FULL JOIN
		(SELECT ctr_id, sdate, prselc_id, uh_id, lh_id, cab_id, year, edate
			FROM config_data.mv_configuration_events
		) CONFIGS
	USING (ctr_id, sdate)
	WHERE cab_lh_sts_shr IS NULL 
	AND CONFIGS.cab_id IS NOT NULL 
	AND CONFIGS.lh_id IS NOT NULL
ORDER BY ctr_id, sdate NULLS FIRST;