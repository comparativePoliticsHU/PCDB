CREATE OR REPLACE VIEW beta_version.view_configuration_vto_prs
AS
WITH 
configs AS (SELECT ctr_id, sdate, cab_id, prselc_id FROM beta_version.mv_configuration_events) , -- AS configs
cab_parties AS (SELECT cab_id, pty_id FROM beta_version.cabinet_portfolios WHERE pty_cab IS TRUE), -- AS cab_parties 
config_cab_parties AS (SELECT * FROM configs FULL OUTER JOIN cab_parties USING(cab_id) ), -- WITH AS config_cab_parties	
cab_pty_hos_pty AS (SELECT ctr_id, sdate, ABS(SIGN(pty_id-pty_id_hos)) AS in_cohabitation -- unequals one if party IDs of president and respective cabinet differ 
					FROM config_cab_parties FULL OUTER JOIN
						(SELECT prselc_id, pty_id AS pty_id_hos FROM beta_version.presidential_election) AS PTY_ID_HOS
					USING(prselc_id)
					WHERE prselc_id IS NOT NULL), -- AS cab_pty_hos_pty
config_cohabitation AS (SELECT ctr_id, sdate, LEAST(in_cohabitation) AS cohabitation -- only if all in_cohabitation indicator equals one (i.e., president is not member of one of the parties in cabinet), cohabitation is indicated
			FROM cab_pty_hos_pty	
			GROUP BY ctr_id, sdate, in_cohabitation), -- AS config_cohabitation
veto_inst AS (SELECT ctr_id, vto_pwr, vto_inst_sdate, vto_inst_edate
			FROM beta_version.veto_points
			WHERE vto_inst_typ = 'head of state') 
SELECT config_cohabitation.ctr_id, sdate, cohabitation, vto_pwr, 
	(cohabitation*vto_pwr)::SMALLINT AS vto_prs -- president constitutes open veto point, if configuration in cohabitation AND president is an constitutionally entitled veto institution (veto power = 1) 
	FROM config_cohabitation, veto_inst 
	WHERE config_cohabitation.ctr_id = veto_inst.ctr_id
	AND config_cohabitation.sdate >= veto_inst.vto_inst_sdate
	AND config_cohabitation.sdate < veto_inst.vto_inst_edate
	ORDER BY ctr_id, sdate NULLS FIRST;