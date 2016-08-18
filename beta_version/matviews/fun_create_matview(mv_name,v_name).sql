-- Define CREARTE MATERIALIZED VIEW function 
-- source is Listing 2 of http://www.varlena.com/GeneralBits/Tidbits/matviews.html 

-- 	The function takes two arguemnts schema.matview_name and schema.view_name, 
-- 	creates matview as exact copy of view (if not exists), and 
-- 	records by time stamp in matviews table as last_refresh

CREATE OR REPLACE FUNCTION beta_version.create_matview(NAME, NAME) -- note change to destination of entry
RETURNS VOID
SECURITY DEFINER
LANGUAGE plpgsql AS '
DECLARE
    matview_name ALIAS FOR $1;
    view_name ALIAS FOR $2;
    entry beta_version.matviews%ROWTYPE; 
BEGIN
    SELECT * INTO entry FROM beta_version.matviews WHERE matviews.mv_name = matview_name;

    IF FOUND THEN
        RAISE EXCEPTION ''Materialized view ''''%'''' already exists.'',
          matview_name;
    END IF;
    
    EXECUTE ''REVOKE ALL ON '' || view_name || '' FROM PUBLIC''; 
    EXECUTE ''GRANT SELECT ON '' || view_name || '' TO PUBLIC'';
    EXECUTE ''CREATE TABLE '' || matview_name || '' AS SELECT * FROM '' || view_name;
    EXECUTE ''REVOKE ALL ON '' || matview_name || '' FROM PUBLIC'';
    EXECUTE ''GRANT SELECT ON '' || matview_name || '' TO PUBLIC'';

    INSERT INTO beta_version.matviews (mv_name, v_name, last_refresh)
      VALUES (matview_name, view_name, CURRENT_TIMESTAMP); 
    
    RETURN;
END
';