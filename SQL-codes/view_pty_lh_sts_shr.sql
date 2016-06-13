CREATE OR REPLACE VIEW config_data.view_pty_lh_sts_shr
AS
SELECT lh_id, pty_id, pty_lh_sts, lh_sts_ttl_computed, 
	(pty_lh_sts::NUMERIC / lh_sts_ttl_computed) AS pty_lhelc_sts_shr
		FROM
			(SELECT lh_id, 
				SUM(pty_lh_sts::NUMERIC) AS lh_sts_ttl_computed
				FROM config_data.lh_seat_results
				GROUP BY lh_id
			) SEATS_TOTAL
	JOIN
		(SELECT lh_id, pty_id, pty_lh_sts
			FROM config_data.lh_seat_results
			WHERE pty_lh_sts <> 0
		) SEATS
	USING (lh_id)
ORDER BY lh_id, pty_id;