CREATE OR REPLACE VIEW beta_version.view_lh_enpp_maxfrag
AS
WITH 
lh_seats AS (SELECT lh_id, pty_id, pty_lh_sts::NUMERIC, 
			sum(pty_lh_sts) OVER (PARTITION BY lh_id)  AS lh_sts_ttl_computed, --  suming parties' seats within lower house configurations to total lower house seats
			( pty_lh_sts::NUMERIC/( sum(pty_lh_sts) OVER (PARTITION BY lh_id) ) ) AS pty_lh_sts_shr -- computing parties's seat shares in given lower house
			FROM beta_version.lh_seat_results
			WHERE pty_lh_sts > 0 ) , -- WITH AS lh_seats, records lower house seats and seart shares at party level
otherw_and_ind_parties AS (SELECT DISTINCT ON (pty_id, pty_abr) pty_id 
				FROM beta_version.party 
				WHERE pty_abr LIKE 'Otherw' OR pty_abr LIKE 'IND' ) , -- WITH AS otherw_and_ind_parties
m_upround AS (SELECT lh_id, pty_id, CEIL(lh_sts_of_Oth_or_INDs/lh_pty_w_least_seats)::NUMERIC AS lh_m_upround -- dividing seats hold by Others and Independentsseats though seat hold by party with lowest number of seats gives fraction that is uprounded to next bigger integer 
		FROM
			(SELECT lh_id, MIN(pty_lh_sts)::NUMERIC AS lh_pty_w_least_seats -- identify group with lowest number of seats in lower house
				FROM lh_seats 
				GROUP BY lh_id ) AS LH_PTY_w_LEAST_SEATS
		LEFT OUTER JOIN
			(SELECT lh_id, pty_id, pty_lh_sts::NUMERIC AS lh_sts_of_Oth_or_INDs -- identify number of seats Others and independents hold
				FROM lh_seats 
				WHERE pty_id IN (SELECT * FROM otherw_and_ind_parties) ) AS SEATS_of_OTHERW_or_INDs
		USING(lh_id)
		WHERE (lh_sts_of_Oth_or_INDs/lh_pty_w_least_seats) > 1 OR NOT NULL -- conditioning on > 1 excludes configurations for which adjustment woud not matter (i.e., configurations where others and/or independents hold the smallest number of seats); conditioning on NOT NULL excludes configurations from subquery, in which neither Others nor Independent entered the lower house (both conditions increase computational efficiency)
		) -- WITH AS m_upround, adjustment divisor to simualte maximum fragementation according to Gallagher and Mitchell
SELECT lh_id, 1/SUM(COALESCE(lh_m_upround, 1)*((pty_lh_sts_shr/COALESCE(lh_m_upround, 1))^2))::NUMERIC AS lh_enpp_maxfrag -- Effective Number of Parties in Parliament according to Laakso and Taagepera, assuming maximum fragmentation by adjusting for contribution to indicator of group 'Others with seat(s)' and 'Independents' following Gallagher and Mitchell
	FROM lh_seats LEFT OUTER JOIN m_upround USING (lh_id, pty_id)
	GROUP BY lh_id
ORDER BY lh_id;



