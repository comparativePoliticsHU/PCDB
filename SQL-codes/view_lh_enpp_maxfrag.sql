CREATE VIEW config_data.view_lh_enpp_maxfrag
AS
SELECT lh_id, lhelc_enpp_maxfrag AS lh_enpp_maxfrag
FROM
	(SELECT lh_id, lhelc_id FROM config_data.lower_house) AS LOWER_HOUSE
JOIN
	(SELECT lhelc_id, 
		1/SUM(COALESCE(lh_m_upround, 1)*
			((pty_lh_sts_shr/COALESCE(lh_m_upround, 1))^2))::NUMERIC 
			AS lhelc_enpp_maxfrag
		FROM
			(SELECT lhelc_id, pty_id, 
				(SEATS.pty_lh_sts/SEATS_TOTAL.lhelc_sts_ttl_computed)::NUMERIC 
					AS pty_lh_sts_shr
				FROM
					(SELECT lhelc_id, SUM(pty_lh_sts)::NUMERIC AS lhelc_sts_ttl_computed
						FROM config_data.lh_seat_results
						GROUP BY lhelc_id 
					) AS SEATS_TOTAL
				JOIN
					(SELECT lhelc_id, pty_id, pty_lh_sts
						FROM config_data.lh_seat_results
						WHERE pty_lh_sts > 0 
					) AS SEATS
				USING(lhelc_id)
				ORDER BY lhelc_id, pty_id
			) AS PTY_LH_STS_SHRs
		LEFT OUTER JOIN
			(SELECT lh_m_upround, lhelc_id, pty_id 
				FROM config_data.view_lh_m
			) AS MULTIPLIERS
		USING (lhelc_id, pty_id)
		GROUP BY lhelc_id		
	) AS LHELC_ENPP_MAXFRAG
USING(lhelc_id);