CREATE OR REPLACE VIEW beta_version.view_configuration_vto_jud
AS
SELECT CONFIGS.ctr_id, sdate, ROUND(vto_pwr)::SMALLINT AS vto_jud
FROM
	(SELECT ctr_id, sdate FROM beta_version.mv_configuration_events) AS CONFIGS
,
	(SELECT ctr_id, vto_pwr, vto_inst_sdate, vto_inst_edate
		FROM beta_version.veto_points
		WHERE vto_inst_typ = 'judicial'
	) AS VETO_INST
WHERE CONFIGS.ctr_id = VETO_INST.ctr_id
AND CONFIGS.sdate >= VETO_INST.vto_inst_sdate
AND CONFIGS.sdate < VETO_INST.vto_inst_edate
ORDER BY ctr_id, sdate NULLS FIRST;
