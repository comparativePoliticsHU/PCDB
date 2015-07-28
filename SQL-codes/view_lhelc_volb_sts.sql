CREATE OR REPLACE VIEW config_data.view_lhelc_volb_sts
AS
SELECT lhelc_id, lhelc_volb_sts_computed
	FROM 
		(SELECT lhelc_id
			FROM config_data.lh_election
		) AS ALL_LH_ELECTIONS
	LEFT OUTER JOIN
		(SELECT lhelc_id, 
			(SUM(pty_lh_sts_pct_diff)/2)::DOUBLE PRECISION 
				AS lhelc_volb_sts_computed
			FROM
				(SELECT CUR_LHELC_STS_SHR.lhelc_id AS lhelc_id, 
					ABS(PREV_LHELC_STS_SHR.pty_prv_lh_sts_pct
					- CUR_LHELC_STS_SHR.pty_cur_lh_sts_pct) 
						AS pty_lh_sts_pct_diff
					FROM
						(SELECT lhelc_id, pty_id, 
							100*(SEATS.pty_lh_sts
							/SEATS_TOTAL.lhelc_sts_ttl_computed) 
								AS pty_prv_lh_sts_pct
							FROM
								(SELECT lhelc_id, 
									SUM(pty_lh_sts)::NUMERIC 
										AS lhelc_sts_ttl_computed 
									FROM config_data.lh_seat_results
									GROUP BY lhelc_id
								) AS SEATS_TOTAL
							JOIN
								(SELECT lhelc_id, pty_id, pty_lh_sts::NUMERIC
									FROM config_data.lh_seat_results
									WHERE pty_lh_sts >= 1
								) AS SEATS
							USING(lhelc_id))
						AS PREV_LHELC_STS_SHR 
					,
						(SELECT lhelc_id, lhelc_prv_id, pty_id, 
							100*(pty_lh_sts
							/lhelc_sts_ttl_computed)
								AS pty_cur_lh_sts_pct
							FROM
								(SELECT lhelc_id, 
									SUM(pty_lh_sts)::NUMERIC 
										AS lhelc_sts_ttl_computed 
									FROM config_data.lh_seat_results
									GROUP BY lhelc_id 
								) AS SEATS_TOTAL
							JOIN
								(SELECT lhelc_id, lhelc_prv_id, pty_id, pty_lh_sts
									FROM
										(SELECT lhelc_id, lhelc_prv_id
											FROM config_data.lh_election
										) AS LH_ELCETION
									JOIN
										(SELECT lhelc_id, pty_id, pty_lh_sts::NUMERIC
											FROM config_data.lh_seat_results
											WHERE pty_lh_sts >= 1
										) AS LH_SEAT_RESULTS
									USING(lhelc_id)
								) AS CUR_LHELC_STS
							USING(lhelc_id)
						) AS CUR_LHELC_STS_SHR 
					WHERE CUR_LHELC_STS_SHR.lhelc_prv_id = PREV_LHELC_STS_SHR.lhelc_id 
					AND CUR_LHELC_STS_SHR.pty_id = PREV_LHELC_STS_SHR.pty_id
				) AS PTY_STS_SHR_DIFF
			WHERE lhelc_id 
			NOT IN
				(SELECT DISTINCT lhelc_id
					FROM  
						(SELECT lhelc_id, pty_id, pty_lh_sts 
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
			GROUP BY lhelc_id
		) AS VALID_LHELC_VOLB_STS
	USING(lhelc_id)
ORDER BY lhelc_id;