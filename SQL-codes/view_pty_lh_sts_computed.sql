CREATE OR REPLACE VIEW config_data.view_pty_lh_sts_computed
AS
SELECT lhsres_id, lhelc_id, pty_id, pty_lh_sts,
	(COALESCE(pty_lh_sts_pr,0)
	+ COALESCE(pty_lh_sts_pl,0)) 
		AS pty_lh_sts_computed
	FROM config_data.lh_seat_results
ORDER BY lhelc_id, pty_id;