CREATE OR REPLACE VIEW beta_version.view_lh_volb_sts
AS
WITH 
	lh_ids AS (SELECT ctr_id, lh_id, lh_prv_id, lh_nxt_id FROM beta_version.lower_house) , -- WITH AS lh_ids, enlists lower house configurations 
	lh_seat_res AS (SELECT lh_id, pty_id, pty_lh_sts::NUMERIC , ( sum(pty_lh_sts::NUMERIC ) OVER (PARTITION BY lh_id) ) AS lh_sts_ttl_computed
		FROM beta_version.lh_seat_results
		WHERE pty_lh_sts >= 1 
		AND lh_id IN (SELECT DISTINCT lh_id FROM lh_ids) -- this condition can be eliminated in config_data
		) , -- WITH AS lh_seat_res, records lower house seat results at the party level
	invalid_lhs AS (SELECT DISTINCT lh_id
				FROM lh_seat_res JOIN (SELECT pty_id, pty_abr FROM beta_version.party ) AS PARTIES USING(pty_id)
				WHERE pty_lh_sts IS NULL 
				AND pty_abr NOT LIKE '%Other' 
				AND pty_abr NOT LIKE 'IND' ) -- WITH AS invalid_lhs, used for exclusion of lower house configurations in which a party abbrevation is neither Others nor Independent, yet no seat is recorded (aggregation of seat shares would be erroneous)
SELECT DISTINCT CUR_lh_STS_SHR.lh_id AS lh_id, 
	CASE WHEN CUR_lh_STS_SHR.lh_id IN (SELECT * FROM invalid_lhs) -- when for at least one party NULL seats are record, 
		THEN NULL -- aggregation of seats will be erroneous, and no valid Seats B Volatility can be computed
		ELSE (sum(abs(pty_prv_lh_sts_shr-pty_cur_lh_sts_shr)) OVER (PARTITION BY CUR_lh_STS_SHR.lh_id) )/2 
	END AS lh_volb_sts_computed
	FROM
		( SELECT lh_id, pty_id, (pty_lh_sts/lh_sts_ttl_computed) AS pty_prv_lh_sts_shr FROM lh_seat_res ) AS PREV_LH_STS_SHR 
	JOIN
		( SELECT lh_ids.lh_id, lh_prv_id, pty_id, (pty_lh_sts/lh_sts_ttl_computed) AS pty_cur_lh_sts_shr 
			FROM lh_ids RIGHT OUTER JOIN lh_seat_res USING(lh_id) ) AS CUR_LH_STS_SHR
	ON ( CUR_LH_STS_SHR.lh_prv_id = PREV_LH_STS_SHR.lh_id AND CUR_LH_STS_SHR.pty_id = PREV_LH_STS_SHR.pty_id )
-- joining current on previous lower house configs 
-- by CUR_LH.lh_prv_id = PRV_LH.lh_id allows to identify parties in current lower house
-- that were already in previous lower house, i.e., that are stable parties
ORDER BY lh_id;	