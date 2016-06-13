CREATE OR REPLACE VIEW config_data.view_configuration_vto_uh
AS
SELECT VETO_INST.ctr_id, sdate, 
	cab_id, uh_id, cab_uh_sts_shr, vto_pwr AS vto_pwr_uh,
	SIGN(SIGN(vto_pwr-(cab_uh_sts_shr+0.00001))+1)::SMALLINT AS vto_uh
FROM
	(SELECT *
		FROM
			(SELECT  ctr_id, sdate, cab_id, uh_id
				FROM config_data.mv_configuration_events
			) AS CONFIG_EVENTS
		JOIN
			(SELECT ctr_id, sdate, cab_uh_sts_shr
				FROM config_data.view_cab_uh_sts_shr
			) AS CAB_UH_STS_SHR
		USING(ctr_id, sdate)
	) AS CONFIG_EVENTS_w_CAB_UH_STS_SHR
,
	(SELECT ctr_id, vto_pwr, vto_inst_sdate, vto_inst_edate
		FROM config_data.veto_points
		WHERE vto_inst_typ = 'upper house'
	) AS VETO_INST
WHERE CONFIG_EVENTS_w_CAB_UH_STS_SHR.ctr_id = VETO_INST.ctr_id
AND CONFIG_EVENTS_w_CAB_UH_STS_SHR.sdate >= VETO_INST.vto_inst_sdate
AND CONFIG_EVENTS_w_CAB_UH_STS_SHR.sdate <= VETO_INST.vto_inst_edate
ORDER BY ctr_id, sdate NULLS FIRST;
