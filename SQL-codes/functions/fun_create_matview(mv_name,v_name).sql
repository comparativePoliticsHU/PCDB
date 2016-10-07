-- Define CREARTE MATERIALIZED VIEW function 
-- source is Listing 2 of http://www.varlena.com/GeneralBits/Tidbits/matviews.html 

-- 	The function takes two arguemnts schema.matview_name and schema.view_name, 
-- 	creates matview as exact copy of view (if not exists), and 
-- 	records by time stamp in matviews table as last_refresh

CREATE OR REPLACE FUNCTION config_data.create_matview(TEXT, TEXT, TEXT[]) -- note change to destination of entry
RETURNS VOID
SECURITY DEFINER
LANGUAGE plpgsql AS $$
DECLARE
    matview_name ALIAS FOR $1;
    view_name ALIAS FOR $2;
    entry config_data.matviews%ROWTYPE; 

    primary_key_columns TEXT := ARRAY_TO_STRING($3, ', ');
    mv_schema_name TEXT := (REGEXP_SPLIT_TO_ARRAY($1,E'\\.'))[1];
    mv_table_name TEXT := (REGEXP_SPLIT_TO_ARRAY($1,E'\\.'))[2];

BEGIN
    SELECT * INTO entry FROM config_data.matviews WHERE matviews.mv_name = matview_name;

    IF FOUND THEN
        RAISE EXCEPTION 'Materialized view ''''%'''' already exists.',
          matview_name;
    END IF;

    IF NULLIF(primary_key_columns, '') IS NULL THEN 
	RAISE EXCEPTION 'No primary key columns defined on materialized view ''''%''''. Please pass Array with primary key column names as third argument!',
          matview_name;
    END IF;
	
    EXECUTE 'REVOKE ALL ON '|| view_name || ' FROM PUBLIC'; 
    EXECUTE 'GRANT SELECT ON ' || view_name || ' TO PUBLIC';
    EXECUTE 'CREATE TABLE ' || matview_name || ' AS SELECT * FROM ' || view_name;

    EXECUTE 'ALTER TABLE ' || matview_name || ' ADD PRIMARY KEY (' || primary_key_columns || ')';
    EXECUTE 'CLUSTER ' || matview_name || ' USING ' || mv_table_name || '_pkey';
  
    EXECUTE 'REVOKE ALL ON ' || matview_name || ' FROM PUBLIC';
    EXECUTE 'GRANT SELECT ON ' || matview_name || ' TO PUBLIC';

    INSERT INTO config_data.matviews (mv_name, v_name, last_refresh)
      VALUES (matview_name, view_name, CURRENT_TIMESTAMP); 
    
    RETURN;
END
$$;