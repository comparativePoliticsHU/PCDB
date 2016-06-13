CREATE OR REPLACE FUNCTION config_data.update_mv_config_events() 
RETURNS VOID
SECURITY DEFINER
LANGUAGE plpgsql AS '
BEGIN
	UPDATE config_data.mv_configuration_events
		SET cab_id = cab_id, 
			lh_id = lh_id, lhelc_id = lhelc_id, 
			uh_id = uh_id, prselc_id = prselc_id, 
			edate = edate;
END';