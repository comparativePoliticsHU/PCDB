CREATE OR REPLACE VIEW config_data.view_lhelc_volb_vts
AS
SELECT lhelc_id, lhelc_volb_vts_computed
	FROM 
		(SELECT lhelc_id 
			FROM config_data.lh_election
		) AS ALL_LH_ELECTIONS
	LEFT OUTER JOIN
		(SELECT lhelc_id, 
			(SUM(pty_lh_vts_shr_diff)/2)::DOUBLE PRECISION 
				AS lhelc_volb_vts_computed
			FROM
				(SELECT CUR_LHELC_VTS_SHR.lhelc_id AS lhelc_id, 
					ABS(PREV_LHELC_VTS_SHR.pty_prv_lh_vts_shr 
					- CUR_LHELC_VTS_SHR.pty_cur_lh_vts_shr) 
						AS pty_lh_vts_shr_diff
					FROM
						(SELECT lhelc_id, pty_id, 
						100*(VOTES.pty_lh_vts_computed
						/VOTES_TOTAL.lhelc_vts_ttl_computed) 
							AS pty_prv_lh_vts_shr
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
								) AS VOTES
							USING(lhelc_id)
						) AS PREV_LHELC_VTS_SHR 	
					,
						(SELECT lhelc_id, lhelc_prv_id, pty_id, 
							100*(pty_lh_vts_computed
							/lhelc_vts_ttl_computed) 
								AS pty_cur_lh_vts_shr
							FROM
								(SELECT lhelc_id, 
									SUM(COALESCE(pty_lh_vts_pl, 0)
									+ COALESCE(pty_lh_vts_pr, 0))::NUMERIC
										AS lhelc_vts_ttl_computed 
									FROM config_data.lh_vote_results
									GROUP BY lhelc_id
								) AS VOTES_TOTAL
							JOIN
								(SELECT lhelc_id, lhelc_prv_id, pty_id, pty_lh_vts_computed
									FROM
										(SELECT lhelc_id, lhelc_prv_id
											FROM config_data.lh_election
										) AS LH_ELECTION
									JOIN
										(SELECT lhelc_id, pty_id, 
											(COALESCE(pty_lh_vts_pl, 0)
											+ COALESCE(pty_lh_vts_pr, 0))::numeric 
												AS pty_lh_vts_computed
											FROM config_data.lh_vote_results
											WHERE pty_id 
											NOT IN
												(SELECT pty_id 
													FROM config_data.party
													WHERE pty_abr LIKE 'Other'
												)
										) AS LH_VOTE_RESULTS
									USING(lhelc_id)
								) AS CUR_LHELC_VTS
							USING(lhelc_id)
						) AS CUR_LHELC_VTS_SHR
					WHERE CUR_LHELC_VTS_SHR.lhelc_prv_id = PREV_LHELC_VTS_SHR.lhelc_id 
					AND CUR_LHELC_VTS_SHR.pty_id = PREV_LHELC_VTS_SHR.pty_id
				) AS PTY_VTS_SHR_DIFF
			WHERE lhelc_id 
			NOT IN
				(SELECT DISTINCT lhelc_id
					FROM  
						(SELECT lhelc_id, pty_id, 
							(COALESCE(pty_lh_vts_pr,0)
							+ COALESCE(pty_lh_vts_pl,0))::NUMERIC 
								AS pty_lh_vts_computed 
							FROM config_data.lh_vote_results
						) AS LH_VOTES
					JOIN
						(SELECT pty_id, pty_abr 
							FROM config_data.party
						) AS PARTIES 
					USING(pty_id)
					WHERE pty_lh_vts_computed = 0 
					AND pty_abr NOT LIKE 'Other'
				) 
		GROUP BY lhelc_id
		) AS VALID_LHELC_VOLB_VTS
	USING(lhelc_id)
ORDER BY lhelc_id;