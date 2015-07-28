CREATE OR REPLACE VIEW config_data.cc_hos_and_cab_cohabitation
AS
SELECT *, ABS(SIGN(pty_id-pty_id_hos)) AS in_cohabitation
	FROM
		(SELECT *
			FROM
				(SELECT ctr_id, sdate, cab_id, prselc_id
					FROM config_data.mv_configuration_events
				) AS CONFIG_EVENTS
			FULL OUTER JOIN
				(SELECT cab_id, pty_id
					FROM config_data.cabinet_portfolios
					WHERE pty_cab IS TRUE
				) AS ALL_CAB_PARTIES
			USING(cab_id)
		) AS CONFIG_EVENTS_w_ALL_CAB_PARTIES
	FULL OUTER JOIN
		(SELECT prselc_id, pty_id AS pty_id_hos
			FROM config_data.presidential_election
		) AS PTY_ID_HOS
	USING(prselc_id)
	WHERE prselc_id IS NOT NULL
ORDER BY ctr_id, sdate;