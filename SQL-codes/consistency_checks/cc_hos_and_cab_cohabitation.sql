CREATE OR REPLACE VIEW config_data.cc_hos_and_cab_cohabitation
AS
WITH 
configs AS (SELECT ctr_id, sdate, cab_id, prselc_id FROM config_data.mv_configuration_events),
cab_configs AS (SELECT * 
			FROM configs 
			FULL OUTER JOIN (SELECT cab_id, pty_id AS cab_pty_id
						FROM config_data.cabinet_portfolios
						WHERE pty_cab IS TRUE) AS cab_portfls
			USING(cab_id)), 
hos_pty AS (SELECT prselc_id, pty_id AS pty_id_hos FROM config_data.presidential_election)
SELECT *, ABS(SIGN(cab_pty_id-pty_id_hos)) AS in_cohabitation
	FROM cab_configs
	FULL OUTER JOIN hos_pty USING(prselc_id)
WHERE prselc_id IS NOT NULL
-- AND cab_pty_id IS NULL -- un-comment to return cases where pty_id of cabinet parties, and hence cohabitation indicator is missing
-- AND pty_id_hos IS NULL -- un-comment to  return cases where pty_id of head of state, and hence cohabitation indicator is missing 
ORDER BY ctr_id, sdate;