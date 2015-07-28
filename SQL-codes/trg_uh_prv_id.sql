CREATE OR REPLACE FUNCTION config_data.trg_uh_prv_id() 
RETURNS trigger AS $function$
	BEGIN 
		NEW.uh_prv_id := 
			(SELECT uh_id FROM config_data.upper_house
			WHERE uh_sdate < NEW.uh_sdate
			AND ctr_id = NEW.ctr_id
			ORDER BY ctr_id, uh_sdate DESC
			LIMIT 1); 
	RETURN NEW;
	END;
$function$ LANGUAGE plpgsql;

CREATE TRIGGER trg_uh_prv_id 
	BEFORE INSERT OR UPDATE ON config_data.upper_house
	FOR EACH ROW
	EXECUTE PROCEDURE config_data.trg_uh_prv_id();
