CREATE OR REPLACE VIEW beta_version.view_configuration_vto_hog
AS
WITH
configs AS (SELECT  ctr_id, sdate, cab_id FROM beta_version.mv_configuration_events),
hog_not_member AS (SELECT cab_id,
				CASE WHEN COUNT(pty_id) > 0 -- if the head of government is member of (at least) one party in cabinet 
					THEN 0::SMALLINT -- then indicator evaluates to zero
					ELSE 1::SMALLINT -- else, to one, i.e., head of government is not member of cabinet parties
				END AS hog_not_member_of_cab_parties
			FROM beta_version.cabinet_portfolios
			WHERE pty_cab IS TRUE AND pty_cab_hog IS TRUE
			GROUP BY cab_id), -- WITH AS hog_not_member
configs_w_hog_pty AS (SELECT ctr_id, sdate, cab_id, hog_not_member_of_cab_parties
			FROM configs JOIN hog_not_member USING(cab_id)),  
veto_inst AS (SELECT ctr_id, vto_pwr, vto_inst_sdate, vto_inst_edate
			FROM beta_version.veto_points
			WHERE vto_inst_typ = 'head of government') 
SELECT configs_w_hog_pty.ctr_id, sdate, cab_id, 
	hog_not_member_of_cab_parties, vto_pwr, 
	(hog_not_member_of_cab_parties*vto_pwr)::SMALLINT AS vto_hog
FROM configs_w_hog_pty, veto_inst
WHERE configs_w_hog_pty.ctr_id = veto_inst.ctr_id
AND configs_w_hog_pty.sdate >= veto_inst.vto_inst_sdate
AND configs_w_hog_pty.sdate < veto_inst.vto_inst_edate
ORDER BY ctr_id, sdate NULLS FIRST;
