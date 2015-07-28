CREATE VIEW config_data.view_pty_cab_sts
AS
SELECT cab_id, COUNT(cab_id) AS pty_cab_sts 
	FROM config_data.cabinet_portfolios
	WHERE pty_cab IS TRUE
	GROUP BY cab_id
ORDER BY cab_id;