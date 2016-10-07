CREATE OR REPLACE VIEW config_data.cc_lhelc_vola_vts
AS
WITH 
vola_vts_computed AS (SELECT lhelc_id, ROUND(lhelc_vola_vts_computed::NUMERIC*100, 7) AS lhelc_vola_vts_computed 
			FROM config_data.view_lhelc_vola_vts), 
vola_vts AS (SELECT lhelc_id, ROUND(lhelc_vola_vts::NUMERIC, 7) AS lhelc_vola_vts FROM config_data.lh_election)
SELECT * FROM vola_vts_computed FULL OUTER JOIN vola_vts USING (lhelc_id)
WHERE lhelc_vola_vts_computed != lhelc_vola_vts;
