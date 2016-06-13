CREATE OR REPLACE VIEW config_data.view_lh_volb_sts
AS
SELECT lh_id, lh_volb_sts_computed
	FROM 
		(SELECT lh_id
			FROM config_data.lower_house
		) AS ALL_LOWER_HOUSES
	LEFT OUTER JOIN
		(SELECT lh_id, 
			(SUM(pty_lh_sts_pct_diff)/2)::DOUBLE PRECISION 
				AS lh_volb_sts_computed
			FROM
				(SELECT CUR_lh_STS_SHR.lh_id AS lh_id, 
					ABS(PREV_lh_STS_SHR.pty_prv_lh_sts_pct
					- CUR_lh_STS_SHR.pty_cur_lh_sts_pct) 
						AS pty_lh_sts_pct_diff
					FROM
						(SELECT lh_id, pty_id, 
							100*(SEATS.pty_lh_sts
							/SEATS_TOTAL.lh_sts_ttl_computed) 
								AS pty_prv_lh_sts_pct
							FROM
								(SELECT lh_id, 
									SUM(pty_lh_sts)::NUMERIC 
										AS lh_sts_ttl_computed 
									FROM config_data.lh_seat_results
									GROUP BY lh_id
								) AS SEATS_TOTAL
							JOIN
								(SELECT lh_id, pty_id, pty_lh_sts::NUMERIC
									FROM config_data.lh_seat_results
									WHERE pty_lh_sts >= 1
								) AS SEATS
							USING(lh_id))
						AS PREV_LH_STS_SHR 
					,
						(SELECT lh_id, lh_prv_id, pty_id, 
							100*(pty_lh_sts
							/lh_sts_ttl_computed)
								AS pty_cur_lh_sts_pct
							FROM
								(SELECT lh_id, 
									SUM(pty_lh_sts)::NUMERIC 
										AS lh_sts_ttl_computed 
									FROM config_data.lh_seat_results
									GROUP BY lh_id 
								) AS SEATS_TOTAL
							JOIN
								(SELECT lh_id, lh_prv_id, pty_id, pty_lh_sts
									FROM
										(SELECT lh_id, lh_prv_id
											FROM config_data.lower_house
										) AS LOWER_HOUSE
									JOIN
										(SELECT lh_id, pty_id, pty_lh_sts::NUMERIC
											FROM config_data.lh_seat_results
											WHERE pty_lh_sts >= 1
										) AS LH_SEAT_RESULTS
									USING(lh_id)
								) AS CUR_LH_STS
							USING(lh_id)
						) AS CUR_LH_STS_SHR 
					WHERE CUR_LH_STS_SHR.lh_prv_id = PREV_LH_STS_SHR.lh_id 
					AND CUR_LH_STS_SHR.pty_id = PREV_LH_STS_SHR.pty_id
				) AS PTY_STS_SHR_DIFF
			WHERE lh_id 
			NOT IN
				(SELECT DISTINCT lh_id
					FROM  
						(SELECT lh_id, pty_id, pty_lh_sts 
							FROM config_data.lh_seat_results
						) AS LH_SEATS
					JOIN
						(SELECT pty_id, pty_abr 
							FROM config_data.party
						) AS PARTIES 
					USING(pty_id)
				WHERE pty_lh_sts IS NULL 
				AND pty_abr NOT LIKE '%Other'
				)
			GROUP BY lh_id
		) AS VALID_LH_VOLB_STS
	USING(lh_id)
ORDER BY lh_id;