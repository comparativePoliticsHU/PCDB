CREATE OR REPLACE VIEW config_data.view_pty_uh_sts_shr
AS
SELECT uh_id, pty_id, pty_uh_sts, uh_sts_ttl_computed, 
	(pty_uh_sts::NUMERIC / uh_sts_ttl_computed) AS pty_uh_sts_shr
		FROM
		(SELECT uh_id, SUM(pty_uh_sts::NUMERIC) AS uh_sts_ttl_computed
			FROM config_data.uh_seat_results
			GROUP BY uh_id
		) SEATS_TOTAL
	JOIN
		(SELECT uh_id, pty_id, pty_uh_sts
			FROM config_data.uh_seat_results
			WHERE pty_uh_sts <> 0
		) SEATS
	USING (uh_id)
ORDER BY uh_id, pty_id;