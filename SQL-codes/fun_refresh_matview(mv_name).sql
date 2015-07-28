CREATE OR REPLACE FUNCTION config_data.refresh_matview(NAME) RETURNS VOID
SECURITY DEFINER
LANGUAGE plpgsql AS '
DECLARE 
    matview_name ALIAS FOR $1;
    entry config_data.matviews%ROWTYPE;
BEGIN

    SELECT mv_name, v_name INTO entry FROM config_data.matviews WHERE matviews.mv_name = matview_name;

    IF NOT FOUND THEN
        RAISE EXCEPTION ''Materialized view % does not exist.'', matview_name;
    END IF;

    EXECUTE ''ALTER TABLE config_data.'' || matview_name || '' DISABLE TRIGGER USER'';
    EXECUTE ''DELETE FROM config_data.'' || matview_name;
    EXECUTE ''INSERT INTO config_data.'' || matview_name
        || '' SELECT * FROM '' || entry.v_name;
    EXECUTE ''ALTER TABLE config_data.'' || matview_name || '' ENABLE TRIGGER USER'';

    UPDATE config_data.matviews
        SET last_refresh=CURRENT_TIMESTAMP
        WHERE matviews.mv_name = matview_name;
        
    EXECUTE ''SELECT config_data.update_mv_config_events()'';
	
    RETURN;
END';