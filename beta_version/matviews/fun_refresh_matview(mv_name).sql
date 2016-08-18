-- Define REFRESH MATERIALIZED VIEW function 
-- source is Listing 4 of http://www.varlena.com/GeneralBits/Tidbits/matviews.html 

-- 	The function takes one arguemnt schema.matview_name; disables all triggers defined on matview, delets all data from matview, inserts anew from corresponding view (as recorded in table matviews), and enables all triggers defined on matview; and records by time stamp in matviews table update in last_refresh

--	NOTE: when triggers on matview are defined, below line that updates row in matviews table, a line needs to be added that triggers, e.g. update <some column> of matview 

CREATE OR REPLACE FUNCTION beta_version.refresh_matview(NAME) RETURNS VOID -- note change to destination of entry
SECURITY DEFINER
LANGUAGE plpgsql AS '
DECLARE 
    matview_name ALIAS FOR $1;
    entry beta_version.matviews%ROWTYPE;
BEGIN

    SELECT mv_name, v_name INTO entry FROM beta_version.matviews WHERE matviews.mv_name = matview_name;

    IF NOT FOUND THEN
        RAISE EXCEPTION ''Materialized view % does not exist.'', matview_name;
    END IF;

    EXECUTE ''ALTER TABLE '' || matview_name || '' DISABLE TRIGGER USER'';
    EXECUTE ''DELETE FROM '' || matview_name;
    EXECUTE ''INSERT INTO '' || matview_name
        || '' SELECT * FROM '' || entry.v_name;
    EXECUTE ''ALTER TABLE '' || matview_name || '' ENABLE TRIGGER USER'';

    UPDATE beta_version.matviews
        SET last_refresh=CURRENT_TIMESTAMP
        WHERE matviews.mv_name = matview_name;
        	
    RETURN;
END';
