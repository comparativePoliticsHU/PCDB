CREATE OR REPLACE VIEW config_data.cc_lhelc_volb_vts
AS
WITH 
volb_vts_computed AS (SELECT lhelc_id, ROUND(lhelc_volb_vts_computed::NUMERIC*100, 7) AS lhelc_volb_vts_computed 
			FROM config_data.view_lhelc_volb_vts), 
volb_vts AS (SELECT lhelc_id, ROUND(lhelc_volb_vts::NUMERIC, 7) AS lhelc_volb_vts FROM config_data.lh_election)
SELECT * FROM volb_vts_computed FULL OUTER JOIN volb_vts USING (lhelc_id)
WHERE lhelc_volb_vts_computed != lhelc_volb_vts;
