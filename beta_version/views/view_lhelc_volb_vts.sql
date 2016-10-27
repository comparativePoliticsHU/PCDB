CREATE OR REPLACE VIEW beta_version.view_lhelc_volb_vts
AS
WITH 
lhelc_ids AS (SELECT lhelc_id, lhelc_prv_id, lhelc_nxt_id FROM beta_version.lh_election) , -- WITH AS lhelc_ids, enlists lower house election configuration IDS 
lh_ids AS (SELECT * FROM lhelc_ids
		RIGHT OUTER JOIN (SELECT ctr_id, lh_id, lhelc_id FROM beta_version.lower_house) AS LHS USING (lhelc_id)), -- WITH AS lh_ids, enlists lower house configurations with corresponding elections 
lhelc_vres AS (SELECT lhelc_id, pty_id, 
			(COALESCE(pty_lh_vts_pr,0) + COALESCE(pty_lh_vts_pl,0))::NUMERIC AS pty_lhelc_vts_computed, -- adding party'S plurality and proportional votes to total votes
			(sum(COALESCE(pty_lh_vts_pr,0) + COALESCE(pty_lh_vts_pl,0)) OVER (PARTITION BY lhelc_id) )::NUMERIC AS lhelc_vts_ttl_computed -- suming parties' total votes within lower house elections to total lower house election vote cast
		FROM beta_version.lh_vote_results
		WHERE (pty_id - 999) % 1000 != 0), -- ‘Others without seat’ (pty_id is ##999) are excluded from the computation of individual parties’ vote shares,cause volatility in the lower house is of interest (not volatility in the party system more generally)
lh_vote_res AS (SELECT *, (pty_lhelc_vts_computed/lhelc_vts_ttl_computed) AS pty_lhelc_vts_shr_computed -- computes party's vote share
		FROM lh_ids LEFT OUTER JOIN lhelc_vres USING (lhelc_id)), -- WITH AS lhelc_vote_res, records lower house election vote results at party level 
prev_lhelc AS (SELECT lhelc_id, pty_id, pty_lhelc_vts_shr_computed AS pty_lhelc_vts_shr FROM lh_vote_res), 
cur_lhelc AS (SELECT lhelc_id, lhelc_prv_id, pty_id, pty_lhelc_vts_shr_computed AS pty_cur_lhelc_vts_shr FROM lh_vote_res)
SELECT DISTINCT ON (lh_id, lhelc_id) lh_id, lh_ids.lhelc_id,
	(SUM(ABS(pty_lhelc_vts_shr-pty_cur_lhelc_vts_shr)) OVER (PARTITION BY lh_ids.lhelc_id) )/2 AS lhelc_volb_vts_computed
	FROM lh_ids
	LEFT OUTER JOIN cur_lhelc ON (cur_lhelc.lhelc_id = lh_ids.lhelc_id)
	LEFT OUTER JOIN prev_lhelc ON (cur_lhelc.lhelc_prv_id = prev_lhelc.lhelc_id AND cur_lhelc.pty_id = prev_lhelc.pty_id) -- joining current on previous lower house elections configurations by CUR_LHELC_VTS_SHR.lhelc_prv_id = PREV_LHELC_VTS_SHR.lhelc_id allows to identify parties in current election that already contested in previous election, i.e., that are stable parties
ORDER BY lh_id, lhelc_id;	