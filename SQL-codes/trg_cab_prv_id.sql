CREATE OR REPLACE FUNCTION config_data.trg_cab_prv_id() 
RETURNS trigger AS $function$
	BEGIN 
		NEW.cab_prv_id := 
			(SELECT cab_id FROM config_data.cabinet
			WHERE cab_sdate < NEW.cab_sdate
			AND ctr_id = NEW.ctr_id
			ORDER BY ctr_id, cab_sdate DESC
			LIMIT 1); 
	RETURN NEW;
	END;
$function$ LANGUAGE plpgsql;

CREATE TRIGGER trg_cab_prv_id 
	BEFORE INSERT OR UPDATE ON config_data.cabinet
	FOR EACH ROW
	EXECUTE PROCEDURE config_data.trg_cab_prv_id();