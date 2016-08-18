CREATE OR REPLACE VIEW beta_version.view_lh_vola_sts
AS
WITH 
	lh_ids AS (SELECT ctr_id, lh_id, lh_prv_id, lh_nxt_id FROM beta_version.lower_house) , -- WITH AS lh_ids, enlists lower house configurations
	lh_seat_res AS (SELECT lh_id, pty_id, pty_lh_sts::NUMERIC , 
		( sum(pty_lh_sts::NUMERIC ) OVER (PARTITION BY lh_id) ) AS lh_sts_ttl_computed --  suming parties' seats within lower house configurations to total lower house seats
		FROM beta_version.lh_seat_results
		WHERE pty_lh_sts >= 1 -- considering only parties that hold at least one seat
		AND lh_id IN (SELECT DISTINCT lh_id FROM lh_ids) -- this condition can be eliminated in config_data
		)  -- WITH AS lh_seat_res, records lower house seat results at party level 
SELECT LHS.lh_id, ABS(COALESCE(ret_ptys_sts_shr, 0) + COALESCE(new_ptys_sts_shr, 0))/2 AS lh_vola_sts_computed 
FROM
	(SELECT * FROM lh_ids) AS LHS
LEFT OUTER JOIN
	(SELECT DISTINCT ON (lh_id) lh_id, sum(pty_lh_sts/lh_sts_ttl_computed) OVER (PARTITION BY lh_id) AS new_ptys_sts_shr
		FROM lh_seat_res -- seat results of parties that were not in previous lower house, i.e., new-entry parties
			WHERE  (lh_id, pty_id) NOT IN (  -- by exclusion of present stable parties, only new-entry parties to current lower house configuration remain 
			SELECT DISTINCT ON (CUR_LH.lh_id, CUR_LH.pty_id) CUR_LH.lh_id, CUR_LH.pty_id 
				FROM	(SELECT DISTINCT ON (lh_id, pty_id) lh_id, pty_id FROM lh_seat_res ) AS CUR_LH
				JOIN 
					(SELECT DISTINCT ON (lh_id, pty_id) SRES.lh_id, lh_nxt_id, pty_id 
								FROM lh_seat_res AS SRES 
								JOIN lh_ids AS LH ON (SRES.lh_id=LH.lh_id) ) AS PRV_LH
				ON (CUR_LH.lh_id = PRV_LH.lh_nxt_id AND CUR_LH.pty_id=PRV_LH.pty_id)
				-- joining current on previous lower house configurations 
				-- by CUR_LH.lh_id = PRV_LH.lh_nxt_id allows to identify parties 
				-- that entered both the previous and the current lower, i.e., that present stable parties
				) 
			AND lh_id NOT IN (SELECT min(lh_id) OVER (PARTITION BY ctr_id) FROM lh_ids) -- exclusion of first config, for no previous config exists
	) AS NEW_PTYS USING(lh_id)
LEFT OUTER JOIN
	(SELECT DISTINCT ON (lh_id) lh_id, sum(pty_lh_sts/lh_sts_ttl_computed) OVER (PARTITION BY lh_id) AS ret_ptys_sts_shr
		FROM lh_seat_res -- seat results of parties not in next lower house, i.e., retiring parties
			WHERE  (lh_id, pty_id) NOT IN ( -- by exclusion of future stable parties, only parties that will retire from current lower house configuration remain
			SELECT DISTINCT ON (CUR_LH.lh_id, CUR_LH.pty_id) CUR_LH.lh_id, CUR_LH.pty_id 
			FROM	(SELECT DISTINCT ON (lh_id, pty_id) lh_id, pty_id FROM lh_seat_res ) AS CUR_LH
			JOIN 
				(SELECT DISTINCT ON (lh_id, pty_id) SRES.lh_id, lh_prv_id, pty_id 
							FROM lh_seat_res AS SRES 
							JOIN lh_ids AS LH ON (SRES.lh_id=LH.lh_id) ) AS NXT_LH
			ON (CUR_LH.lh_id = NXT_LH.lh_prv_id AND CUR_LH.pty_id=NXT_LH.pty_id)
			-- joining current on next lower house configurations
			-- by CUR_LH.lh_id = NXT_LH.lh_prv_id allows to identify parties 
			-- that were in both the current and the next lower house, i.e., future stable parties
			) 	
	) AS RET_PTYS ON(LHS.lh_prv_id=RET_PTYS.lh_id) 
	-- joining the set of future retiring parties on lower house configs by lh_prv_id
	-- identifies parties that were in last lower house but are not in current lower house
	-- configuration, i.e., parties that have acutally retired (from the perspective of the current configuration)
ORDER BY lh_id;