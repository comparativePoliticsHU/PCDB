CREATE OR REPLACE VIEW config_data.view_lhelc_w_underestimated_ENPP
AS
SELECT lhelc_id, 
	(lh_sts_of_Others_or_INDs/lh_pty_w_least_seats) AS lhelc_m
	FROM
		(SELECT lhelc_id, MIN(pty_lh_sts) AS lh_pty_w_least_seats 
			FROM config_data.lh_seat_results 
			WHERE pty_lh_sts > 0 
			GROUP BY lhelc_id 
		) AS LH_PTY_w_LEAST_SEATS
	LEFT OUTER JOIN
		(SELECT lhelc_id, pty_id, pty_lh_sts AS lh_sts_of_Others_or_INDs 
			FROM config_data.lh_seat_results
			WHERE pty_lh_sts > 0 
			AND pty_id 
			IN 
				(SELECT pty_id 
					FROM config_data.view_Others_and_INDs
				)
		) AS SEATS_of_OTHERS_or_INDs
	USING(lhelc_id)
WHERE (lh_sts_of_Others_or_INDs/lh_pty_w_least_seats) > 1 OR NOT NULL;