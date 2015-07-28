CREATE VIEW config_data.CC_lhelc_sts_ttl
AS
SELECT *
	FROM
		(SELECT lhelc_id, lhelc_sts_ttl 
			FROM config_data.lh_election
		) AS RECORDED
	JOIN 
		(SELECT lhelc_id,SUM(pty_lh_sts) AS lhelc_sts_ttl_computed
			FROM config_data.lh_seat_results
			GROUP BY lhelc_id
		) AS COMPUTED
USING(lhelc_id)
WHERE lhelc_sts_ttl_computed != lhelc_sts_ttl;