CREATE OR REPLACE VIEW config_data.view_lh_sts_ttl_computed
AS
SELECT lh_id, SUM(COALESCE(pty_lh_sts_pl,0)+COALESCE(pty_lh_sts_pr,0))::NUMERIC 
			AS lh_sts_ttl_computed
	FROM config_data.lh_seat_results
	GROUP BY lh_id
ORDER BY lh_id;
