CREATE OR REPLACE VIEW config_data.cc_missing_lhelc_pty_vts_and_sts_records
AS
WITH 
lhelc_vres AS (SELECT lhelc_id, pty_id, pty_lh_vts_pr, pty_lh_vts_pl FROM config_data.lh_vote_results),
invalid_lhelc_vres AS (SELECT DISTINCT lhelc_id
				FROM  lhelc_vres
				WHERE pty_lh_vts_pr IS NULL 
				AND pty_lh_vts_pl IS NULL 
				AND (pty_id - 999) % 1000 != 0), 
lh_sres AS (SELECT lh_id, lhelc_id, pty_id, pty_lh_sts_pr, pty_lh_sts_pl 
		FROM config_data.lh_seat_results
		JOIN (SELECT lh_id, lhelc_id FROM config_data.lower_house) AS ids USING (lh_id))
SELECT lhelc_id, pty_id, pty_lh_vts_pr, pty_lh_vts_pl, 
	lh_id, pty_lh_sts_pr, pty_lh_sts_pl 
	FROM lh_sres
	JOIN (SELECT * FROM lhelc_vres WHERE lhelc_id IN (SELECT * FROM invalid_lhelc_vres)) AS vres
USING(lhelc_id, pty_id);