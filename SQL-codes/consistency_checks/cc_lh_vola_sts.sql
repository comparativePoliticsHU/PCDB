CREATE OR REPLACE VIEW config_data.cc_lh_vola_sts
AS
WITH 
lower_houses AS (SELECT lhelc_id, lh_id FROM config_data.lower_house),
vola_sts_computed AS (SELECT lhelc_id, lh_id, 
			ROUND(lh_vola_sts_computed::NUMERIC*100, 5) AS lh_vola_sts_computed 
			FROM config_data.view_lh_vola_sts 
			RIGHT OUTER JOIN lower_houses USING (lh_id)),
vola_sts AS (SELECT lhelc_id, ROUND(lhelc_vola_sts::NUMERIC, 5) As lhelc_vola_sts FROM config_data.lh_election)
SELECT lh_id, lhelc_id, lhelc_vola_sts, lh_vola_sts_computed
	FROM vola_sts_computed FULL OUTER JOIN vola_sts USING (lhelc_id)
	WHERE lh_vola_sts_computed != lhelc_vola_sts::NUMERIC;
