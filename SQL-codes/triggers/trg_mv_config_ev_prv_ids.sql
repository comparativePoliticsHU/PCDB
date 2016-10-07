-- Select corresponding cab_id
CREATE FUNCTION config_data.trg_mv_config_ev_prv_cab_id() 
RETURNS trigger AS $function$
	BEGIN 
		IF 
			OLD.cab_id IS NOT NULL THEN NEW.cab_id = OLD.cab_id;
		ELSE 
			NEW.cab_id := 
			(SELECT cab_id FROM config_data.mv_configuration_events
			WHERE sdate < NEW.sdate
			AND ctr_id = NEW.ctr_id
			ORDER BY ctr_id, sdate DESC
			LIMIT 1);
		END IF;
	RETURN NEW;
	END;
$function$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_it_mv_config_ev_prv_cab_id 
ON config_data.mv_configuration_events; 
CREATE TRIGGER trg_it_mv_config_ev_prv_cab_id
	AFTER INSERT ON config_data.mv_configuration_events FOR EACH ROW -- after insert
	EXECUTE PROCEDURE config_data.trg_mv_config_ev_prv_cab_id();

DROP TRIGGER IF EXISTS trg_dt_mv_config_ev_prv_cab_id 
ON config_data.mv_configuration_events; 
CREATE TRIGGER trg_dt_mv_config_ev_prv_cab_id
	AFTER DELETE ON config_data.mv_configuration_events FOR EACH ROW -- after delete
	EXECUTE PROCEDURE config_data.trg_mv_config_ev_prv_cab_id();

DROP TRIGGER IF EXISTS trg_ut_mv_config_ev_prv_cab_id 
ON config_data.mv_configuration_events; 
CREATE TRIGGER trg_ut_mv_config_ev_prv_cab_id
	BEFORE UPDATE ON config_data.mv_configuration_events FOR EACH ROW -- before update
	EXECUTE PROCEDURE config_data.trg_mv_config_ev_prv_cab_id();
	
-- Select corresponding lh_id
CREATE FUNCTION config_data.trg_mv_config_ev_prv_lh_id() 
RETURNS trigger AS $function$
	BEGIN 
		IF 
			OLD.lh_id IS NOT NULL THEN NEW.lh_id = OLD.lh_id;
		ELSE 
			NEW.lh_id := 
			(SELECT lh_id FROM config_data.mv_configuration_events
			WHERE sdate < NEW.sdate
			AND ctr_id = NEW.ctr_id
			ORDER BY ctr_id, sdate DESC
			LIMIT 1);
		END IF;
	RETURN NEW;
	END;
$function$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_it_mv_config_ev_prv_lh_id 
ON config_data.mv_configuration_events; 
CREATE TRIGGER trg_it_mv_config_ev_prv_lh_id
	AFTER INSERT ON config_data.mv_configuration_events FOR EACH ROW -- after insert
	EXECUTE PROCEDURE config_data.trg_mv_config_ev_prv_lh_id();

DROP TRIGGER IF EXISTS trg_dt_mv_config_ev_prv_lh_id 
ON config_data.mv_configuration_events; 
CREATE TRIGGER trg_dt_mv_config_ev_prv_lh_id
	AFTER DELETE ON config_data.mv_configuration_events FOR EACH ROW -- after delete
	EXECUTE PROCEDURE config_data.trg_mv_config_ev_prv_lh_id();

DROP TRIGGER IF EXISTS trg_ut_mv_config_ev_prv_lh_id 
ON config_data.mv_configuration_events; 
CREATE TRIGGER trg_ut_mv_config_ev_prv_lh_id
	BEFORE UPDATE ON config_data.mv_configuration_events FOR EACH ROW -- before update
	EXECUTE PROCEDURE config_data.trg_mv_config_ev_prv_lh_id();

		
-- Select corresponding lhelc_id
CREATE FUNCTION config_data.trg_mv_config_ev_prv_lhelc_id() 
RETURNS trigger AS $function$
	BEGIN 
		IF 
			OLD.lhelc_id IS NOT NULL THEN NEW.lhelc_id = OLD.lhelc_id;
		ELSE 
			NEW.lhelc_id := 
			(SELECT lhelc_id FROM config_data.mv_configuration_events
			WHERE sdate < NEW.sdate
			AND ctr_id = NEW.ctr_id
			ORDER BY ctr_id, sdate DESC
			LIMIT 1);
		END IF;
	RETURN NEW;
	END;
$function$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_it_mv_config_ev_prv_lhelc_id 
ON config_data.mv_configuration_events; 
CREATE TRIGGER trg_it_mv_config_ev_prv_lhelc_id
	AFTER INSERT ON config_data.mv_configuration_events FOR EACH ROW -- after insert
	EXECUTE PROCEDURE config_data.trg_mv_config_ev_prv_lhelc_id();

DROP TRIGGER IF EXISTS trg_dt_mv_config_ev_prv_lhelc_id 
ON config_data.mv_configuration_events; 
CREATE TRIGGER trg_dt_mv_config_ev_prv_lhelc_id
	AFTER DELETE ON config_data.mv_configuration_events FOR EACH ROW -- after delete
	EXECUTE PROCEDURE config_data.trg_mv_config_ev_prv_lhelc_id();

DROP TRIGGER IF EXISTS trg_ut_mv_config_ev_prv_lhelc_id 
ON config_data.mv_configuration_events; 
CREATE TRIGGER trg_ut_mv_config_ev_prv_lhelc_id
	BEFORE UPDATE ON config_data.mv_configuration_events FOR EACH ROW -- before update
	EXECUTE PROCEDURE config_data.trg_mv_config_ev_prv_lhelc_id();
	
-- Select corresponding uh_id
CREATE FUNCTION config_data.trg_mv_config_ev_prv_uh_id() 
RETURNS trigger AS $function$
	BEGIN 
		IF 
			OLD.uh_id IS NOT NULL THEN NEW.uh_id= OLD.uh_id;
		ELSE 
			NEW.uh_id := 
			(SELECT uh_id FROM config_data.mv_configuration_events
			WHERE sdate < NEW.sdate
			AND ctr_id = NEW.ctr_id
			ORDER BY ctr_id, sdate DESC
			LIMIT 1); 
		END IF;
	RETURN NEW;
	END;
$function$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_it_mv_config_ev_prv_uh_id 
ON config_data.mv_configuration_events; 
CREATE TRIGGER trg_it_mv_config_ev_prv_uh_id
 	AFTER INSERT ON config_data.mv_configuration_events FOR EACH ROW -- after insert
 	EXECUTE PROCEDURE config_data.trg_mv_config_ev_prv_uh_id();

DROP TRIGGER IF EXISTS trg_dt_mv_config_ev_prv_uh_id 
ON config_data.mv_configuration_events; 
CREATE TRIGGER trg_dt_mv_config_ev_prv_uh_id
 	AFTER DELETE ON config_data.mv_configuration_events FOR EACH ROW -- after delete
 	EXECUTE PROCEDURE config_data.trg_mv_config_ev_prv_uh_id();

DROP TRIGGER IF EXISTS trg_ut_mv_config_ev_prv_uh_id 
ON config_data.mv_configuration_events; 
CREATE TRIGGER trg_ut_mv_config_ev_prv_uh_id
	BEFORE UPDATE ON config_data.mv_configuration_events FOR EACH ROW -- before update
	EXECUTE PROCEDURE config_data.trg_mv_config_ev_prv_uh_id();

-- Select corresponding prselc_id
CREATE FUNCTION config_data.trg_mv_config_ev_prv_prselc_id() 
RETURNS trigger AS $function$
	BEGIN 
		IF 
			OLD.prselc_id IS NOT NULL THEN NEW.prselc_id= OLD.prselc_id;
		ELSE 
			NEW.prselc_id := 
			(SELECT prselc_id FROM config_data.mv_configuration_events
			WHERE sdate < NEW.sdate
			AND ctr_id = NEW.ctr_id
			ORDER BY ctr_id, sdate DESC
			LIMIT 1); 
		END IF;
	RETURN NEW;
	END;
$function$ LANGUAGE plpgsql;
	
DROP TRIGGER IF EXISTS trg_it_mv_config_ev_prv_prselc_id 
 ON config_data.mv_configuration_events; 
 CREATE TRIGGER trg_it_mv_config_ev_prv_prselc_id
	AFTER INSERT ON config_data.mv_configuration_events FOR EACH ROW -- after insert
	EXECUTE PROCEDURE config_data.trg_mv_config_ev_prv_prselc_id();	

DROP TRIGGER IF EXISTS trg_dt_mv_config_ev_prv_prselc_id 
ON config_data.mv_configuration_events; 
CREATE TRIGGER trg_dt_mv_config_ev_prv_prselc_id
	AFTER DELETE ON config_data.mv_configuration_events FOR EACH ROW -- after delete
	EXECUTE PROCEDURE config_data.trg_mv_config_ev_prv_prselc_id();
	
DROP TRIGGER IF EXISTS trg_ut_mv_config_ev_prv_prselc_id 
ON config_data.mv_configuration_events; 
CREATE TRIGGER trg_ut_mv_config_ev_prv_prselc_id
	BEFORE UPDATE ON config_data.mv_configuration_events FOR EACH ROW -- before update
	EXECUTE PROCEDURE config_data.trg_mv_config_ev_prv_prselc_id();
