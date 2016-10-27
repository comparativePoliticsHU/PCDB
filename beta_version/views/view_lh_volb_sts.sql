CREATE OR REPLACE VIEW beta_version.view_lh_volb_sts
AS
WITH 
lh_ids AS (SELECT ctr_id, lh_id, lh_prv_id, lh_nxt_id FROM beta_version.lower_house) , -- WITH AS lh_ids, enlists lower house configurations 
lh_seat_res AS (SELECT lh_id, pty_id, pty_lh_sts::NUMERIC, 
			sum(pty_lh_sts::NUMERIC) OVER (PARTITION BY lh_id) AS lh_sts_ttl_computed
			FROM beta_version.lh_seat_results
			WHERE pty_lh_sts >= 1) , -- WITH AS lh_seat_res, records lower house seat results at the party level
invalid_lhs AS (SELECT DISTINCT lh_id
			FROM lh_seat_res 
			WHERE pty_lh_sts IS NULL
			OR (pty_lh_sts = 0 AND (pty_id - 999) % 1000 != 0)
			OR ((pty_lh_sts IS NOT NULL OR pty_lh_sts > 0) AND (pty_id - 999) % 1000 = 0)), -- WITH AS invalid_lhs, used for exclusion of lower house configurations in which a party abbrevation is neither Others nor Independent, yet no seat is recorded (aggregation of seat shares would be erroneous)
prev_lh AS (SELECT lh_id, pty_id, 
		(pty_lh_sts/lh_sts_ttl_computed) AS pty_prv_lh_sts_shr 
		FROM lh_seat_res), -- WITH AS prev_lh
cur_lh AS (SELECT lh_ids.lh_id, lh_prv_id, pty_id, 
		(pty_lh_sts/lh_sts_ttl_computed) AS pty_cur_lh_sts_shr 
		FROM lh_seat_res LEFT OUTER JOIN lh_ids USING(lh_id)) -- WITH AS cur_lh		
SELECT DISTINCT 
	cur_lh.lh_id AS lh_id, 
	CASE WHEN cur_lh.lh_id IN (SELECT * FROM invalid_lhs) -- when for at least one party NULL seats are record, 
		THEN NULL -- aggregation of seats will be erroneous, and no valid Seats B Volatility can be computed
		ELSE COALESCE((SUM(ABS(pty_prv_lh_sts_shr-pty_cur_lh_sts_shr)) OVER (PARTITION BY cur_lh.lh_id))/2, 0) 
	END AS lh_volb_sts_computed
	FROM lh_ids
	LEFT OUTER JOIN cur_lh ON (cur_lh.lh_id = lh_ids.lh_id)
	LEFT OUTER JOIN prev_lh ON (cur_lh.lh_prv_id = prev_lh.lh_id AND cur_lh.pty_id = prev_lh.pty_id) -- joining current on previous lower house configs by CUR_LH.lh_prv_id = PRV_LH.lh_id allows to identify parties in current lower house that were already in previous lower house, i.e., that are stable parties
ORDER BY lh_id;	