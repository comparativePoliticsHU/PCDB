CREATE OR REPLACE FUNCTION config_data.create_matview(NAME, NAME)
RETURNS VOID
SECURITY DEFINER
LANGUAGE plpgsql AS '
DECLARE
    matview_name ALIAS FOR $1;
    view_name ALIAS FOR $2;
    entry config_data.matviews%ROWTYPE;
BEGIN
    SELECT * INTO entry FROM config_data.matviews WHERE matviews.mv_name = matview_name;

    IF FOUND THEN
        RAISE EXCEPTION ''Materialized view ''''%'''' already exists.'',
          matview_name;
    END IF;
    
    EXECUTE ''REVOKE ALL ON '' || view_name || '' FROM PUBLIC''; 
    EXECUTE ''GRANT SELECT ON '' || view_name || '' TO PUBLIC'';
    EXECUTE ''CREATE TABLE '' || matview_name || '' AS SELECT * FROM '' || view_name;
    EXECUTE ''REVOKE ALL ON '' || matview_name || '' FROM PUBLIC'';
    EXECUTE ''GRANT SELECT ON '' || matview_name || '' TO PUBLIC'';

    INSERT INTO config_data.matviews (mv_name, v_name, last_refresh)
      VALUES (matview_name, view_name, CURRENT_TIMESTAMP); 
    
    RETURN;
END
';