CREATE OR REPLACE FUNCTION config_data.mv_config_ev_refresh_row(SMALLINT, DATE) 
RETURNS VOID
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
	DECLARE
	country ALIAS FOR $1;
	start_date ALIAS FOR $2;
	entry config_data.matviews%ROWTYPE;
		BEGIN
			ALTER TABLE config_data.mv_configuration_events DISABLE TRIGGER USER;
			
			DELETE FROM config_data.mv_configuration_events 
				WHERE mv_configuration_events.ctr_id = country
				AND mv_configuration_events.sdate = start_date;
			
			INSERT INTO config_data.mv_configuration_events 
			SELECT * 
				FROM config_data.view_configuration_events 
				WHERE view_configuration_events.ctr_id = country 
				AND view_configuration_events.sdate = start_date;
				
			ALTER TABLE config_data.mv_configuration_events ENABLE TRIGGER USER;	

			PERFORM config_data.update_mv_config_events();
				
		  RETURN;
		END
';