CREATE VIEW config_data.cc_missing_lhelc_pty_vts_and_sts_records
AS
SELECT *
FROM
	(SELECT lhelc_id, pty_id, pty_lh_vts_pr, pty_lh_vts_pl 
		FROM config_data.lh_vote_results
		WHERE lhelc_id 
		IN 
			(SELECT lhelc_id
				FROM  
					(SELECT lhelc_id, pty_id, pty_lh_vts_pr, pty_lh_vts_pl F
						ROM config_data.lh_vote_results
					) AS LH_VOTES
				JOIN
					(SELECT pty_id, pty_abr 
						FROM config_data.party
					) AS PARTIES 
				USING(pty_id)
				WHERE pty_lh_vts_pr IS NULL AND pty_lh_vts_pl IS NULL 
				AND pty_abr NOT LIKE '%Other')
	) AS VOTES
JOIN
	(SELECT lhelc_id, pty_id, pty_lh_sts_pr, pty_lh_sts_pl 
		FROM config_data.lh_seat_results
	) SEATS
USING(lhelc_id, pty_id);