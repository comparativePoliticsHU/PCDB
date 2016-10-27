CREATE OR REPLACE FUNCTION config_data.trg_*_prv_id() 
RETURNS trigger AS $function$ 
	BEGIN  
		NEW.*_prv_id :=  
			(SELECT *_id FROM config_data.# 
			WHERE *_sdate < NEW.*_sdate 
			AND ctr_id = NEW.ctr_id 
			ORDER BY ctr_id, *_sdate DESC 
			LIMIT 1); 
	RETURN NEW; 
	END; 
$function$ LANGUAGE plpgsql;

CREATE TRIGGER trg_*_prv_id 
	BEFORE INSERT OR UPDATE ON config_data.#
	FOR EACH ROW 
	EXECUTE PROCEDURE config_data.trg_*_prv_id(); 
