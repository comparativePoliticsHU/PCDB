CREATE OR REPLACE VIEW config_data.view_lh_enpp_minfrag
AS
WITH
lh_sres AS (SELECT lh_id, pty_id, 
			pty_lh_sts::NUMERIC,
			(COALESCE(pty_lh_sts_pr, 0) + 
			 COALESCE(pty_lh_sts_pl, 0))::NUMERIC AS pty_lh_sts_computed,
			SUM(COALESCE(pty_lh_sts_pr, 0) + 
			    COALESCE(pty_lh_sts_pl, 0)
			) OVER (PARTITION BY lh_id)::NUMERIC AS lh_sts_ttl_computed, --  suming parties' seats within lower house configurations to total lower house seats
			((COALESCE(pty_lh_sts_pr, 0) + COALESCE(pty_lh_sts_pl, 0))::NUMERIC/
			 (SUM(COALESCE(pty_lh_sts_pr, 0) + 
			      COALESCE(pty_lh_sts_pl, 0)
			 ) OVER (PARTITION BY lh_id))::NUMERIC
			) AS pty_lh_sts_shr -- computing parties's seat shares in given lower house
			FROM config_data.lh_seat_results
			WHERE COALESCE(pty_lh_sts_pr, 0) + 
			      COALESCE(pty_lh_sts_pl, 0) > 0)
SELECT lh_id, 1/SUM(pty_lh_sts_shr^2.0) AS lh_enpp_minfrag -- Effective Number of Parties in Parliament according to Laakso and Taagepera
	FROM lh_sres
	GROUP BY lh_id
ORDER BY lh_id;

		