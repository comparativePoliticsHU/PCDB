CREATE OR REPLACE VIEW config_data.view_configuration_vto_pts
AS
WITH cab_sts_ttl
	AS (SELECT cab_id, COUNT(pty_cab) AS cab_sts_ttl_computed
		FROM config_data.cabinet_portfolios
		WHERE pty_cab IS TRUE
		GROUP BY cab_id ) -- WITH AS cab_sts_ttl
SELECT ctr_id, sdate, cab_id, (cab_sts_ttl_computed-1)::SMALLINT AS vto_pts
	FROM
		(SELECT ctr_id, sdate, cab_id FROM config_data.mv_configuration_events) AS CONFIGS
	JOIN
		(SELECT cab_id, cab_sts_ttl_computed FROM cab_sts_ttl ) AS CAB_STS_TTL
	USING(cab_id)
ORDER BY ctr_id, sdate NULLS FIRST;
