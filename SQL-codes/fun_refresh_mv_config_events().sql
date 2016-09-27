CREATE OR REPLACE FUNCTION config_data.refresh_mv_config_events(SMALLINT) 
RETURNS VOID
SECURITY DEFINER
LANGUAGE plpgsql AS $$
	BEGIN
		ALTER TABLE config_data.mv_configuration_events DISABLE TRIGGER USER;
		DELETE FROM config_data.mv_configuration_events WHERE ctr_id = $1;
		INSERT INTO config_data.mv_configuration_events 
			SELECT * FROM config_data.view_configuration_events WHERE ctr_id = $1;
		ALTER TABLE config_data.mv_configuration_events ENABLE TRIGGER USER;

		UPDATE config_data.matviews
			SET last_refresh=(SELECT CURRENT_TIMESTAMP)
			WHERE matviews.mv_name LIKE 'config_data.mv_configuration_events';
			
		EXECUTE 'SELECT config_data.update_mv_config_events()';
			
		RETURN;
	END $$;