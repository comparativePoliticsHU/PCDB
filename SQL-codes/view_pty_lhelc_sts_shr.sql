CREATE OR REPLACE VIEW config_data.view_pty_lhelc_sts_shr
AS
SELECT lhelc_id, pty_id, pty_lh_sts, lhelc_sts_ttl_computed, 
	(pty_lh_sts::NUMERIC / lhelc_sts_ttl_computed) AS pty_lhelc_sts_shr
		FROM
			(SELECT lh_seat_results.lhelc_id, 
				SUM(pty_lh_sts::NUMERIC) AS lhelc_sts_ttl_computed
				FROM config_data.lh_seat_results
				GROUP BY lhelc_id
			) SEATS_TOTAL
	JOIN
		(SELECT lhelc_id, pty_id, pty_lh_sts
			FROM config_data.lh_seat_results
			WHERE pty_lh_sts <> 0
		) SEATS
	USING (lhelc_id)
ORDER BY lhelc_id, pty_id;