CREATE OR REPLACE VIEW config_data.view_cab_lh_sts_shr
AS
SELECT DISTINCT ctr_id, sdate, cab_id, lh_id, cab_lh_sts_shr
FROM
	(SELECT ctr_id, sdate, lh_id, cab_id, SUM(pty_lhelc_sts_shr) AS cab_lh_sts_shr
		FROM
			(SELECT cab_id, pty_id, pty_cab 
				FROM config_data.cabinet_portfolios
			) AS CAB_PORTFOLIOS
		JOIN
			(SELECT *
				FROM
					(SELECT ctr_id, sdate, lh_id, cab_id 
						FROM config_data.mv_configuration_events
					) AS CONFIGURATION_EVENTS
				LEFT OUTER JOIN
					(SELECT *
						FROM
							(SELECT lh_id, lhelc_id 
								FROM config_data.lower_house
							) LOWER_HOUSE
						FULL OUTER JOIN
							(SELECT lhelc_id, pty_id, pty_lhelc_sts_shr 
								FROM config_data.view_pty_lhelc_sts_shr
							) PTY_LH_STS_SHR
						USING(lhelc_id)
						WHERE lh_id IS NOT NULL
					) AS PTY_LH_STS_SHR
				USING(lh_id)
			) AS CAB_LH_CONFIGS
		USING(cab_id, pty_id)
		WHERE pty_cab IS TRUE
		GROUP BY ctr_id, sdate, lh_id, cab_id
		ORDER BY ctr_id, sdate
	) AS CONFIGS_W_CAB_LH_STS_SHR
ORDER BY ctr_id, sdate, cab_id NULLS FIRST;