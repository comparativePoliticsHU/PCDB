-- Function to select previous cab_id from 'configurations' if change in configuration is not due to a change in cabinet
CREATE FUNCTION config_data.trg_config_prv_cab_id() RETURNS trigger AS $function$
	BEGIN 
		IF 
			OLD.cab_id IS NOT NULL THEN NEW.cab_id = OLD.cab_id;
		ELSE 
			NEW.cab_id := 
			(SELECT cab_id FROM configurations
			WHERE sdate < NEW.sdate
			AND ctr_id = NEW.ctr_id
			ORDER BY ctr_id, sdate DESC
			LIMIT 1); -- selects next lowest CAB start date
		END IF;
	RETURN NEW;
	END;
$function$ LANGUAGE plpgsql;

-- implement trigger on 'configurations' 
DROP TRIGGER IF EXISTS trg_it_configurations_prv_cab_id ON configurations; 
CREATE TRIGGER trg_it_configurations_prv_cab_id
	AFTER INSERT ON configurations FOR EACH ROW -- after insert
	EXECUTE PROCEDURE config_data.trg_config_prv_cab_id();

DROP TRIGGER IF EXISTS trg_ut_configurations_prv_cab_id ON configurations; 
CREATE TRIGGER trg_ut_configurations_prv_cab_id
	BEFORE UPDATE ON configurations FOR EACH ROW -- before update
	EXECUTE PROCEDURE config_data.trg_config_prv_cab_id();
	
---------------------
-- Function to select previous lh_id from 'configurations' if change in configuration is not due to a change in the lower house
CREATE FUNCTION config_data.trg_config_prv_lh_id() RETURNS trigger AS $function$
	BEGIN 
		IF 
			OLD.lh_id IS NOT NULL THEN NEW.lh_id = OLD.lh_id;
		ELSE 
			NEW.lh_id := 
			(SELECT lh_id FROM configurations
			WHERE sdate < NEW.sdate
			AND ctr_id = NEW.ctr_id
			ORDER BY ctr_id, sdate DESC
			LIMIT 1); -- selects next lowest LH start date
		END IF;
	RETURN NEW;
	END;
$function$ LANGUAGE plpgsql;

-- implement trigger on 'configurations' 
DROP TRIGGER IF EXISTS trg_it_configurations_prv_lh_id ON configurations; 
CREATE TRIGGER trg_it_configurations_prv_lh_id
	AFTER INSERT ON configurations FOR EACH ROW -- after insert
	EXECUTE PROCEDURE config_data.trg_config_prv_lh_id();

DROP TRIGGER IF EXISTS trg_ut_configurations_prv_lh_id ON configurations; 
CREATE TRIGGER trg_ut_configurations_prv_lh_id
	BEFORE UPDATE ON configurations FOR EACH ROW -- before update
	EXECUTE PROCEDURE config_data.trg_config_prv_lh_id();
	
-------------------------------
-- Function to select previous uh_id from 'configurations' if change in configuration is not due to a change in the upper house
CREATE FUNCTION config_data.trg_config_prv_uh_id() RETURNS trigger AS $function$
	BEGIN 
		IF 
			OLD.uh_id IS NOT NULL THEN NEW.uh_id= OLD.uh_id;
		ELSE 
			NEW.uh_id := 
			(SELECT uh_id FROM configurations
			WHERE sdate < NEW.sdate
			AND ctr_id = NEW.ctr_id
			ORDER BY ctr_id, sdate DESC
			LIMIT 1); -- selects next lowest UH start date
		END IF;
	RETURN NEW;
	END;
$function$ LANGUAGE plpgsql;

-- implement trigger on 'configurations' 
DROP TRIGGER IF EXISTS trg_it_configurations_prv_uh_id ON configurations; 
CREATE TRIGGER trg_it_configurations_prv_uh_id
	AFTER INSERT ON configurations FOR EACH ROW -- after insert
	EXECUTE PROCEDURE config_data.trg_config_prv_uh_id();

DROP TRIGGER IF EXISTS trg_ut_configurations_prv_uh_id ON configurations; 
CREATE TRIGGER trg_ut_configurations_prv_uh_id
	BEFORE UPDATE ON configurations FOR EACH ROW -- before update
	EXECUTE PROCEDURE config_data.trg_config_prv_uh_id();

----------------------------------------
--Function to select previous prselc_id from 'configurations' if change in configuration is not due to a change stemming from presidential elections
CREATE FUNCTION config_data.trg_config_prv_prselc_id() RETURNS trigger AS $function$
	BEGIN 
		IF 
			OLD.prselc_id IS NOT NULL THEN NEW.prselc_id= OLD.prselc_id;
		ELSE 
			NEW.prselc_id := 
			(SELECT prselc_id FROM configurations
			WHERE sdate < NEW.sdate
			AND ctr_id = NEW.ctr_id
			ORDER BY ctr_id, sdate DESC
			LIMIT 1); -- selects next lowest PRSELC date
		END IF;
	RETURN NEW;
	END;
$function$ LANGUAGE plpgsql;
	
-- implement trigger on 'configurations' 
DROP TRIGGER IF EXISTS trg_it_configurations_prv_prselc_id ON configurations; 
CREATE TRIGGER trg_it_configurations_prv_prselc_id
	AFTER INSERT ON configurations FOR EACH ROW -- after insert
	EXECUTE PROCEDURE config_data.trg_config_prv_prselc_id();	
	
DROP TRIGGER IF EXISTS trg_ut_configurations_prv_prselc_id ON configurations; 
CREATE TRIGGER trg_ut_configurations_prv_prselc_id
	BEFORE UPDATE ON configurations FOR EACH ROW -- before update
	EXECUTE PROCEDURE config_data.trg_config_prv_prselc_id();
