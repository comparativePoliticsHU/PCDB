CREATE OR REPLACE VIEW config_data.view_lh_vola_sts
AS
SELECT lh_id, 
	(ABS(COALESCE(old_pty_sum, 0) 
	+ COALESCE(new_pty_sum, 0))/2)::DOUBLE PRECISION 
		AS lh_vola_sts_computed
	FROM
		(SELECT lh_id, old_pty_sum
			FROM
				(SELECT lh_id
					FROM config_data.lower_house
				) AS LH_CONFIGS
			LEFT OUTER JOIN 
				(SELECT lh_nxt_id AS lh_id, 
					SUM(old_pty_lh_sts_shr) 
						AS old_pty_sum
					FROM
						(SELECT lh_id, lh_nxt_id
							FROM config_data.lower_house
						) AS LOWER_HOUSE
					JOIN
						(SELECT lh_id, pty_id, 
							100*MAX(SEATS.pty_lh_sts
							/SEATS_TOTAL.lh_sts_ttl_computed) 
								AS old_pty_lh_sts_shr
							FROM
								(SELECT lh_id, sum(pty_lh_sts)::NUMERIC 
									AS lh_sts_ttl_computed
									FROM config_data.lh_seat_results
									GROUP BY lh_id
								) AS SEATS_TOTAL	
							JOIN
								(SELECT lh_id, pty_id, pty_lh_sts::NUMERIC
									FROM config_data.lh_seat_results
									WHERE lh_id 
									NOT IN
										(SELECT max(lh_id) AS lh_id
											FROM config_data.lower_house
											GROUP BY ctr_id
										)
									AND pty_lh_sts >= 1 
									EXCEPT 
										SELECT lh_id, CUR_LH.pty_id AS pty_id, pty_lh_sts
											FROM 
												(SELECT lh_id, pty_id, pty_lh_sts 
													FROM config_data.lh_seat_results
												) AS PREV_LH
											,
												(SELECT lh_prv_id, pty_id 
													FROM 
														(SELECT lh_id, lh_prv_id 
															FROM config_data.lower_house
														) AS LOWER_HOUSE
													JOIN 
														(SELECT lh_id, pty_id 
															FROM config_data.lh_seat_results
														) AS LH_SEAT_RESULTS
													USING(lh_id)
												) AS CUR_LH 
											WHERE CUR_LH.lh_prv_id = PREV_LH.lh_id 
											AND CUR_LH.pty_id = PREV_LH.pty_id
								) AS SEATS
							USING(lh_id)
							GROUP BY lh_id, pty_id
						) AS OLD_PTY_LH_STS_PCT
					USING(lh_id)
				GROUP BY lh_nxt_id
				) AS RETIERING_PARTIES
			USING (lh_id)
		) AS LH_RETIERING_PARTIES
	LEFT OUTER JOIN 
		(SELECT lh_id, 
			SUM(new_pty_lh_sts_shr) 
				AS new_pty_sum
			FROM
				(SELECT lh_id, pty_id, 
					100*MAX(SEATS.pty_lh_sts
					/SEATS_TOTAL.lh_sts_ttl_computed) 
						AS new_pty_lh_sts_shr
					FROM
						(SELECT lh_id, 
							SUM(pty_lh_sts)::NUMERIC 
								AS lh_sts_ttl_computed
							FROM config_data.lh_seat_results
							GROUP BY lh_id
						) AS SEATS_TOTAL	
					JOIN
						(SELECT lh_id, pty_id, pty_lh_sts::numeric
							FROM config_data.lh_seat_results
							WHERE lh_id 
							NOT IN
								(SELECT max(lh_id) AS lh_id
									FROM config_data.lower_house
									GROUP BY ctr_id)
						AND pty_lh_sts >= 1
						EXCEPT 
							SELECT lh_id, CUR_LH.pty_id AS pty_id, pty_lh_sts
								FROM 
									(SELECT lh_id, pty_id, pty_lh_sts 
										FROM config_data.lh_seat_results
									) AS PREV_LH
								,
									(SELECT lh_nxt_id, pty_id 
										FROM 
											(SELECT lh_id, lh_nxt_id 
												FROM config_data.lower_house
											) AS LOWER_HOUSE
										JOIN 
											(SELECT lh_id, pty_id 
												FROM config_data.lh_seat_results
											) AS LH_SEAT_RESULTS
										USING(lh_id)
									) AS CUR_LH 
							WHERE CUR_LH.lh_nxt_id = PREV_LH.lh_id 
							AND CUR_LH.pty_id = PREV_LH.pty_id
						) AS SEATS
					USING(lh_id)
					GROUP BY lh_id, pty_id
				) AS NEW_PTY_LH_STS_PCT
			GROUP BY lh_id
		) AS NEWENTRY_PARTIES
	USING(lh_id)
ORDER BY lh_id;


