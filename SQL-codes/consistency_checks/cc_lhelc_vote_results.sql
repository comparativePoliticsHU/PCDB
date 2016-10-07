CREATE OR REPLACE VIEW config_data.cc_lhelc_vote_results
AS
WITH 
lhelc_vres AS (SELECT lhelc_id, 
			COALESCE(lhelc_vts_pr,0) AS lhelc_vts_pr, 
			COALESCE(lhelc_vts_pl,0) AS lhelc_vts_pl 
			FROM config_data.lh_election),
lhelc_vres_computed AS (SELECT lhelc_id, 
				SUM(COALESCE(pty_lh_vts_pr,0)) AS lhelc_vts_pr_computed, 
				SUM(COALESCE(pty_lh_vts_pl,0)) AS lhelc_vts_pl_computed
				FROM config_data.lh_vote_results
				GROUP BY lhelc_id)
SELECT lhelc_id, 
	lhelc_vts_pr, lhelc_vts_pr_computed, 
	lhelc_vts_pl, lhelc_vts_pl_computed
	FROM lhelc_vres	
	JOIN lhelc_vres_computed USING(lhelc_id)
WHERE lhelc_vts_pr != lhelc_vts_pr_computed 
OR lhelc_vts_pl != lhelc_vts_pl_computed
ORDER BY lhelc_id;