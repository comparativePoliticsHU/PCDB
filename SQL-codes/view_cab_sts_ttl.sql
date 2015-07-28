CREATE OR REPLACE VIEW config_data.view_cab_sts_ttl
AS
SELECT cab_id, cab_sts_ttl_computed
	FROM
		(SELECT cab_id
			FROM config_data.cabinet
		) CABINET
	LEFT JOIN 
		(SELECT cab_id, COUNT(pty_cab) AS cab_sts_ttl_computed
			FROM config_data.cabinet_portfolios
		WHERE pty_cab IS TRUE
		GROUP BY cabinet_portfolios.cab_id
		) CABINET_PORTFOLIOS
	USING (cab_id)
ORDER BY cabinet.cab_id;