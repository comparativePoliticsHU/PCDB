CREATE FUNCTION config_data.trg_lh_nxt_id() RETURNS trigger AS $function$
	BEGIN 
		NEW.lh_nxt_id := 
			(SELECT lh_id FROM config_data.lower_house
			WHERE lh_sdate > NEW.lh_sdate
			AND ctr_id = NEW.ctr_id
			ORDER BY ctr_id, lh_sdate ASC -- ascending
			LIMIT 1);
	RETURN NEW;
	END;
$function$ LANGUAGE plpgsql;

CREATE TRIGGER trg_lh_nxt_id 
	BEFORE INSERT OR UPDATE ON config_data.lower_house
	FOR EACH ROW
	EXECUTE PROCEDURE config_data.trg_lh_nxt_id();
