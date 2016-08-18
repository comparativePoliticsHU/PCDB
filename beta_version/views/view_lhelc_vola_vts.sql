CREATE OR REPLACE VIEW beta_version.view_lhelc_vola_vts
AS
WITH 
	lhelc_ids AS (SELECT lhelc_id, lhelc_prv_id, lhelc_nxt_id FROM beta_version.lh_election) , -- WITH AS lhelc_ids, enlists lower house election IDs 
	lh_ids AS (SELECT * FROM lhelc_ids
			RIGHT OUTER JOIN (SELECT ctr_id, lh_id, lhelc_id FROM beta_version.lower_house) AS LHS USING (lhelc_id)
		), -- WITH AS lh_ids, enlists lower house configurations and corrsponding elections
	lhelc_vote_res AS (SELECT *, (pty_lhelc_vts_computed/lhelc_vts_ttl_computed) AS pty_lhelc_vts_shr_computed -- computes party's vote share
			FROM lh_ids LEFT OUTER JOIN
			(SELECT lhelc_id, pty_id, 
				(COALESCE(pty_lh_vts_pr,0) + COALESCE(pty_lh_vts_pl,0))::NUMERIC AS pty_lhelc_vts_computed, -- adding party'S plurality and proportional votes to total votes
				(sum(COALESCE(pty_lh_vts_pr,0) + COALESCE(pty_lh_vts_pl,0)) OVER (PARTITION BY lhelc_id) )::NUMERIC AS lhelc_vts_ttl_computed -- suming parties' total votes within lower house elections to total lower house election vote cast
				FROM beta_version.lh_vote_results
				WHERE pty_id NOT IN (SELECT DISTINCT pty_id FROM beta_version.party WHERE pty_abr LIKE 'Other')
				-- ‘Others without seat’ (pty_id is ##999) are excluded from the computation of individual parties’ vote shares,
				-- for volatility in the lower house is of interest (not volatility in the party system more generally)
			) AS LHELC_VRES USING (lhelc_id) 
		) -- WITH AS lhelc_vote_res, records lower house election vote results at party level 
SELECT LHS.lh_id, LHS.lhelc_id, 	
	CASE WHEN LHS.lhelc_id IS NULL -- if no corrsponding lhelc_id recorded for lower house configuration (e.g., in case of party split/merger),
		THEN NULL -- do not record volatility
		ELSE (abs(COALESCE(ret_ptys_vts_shr, 0) + COALESCE(new_ptys_vts_shr, 0))/2)*100 
	END AS lhelc_vola_vts_computed
FROM 
	lh_ids AS LHS -- list of all lower houses constitutes reference point
LEFT OUTER JOIN
	(SELECT DISTINCT ON (lhelc_id) lhelc_id, sum(pty_lhelc_vts_shr_computed) OVER (PARTITION BY lhelc_id) AS new_ptys_vts_shr -- commulated vote share received by new-entry parties
	FROM lhelc_vote_res
		WHERE  (lhelc_id, pty_id) NOT IN ( -- by exclusion of present stable parties, only new-entry parties to current election remain 
			SELECT DISTINCT ON (CUR_LHELC.lhelc_id, CUR_LHELC.pty_id) CUR_LHELC.lhelc_id, CUR_LHELC.pty_id
				FROM
					(SELECT lhelc_id, lhelc_nxt_id, pty_id 
						FROM lhelc_ids JOIN (SELECT lhelc_id, pty_id FROM lhelc_vote_res) AS VRES USING(lhelc_id) 
					) AS PREV_LHELC 
				JOIN
					(SELECT lhelc_id, pty_id FROM lhelc_vote_res) AS CUR_LHELC 
				ON ( CUR_LHELC.lhelc_id = PREV_LHELC.lhelc_nxt_id AND CUR_LHELC.pty_id = PREV_LHELC.pty_id )
				-- joining current lower houses on previous lower house configs 
				-- by CUR_LHELC.lhelc_id = PRV_LHELC.lh_nxt_id allows to identify parties 
				-- that contested the previous and the current lower house election, i.e., present stable parties
				) 
		AND lhelc_id NOT IN (SELECT min(lhelc_id) OVER (PARTITION BY ctr_id) FROM lh_ids) -- exclusion of first config, for no previous config exists
	) AS NEW_PTYS USING(lhelc_id)
LEFT OUTER JOIN 
	(SELECT DISTINCT ON (lhelc_id) lhelc_id, sum(pty_lhelc_vts_shr_computed) OVER (PARTITION BY lhelc_id) AS ret_ptys_vts_shr
		FROM lhelc_vote_res
		WHERE  (lhelc_id, pty_id) NOT IN ( -- by exclusion of future stable parties, only parties that will retire from current election remain
			SELECT DISTINCT ON (CUR_LHELC.lhelc_id, CUR_LHELC.pty_id) CUR_LHELC.lhelc_id, CUR_LHELC.pty_id
				FROM
					(SELECT lhelc_id, lhelc_prv_id, pty_id 
						FROM lhelc_ids JOIN (SELECT lhelc_id, pty_id FROM lhelc_vote_res) AS VRES USING(lhelc_id) 
					) AS NXT_LHELC 
				JOIN
					(SELECT lhelc_id, pty_id FROM lhelc_vote_res) AS CUR_LHELC 
				ON (CUR_LHELC.lhelc_id = NXT_LHELC.lhelc_prv_id AND CUR_LHELC.pty_id=NXT_LHELC.pty_id)
				-- joining current on next lower house election configs 
				-- by CUR_LHELC.lhelc_id = NXT_LHELC.lhelc_prv_id allows to identify parties 
				-- that contested both the current and the next lower house election, i.e., future stable parties
		) 
		AND lhelc_id NOT IN (SELECT max(lhelc_id) OVER (PARTITION BY ctr_id) FROM lh_ids) -- exclusion of first config, for no previous config exists
	) AS RET_PTYS ON(LHS.lhelc_prv_id=RET_PTYS.lhelc_id) 
	-- joining the set of future retiring parties on lower house election by lhelc_prv_id identifies 
	-- parties that contested last lower house election but did not contest the current lower house election,
	-- i.e., parties that have acutally retired (from the perspective of the current config)
ORDER BY lh_id;