CREATE OR REPLACE VIEW beta_version.view_configuration_vto_uh
AS
WITH 
config_ev AS (SELECT ctr_id, sdate, cab_id, uh_id FROM beta_version.mv_configuration_events), -- WITH AS config_ev
cab_uh_sts_shr AS
	(WITH pty_uh_sts_shr
		AS (SELECT uh_id, pty_id, pty_uh_sts, uh_sts_ttl_computed, (pty_uh_sts::NUMERIC / uh_sts_ttl_computed) AS pty_uhelc_sts_shr
			FROM
				(SELECT uh_id, SUM(pty_uh_sts::NUMERIC) AS uh_sts_ttl_computed
						FROM beta_version.uh_seat_results 
						GROUP BY uh_id ) SEATS_TOTAL
			JOIN
				(SELECT uh_id, pty_id, pty_uh_sts 
					FROM beta_version.uh_seat_results
					WHERE pty_uh_sts <> 0 ) SEATS
			USING (uh_id) ) -- WITH AS pty_uh_sts_shr
	SELECT DISTINCT ON (ctr_id, sdate) ctr_id, sdate, cab_id, uh_id, SUM(pty_uhelc_sts_shr) AS cab_uh_sts_shr
		FROM
			(SELECT cab_id, pty_id, pty_cab FROM beta_version.cabinet_portfolios ) AS CAB_PORTFOLIOS
		JOIN
			(SELECT *
				FROM
					(SELECT * FROM config_ev ) AS CONFIGS
				LEFT OUTER JOIN
					(SELECT uh_id, pty_id, pty_uhelc_sts_shr FROM pty_uh_sts_shr ) AS PTY_UH_STS_SHR
				USING(uh_id) ) AS CAB_UH_CONFIGS
		USING(cab_id, pty_id)
		WHERE pty_cab IS TRUE
		GROUP BY ctr_id, sdate, uh_id, cab_id ) -- WITH AS cab_lh_sts_shr
SELECT VETO_INST.ctr_id, sdate, 
	cab_id, uh_id, cab_uh_sts_shr, vto_pwr AS vto_pwr_uh,
	CASE WHEN (cab_uh_sts_shr-vto_pwr)::NUMERIC >= 0 -- if cab has at least seat share of (ordinarily) 50% 
		THEN 0::SMALLINT -- veto point is closed
		ELSE 1::SMALLINT -- else, it's open
	END AS vto_uh
FROM
	(SELECT *
		FROM
			(SELECT * FROM config_ev ) AS CONFIG_EVENTS
		JOIN
			(SELECT * FROM cab_uh_sts_shr ) AS CAB_UH_STS_SHR
		USING(ctr_id, sdate, cab_id, uh_id)
	) AS CONFIG_EVENTS_w_CAB_UH_STS_SHR
,
	(SELECT ctr_id, vto_pwr, vto_inst_sdate, vto_inst_edate
		FROM beta_version.veto_points
		WHERE vto_inst_typ = 'upper house'
	) AS VETO_INST
WHERE CONFIG_EVENTS_w_CAB_UH_STS_SHR.ctr_id = VETO_INST.ctr_id
AND CONFIG_EVENTS_w_CAB_UH_STS_SHR.sdate >= VETO_INST.vto_inst_sdate
AND CONFIG_EVENTS_w_CAB_UH_STS_SHR.sdate < VETO_INST.vto_inst_edate
ORDER BY ctr_id, sdate NULLS FIRST;
