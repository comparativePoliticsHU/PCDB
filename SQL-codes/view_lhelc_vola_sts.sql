CREATE OR REPLACE VIEW config_data.view_lhelc_vola_sts
AS
SELECT lhelc_id, 
	(ABS(COALESCE(old_pty_sum, 0) 
	+ COALESCE(new_pty_sum, 0))/2)::DOUBLE PRECISION 
		AS lhelc_vola_sts_computed
	FROM
		(SELECT lhelc_id, old_pty_sum
			FROM
				(SELECT lhelc_id
					FROM config_data.lh_election
				) AS LH_CONFIGS
			LEFT OUTER JOIN 
				(SELECT lhelc_nxt_id AS lhelc_id, 
					SUM(old_pty_lh_sts_shr) 
						AS old_pty_sum
					FROM
						(SELECT lhelc_id, lhelc_nxt_id
							FROM config_data.lh_election
						) AS LH_ELECTION
					JOIN
						(SELECT lhelc_id, pty_id, 
							100*MAX(SEATS.pty_lh_sts
							/SEATS_TOTAL.lhelc_sts_ttl_computed) 
								AS old_pty_lh_sts_shr
							FROM
								(SELECT lhelc_id, sum(pty_lh_sts)::NUMERIC 
									AS lhelc_sts_ttl_computed
									FROM config_data.lh_seat_results
									GROUP BY lhelc_id
								) AS SEATS_TOTAL	
							JOIN
								(SELECT lhelc_id, pty_id, pty_lh_sts::NUMERIC
									FROM config_data.lh_seat_results
									WHERE lhelc_id 
									NOT IN
										(SELECT max(lhelc_id) AS lhelc_id
											FROM config_data.lh_election
											GROUP BY ctr_id
										)
									AND pty_lh_sts >= 1 
									EXCEPT 
										SELECT lhelc_id, CUR_LHELC.pty_id AS pty_id, pty_lh_sts
											FROM 
												(SELECT lhelc_id, pty_id, pty_lh_sts 
													FROM config_data.lh_seat_results
												) AS PREV_LHELC 
											,
												(SELECT lhelc_prv_id, pty_id 
													FROM 
														(SELECT lhelc_id, lhelc_prv_id 
															FROM config_data.lh_election
														) AS LH_ELCETION
													JOIN 
														(SELECT lhelc_id, pty_id 
															FROM config_data.lh_seat_results
														) AS LH_SEAT_RESULTS
													USING(lhelc_id)
												) AS CUR_LHELC 
											WHERE CUR_LHELC.lhelc_prv_id = PREV_LHELC.lhelc_id 
											AND CUR_LHELC.pty_id = PREV_LHELC.pty_id
								) AS SEATS
							USING(lhelc_id)
							GROUP BY lhelc_id, pty_id
						) AS OLD_PTY_LH_STS_PCT
					USING(lhelc_id)
				GROUP BY lhelc_nxt_id
				) AS RETIERING_PARTIES
			USING (lhelc_id)
		) AS LH_RETIERING_PARTIES
	LEFT OUTER JOIN 
		(SELECT lhelc_id, 
			SUM(new_pty_lh_sts_shr) 
				AS new_pty_sum
			FROM
				(SELECT lhelc_id, pty_id, 
					100*MAX(SEATS.pty_lh_sts
					/SEATS_TOTAL.lhelc_sts_ttl_computed) 
						AS new_pty_lh_sts_shr
					FROM
						(SELECT lhelc_id, 
							SUM(pty_lh_sts)::NUMERIC 
								AS lhelc_sts_ttl_computed
							FROM config_data.lh_seat_results
							GROUP BY lhelc_id
						) AS SEATS_TOTAL	
					JOIN
						(SELECT lhelc_id, pty_id, pty_lh_sts::numeric
							FROM config_data.lh_seat_results
							WHERE lhelc_id 
							NOT IN
								(SELECT max(lhelc_id) AS lhelc_id
									FROM config_data.lh_election
									GROUP BY ctr_id
								)
						AND pty_lh_sts >= 1
						EXCEPT 
							SELECT lhelc_id, CUR_LHELC.pty_id AS pty_id, pty_lh_sts
								FROM 
									(SELECT lhelc_id, pty_id, pty_lh_sts 
										FROM config_data.lh_seat_results
									) AS PREV_LHELC 
								,
									(SELECT lhelc_nxt_id, pty_id 
										FROM 
											(SELECT lhelc_id, lhelc_nxt_id 
												FROM config_data.lh_election
											) AS LH_ELCETION
										JOIN 
											(SELECT lhelc_id, pty_id 
												FROM config_data.lh_seat_results
											) AS LH_SEAT_RESULTS
										USING(lhelc_id)
									) AS CUR_LHELC 
							WHERE CUR_LHELC.lhelc_nxt_id = PREV_LHELC.lhelc_id 
							AND CUR_LHELC.pty_id = PREV_LHELC.pty_id
						) AS SEATS
					USING(lhelc_id)
					GROUP BY lhelc_id, pty_id
				) AS NEW_PTY_LH_STS_PCT
			GROUP BY lhelc_id
		) AS NEWENTRY_PARTIES
	USING(lhelc_id)
ORDER BY lhelc_id;


