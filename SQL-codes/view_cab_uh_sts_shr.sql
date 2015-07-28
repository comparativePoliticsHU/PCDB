CREATE OR REPLACE VIEW config_data.view_cab_uh_sts_shr
AS
SELECT DISTINCT ctr_id, sdate, cab_id, uh_id, cab_uh_sts_shr
FROM
	(SELECT ctr_id, sdate, uh_id, cab_id, SUM(pty_uh_sts_shr) AS cab_uh_sts_shr
		FROM
			(SELECT cab_id, pty_id, pty_cab 
				FROM config_data.cabinet_portfolios
			) AS CAB_PORTFOLIOS
		JOIN
			(SELECT *
			FROM
				(SELECT ctr_id, sdate, uh_id, cab_id 
					FROM config_data.mv_configuration_events
				) AS CONFIGURATION_EVENTS
			LEFT OUTER JOIN
				(SELECT uh_id, pty_id, pty_uh_sts_shr 
					FROM config_data.view_pty_uh_sts_shr
					WHERE uh_id IS NOT NULL
				) AS PTY_UH_STS_SHR
			USING(uh_id)
			) AS CAB_UH_CONFIGS
		USING(cab_id, pty_id)
		WHERE pty_cab IS TRUE
		GROUP BY ctr_id, sdate, uh_id, cab_id
		ORDER BY ctr_id, sdate
	) AS CONFIGS_W_CAB_UH_STS_SHR
ORDER BY ctr_id, sdate, cab_id NULLS FIRST;