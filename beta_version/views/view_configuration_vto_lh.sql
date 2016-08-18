CREATE OR REPLACE VIEW beta_version.view_configuration_vto_lh
AS
WITH 
config_ev AS (SELECT ctr_id, sdate, cab_id, lh_id FROM beta_version.mv_configuration_events), -- WITH AS config_ev
cab_lh_sts_shr AS
	(WITH pty_lh_sts_shr
		AS (SELECT lh_id, pty_id, pty_lh_sts, lh_sts_ttl_computed, (pty_lh_sts::NUMERIC / lh_sts_ttl_computed) AS pty_lhelc_sts_shr
			FROM
				(SELECT lh_id, SUM(pty_lh_sts::NUMERIC) AS lh_sts_ttl_computed
						FROM beta_version.lh_seat_results 
						GROUP BY lh_id ) SEATS_TOTAL
			JOIN
				(SELECT lh_id, pty_id, pty_lh_sts 
					FROM beta_version.lh_seat_results
					WHERE pty_lh_sts <> 0 ) SEATS
			USING (lh_id) ) -- WITH AS pty_lh_sts_shr
	SELECT DISTINCT ON (ctr_id, sdate) ctr_id, sdate, cab_id, lh_id, SUM(pty_lhelc_sts_shr) AS cab_lh_sts_shr
		FROM
			(SELECT cab_id, pty_id, pty_cab FROM beta_version.cabinet_portfolios ) AS CAB_PORTFOLIOS
		JOIN
			(SELECT *
				FROM
					(SELECT * FROM config_ev ) AS CONFIGS
				LEFT OUTER JOIN
					(SELECT lh_id, pty_id, pty_lhelc_sts_shr FROM pty_lh_sts_shr ) AS PTY_LH_STS_SHR
				USING(lh_id) ) AS CAB_LH_CONFIGS
		USING(cab_id, pty_id)
		WHERE pty_cab IS TRUE
		GROUP BY ctr_id, sdate, lh_id, cab_id ) -- WITH AS cab_lh_sts_shr
SELECT VETO_INST.ctr_id, sdate, 
	cab_id, lh_id, cab_lh_sts_shr, vto_pwr AS vto_pwr_lh,
	CASE WHEN (cab_lh_sts_shr-vto_pwr)::NUMERIC >= 0 -- if cab has at least seat share of (ordinarily) 50% 
		THEN 0::SMALLINT -- veto point is closed
		ELSE 1::SMALLINT -- else, it's open
	END AS vto_lh
FROM
	(SELECT *
		FROM
			(SELECT * FROM config_ev ) AS CONFIG_EVENTS
		JOIN
			(SELECT * FROM cab_lh_sts_shr ) AS CAB_LH_STS_SHR
		USING(ctr_id, sdate, cab_id, lh_id)
	) AS CONFIG_EVENTS_w_CAB_LH_STS_SHR
,
	(SELECT ctr_id, vto_pwr, vto_inst_sdate, vto_inst_edate
		FROM beta_version.veto_points
		WHERE vto_inst_typ = 'lower house'
	) AS VETO_INST
WHERE CONFIG_EVENTS_w_CAB_LH_STS_SHR.ctr_id = VETO_INST.ctr_id
AND CONFIG_EVENTS_w_CAB_LH_STS_SHR.sdate >= VETO_INST.vto_inst_sdate
AND CONFIG_EVENTS_w_CAB_LH_STS_SHR.sdate < VETO_INST.vto_inst_edate
ORDER BY ctr_id, sdate NULLS FIRST;
