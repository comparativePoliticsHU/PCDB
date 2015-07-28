CREATE VIEW config_data.view_Others_and_INDs
AS
SELECT pty_id 
	FROM 
		(SELECT pty_id, pty_abr 
			FROM config_data.party 
			WHERE pty_abr LIKE 'Other%' 
			OR pty_abr LIKE 'IND'
		) AS Others_and_INDs;