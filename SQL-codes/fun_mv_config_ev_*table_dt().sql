CREATE OR REPLACE FUNCTION config_data.mv_config_ev_*table_dt() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_refresh_row(ctr_id::SMALLINT, *_sdate::DATE)
		FROM config_data.*table 
		WHERE *table.*_id = OLD.*_id 
		AND *table.*_sdate = OLD.*_sdate;
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_delete ON config_data.*table;
CREATE TRIGGER mv_config_ev_delete 
	AFTER DELETE ON config_data.*table
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_*table_dt();