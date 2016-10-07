CREATE OR REPLACE VIEW config_data.cc_missing_lh_pty_sts_records
AS
WITH 
lh_sres AS (SELECT lh_id, pty_id, pty_lh_sts::NUMERIC, 
		(COALESCE( pty_lh_sts_pr, 0) + COALESCE(pty_lh_sts_pl, 0))::NUMERIC AS pty_lh_sts_computed 
		FROM config_data.lh_seat_results)
SELECT * FROM lh_sres
WHERE lh_id IN (SELECT lh_id FROM lh_sres WHERE pty_lh_sts IS NULL AND (pty_id - 999) % 1000 != 0)
ORDER BY lh_id, pty_id;
