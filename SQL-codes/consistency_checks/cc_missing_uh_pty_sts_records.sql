CREATE OR REPLACE VIEW config_data.cc_missing_uh_pty_sts_records
AS
WITH 
uh_sres AS (SELECT uh_id, pty_id, pty_uh_sts FROM config_data.uh_seat_results),
invalid_uhs AS (SELECT DISTINCT uh_id FROM uh_sres
			WHERE pty_uh_sts IS NULL 
			AND (pty_id - 999) % 1000 != 0)			
SELECT * FROM uh_sres
	WHERE uh_id IN (SELECT * FROM invalid_uhs)
