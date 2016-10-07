CREATE OR REPLACE FUNCTION config_data.trg_mv_config_ev_edate() 
RETURNS trigger AS $$
	BEGIN 
		NEW.edate := 
		(SELECT sdate-1 FROM config_data.mv_configuration_events
		WHERE sdate > NEW.sdate
		AND ctr_id = NEW.ctr_id
		ORDER BY ctr_id, sdate ASC
		LIMIT 1);
	RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_it_mv_config_ev_edate ON config_data.mv_configuration_events; 
CREATE TRIGGER trg_it_mv_config_ev_edate
	AFTER INSERT ON config_data.mv_configuration_events FOR EACH ROW 
	EXECUTE PROCEDURE config_data.trg_mv_config_ev_edate();
	
DROP TRIGGER IF EXISTS trg_dt_mv_config_ev_edate ON config_data.mv_configuration_events; 
CREATE TRIGGER trg_dt_mv_config_ev_edate
	AFTER DELETE ON config_data.mv_configuration_events FOR EACH ROW
	EXECUTE PROCEDURE config_data.trg_mv_config_ev_edate();

DROP TRIGGER IF EXISTS trg_ut_mv_config_ev_edate ON config_data.mv_configuration_events; 
CREATE TRIGGER trg_ut_mv_config_ev_edate
	BEFORE UPDATE ON config_data.mv_configuration_events FOR EACH ROW
	EXECUTE PROCEDURE config_data.trg_mv_config_ev_edate();
	