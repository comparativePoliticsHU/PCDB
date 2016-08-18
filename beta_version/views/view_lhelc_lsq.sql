CREATE OR REPLACE VIEW beta_version.view_lhelc_lsq
AS
WITH 
	lhelc_ids AS (SELECT lhelc_id, lhelc_prv_id, lhelc_nxt_id FROM beta_version.lh_election) , --WITH AS lhelc_ids
	lh_ids AS (SELECT * FROM lhelc_ids
			RIGHT OUTER JOIN (SELECT ctr_id, lh_id, lhelc_id FROM beta_version.lower_house) AS LHS USING (lhelc_id)
		), -- WITH AS lh_ids
	lhelc_vote_res AS (SELECT *, (pty_lhelc_vts_computed/lhelc_vts_ttl_computed) AS pty_lhelc_vts_shr_computed
			FROM lh_ids LEFT OUTER JOIN
			(SELECT lhelc_id, pty_id, 
				NULLIF(COALESCE(pty_lh_vts_pr,0) + COALESCE(pty_lh_vts_pl,0),0)::NUMERIC AS pty_lhelc_vts_computed, -- NULL if plurality and proportional vote records sum to zero
				(sum(COALESCE(pty_lh_vts_pr,0) + COALESCE(pty_lh_vts_pl,0)) OVER (PARTITION BY lhelc_id) )::NUMERIC AS lhelc_vts_ttl_computed
				FROM beta_version.lh_vote_results
				-- WHERE (pty_id - 999) % 1000 != 0
				-- ‘Others without seat’ (pty_id is ##999) can be excluded from the computation of individual parties’ vote shares,
				-- when disproportionality in the lower house is of interest (not volatility in the party system at large)
				-- NOTE that including 'Others without seat,' as Gallagher originally did, inflates the aggregate indicator in proportion to the votes 'Others w/o seats' receive
			) AS LHELC_VRES USING (lhelc_id)
			WHERE lh_id IN (SELECT DISTINCT lh_id FROM lh_ids)
		) , -- WITH AS lhelc_vote_res
	lh_seat_res AS (SELECT lh_id, pty_id, pty_lh_sts::NUMERIC, ( sum(pty_lh_sts::NUMERIC ) OVER (PARTITION BY lh_id) ) AS lh_sts_ttl_computed, 
				CASE WHEN pty_lh_sts = 0
					THEN 0
					ELSE (pty_lh_sts::NUMERIC/( sum(pty_lh_sts::NUMERIC ) OVER (PARTITION BY lh_id) ) ) 
				END AS pty_lh_sts_shr_computed 
						FROM beta_version.lh_seat_results
			--WHERE lh_id IN (SELECT DISTINCT lh_id FROM lh_ids) -- this condition can be eliminated in config_data
		) , -- WITH AS lh_seat_res
	invalid_lsq AS (SELECT  *
			FROM
				( SELECT lhelc_id, pty_id, pty_lhelc_vts_shr_computed FROM lhelc_vote_res ) AS PTY_VOTE_SHR
			FULL OUTER JOIN
				( SELECT lh_id, lhelc_id, pty_id, pty_lh_sts_shr_computed FROM lh_seat_res JOIN lh_ids USING(lh_id) ) AS PTY_SEAT_SHR 
			USING(lhelc_id, pty_id)
			WHERE (pty_lhelc_vts_shr_computed IS NOT NULL AND pty_lh_sts_shr_computed = 0 AND (pty_id - 999) % 1000 != 0 ) -- (a) 
			OR (pty_lhelc_vts_shr_computed IS NULL AND pty_lh_sts_shr_computed > 0 ) -- (b) 
		 ) -- WITH AS invalid_lsq, identifies lower house election-lower house configurations in which for at least one party either
		   -- (a) vote results are recorded (i.e., computed vote share is NOT NULL) but zero seats despite party ID is not 'Others without seat', or
		   -- (b) seat results are recorded (i.e., party holds at least one seat) but no vote results are (i.e., computed vote share is NULL) 
SELECT DISTINCT ON (lhelc_id) lhelc_id, lh_id, -- select distinct at level of lower house elections, as LSQ is an aggregate indicator  
-- SELECT lhelc_id, lh_id, pty_id, pty_lhelc_vts_shr_computed, pty_lh_sts_shr_computed, (pty_lhelc_vts_shr_computed - pty_lh_sts_shr_computed)^2.0 AS squared_diff,
	CASE WHEN lhelc_id IN (SELECT DISTINCT lhelc_id FROM invalid_lsq) -- when in list of invalid lower house election configurations (see WITH-clause),
		THEN NULL -- no lsq is computed, for result would be biased by missingness of vote/seat records
		ELSE sqrt(0.5*( sum( (pty_lhelc_vts_shr_computed - pty_lh_sts_shr_computed)^2.0) OVER (PARTITION BY lh_id) )) 
	END AS lhelc_lsq_computed
FROM
	( SELECT lhelc_id, pty_id, pty_lhelc_vts_shr_computed FROM lhelc_vote_res ) AS PTY_VOTE_SHR
FULL OUTER JOIN
	( SELECT lh_id, lhelc_id, pty_id, pty_lh_sts_shr_computed FROM lh_seat_res JOIN lh_ids USING(lh_id) ) AS PTY_SEAT_SHR 
USING(lhelc_id, pty_id)
WHERE lhelc_id IS NOT NULL -- excluding lower house configuration to which no election corresponds (i.e., those resulting from party mergers/splits between elections)
--AND (pty_id - 999) % 1000 != 0 
--AND (pty_id - 998) % 1000 != 0 
--AND (pty_id - 997) % 1000 != 0 
ORDER BY lhelc_id, pty_id;
-- NOTE that the problem of 'bunching' of others and independents (i.e. small parties and independents not being listed separately) is ratehr severe in our data. When they are a significant forces, there are problems in trying to compute indices given that each independent candidate should be treated as a separate ‘party’ (cf Gallagher 2013). Consider adjustment (e.g. as in Appendix B of Gallagher and Mitchell) or exlcusion of these groups from computation.