CREATE OR REPLACE VIEW config_data.cc_missing_lhelc_pty_sts_records
AS
SELECT lhelc_id, pty_id, pty_lh_sts 
	FROM config_data.lh_seat_results
	WHERE lhelc_id 
	IN 
		(SELECT lhelc_id
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
			AND pty_abr NOT LIKE 'Other'
		)
ORDER BY lhelc_id, pty_id;
