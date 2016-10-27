CREATE OR REPLACE VIEW config_data.view_pty_uh_sts_shr
AS
SELECT uh_id, pty_id,
	pty_uh_sts,
	NULLIF(SUM(pty_uh_sts) OVER (PARTITION BY uh_id), 0)::NUMERIC AS uh_sts_ttl_computed,
	CASE WHEN (SUM(pty_uh_sts) OVER (PARTITION BY uh_id) = 0)
		THEN NULL::NUMERIC 
		ELSE (pty_uh_sts::NUMERIC / SUM(pty_uh_sts) OVER (PARTITION BY uh_id)::NUMERIC)
	END AS pty_uh_sts_shr_computed
	FROM config_data.uh_seat_results
ORDER BY uh_id, pty_id;