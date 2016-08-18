CREATE OR REPLACE VIEW beta_version.view_configuration_vto_hog
AS
WITH
hog_not_member AS (SELECT cab_id,
				CASE WHEN COUNT(pty_id) > 0 -- if the head of government is member of (at least) one party in cabinet 
					THEN 0::SMALLINT -- then indicator evaluates to zero
					ELSE 1::SMALLINT -- else, to one, i.e., head of government is not member of cabinet parties
				END AS hog_not_member_of_cab_parties
			FROM beta_version.cabinet_portfolios
			WHERE pty_cab IS TRUE AND pty_cab_hog IS TRUE
			GROUP BY cab_id) -- WITH AS hog_not_member
SELECT CONFIG_EVENTS_w_HOG_PTY.ctr_id, sdate, cab_id, 
	hog_not_member_of_cab_parties, vto_pwr, 
	(hog_not_member_of_cab_parties*vto_pwr)::SMALLINT AS vto_hog
FROM
	(SELECT ctr_id, sdate, cab_id, hog_not_member_of_cab_parties
		FROM
			(SELECT  ctr_id, sdate, cab_id FROM beta_version.mv_configuration_events) AS CONFIGS
		JOIN
			(SELECT * FROM hog_not_member) AS HOG_NOT_MEMBER_OF_CAB_PARTIES
		USING(cab_id)
	) AS CONFIG_EVENTS_w_HOG_PTY
,
	(SELECT ctr_id, vto_pwr, vto_inst_sdate, vto_inst_edate
		FROM beta_version.veto_points
		WHERE vto_inst_typ = 'head of government'
	) AS VETO_INST
WHERE CONFIG_EVENTS_w_HOG_PTY.ctr_id = VETO_INST.ctr_id
AND CONFIG_EVENTS_w_HOG_PTY.sdate >= VETO_INST.vto_inst_sdate
AND CONFIG_EVENTS_w_HOG_PTY.sdate < VETO_INST.vto_inst_edate
ORDER BY ctr_id, sdate NULLS FIRST;
