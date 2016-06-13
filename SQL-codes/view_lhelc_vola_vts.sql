CREATE OR REPLACE VIEW config_data.view_lhelc_vola_vts
AS
SELECT lhelc_id, 
	(ABS(COALESCE(old_pty_sum, 0) 
	+ COALESCE(new_pty_sum, 0))/2)::DOUBLE PRECISION 
		AS lhelc_vola_vts_computed
	FROM
		(SELECT lhelc_id, old_pty_sum
			FROM
				(SELECT lhelc_id
					FROM config_data.lh_election
				) AS LH_CONFIGS
			LEFT OUTER JOIN 
				(SELECT lhelc_nxt_id AS lhelc_id, 
					SUM(new_pty_lh_vts_shr) AS old_pty_sum
					FROM
						(SELECT lhelc_id, lhelc_nxt_id
							FROM config_data.lh_election
						) AS LH_ELECTION
					JOIN
						(SELECT lhelc_id, pty_id, 
							100*(VOTES.pty_lh_vts_computed
							/VOTES_TOTAL.lhelc_vts_ttl_computed) 
								AS new_pty_lh_vts_shr
							FROM
								(SELECT lhelc_id, 
									SUM(COALESCE(pty_lh_vts_pl, 0)
									+ COALESCE(pty_lh_vts_pr, 0))::NUMERIC 
										AS lhelc_vts_ttl_computed 
									FROM config_data.lh_vote_results
								GROUP BY lhelc_id
								) AS VOTES_TOTAL
							JOIN
								(SELECT lhelc_id, pty_id, 
									(COALESCE(pty_lh_vts_pl, 0)
									+ COALESCE(pty_lh_vts_pr, 0))::NUMERIC 
										AS pty_lh_vts_computed 
									FROM config_data.lh_vote_results
									WHERE pty_id 
									NOT IN
										(SELECT pty_id 
											FROM config_data.party
											WHERE pty_abr LIKE 'Other'
										)
									EXCEPT 
										SELECT lhelc_id, CUR_LHELC.pty_id AS pty_id, pty_lh_vts_computed
											FROM 
												(SELECT lhelc_id, pty_id, 
													(COALESCE(pty_lh_vts_pl, 0)
													+ COALESCE(pty_lh_vts_pr, 0))::NUMERIC 
														AS pty_lh_vts_computed
													FROM config_data.lh_vote_results
												) AS PREV_LHELC 
											,
												(SELECT lhelc_prv_id, pty_id 
													FROM 
														(SELECT lhelc_id, lhelc_prv_id 
															FROM config_data.lh_election
														) AS LH_ELECTION
													JOIN 
														(SELECT lhelc_id, pty_id 
															FROM config_data.lh_vote_results
														) AS LH_VOTE_RESULTS
													USING(lhelc_id)
												) AS CUR_LHELC 
										WHERE CUR_LHELC.lhelc_prv_id = PREV_LHELC.lhelc_id 
										AND CUR_LHELC.pty_id = PREV_LHELC.pty_id 
								) AS VOTES
							USING(lhelc_id)
						) AS OLD_PARTY_SHR_SUM
					USING(lhelc_id)
					GROUP BY lhelc_nxt_id
				) AS OLD_PARTIES
			USING(lhelc_id)
		) AS LH_RETIRING_PARTIES
	LEFT OUTER JOIN 
		(SELECT lhelc_id, SUM(new_pty_lh_vts_shr) AS new_pty_sum
			FROM
				(SELECT lhelc_id, pty_id, 
					100*(VOTES.pty_lh_vts_computed/VOTES_TOTAL.lhelc_vts_ttl_computed) AS new_pty_lh_vts_shr
					FROM
						(SELECT lhelc_id, 
							SUM(COALESCE(pty_lh_vts_pl, 0)
							+ COALESCE(pty_lh_vts_pr, 0))::NUMERIC 
								AS lhelc_vts_ttl_computed 
							FROM config_data.lh_vote_results
						GROUP BY lhelc_id
						) AS VOTES_TOTAL
					JOIN
						(SELECT lhelc_id, pty_id, 
							(COALESCE(pty_lh_vts_pl, 0)
							+ COALESCE(pty_lh_vts_pr, 0))::NUMERIC 
								AS pty_lh_vts_computed 
							FROM config_data.lh_vote_results
						WHERE pty_id 
						NOT IN
							(SELECT pty_id 
								FROM config_data.party
								WHERE pty_abr LIKE 'Other'
							)
						AND lhelc_id 
						NOT IN
							(SELECT MAX(lhelc_id) AS lhelc_id
								FROM config_data.lh_election
								GROUP BY ctr_id
							)
						EXCEPT 
							SELECT lhelc_id, CUR_LHELC.pty_id AS pty_id, pty_lh_vts_computed
								FROM 
									(SELECT lhelc_id, pty_id, 
										(COALESCE(pty_lh_vts_pl, 0)
										+ COALESCE(pty_lh_vts_pr, 0))::NUMERIC 
											AS pty_lh_vts_computed
										FROM config_data.lh_vote_results
									) AS PREV_LHELC 
								,
									(SELECT lhelc_nxt_id, pty_id 
										FROM 
											(SELECT lhelc_id, lhelc_nxt_id 
												FROM config_data.lh_election
											) AS LH_ELECTION
										JOIN 
											(SELECT lhelc_id, pty_id 
												FROM config_data.lh_vote_results
											) AS LH_VOTE_RESULTS
										USING(lhelc_id)
									) AS CUR_LHELC 
							WHERE CUR_LHELC.lhelc_nxt_id = PREV_LHELC.lhelc_id 
							AND CUR_LHELC.pty_id = PREV_LHELC.pty_id 
						) AS VOTES
					USING(lhelc_id)
				) AS NEW_PARTY_VOTE_SHARES
			GROUP BY lhelc_id
		) AS NEW_PARTIES
	USING(lhelc_id)
ORDER BY lhelc_id;
