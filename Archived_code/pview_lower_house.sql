CREATE OR REPLACE VIEW public.lower_house
AS
WITH 
countries AS (SELECT ctr_id, ctr_ccode FROM config_data.country),
lower_houses AS (SELECT * FROM config_data.lower_house),
lh_sts_ttl_computed AS (SELECT lh_id, 
				SUM(COALESCE(pty_lh_sts_pl,0)+
				    COALESCE(pty_lh_sts_pr,0)
				) OVER (PARTITION BY lh_id)::NUMERIC AS lh_sts_ttl_computed
				FROM config_data.lh_seat_results),
lh_enpp_minfrag AS (SELECT lh_id, lh_enpp_minfrag::NUMERIC(9,6) AS lh_enpp_minfrag_computed FROM config_data.view_lh_enpp_minfrag),
lh_enpp_maxfrag AS (SELECT lh_id, lh_enpp_maxfrag::NUMERIC(9,6) AS lh_enpp_maxfrag_computed FROM config_data.view_lh_enpp_maxfrag) 
SELECT lower_houses.ctr_id, ctr_ccode, lh_sdate,
	lower_houses.lh_id, lh_prv_id, lhelc_id, 
	lh_sts_ttl::NUMERIC, lh_sts_ttl_computed, 
	lh_enpp::NUMERIC(9,6), lh_enpp_minfrag_computed, lh_enpp_maxfrag_computed,
	pty_lh_rght, lh_cmt, lh_src
FROM
lower_houses
LEFT OUTER JOIN countries USING(ctr_id)
LEFT OUTER JOIN lh_sts_ttl_computed USING(lh_id)
LEFT OUTER JOIN lh_enpp_minfrag USING(lh_id)
LEFT OUTER JOIN lh_enpp_maxfrag USING(lh_id)
ORDER BY lh_id;
