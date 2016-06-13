CREATE OR REPLACE VIEW config_data.cc_missing_lh_pty_sts_records
AS
SELECT lh_id, pty_id, pty_lh_sts 
	FROM config_data.lh_seat_results
	WHERE lh_id 
	IN 
		(SELECT lh_id
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
			AND pty_abr NOT LIKE 'Other'
		)
ORDER BY lh_id, pty_id;
