-- CREATE OR REPLACE VIEW config_data.view_configuration_vto_lh
-- AS
WITH 
configs AS (SELECT ctr_id, sdate, cab_id, lh_id FROM config_data.mv_configuration_events), -- WITH AS configs
pty_lh_sts_shr AS (SELECT lh_id, pty_id, pty_lh_sts, 
			SUM(pty_lh_sts::NUMERIC) OVER (PARTITION BY lh_id) AS lh_sts_ttl_computed,
			(pty_lh_sts::NUMERIC / SUM(pty_lh_sts::NUMERIC) OVER (PARTITION BY lh_id) ) AS pty_lhelc_sts_shr
			FROM config_data.lh_seat_results 
			WHERE pty_lh_sts <> 0), -- WITH AS pty_lhelc_sts_shr
cab_lh_sts_shr AS (SELECT DISTINCT ON (ctr_id, sdate) ctr_id, sdate, cab_id, lh_id, SUM(pty_lhelc_sts_shr) AS cab_lh_sts_shr
			FROM
				(SELECT cab_id, pty_id, pty_cab FROM config_data.cabinet_portfolios ) AS CAB_PORTFOLIOS
			JOIN
				(SELECT * FROM configs LEFT OUTER JOIN pty_lh_sts_shr USING(lh_id) ) AS CAB_LH_CONFIGS
			USING(cab_id, pty_id)
			WHERE pty_cab IS TRUE
			GROUP BY ctr_id, sdate, lh_id, cab_id ), -- WITH AS cab_lh_sts_shr
configs_w_sts_shr AS (SELECT * FROM configs JOIN cab_lh_sts_shr USING(ctr_id, sdate, cab_id, lh_id)),
veto_inst AS (SELECT ctr_id, vto_pwr, vto_inst_sdate, vto_inst_edate
		FROM config_data.veto_points
		WHERE vto_inst_typ = 'lower house') 
SELECT veto_inst.ctr_id, sdate, 
	cab_id, lh_id, cab_lh_sts_shr, vto_pwr AS vto_pwr_lh,
	CASE WHEN (cab_lh_sts_shr-vto_pwr)::NUMERIC >= 0 -- if cab has at least seat share of (ordinarily) 50% 
		THEN 0::SMALLINT -- veto point is closed
		ELSE 1::SMALLINT -- else, it's open
	END AS vto_lh
FROM configs_w_sts_shr, veto_inst
WHERE configs_w_sts_shr.ctr_id = veto_inst.ctr_id
AND configs_w_sts_shr.sdate >= veto_inst.vto_inst_sdate
AND configs_w_sts_shr.sdate < veto_inst.vto_inst_edate
ORDER BY ctr_id, sdate NULLS FIRST;
