CREATE VIEW config_data.view_Others_and_INDs
AS
SELECT DISTINCT pty_id
	FROM config_data.party 
	WHERE (pty_id - 999) % 1000 = ANY ('{0, 998, 999}'::int[])