CREATE OR REPLACE VIEW config_data.view_configuration_vto_jud
AS
SELECT CONFIG_EVENTS.ctr_id, sdate, ROUND(vto_pwr)::SMALLINT AS vto_jud
FROM
	(SELECT ctr_id, sdate
		FROM config_data.mv_configuration_events
	) AS CONFIG_EVENTS
,
	(SELECT ctr_id, vto_pwr, vto_inst_sdate, vto_inst_edate
		FROM config_data.veto_points
		WHERE vto_inst_typ = 'judicial'
	) AS VETO_INST
WHERE CONFIG_EVENTS.ctr_id = VETO_INST.ctr_id
AND CONFIG_EVENTS.sdate >= VETO_INST.vto_inst_sdate
AND CONFIG_EVENTS.sdate <= VETO_INST.vto_inst_edate
ORDER BY ctr_id, sdate NULLS FIRST;
