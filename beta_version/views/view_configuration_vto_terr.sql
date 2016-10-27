CREATE OR REPLACE VIEW beta_version.view_configuration_vto_terr
AS
WITH 
	configs AS (SELECT ctr_id, sdate FROM beta_version.mv_configuration_events ),
	veto_inst AS (SELECT ctr_id, vto_pwr, vto_inst_sdate, vto_inst_edate
			FROM beta_version.veto_points
			WHERE vto_inst_typ = 'territorial')
SELECT configs.ctr_id, sdate, ROUND(vto_pwr)::SMALLINT AS vto_terr
FROM configs, veto_inst
WHERE configs.ctr_id = veto_inst.ctr_id
AND configs.sdate >= veto_inst.vto_inst_sdate
AND configs.sdate < veto_inst.vto_inst_edate
ORDER BY ctr_id, sdate NULLS FIRST;