CREATE FUNCTION config_data.trg_mv_config_ev_prv_*_id() 
RETURNS trigger AS $function$
	BEGIN 
		IF 
			OLD.*_id IS NOT NULL THEN NEW.*_id = OLD.*_id;
		ELSE 
			NEW.*_id := 
			(SELECT *_id FROM config_data.mv_configuration_events
			WHERE sdate < NEW.sdate
			AND ctr_id = NEW.ctr_id
			ORDER BY ctr_id, sdate DESC
			LIMIT 1);
		END IF;
	RETURN NEW;
	END;
$function$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_it_mv_config_ev_prv_*_id 
ON config_data.mv_configuration_events; 
CREATE TRIGGER trg_it_mv_config_ev_prv_*_id
	AFTER INSERT ON config_data.mv_configuration_events FOR EACH ROW -- after insert
	EXECUTE PROCEDURE config_data.trg_mv_config_ev_prv_*_id();

DROP TRIGGER IF EXISTS trg_dt_mv_config_ev_prv_*_id 
ON config_data.mv_configuration_events; 
CREATE TRIGGER trg_dt_mv_config_ev_prv_*_id
	AFTER DELETE ON config_data.mv_configuration_events FOR EACH ROW -- after delete
	EXECUTE PROCEDURE config_data.trg_mv_config_ev_prv_*_id();

DROP TRIGGER IF EXISTS trg_ut_mv_config_ev_prv_*_id 
ON config_data.mv_configuration_events; 
CREATE TRIGGER trg_ut_mv_config_ev_prv_*_id
	BEFORE UPDATE ON config_data.mv_configuration_events FOR EACH ROW -- before update
	EXECUTE PROCEDURE config_data.trg_mv_config_ev_prv_*_id();