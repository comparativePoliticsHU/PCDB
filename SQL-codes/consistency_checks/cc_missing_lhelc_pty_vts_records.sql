CREATE OR REPLACE VIEW config_data.cc_missing_lhelc_pty_vts_records
AS
WITH 
lhelc_vres AS (SELECT lhelc_id, pty_id,
			(COALESCE(pty_lh_vts_pr,0)+ COALESCE(pty_lh_vts_pl,0))::NUMERIC AS pty_lh_vts_computed
		FROM config_data.lh_vote_results),
invalid_lhelcs AS (SELECT DISTINCT lhelc_id FROM lhelc_vres 
			WHERE pty_lh_vts_computed = 0 
			AND (pty_id - 999) % 1000 != 0)	
SELECT * FROM lhelc_vres WHERE lhelc_id IN (SELECT * FROM invalid_lhelcs);
