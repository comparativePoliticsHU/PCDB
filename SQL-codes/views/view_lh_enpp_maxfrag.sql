CREATE OR REPLACE VIEW config_data.view_lh_enpp_maxfrag
AS
WITH 
lh_sres AS (SELECT lh_id, pty_id, 
			pty_lh_sts::NUMERIC,
			(COALESCE(pty_lh_sts_pr, 0) + 
			 COALESCE(pty_lh_sts_pl, 0))::NUMERIC AS pty_lh_sts_computed,
			SUM(COALESCE(pty_lh_sts_pr, 0) + 
			    COALESCE(pty_lh_sts_pl, 0)
			) OVER (PARTITION BY lh_id)::NUMERIC AS lh_sts_ttl_computed, --  suming parties' seats within lower house configurations to total lower house seats
			((COALESCE(pty_lh_sts_pr, 0) + COALESCE(pty_lh_sts_pl, 0))::NUMERIC/
			 (SUM(COALESCE(pty_lh_sts_pr, 0) + 
			     COALESCE(pty_lh_sts_pl, 0)
			 ) OVER (PARTITION BY lh_id))::NUMERIC
			) AS pty_lh_sts_shr -- computing parties's seat shares in given lower house
			FROM config_data.lh_seat_results
			WHERE COALESCE(pty_lh_sts_pr, 0) + 
			      COALESCE(pty_lh_sts_pl, 0) > 0), -- WITH AS lh_seats, records lower house seats and seart shares at party level
others_and_inds AS (SELECT DISTINCT pty_id
			FROM config_data.party 
			WHERE (pty_id - 999) % 1000 = ANY ('{0, 998, 999}'::int[])), -- WITH AS otherw_and_ind_parties
lh_min_sts AS (SELECT DISTINCT lh_id, 
			MIN(pty_lh_sts_computed) OVER (PARTITION BY lh_id) AS min_lh_sts 
			FROM lh_sres),
lh_others_sts AS (SELECT DISTINCT lh_id, pty_id, pty_lh_sts_computed AS others_lh_sts 
			FROM lh_sres 
			WHERE pty_id IN (SELECT pty_id FROM others_and_inds)),
m_upround AS (SELECT lh_id, pty_id, CEIL(others_lh_sts/min_lh_sts) AS lh_m_upround
		FROM lh_min_sts JOIN lh_others_sts USING (lh_id))
SELECT lh_id, 1/SUM(COALESCE(lh_m_upround, 1)*(
                    (pty_lh_sts_shr/COALESCE(lh_m_upround, 1)
                   )^2))::NUMERIC AS lh_enpp_maxfrag -- Effective Number of Parties in Parliament according to Laakso and Taagepera, assuming maximum fragmentation by adjusting for contribution to indicator of group 'Others with seat(s)' and 'Independents' following Gallagher and Mitchell
	FROM lh_sres LEFT OUTER JOIN m_upround USING (lh_id, pty_id)
	GROUP BY lh_id
ORDER BY lh_id;



