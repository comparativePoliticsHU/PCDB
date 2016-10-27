CREATE VIEW config_data.cc_lh_sts_ttl_distrib
AS
SELECT *
	FROM
		(SELECT lh_id, lhelc_id, lhelc_sts_ttl
			FROM
				(SELECT lh_id, lhelc_id
					FROM config_data.lower_house
				) AS LOWER_HOUSE
			JOIN
				(SELECT lhelc_id, lhelc_sts_ttl 
					FROM config_data.lh_election
				) AS LH_ELECTION
			USING(lhelc_id)
		) AS RECORDED
	JOIN 
		(SELECT lh_id,SUM(pty_lh_sts) AS lh_sts_ttl_computed
			FROM config_data.lh_seat_results
			GROUP BY lh_id
		) AS COMPUTED
USING(lh_id)
WHERE lh_sts_ttl_computed != lhelc_sts_ttl;