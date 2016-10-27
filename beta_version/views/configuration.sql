﻿CREATE OR REPLACE VIEW beta_version.pview_configuration
AS
WITH 
	configs AS (SELECT * FROM beta_version.mv_configuration_events ) ,
	cab_sts_ttl AS (SELECT cab_id, COUNT(pty_cab)::INTEGER AS cab_sts_ttl_computed
		FROM beta_version.cabinet_portfolios
		WHERE pty_cab IS TRUE
		GROUP BY cab_id ) , -- WITH AS cab_sts_ttl
	vto_pts AS (SELECT * FROM beta_version.view_configuration_vto_pts) ,
	vto_hog AS (SELECT * FROM beta_version.view_configuration_vto_hog) ,
	vto_lh AS (SELECT * FROM beta_version.view_configuration_vto_lh) ,
	vto_uh AS (SELECT * FROM beta_version.view_configuration_vto_uh) ,
	vto_prs AS (SELECT * FROM beta_version.view_configuration_vto_prs) ,
	vto_jud AS (SELECT * FROM beta_version.view_configuration_vto_jud) ,
	vto_elct AS (SELECT * FROM beta_version.view_configuration_vto_elct) ,
	vto_terr AS (SELECT * FROM beta_version.view_configuration_vto_terr)
SELECT ctr_id, sdate, edate, 
	configs.cab_id, configs.lh_id, configs.lhelc_id, configs.uh_id, configs.prselc_id, 
	cab_sts_ttl_computed AS cab_sts_ttl, 
	cab_lh_sts_shr::NUMERIC(7,5), cab_uh_sts_shr::NUMERIC(7,5),
	vto_lh, vto_uh, vto_prs, vto_pts, vto_jud, vto_elct, vto_terr,
	(COALESCE(vto_lh,0)+COALESCE(vto_uh,0)+COALESCE(vto_prs,0)
		-- +COALESCE(vto_jud,0)+COALESCE(vto_elct,0)+COALESCE(vto_terr,0)
	)::NUMERIC AS vto_sum, 
	year::NUMERIC(4,0), (edate-sdate)::INTEGER AS config_duration
FROM
	configs
	LEFT OUTER JOIN cab_sts_ttl USING(cab_id)
	LEFT OUTER JOIN vto_pts USING(ctr_id, sdate)
	LEFT OUTER JOIN vto_hog USING(ctr_id, sdate)
	LEFT OUTER JOIN vto_lh  USING(ctr_id, sdate)
	LEFT OUTER JOIN vto_uh  USING(ctr_id, sdate)
	LEFT OUTER JOIN vto_prs USING(ctr_id, sdate)
	LEFT OUTER JOIN vto_jud USING(ctr_id, sdate)
	LEFT OUTER JOIN vto_elct USING(ctr_id, sdate)
	LEFT OUTER JOIN vto_terr USING(ctr_id, sdate)
ORDER BY ctr_id, sdate; 