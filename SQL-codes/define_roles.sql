-- Grant usage of all schemata to all accounts
GRANT usage ON SCHEMA public TO polconfdb_1,polconfdb_2,polconfdb_3,polconfdb_4,polconfdb_5 ; 
GRANT usage ON SCHEMA config_data TO polconfdb_1,polconfdb_2,polconfdb_3,polconfdb_4,polconfdb_5 ; 
GRANT usage ON SCHEMA beta_version TO polconfdb_1,polconfdb_2,polconfdb_3,polconfdb_4,polconfdb_5 ; 
GRANT usage ON SCHEMA updates TO polconfdb_1,polconfdb_2,polconfdb_3,polconfdb_4,polconfdb_5 ; 

-- create additional adminstrator role
GRANT ALL ON SCHEMA public TO polconfdb_1;
GRANT ALL ON SCHEMA config_data TO polconfdb_1;
GRANT ALL ON SCHEMA beta_version TO polconfdb_1;
GRANT ALL ON SCHEMA updates TO polconfdb_1;

-- create two read-and-write accounts
GRANT select, insert, update, delete ON ALL TABLES IN SCHEMA config_data TO polconfdb_2, polconfdb_3;
GRANT execute ON ALL FUNCTIONS IN SCHEMA config_data TO polconfdb_2, polconfdb_3;

GRANT select, insert, update, delete ON ALL TABLES IN SCHEMA beta_version TO polconfdb_2, polconfdb_3;
GRANT execute ON ALL FUNCTIONS IN SCHEMA beta_version TO polconfdb_2, polconfdb_3;

GRANT select, insert, update, delete ON ALL TABLES IN SCHEMA updates TO polconfdb_2, polconfdb_3;
GRANT execute ON ALL FUNCTIONS IN SCHEMA updates TO polconfdb_2, polconfdb_3;

-- creat two read-only accounts
GRANT select ON ALL TABLES IN SCHEMA config_data TO polconfdb_4, polconfdb_5;
GRANT select ON ALL TABLES IN SCHEMA beta_version TO polconfdb_4, polconfdb_5;
GRANT select ON ALL TABLES IN SCHEMA updates TO polconfdb_4, polconfdb_5;
