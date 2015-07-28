CREATE OR REPLACE VIEW config_data.cc_missing_lhelc_pty_vts_records
AS
SELECT lhelc_id, pty_id, 
	(COALESCE(pty_lh_vts_pr,0)
	+ COALESCE(pty_lh_vts_pl,0)) 
		AS pty_lh_vts_computed
	FROM config_data.lh_vote_results
	WHERE lhelc_id 
	IN 
		(SELECT lhelc_id
			FROM  
				(SELECT lhelc_id, pty_id, 
					(COALESCE(pty_lh_vts_pr,0) 
					+ COALESCE(pty_lh_vts_pl,0)) 
						AS pty_lh_vts_computed 
					FROM config_data.lh_vote_results
				) AS LH_VOTES
			JOIN
				(SELECT pty_id, pty_abr 
					FROM config_data.party
				) AS PARTIES 
			USING(pty_id)
		WHERE pty_lh_vts_computed = 0 
		AND pty_abr NOT LIKE '%Other'
		)	
ORDER BY lhelc_id, pty_id;
