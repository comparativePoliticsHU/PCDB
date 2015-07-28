CREATE VIEW config_data.cc_no_lsq_noothersw
AS
SELECT DISTINCT lhelc_id
	FROM  
		(SELECT * 
			FROM
				(SELECT lhelc_id, pty_id, pty_lh_sts_pr, pty_lh_sts_pl 
					FROM config_data.lh_seat_results
				) AS LH_SEATS
			JOIN
				(SELECT pty_id, pty_abr
					FROM config_data.party
				) AS PARTIES 
			USING(pty_id)
		) AS SEATS
	JOIN
		(SELECT * 
			FROM
				(SELECT lhelc_id, pty_id, pty_lh_vts_pr, pty_lh_vts_pl 
					FROM config_data.lh_vote_results
				) AS LH_SEATS
			JOIN
				(SELECT pty_id, pty_abr 
					FROM config_data.party
				) AS PARTIES 
			USING(pty_id)
		) AS VOTES
	USING(lhelc_id, pty_id)
	WHERE pty_lh_vts_pr IS NULL 
		AND pty_lh_vts_pl IS NULL 
		AND VOTES.pty_abr NOT LIKE '%Other' 
		AND VOTES.pty_abr NOT LIKE '%Otherw'
	OR pty_lh_sts_pr IS NULL 
		AND pty_lh_sts_pl IS NULL 
		AND SEATS.pty_abr NOT LIKE '%Other' 
		AND SEATS.pty_abr NOT LIKE '%Otherw'
ORDER BY lhelc_id;
