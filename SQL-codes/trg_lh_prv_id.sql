-- Trigger selects previous LH id 
CREATE FUNCTION config_data.trg_lh_prv_id() RETURNS trigger AS $function$
	BEGIN 
		NEW.lh_prv_id := 
			(SELECT lh_id FROM config_data.lower_house
			WHERE lh_sdate < NEW.lh_sdate
			AND ctr_id = NEW.ctr_id
			ORDER BY ctr_id, lh_sdate DESC
			LIMIT 1); -- selects next lowest LH start date
	RETURN NEW;
	END;
$function$ LANGUAGE plpgsql;

CREATE TRIGGER trg_lh_prv_id 
	BEFORE INSERT OR UPDATE ON config_data.lower_house
	FOR EACH ROW
	EXECUTE PROCEDURE config_data.trg_lh_prv_id();
