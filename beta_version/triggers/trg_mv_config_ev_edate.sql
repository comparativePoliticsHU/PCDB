CREATE OR REPLACE FUNCTION beta_version.trg_mv_config_ev_edate() 
RETURNS trigger AS $function$
	BEGIN 
		NEW.edate := 
		(SELECT sdate-1 FROM beta_version.mv_configuration_events
		WHERE sdate > NEW.sdate
		AND ctr_id = NEW.ctr_id
		ORDER BY ctr_id, sdate ASC
		LIMIT 1);
	RETURN NEW;
	END;
$function$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_it_mv_config_ev_edate ON beta_version.mv_configuration_events; 
CREATE TRIGGER trg_it_mv_config_ev_edate
	AFTER INSERT ON beta_version.mv_configuration_events FOR EACH ROW 
	EXECUTE PROCEDURE beta_version.trg_mv_config_ev_edate();
	
DROP TRIGGER IF EXISTS trg_dt_mv_config_ev_edate ON beta_version.mv_configuration_events; 
CREATE TRIGGER trg_dt_mv_config_ev_edate
	AFTER DELETE ON beta_version.mv_configuration_events FOR EACH ROW
	EXECUTE PROCEDURE beta_version.trg_mv_config_ev_edate();

DROP TRIGGER IF EXISTS trg_ut_mv_config_ev_edate ON beta_version.mv_configuration_events; 
CREATE TRIGGER trg_ut_mv_config_ev_edate
	BEFORE UPDATE ON beta_version.mv_configuration_events FOR EACH ROW
	EXECUTE PROCEDURE beta_version.trg_mv_config_ev_edate();
	