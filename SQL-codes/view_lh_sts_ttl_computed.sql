CREATE OR REPLACE VIEW config_data.view_lh_sts_ttl_computed
AS
SELECT lh_id, lhelc_sts_ttl_computed AS lh_sts_ttl_computed 
FROM	
	(SELECT lh_id, lhelc_id 
		FROM config_data.lower_house
	) AS LOWER_HOUSE
RIGHT OUTER JOIN
	(SELECT lhelc_id, 	
		SUM(COALESCE(pty_lh_sts_pl,0)+COALESCE(pty_lh_sts_pr,0))::NUMERIC 
			AS lhelc_sts_ttl_computed
		FROM config_data.lh_seat_results
		GROUP BY lhelc_id
	) AS LHELC_STS_TTL_COMPUTED
USING(lhelc_id)
ORDER BY lh_id;
