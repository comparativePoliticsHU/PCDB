CREATE OR REPLACE VIEW beta_version.view_configuration_vto_uh
AS
WITH 
configs AS (SELECT ctr_id, sdate, cab_id, uh_id FROM beta_version.mv_configuration_events), -- AS configs
pty_uh_sts_shr AS (SELECT uh_id, pty_id, pty_uh_sts, 
			SUM(pty_uh_sts::NUMERIC) OVER (PARTITION BY uh_id) AS uh_sts_ttl_computed, 
			(pty_uh_sts::NUMERIC / SUM(pty_uh_sts::NUMERIC) OVER (PARTITION BY uh_id)) AS pty_uhelc_sts_shr
			FROM beta_version.uh_seat_results 
			WHERE pty_uh_sts <> 0 ), -- AS pty_uh_sts_shr
cab_uh_configs AS (SELECT * FROM configs LEFT OUTER JOIN pty_uh_sts_shr USING(uh_id) ), -- AS cab_uh_configs
cab_uh_sts_shr AS (SELECT DISTINCT ON (ctr_id, sdate) ctr_id, sdate, cab_id, uh_id, SUM(pty_uhelc_sts_shr) AS cab_uh_sts_shr
			FROM (SELECT cab_id, pty_id, pty_cab FROM beta_version.cabinet_portfolios) AS CAB_PORTFOLIOS
			JOIN cab_uh_configs USING(cab_id, pty_id)
			WHERE pty_cab IS TRUE
			GROUP BY ctr_id, sdate, uh_id, cab_id ), -- AS cab_uh_sts_shr
configs_w_sts_shr AS (SELECT * FROM configs JOIN cab_uh_sts_shr USING(ctr_id, sdate, cab_id, uh_id)), -- AS configs_w_sts_shr
veto_inst AS (SELECT ctr_id, vto_pwr, vto_inst_sdate, vto_inst_edate
		FROM beta_version.veto_points
		WHERE vto_inst_typ = 'upper house')		
SELECT veto_inst.ctr_id, sdate, 
	cab_id, uh_id, cab_uh_sts_shr, vto_pwr AS vto_pwr_uh,
	CASE WHEN (cab_uh_sts_shr-vto_pwr)::NUMERIC >= 0 -- if cab has at least seat share of (ordinarily) 50% 
		THEN 0::SMALLINT -- veto point is closed
		ELSE 1::SMALLINT -- else, it's open
	END AS vto_uh
FROM configs_w_sts_shr, veto_inst
WHERE configs_w_sts_shr.ctr_id = veto_inst.ctr_id
AND configs_w_sts_shr.sdate >= veto_inst.vto_inst_sdate
AND configs_w_sts_shr.sdate < veto_inst.vto_inst_edate
ORDER BY ctr_id, sdate NULLS FIRST;
