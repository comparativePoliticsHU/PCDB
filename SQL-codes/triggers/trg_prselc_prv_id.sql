CREATE FUNCTION config_data.trg_prselc_prv_id() 
RETURNS trigger AS $function$
	BEGIN 
		NEW.prselc_prv_id := 
			(SELECT prselc_prv_id FROM config_data.presidential_election
			WHERE prselc_date < NEW.prselc_date
			AND ctr_id = NEW.ctr_id
			ORDER BY ctr_id, prselc_date DESC
			LIMIT 1); 
	RETURN NEW;
	END;
$function$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prselc_prv_id 
	BEFORE INSERT OR UPDATE ON config_data.presidential_election
	FOR EACH ROW
	EXECUTE PROCEDURE config_data.trg_prselc_prv_id();
