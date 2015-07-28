CREATE OR REPLACE VIEW config_data.cc_uh_sdate
AS
SELECT 'Upper House'::TEXT AS inst_name, ctr_id, 
	uh_id, uhelc_date, uh_sdate, 
	(uh_sdate-uhelc_date) AS date_dif, 
	SIGN(COALESCE(uh_sdate-uhelc_date, 0)) AS prob_corr_ddif
	FROM
		(SELECT ctr_id, uh_id, uhelc_id, uh_sdate 
			FROM config_data.upper_house
		) AS UPPER_HOUSE
	JOIN
		(SELECT uhelc_id, uhelc_date 
			FROM config_data.uh_election
		) AS UHELC_DATE
	USING (uhelc_id)
ORDER BY uh_id;


