CREATE OR REPLACE VIEW config_data.view_configuration_vto_pts
AS
SELECT ctr_id, sdate, cab_id, (cab_sts_ttl_computed-1)::SMALLINT AS vto_pts
FROM
	(SELECT  ctr_id, sdate, cab_id
		FROM config_data.mv_configuration_events
	) AS CONFIG_EVENTS
JOIN
	(SELECT cab_id, cab_sts_ttl_computed
		FROM config_data.view_cab_sts_ttl
	) AS CAB_STS_TTL
USING(cab_id)
ORDER BY ctr_id, sdate NULLS FIRST;
