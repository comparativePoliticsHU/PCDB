CREATE VIEW database.view_invalid_lh_vote_results
AS 
SELECT lhelc_id, pty_id, pty_abr, pty_lh_vts_pr, pty_lh_vts_pl
	FROM  
		(SELECT lhelc_id, pty_id, pty_lh_vts_pr, pty_lh_vts_pl FROM database.lh_vote_results) AS lh_seats
		JOIN
		(SELECT pty_id, pty_abr FROM database.party) AS party
		USING(pty_id)
	WHERE pty_lh_vts_pr IS NULL AND pty_lh_vts_pl IS NULL 
	AND pty_abr NOT LIKE '%Other%';

SELECT lhelc_id, lhelc_cmt
FROM database.lh_election
WHERE lhelc_id IN 
	(SELECT lhelc_id FROM  
		(SELECT lhelc_id, pty_id, pty_lh_vts_pr, pty_lh_vts_pl FROM database.lh_vote_results) AS lh_seats
		JOIN
		(SELECT pty_id, pty_abr FROM database.party) AS party
		USING(pty_id)
	WHERE pty_lh_vts_pr IS NULL AND pty_lh_vts_pl IS NULL 
	AND pty_abr NOT LIKE '%Other%');

UPDATE database.lh_election 
SET lhelc_cmt = lhelc_cmt || '; ' || 'no lsq can be computed because of lacking vote result information for respective LH election'
WHERE lhelc_id IN 
	(SELECT lhelc_id FROM  
		(SELECT lhelc_id, pty_id, pty_lh_vts_pr, pty_lh_vts_pl FROM database.lh_vote_results) AS lh_seats
		JOIN
		(SELECT pty_id, pty_abr FROM database.party) AS party
		USING(pty_id)
	WHERE pty_lh_vts_pr IS NULL AND pty_lh_vts_pl IS NULL 
	AND pty_abr NOT LIKE '%Other%')
 AND lhelc_cmt NOT LIKE '.';

UPDATE database.lh_election 
SET lhelc_cmt = 'no lsq can be computed because of lacking vote result information for respective LH election'
WHERE lhelc_id IN 
	(SELECT lhelc_id FROM  
		(SELECT lhelc_id, pty_id, pty_lh_vts_pr, pty_lh_vts_pl FROM database.lh_vote_results) AS lh_seats
		JOIN
		(SELECT pty_id, pty_abr FROM database.party) AS party
		USING(pty_id)
	WHERE pty_lh_vts_pr IS NULL AND pty_lh_vts_pl IS NULL 
	AND pty_abr NOT LIKE '%Other%')
 AND lhelc_cmt LIKE '.';