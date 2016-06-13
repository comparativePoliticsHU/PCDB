CREATE OR REPLACE FUNCTION config_data.mv_config_ev_*table_ut() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
		PERFORM config_data.refresh_mv_config_events(ctr_id::SMALLINT)
			FROM config_data.*table 
			WHERE *table.ctr_id = NEW.ctr_id 
			AND *table.*_id = NEW.*_id 
			AND *table.*_sdate = NEW.*_sdate;	
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_update ON config_data.*table;
CREATE TRIGGER mv_config_ev_update 
	AFTER UPDATE ON config_data.*table
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_*table_ut();
