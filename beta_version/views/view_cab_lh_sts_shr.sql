CREATE OR REPLACE VIEW beta_version.view_cab_lh_sts_shr
AS
WITH pty_lh_sts_shr
	AS (SELECT lh_id, pty_id, pty_lh_sts, lh_sts_ttl_computed, (pty_lh_sts::NUMERIC / lh_sts_ttl_computed) AS pty_lhelc_sts_shr
		FROM
			(SELECT lh_id, SUM(pty_lh_sts::NUMERIC) AS lh_sts_ttl_computed
					FROM beta_version.lh_seat_results 
					GROUP BY lh_id ) SEATS_TOTAL
		JOIN
			(SELECT lh_id, pty_id, pty_lh_sts 
				FROM beta_version.lh_seat_results
				WHERE pty_lh_sts <> 0 ) SEATS
		USING (lh_id) ) -- WITH AS pty_lh_sts_shr
SELECT DISTINCT ON (ctr_id, sdate) ctr_id, sdate, cab_id, lh_id, SUM(pty_lhelc_sts_shr) AS cab_lh_sts_shr
	FROM
		(SELECT cab_id, pty_id, pty_cab FROM beta_version.cabinet_portfolios ) AS CAB_PORTFOLIOS
	JOIN
		(SELECT *
			FROM
				(SELECT ctr_id, sdate, lh_id, cab_id FROM beta_version.mv_configuration_events ) AS CONFIGS
			LEFT OUTER JOIN
				(SELECT lh_id, pty_id, pty_lhelc_sts_shr FROM pty_lh_sts_shr ) AS PTY_LH_STS_SHR
			USING(lh_id) ) AS CAB_LH_CONFIGS
	USING(cab_id, pty_id)
	WHERE pty_cab IS TRUE
	GROUP BY ctr_id, sdate, lh_id, cab_id
ORDER BY ctr_id, sdate, cab_id NULLS FIRST;