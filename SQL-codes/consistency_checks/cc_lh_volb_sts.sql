CREATE OR REPLACE VIEW config_data.cc_lh_volb_sts
AS
WITH 
lower_houses AS (SELECT lhelc_id, lh_id FROM config_data.lower_house),
volb_sts_computed AS (SELECT lhelc_id, lh_id, 
			ROUND(lh_volb_sts_computed::NUMERIC*100, 5) AS lh_volb_sts_computed 
			FROM config_data.view_lh_volb_sts 
			RIGHT OUTER JOIN lower_houses USING (lh_id)),
volb_sts AS (SELECT lhelc_id, ROUND(lhelc_volb_sts::NUMERIC, 5) As lhelc_volb_sts FROM config_data.lh_election)
SELECT lh_id, lhelc_id, lhelc_volb_sts, lh_volb_sts_computed
	FROM volb_sts_computed FULL OUTER JOIN volb_sts USING (lhelc_id)
	WHERE lh_volb_sts_computed != lhelc_volb_sts::NUMERIC;
