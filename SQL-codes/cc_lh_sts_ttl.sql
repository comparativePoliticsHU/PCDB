CREATE OR REPLACE VIEW config_data.cc_lh_sts_ttl
AS
SELECT lh_id, lh_sts_ttl, lh_sts_ttl_computed
FROM	
	(SELECT lh_id, lh_sts_ttl
		FROM config_data.lower_house
	) AS LOWER_HOUSE
JOIN
	(SELECT lh_id, 
		SUM(COALESCE(pty_lh_sts_pl,0)
		+ COALESCE(pty_lh_sts_pr,0))::NUMERIC 
			AS lh_sts_ttl_computed
		FROM config_data.lh_seat_results
		GROUP BY lh_id
	) AS LH_STS_TTL_COMPUTED
USING(lh_id)
WHERE lh_sts_ttl <> lh_sts_ttl_computed
ORDER BY lh_id;