CREATE OR REPLACE VIEW config_data.cc_cab_sdate
AS
SELECT 'Cabinet'::TEXT AS inst_name, MAX(ctr_id) AS ctr_id, 
	cab_id, cab_sdate, MAX(lhelc_date) AS lhelc_date,
	(cab_sdate-MAX(lhelc_date))AS date_dif, 
	SIGN(COALESCE(cab_sdate-MAX(lhelc_date), 0)) AS prob_corr_ddif
	FROM
		(SELECT CABINET.ctr_id AS ctr_id, cab_id, cab_sdate, lhelc_date
			FROM
				(SELECT ctr_id, cab_id, cab_sdate 
					FROM config_data.cabinet
				) AS CABINET
			,
				(SELECT ctr_id, lhelc_date 
					FROM config_data.lh_election
				) AS LHELC_DATE
			WHERE lhelc_date <= cab_sdate
			AND CABINET.ctr_id = LHELC_DATE.ctr_id
		) AS CAB_SDATE
	GROUP BY cab_id, cab_sdate
ORDER BY cab_id, cab_sdate, lhelc_date;
