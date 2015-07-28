CREATE OR REPLACE VIEW config_data.view_configuration_vto_hog
AS
SELECT CONFIG_EVENTS_w_HOG_PTY.ctr_id, sdate, cab_id, 
	hog_not_member_of_cab_parties, vto_pwr, 
	(hog_not_member_of_cab_parties*vto_pwr)::SMALLINT AS vto_hog
FROM
	(SELECT *
		FROM
			(SELECT  ctr_id, sdate, cab_id
				FROM config_data.mv_configuration_events
			) AS CONFIG_EVENTS
		JOIN
			(SELECT cab_id, 
				(1+(-1*COUNT(pty_id)))::SMALLINT AS hog_not_member_of_cab_parties
				FROM config_data.cabinet_portfolios
				WHERE pty_cab IS TRUE 
				AND pty_cab_hog IS TRUE
				GROUP BY cab_id
			) AS HOG_NOT_MEMBER_OF_CAB_PARTIES
		USING(cab_id)
	) AS CONFIG_EVENTS_w_HOG_PTY
,
	(SELECT ctr_id, vto_pwr, vto_inst_sdate, vto_inst_edate
		FROM config_data.veto_points
		WHERE vto_inst_typ = 'head of government'
	) AS VETO_INST
WHERE CONFIG_EVENTS_w_HOG_PTY.ctr_id = VETO_INST.ctr_id
AND CONFIG_EVENTS_w_HOG_PTY.sdate >= VETO_INST.vto_inst_sdate
AND CONFIG_EVENTS_w_HOG_PTY.sdate <= VETO_INST.vto_inst_edate
ORDER BY ctr_id, sdate NULLS FIRST;
