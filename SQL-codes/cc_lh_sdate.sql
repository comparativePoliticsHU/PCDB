CREATE OR REPLACE VIEW config_data.cc_lh_sdate
AS
SELECT 'Lower House'::TEXT AS inst_name, ctr_id, 
	lh_id, lhelc_date, lh_sdate, (lh_sdate-lhelc_date) AS date_dif, 
	SIGN(COALESCE(lh_sdate-lhelc_date, 0)) AS prob_corr_ddif
	FROM
		(SELECT ctr_id, lh_id, lhelc_id, lh_sdate 
			FROM config_data.lower_house
		) AS LOWER_HOUSE
	JOIN
		(SELECT lhelc_id, lhelc_date 
			FROM config_data.lh_election
		) AS LHELC_DATE
	USING (lhelc_id)
ORDER BY lh_id;


