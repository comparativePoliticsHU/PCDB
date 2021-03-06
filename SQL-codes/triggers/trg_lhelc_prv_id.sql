﻿CREATE FUNCTION config_data.trg_lhelc_prv_id() RETURNS trigger AS $function$
	BEGIN 
		NEW.lhelc_prv_id := 
			(SELECT lhelc_id FROM config_data.lh_election
			WHERE lhelc_date < NEW.lhelc_date
			AND ctr_id = NEW.ctr_id
			ORDER BY ctr_id, lhelc_date DESC
			LIMIT 1); 
	RETURN NEW;
	END;
$function$ LANGUAGE plpgsql;

CREATE TRIGGER trg_lhelc_prv_id 
	BEFORE INSERT OR UPDATE ON config_data.lh_election
	FOR EACH ROW
	EXECUTE PROCEDURE config_data.trg_lhelc_prv_id();
