DROP VIEW IF EXISTS config_data.view_lh_election_party_results;
CREATE OR REPLACE VIEW config_data.view_lh_election_party_results
AS 
SELECT ctr_id, ctr_ccode, lhelc_date,
	pty_id, pty_abr, pty_n_en,
	pty_lh_sts, lhelc_sts_ttl_computed, pty_lh_sts_shr::numeric(7,5), 
	pty_lh_vts, lhelc_vts_ttl_computed, pty_lh_vts_shr::numeric(7,5),
	cmp_id, clea_id,
	lhelc_id, lhelc_prv_id, lhelc_nxt_id
FROM 
	(SELECT ctr_id, ctr_ccode 
		FROM config_data.country
	) AS COUNTRY 
RIGHT OUTER JOIN
	(SELECT *
	FROM
		(SELECT ctr_id, lhelc_date, lhelc_id, lhelc_prv_id, lhelc_nxt_id 
			FROM config_data.lh_election
		) AS LH_ELECTION
	RIGHT OUTER JOIN
		(SELECT *
		FROM
			(SELECT pty_id, pty_abr, pty_n_en, cmp_id, clea_id 
				FROM config_data.party
			) AS PARTY_INDOS
		RIGHT OUTER JOIN -- 4201
			(SELECT *
				FROM
					(SELECT lhelc_id, pty_id, pty_lh_sts, lhelc_sts_ttl_computed, 100*(SEATS.pty_lh_sts/SEATS_TOTAL.lhelc_sts_ttl_computed) AS pty_lh_sts_shr
						FROM
							(SELECT lhelc_id, sum(pty_lh_sts)::numeric as lhelc_sts_ttl_computed
								FROM config_data.lh_seat_results
								GROUP BY lhelc_id 
							) AS SEATS_TOTAL
							-- compute total seats as sum of all parties' seats in a given lh election
						JOIN
							(SELECT lhelc_id, pty_id, pty_lh_sts::numeric
								FROM config_data.lh_seat_results
							) AS SEATS
						USING(lhelc_id)
					) AS SEAT_SHR
				JOIN
					(SELECT lhelc_id, pty_id, pty_lh_vts, lhelc_vts_ttl_computed, 100*(VOTES.pty_lh_vts/VOTES_TOTAL.lhelc_vts_ttl_computed) AS pty_lh_vts_shr
					-- compute parties' vote shares
						FROM
							(SELECT lhelc_id, sum(COALESCE(pty_lh_vts_pr,0) + COALESCE(pty_lh_vts_pl,0))::numeric as lhelc_vts_ttl_computed
								FROM config_data.lh_vote_results 
								GROUP BY lhelc_id 
								ORDER BY lhelc_id
							) AS VOTES_TOTAL
							-- compute total votes as sum of all parties' votes in a given lh election
						JOIN
							(SELECT lhelc_id, pty_id, (COALESCE(pty_lh_vts_pr,0) + COALESCE(pty_lh_vts_pl,0))::numeric as pty_lh_vts
								FROM config_data.lh_vote_results
							-- note that parties for whom neither PR nor Pl votes are recorded have amount a pty_lh_vts value equal to ZERO
							) AS VOTES
						USING(lhelc_id)
					) AS VOTES_SHR
				USING(lhelc_id, pty_id) -- the regular Join ensures that 'Other' without seats are excluded from computation
			) AS LHELC_VTS_STS_RESULTS
		USING(pty_id)
	) AS I
	USING(lhelc_id)
) AS II
USING(ctr_id)
ORDER BY lhelc_id, pty_id
;