CREATE OR REPLACE VIEW beta_version.view_configuration_vto_prs
AS
SELECT CONFIG_EVENTS_COHABITATION.ctr_id, sdate, cohabitation, vto_pwr, 
	(cohabitation*vto_pwr)::SMALLINT AS vto_prs -- president constitutes open veto point, if configuration in cohabitation AND president is an constitutionally entitled veto institution (veto power = 1) 
	FROM
		(SELECT ctr_id, sdate, LEAST(in_cohabitation) AS cohabitation -- only if allin_cohabitation indicator equals one (i.e., president is not member of one of the parties in cabinet), cohabitation is indicated
			FROM
				(WITH config_cab_parties -- all parties in cabinet for a given configurations 
					AS (SELECT * FROM
						(SELECT ctr_id, sdate, cab_id, prselc_id FROM beta_version.mv_configuration_events) AS CONFIGS
						FULL OUTER JOIN 
						(SELECT cab_id, pty_id FROM beta_version.cabinet_portfolios WHERE pty_cab IS TRUE ) AS CAB_PARTIES
						USING(cab_id) ) -- WITH AS config_cab_parties		
				SELECT ctr_id, sdate, ABS(SIGN(pty_id-pty_id_hos)) AS in_cohabitation -- unequals one if party IDs of president and respective cabinet differ 
					FROM config_cab_parties		
					FULL OUTER JOIN
						(SELECT prselc_id, pty_id AS pty_id_hos FROM beta_version.presidential_election) AS PTY_ID_HOS
					USING(prselc_id)
					WHERE prselc_id IS NOT NULL
				) AS CAB_PTY_HOS_PTY
			GROUP BY ctr_id, sdate, in_cohabitation
		) AS CONFIG_EVENTS_COHABITATION
	,
		(SELECT ctr_id, vto_pwr, vto_inst_sdate, vto_inst_edate
			FROM beta_version.veto_points
			WHERE vto_inst_typ = 'head of state'
		) AS VETO_INST
	WHERE CONFIG_EVENTS_COHABITATION.ctr_id = VETO_INST.ctr_id
	AND CONFIG_EVENTS_COHABITATION.sdate >= VETO_INST.vto_inst_sdate
	AND CONFIG_EVENTS_COHABITATION.sdate < VETO_INST.vto_inst_edate
	ORDER BY ctr_id, sdate NULLS FIRST;