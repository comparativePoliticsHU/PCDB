CREATE OR REPLACE VIEW config_data.view_configuration_vto_lh
AS
SELECT VETO_INST.ctr_id, sdate, 
	cab_id, lh_id, cab_lh_sts_shr, vto_pwr AS vto_pwr_lh,
	CASE WHEN (cab_lh_sts_shr-vto_pwr)::NUMERIC >= 0 -- if cab has at least seat share of (ordinarily) 50% 
		THEN 0::SMALLINT -- veto point is closed
		ELSE 1::SMALLINT -- else, it's open
	END AS vto_lh
FROM
	(SELECT *
		FROM
			(SELECT  ctr_id, sdate, cab_id, lh_id
				FROM config_data.mv_configuration_events
			) AS CONFIG_EVENTS
		JOIN
			(SELECT ctr_id, sdate, cab_id, lh_id, cab_lh_sts_shr
				FROM config_data.view_cab_lh_sts_shr
			) AS CAB_LH_STS_SHR
		USING(ctr_id, sdate, cab_id, lh_id)
	) AS CONFIG_EVENTS_w_CAB_LH_STS_SHR
,
	(SELECT ctr_id, vto_pwr, vto_inst_sdate, vto_inst_edate
		FROM config_data.veto_points
		WHERE vto_inst_typ = 'lower house'
	) AS VETO_INST
WHERE CONFIG_EVENTS_w_CAB_LH_STS_SHR.ctr_id = VETO_INST.ctr_id
AND CONFIG_EVENTS_w_CAB_LH_STS_SHR.sdate >= VETO_INST.vto_inst_sdate
AND CONFIG_EVENTS_w_CAB_LH_STS_SHR.sdate <= VETO_INST.vto_inst_edate
ORDER BY ctr_id, sdate NULLS FIRST;
