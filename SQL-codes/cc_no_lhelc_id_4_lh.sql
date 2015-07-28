CREATE OR REPLACE VIEW config_data.cc_no_lhelc_id_4_lh
AS
SELECT lh_id, lhelc_id 
	FROM config_data.lower_house
	WHERE lhelc_id IS NULL;