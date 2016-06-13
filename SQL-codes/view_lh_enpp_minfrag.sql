CREATE OR REPLACE VIEW config_data.view_lh_enpp_minfrag
AS
SELECT lh_id, 1/SUM(pty_lh_sts_shr^2.0) AS lh_enpp_minfrag
	FROM
		(SELECT lh_id, pty_id, 
			(SEATS.pty_lh_sts/SEATS_TOTAL.lhelc_sts_ttl_computed) 
				AS pty_lh_sts_shr
			FROM
				(SELECT lh_id, 
					SUM(pty_lh_sts)::NUMERIC AS lhelc_sts_ttl_computed
					FROM config_data.lh_seat_results
					GROUP BY lh_id 
				) AS SEATS_TOTAL
			JOIN
				(SELECT lh_id, pty_id, pty_lh_sts::NUMERIC
					FROM config_data.lh_seat_results
					WHERE pty_lh_sts <> 0
				) AS SEATS
			USING(lh_id)
			ORDER BY lh_id, pty_id
		) AS SEAT_SHR
	GROUP BY lh_id
	ORDER BY lh_id;
