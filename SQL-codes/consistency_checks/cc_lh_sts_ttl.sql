CREATE OR REPLACE VIEW config_data.cc_lh_sts_ttl
AS
WITH 
lower_house AS (SELECT lh_id, lh_sts_ttl FROM config_data.lower_house),
lh_sres AS (SELECT DISTINCT lh_id,
		SUM(COALESCE(pty_lh_sts,0)) OVER (PARTITION BY lh_id)::NUMERIC AS lh_sts_ttl_aggregate,
		SUM(COALESCE(pty_lh_sts_pl,0) + COALESCE(pty_lh_sts_pr,0)) OVER (PARTITION BY lh_id)::NUMERIC AS lh_sts_ttl_computed_aggregate
		FROM config_data.lh_seat_results)
SELECT lower_house.lh_id, lh_sts_ttl, lh_sts_ttl_aggregate, lh_sts_ttl_computed_aggregate
	FROM lower_house
	LEFT OUTER JOIN lh_sres USING (lh_id)
WHERE lh_sts_ttl != lh_sts_ttl_aggregate
OR    lh_sts_ttl != lh_sts_ttl_computed_aggregate
ORDER BY lh_id;