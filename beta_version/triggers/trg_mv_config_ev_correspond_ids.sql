DROP FUNCTION IF EXISTS beta_version.trg_mv_config_ev_correspond_ids() CASCADE;
CREATE FUNCTION beta_version.trg_mv_config_ev_correspond_ids()
RETURNS trigger AS $function$
	BEGIN 
		IF 
			OLD.cab_id IS NOT NULL THEN NEW.cab_id = OLD.cab_id;
		ELSE 
			NEW.cab_id := 
			(SELECT cab_id FROM beta_version.mv_configuration_events
			WHERE sdate < NEW.sdate
			AND ctr_id = NEW.ctr_id
			ORDER BY ctr_id, sdate DESC
			LIMIT 1);
		END IF;
		IF 
			OLD.lh_id IS NOT NULL THEN NEW.lh_id = OLD.lh_id;
		ELSE 
			NEW.lh_id := 
			(SELECT lh_id FROM beta_version.mv_configuration_events
			WHERE sdate < NEW.sdate
			AND ctr_id = NEW.ctr_id
			ORDER BY ctr_id, sdate DESC
			LIMIT 1);
		END IF;
		IF 
			OLD.lhelc_id IS NOT NULL THEN NEW.lhelc_id = OLD.lhelc_id;
		ELSE 
			NEW.lhelc_id := 
			(SELECT lhelc_id FROM beta_version.mv_configuration_events
			WHERE sdate < NEW.sdate
			AND ctr_id = NEW.ctr_id
			ORDER BY ctr_id, sdate DESC
			LIMIT 1);
		END IF;
		IF 
			OLD.uh_id IS NOT NULL THEN NEW.uh_id= OLD.uh_id;
		ELSE 
			NEW.uh_id := 
			(SELECT uh_id FROM beta_version.mv_configuration_events
			WHERE sdate < NEW.sdate
			AND ctr_id = NEW.ctr_id
			ORDER BY ctr_id, sdate DESC
			LIMIT 1); 
		END IF;
		IF 
			OLD.prselc_id IS NOT NULL THEN NEW.prselc_id= OLD.prselc_id;
		ELSE 
			NEW.prselc_id := 
			(SELECT prselc_id FROM beta_version.mv_configuration_events
			WHERE sdate < NEW.sdate
			AND ctr_id = NEW.ctr_id
			ORDER BY ctr_id, sdate DESC
			LIMIT 1); 
		END IF;
	RETURN NEW;
	END;
$function$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_it_mv_config_ev_correspond_ids ON beta_version.mv_configuration_events; 
 CREATE TRIGGER trg_it_mv_config_ev_correspond_ids
	AFTER INSERT ON beta_version.mv_configuration_events FOR EACH ROW -- after insert
	EXECUTE PROCEDURE beta_version.trg_mv_config_ev_correspond_ids();	

DROP TRIGGER IF EXISTS trg_dt_mv_config_ev_correspond_ids ON beta_version.mv_configuration_events; 
CREATE TRIGGER trg_dt_mv_config_ev_correspond_ids
	AFTER DELETE ON beta_version.mv_configuration_events FOR EACH ROW -- after delete
	EXECUTE PROCEDURE beta_version.trg_mv_config_ev_correspond_ids();
	
DROP TRIGGER IF EXISTS trg_ut_mv_config_ev_correspond_ids ON beta_version.mv_configuration_events; 
CREATE TRIGGER trg_ut_mv_config_ev_correspond_ids
	BEFORE UPDATE ON beta_version.mv_configuration_events FOR EACH ROW -- before update
	EXECUTE PROCEDURE beta_version.trg_mv_config_ev_correspond_ids();
