CREATE VIEW config_data.cc_pty_lh_sts
AS
SELECT lhelc_id, pty_id, 
	pty_lh_sts_pr, pty_lh_sts_pl, pty_lh_sts, 
	(COALESCE(pty_lh_sts_pr,0)+COALESCE(pty_lh_sts_pl,0)) AS pty_lh_sts_computed
	FROM config_data.lh_seat_results
WHERE pty_lh_sts != (COALESCE(pty_lh_sts_pr,0)+COALESCE(pty_lh_sts_pl,0));