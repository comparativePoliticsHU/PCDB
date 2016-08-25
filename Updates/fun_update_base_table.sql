DROP FUNCTION IF EXISTS upsert_base_table();

CREATE OR REPLACE FUNCTION upsert_base_table( -- created in public schema (default)
	target_schema TEXT, target_table TEXT, 
	source_schema TEXT, source_table TEXT)
RETURNS VOID AS $$		
	
	DECLARE -- first, declare some parameters that are used below
		pkey_column TEXT := column_name::VARCHAR -- get column name of column that contains primary key variable
			FROM information_schema.constraint_column_usage 
			WHERE (table_schema = target_schema AND table_name = target_table)
			AND constraint_name LIKE '%pkey%';

		pkey_constraint TEXT := constraint_name::VARCHAR -- get name of primary key constraint
			FROM information_schema.constraint_column_usage 
			WHERE (table_schema = target_schema AND table_name = target_table)
			AND constraint_name LIKE '%pkey%';
			
		shared_columns TEXT := ARRAY_TO_STRING( -- comma-seperated list of columns that are both in target and source table (used for INSERT-statement and SELECT ... FROM source_table) (e.g. cab_sdate, cab_hog_n, ... ) 
						ARRAY(SELECT column_name::VARCHAR AS columns 
							FROM (SELECT column_name, ordinal_position 
								FROM information_schema.columns 
								WHERE table_schema = target_schema AND table_name = target_table
								AND column_name IN 
									(SELECT column_name 
										FROM information_schema.columns 
										WHERE table_schema = source_schema 
										AND table_name = source_table)
								ORDER BY ordinal_position) AS INTERSECTION 
							), ', ');
	
		update_columns TEXT := ARRAY_TO_STRING( -- comma-seperated list of target columns that are set equal to source columns (used for UPDATE-statement) (e.g. cab_sdate = update_source.cab_sdate, cab_hog_n = update_source.cab_hog_n, ... ) 
						ARRAY(SELECT '' || column_name || ' = update_source.' || column_name 
							FROM
								(SELECT column_name, ordinal_position 
									FROM information_schema.columns 
									WHERE table_schema = target_schema 
									AND table_name = target_table
									AND column_name IN 
										(SELECT column_name 
											FROM information_schema.columns 
											WHERE table_schema = source_schema 
											AND table_name = source_table)
									AND column_name NOT LIKE pkey_column
									ORDER BY ordinal_position) AS INTERSECTION 
							), ', ');	
	-- then upsert, that is ...
	BEGIN -- update columns if primary key ID enlisted in source table does already exist in target table
		EXECUTE 'UPDATE ' || target_schema || '.' || target_table || 
			' SET ' || update_columns || 
				' FROM (SELECT * FROM ' || source_schema || '.' || source_table || 
					' WHERE ' || pkey_column || ' IN 
						(SELECT DISTINCT ' || pkey_column || 
							' FROM ' || target_schema || '.' || target_table || 
							') ) AS update_source 
			WHERE ' || target_table || '.' || pkey_column || ' = update_source.' || pkey_column;
		-- insert into target table for the remaining set of primary key ID enlisted in source table 
		EXECUTE 'INSERT INTO ' || target_schema || '.' || target_table || ' (' || shared_columns || ') 
			  SELECT ' || shared_columns || 
				' FROM (SELECT * FROM ' || source_schema || '.' || source_table ||
					' WHERE ' || pkey_column || ' NOT IN 
						(SELECT DISTINCT ' || pkey_column || 
							' FROM ' || target_schema || '.' || target_table || 
					')) AS insert_source';
		-- lastely, use index on primary key column to re-cluster data (i.e., order by priamry key ID)
		EXECUTE 'CLUSTER ' || target_schema || '.' || target_table || ' USING ' || pkey_constraint ;
		
		RETURN;
	END;
$$ LANGUAGE plpgsql;
