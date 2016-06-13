CREATE OR REPLACE VIEW config_data.view_configuration_vto_prs
AS
SELECT CONFIG_EVENTS_COHABITATION.ctr_id, sdate, cohabitation, vto_pwr, 
	(cohabitation*vto_pwr)::SMALLINT AS vto_prs
	FROM
		(SELECT ctr_id, sdate, LEAST(in_cohabitation) AS cohabitation
			FROM
				(SELECT *, ABS(SIGN(pty_id-pty_id_hos)) AS in_cohabitation
					FROM
						(SELECT *
							FROM
								(SELECT ctr_id, sdate, cab_id, prselc_id
									FROM config_data.mv_configuration_events
								) AS CONFIG_EVENTS
							FULL OUTER JOIN 
								(SELECT cab_id, pty_id
									FROM config_data.cabinet_portfolios
									WHERE pty_cab IS TRUE
								) AS ALL_CAB_PARTIES
							USING(cab_id)
						) AS CONFIG_EVENTS_w_ALL_CAB_PARTIES
					FULL OUTER JOIN
						(SELECT prselc_id, pty_id AS pty_id_hos
							FROM config_data.presidential_election
						) AS PTY_ID_HOS
					USING(prselc_id)
					WHERE prselc_id IS NOT NULL
				) AS CAB_PTY_HOS_PTY
			GROUP BY ctr_id, sdate, in_cohabitation
		) AS CONFIG_EVENTS_COHABITATION
	,
		(SELECT ctr_id, vto_pwr, vto_inst_sdate, vto_inst_edate
			FROM config_data.veto_points
			WHERE vto_inst_typ = 'head of state'
		) AS VETO_INST
	WHERE CONFIG_EVENTS_COHABITATION.ctr_id = VETO_INST.ctr_id
	AND CONFIG_EVENTS_COHABITATION.sdate >= VETO_INST.vto_inst_sdate
	AND CONFIG_EVENTS_COHABITATION.sdate <= VETO_INST.vto_inst_edate
	ORDER BY ctr_id, sdate NULLS FIRST;