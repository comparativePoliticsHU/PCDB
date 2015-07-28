CREATE OR REPLACE VIEW config_data.cc_lh_and_lhelc_sts_ttl
AS
SELECT lh_id, lh_sts_ttl, lhelc_sts_ttl_computed, lhelc_id
FROM	
	(SELECT lh_id, lhelc_id, lh_sts_ttl
		FROM config_data.lower_house
	) AS LOWER_HOUSE
RIGHT OUTER JOIN
	(SELECT lhelc_id, 
		SUM(COALESCE(pty_lh_sts_pl,0)
		+ COALESCE(pty_lh_sts_pr,0))::NUMERIC
			AS lhelc_sts_ttl_computed
		FROM config_data.lh_seat_results
		GROUP BY lhelc_id
	) AS LHELC_STS_TTL_COMPUTED
USING(lhelc_id)
WHERE lh_sts_ttl <> lhelc_sts_ttl_computed
ORDER BY lh_id;
