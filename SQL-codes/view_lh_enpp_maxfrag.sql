CREATE OR REPLACE VIEW config_data.view_lh_enpp_maxfrag
AS
SELECT lh_id, 
1/SUM(COALESCE(lh_m_upround, 1)*
	((pty_lh_sts_shr/COALESCE(lh_m_upround, 1))^2))::NUMERIC 
	AS lh_enpp_maxfrag
FROM
	(SELECT lh_id, pty_id, 
		(SEATS.pty_lh_sts/SEATS_TOTAL.lhelc_sts_ttl_computed)::NUMERIC 
			AS pty_lh_sts_shr
		FROM
			(SELECT lh_id, SUM(pty_lh_sts)::NUMERIC AS lhelc_sts_ttl_computed
				FROM config_data.lh_seat_results
				GROUP BY lh_id 
			) AS SEATS_TOTAL
		JOIN
			(SELECT lh_id, pty_id, pty_lh_sts
				FROM config_data.lh_seat_results
				WHERE pty_lh_sts > 0 
			) AS SEATS
		USING(lh_id)
		ORDER BY lh_id, pty_id
	) AS PTY_LH_STS_SHRs
LEFT OUTER JOIN
	(SELECT lh_m_upround, lh_id, pty_id 
		FROM config_data.view_lh_m
	) AS MULTIPLIERS
USING (lh_id, pty_id)
GROUP BY lh_id;