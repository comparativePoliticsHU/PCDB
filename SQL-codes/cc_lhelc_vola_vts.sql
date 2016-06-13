CREATE OR REPLACE VIEW config_data.cc_lhelc_vola_vts
AS
SELECT * 
	FROM
		(SELECT lhelc_id, lhelc_vola_vts_computed 
			FROM config_data.view_lhelc_vola_vts
		) AS COMPUTED
	FULL OUTER JOIN
		(SELECT lhelc_id, lhelc_vola_vts 
			FROM config_data.lh_election
		) AS RECORDED
	USING (lhelc_id)
WHERE TRUNC(lhelc_vola_vts_computed::NUMERIC, 7) != TRUNC(lhelc_vola_vts::NUMERIC, 7);
