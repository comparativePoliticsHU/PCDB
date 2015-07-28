CREATE OR REPLACE VIEW config_data.cc_lhelc_vola_sts
AS
SELECT * 
	FROM
		(SELECT lhelc_id, lhelc_vola_sts_computed 
			FROM config_data.view_lhelc_vola_sts
		) AS COMPUTED
	FULL OUTER JOIN
		(SELECT lhelc_id, lhelc_vola_sts 
			FROM config_data.lh_election
		) AS RECORDED
	USING (lhelc_id)
	WHERE TRUNC(lhelc_vola_sts_computed::NUMERIC, 7) != TRUNC(lhelc_vola_sts::NUMERIC, 7);
