-- Define REFRESH MATERIALIZED VIEW function 
-- source is Listing 4 of http://www.varlena.com/GeneralBits/Tidbits/matviews.html 

-- 	The function takes one arguemnt schema.matview_name; disables all triggers defined on matview, delets all data from matview, inserts anew from corresponding view (as recorded in table matviews), and enables all triggers defined on matview; and records by time stamp in matviews table update in last_refresh

--	NOTE: when triggers on matview are defined, below line that updates row in matviews table, a line needs to be added that triggers, e.g. update <some column> of matview 

CREATE OR REPLACE FUNCTION beta_version.refresh_matview(TEXT, TEXT[] DEFAULT '{}') 
RETURNS VOID 
SECURITY DEFINER
LANGUAGE plpgsql AS $$
DECLARE 
    matview_name ALIAS FOR $1;
    entry beta_version.matviews%ROWTYPE; -- note change to destination of entry

    primary_key_columns TEXT := ARRAY_TO_STRING($2, ', ');
    mv_schema_name TEXT := (REGEXP_SPLIT_TO_ARRAY($1,E'\\.'))[1];
    mv_table_name TEXT := (REGEXP_SPLIT_TO_ARRAY($1,E'\\.'))[2];

    pkey_constraint TEXT := DISTINCT constraint_name::VARCHAR -- get name of primary key constraint
			FROM information_schema.constraint_column_usage 
			WHERE (table_schema = mv_schema_name AND table_name = mv_table_name)
			AND constraint_name LIKE '%pkey%';
    
BEGIN

    SELECT mv_name, v_name INTO entry FROM beta_version.matviews WHERE matviews.mv_name = matview_name;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Materialized view % does not exist.', matview_name;
    END IF;

    IF NULLIF(pkey_constraint, '') IS NULL AND NULLIF(primary_key_columns, '') IS NULL THEN 
	RAISE EXCEPTION 'No primary key columns defined on materialized view ''''%''''. Please pass array with primary key column names as second argument!',
          matview_name;
    END IF;
    
    EXECUTE 'ALTER TABLE ' || matview_name || ' DISABLE TRIGGER USER';
    EXECUTE 'DELETE FROM ' || matview_name;
    EXECUTE 'INSERT INTO ' || matview_name
        || ' SELECT * FROM ' || entry.v_name;
    EXECUTE 'ALTER TABLE ' || matview_name || ' ENABLE TRIGGER USER';

    EXECUTE 'UPDATE ' || matview_name || ' SET edate = edate';

    IF NULLIF(pkey_constraint, '') IS NULL THEN 
	EXECUTE 'ALTER TABLE ' || matview_name || ' ADD PRIMARY KEY (' || primary_key_columns || ')';
	EXECUTE 'CLUSTER ' || matview_name || ' USING ' || mv_table_name || '_pkey';
    ELSE 
	EXECUTE 'CLUSTER ' || matview_name || ' USING ' || pkey_constraint ;
    END IF;
    
    UPDATE beta_version.matviews
        SET last_refresh=CURRENT_TIMESTAMP
        WHERE matviews.mv_name = matview_name;
        	
    RETURN;
END $$;
