CREATE OR REPLACE VIEW config_data.cc_cabinet_hog_info
AS
SELECT cab_id, COUNT(pty_id) 
	FROM config_data.cabinet_portfolios
	WHERE pty_cab_hog IS TRUE 
	GROUP BY cab_id 
	HAVING COUNT(pty_id) <> 1
ORDER BY cab_id;