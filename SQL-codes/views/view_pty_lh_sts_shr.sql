CREATE OR REPLACE VIEW config_data.view_pty_lh_sts_shr
AS
SELECT lh_id, pty_id,
	(COALESCE(pty_lh_sts_pr, 0) + COALESCE(pty_lh_sts_pl, 0))::NUMERIC AS pty_lh_sts_computed,
	NULLIF(SUM((COALESCE(pty_lh_sts_pr, 0) + COALESCE(pty_lh_sts_pl, 0))) OVER (PARTITION BY lh_id), 0)::NUMERIC AS lh_sts_ttl_computed,
	CASE WHEN (SUM(COALESCE(pty_lh_sts_pr, 0) + COALESCE(pty_lh_sts_pl, 0)) OVER (PARTITION BY lh_id) = 0)
		THEN NULL::NUMERIC 
		ELSE ((COALESCE(pty_lh_sts_pr, 0) + COALESCE(pty_lh_sts_pl, 0))::NUMERIC 
			/ SUM((COALESCE(pty_lh_sts_pr, 0) + COALESCE(pty_lh_sts_pl, 0))::NUMERIC) OVER (PARTITION BY lh_id) )
	END AS pty_lhelc_sts_shr_computed
	FROM config_data.lh_seat_results
ORDER BY lh_id, pty_id;