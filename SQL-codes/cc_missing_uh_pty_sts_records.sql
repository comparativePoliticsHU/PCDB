CREATE OR REPLACE VIEW config_data.cc_missing_uh_pty_sts_records
AS
SELECT uh_id, pty_id, pty_uh_sts 
	FROM config_data.uh_seat_results
	WHERE uh_id 
	IN 
		(SELECT uh_id
			FROM  
				(SELECT uh_id, pty_id, pty_uh_sts 
					FROM config_data.uh_seat_results
				) AS UH_SEATS
			JOIN
				(SELECT pty_id, pty_abr 
					FROM config_data.party
				) AS PARTIES 
			USING(pty_id)
			WHERE pty_uh_sts IS NULL 
			AND pty_abr NOT LIKE 'Other'
		)
ORDER BY uh_id, pty_id;
