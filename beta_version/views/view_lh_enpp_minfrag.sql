CREATE OR REPLACE VIEW beta_version.view_lh_enpp_minfrag
AS
WITH lh_seats AS (SELECT lh_id, pty_id, pty_lh_sts::NUMERIC, 
			sum(pty_lh_sts) OVER (PARTITION BY lh_id)  AS lh_sts_ttl_computed, --  suming parties' seats within lower house configurations to total lower house seats
			( pty_lh_sts::NUMERIC/( sum(pty_lh_sts) OVER (PARTITION BY lh_id) ) ) AS pty_lh_sts_shr -- computing partie's seat shares in given lower house
			FROM beta_version.lh_seat_results
			WHERE pty_lh_sts > 0 ) -- WITH AS lh_seats, records lower house seats and seart shares at party level
SELECT lh_id, 1/SUM(pty_lh_sts_shr^2.0) AS lh_enpp_minfrag -- Effective Number of Parties in Parliament according to Laakso and Taagepera
	FROM lh_seats
	GROUP BY lh_id
ORDER BY lh_id;

		