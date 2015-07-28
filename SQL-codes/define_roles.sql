-- Grant usage of schmea config_data to all accounts
GRANT usage ON SCHEMA public, config_data TO polconfdb_1 ; 
GRANT usage ON SCHEMA public, config_data TO polconfdb_2 ;
GRANT usage ON SCHEMA public, config_data TO polconfdb_3 ; 
GRANT usage ON SCHEMA public, config_data TO polconfdb_4 ; 
GRANT usage ON SCHEMA public, config_data TO polconfdb_5 ;

-- create additional adminstrator role
GRANT ALL ON SCHEMA public, config_data TO polconfdb_1;

-- create two view-and-write accounts
GRANT select, insert, update ON ALL TABLES 
	IN SCHEMA public, config_data TO polconfdb_2, polconfdb_3;
GRANT execute ON ALL FUNCTIONS 
	IN SCHEMA public, config_data TO polconfdb_2, polconfdb_3;

-- creat etwo view-only accounts
GRANT select ON ALL TABLES 
	IN SCHEMA public, config_data TO polconfdb_4, polconfdb_5;
