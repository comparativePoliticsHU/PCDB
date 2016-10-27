

CREATE OR REPLACE FUNCTION config_data.mv_config_ctr_yr_refresh() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.refresh_mv_config_ctr_yr_row();
	RETURN NULL;
END';

-- cabinet
DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_ut ON config_data.cabinet;
CREATE TRIGGER mv_config_ctr_yr_refresh_ut
	AFTER UPDATE OF cab_id, cab_sdate ON config_data.cabinet
	FOR EACH STATEMENT EXECUTE PROCEDURE config_data.mv_config_ctr_yr_refresh();

DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_it ON config_data.cabinet;
CREATE TRIGGER mv_config_ctr_yr_refresh_it 
	AFTER INSERT ON config_data.cabinet
	FOR EACH STATEMENT EXECUTE PROCEDURE config_data.mv_config_ctr_yr_refresh();

DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_dt ON config_data.cabinet;
CREATE TRIGGER mv_config_ctr_yr_refresh_dt 
	AFTER DELETE ON config_data.cabinet
	FOR EACH STATEMENT EXECUTE PROCEDURE config_data.mv_config_ctr_yr_refresh();

-- lower house 
DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_ut ON config_data.lower_house;
CREATE TRIGGER mv_config_ctr_yr_refresh_ut
	AFTER UPDATE OF lh_id, lhelc_id, lh_sdate ON config_data.lower_house
	FOR EACH STATEMENT EXECUTE PROCEDURE config_data.mv_config_ctr_yr_refresh();

DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_it ON config_data.lower_house;
CREATE TRIGGER mv_config_ctr_yr_refresh_it 
	AFTER INSERT ON config_data.lower_house
	FOR EACH STATEMENT EXECUTE PROCEDURE config_data.mv_config_ctr_yr_refresh();

DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_dt ON config_data.lower_house;
CREATE TRIGGER mv_config_ctr_yr_refresh_dt 
	AFTER DELETE ON config_data.lower_house
	FOR EACH STATEMENT EXECUTE PROCEDURE config_data.mv_config_ctr_yr_refresh();

-- upper house
DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_ut ON config_data.upper_house;
CREATE TRIGGER mv_config_ctr_yr_refresh_ut
	AFTER UPDATE OF uh_id, uh_sdate ON config_data.upper_house
	FOR EACH STATEMENT EXECUTE PROCEDURE config_data.mv_config_ctr_yr_refresh();

DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_it ON config_data.upper_house;
CREATE TRIGGER mv_config_ctr_yr_refresh_it 
	AFTER INSERT ON config_data.upper_house
	FOR EACH STATEMENT EXECUTE PROCEDURE config_data.mv_config_ctr_yr_refresh();

DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_dt ON config_data.upper_house;
CREATE TRIGGER mv_config_ctr_yr_refresh_dt 
	AFTER DELETE ON config_data.upper_house
	FOR EACH STATEMENT EXECUTE PROCEDURE config_data.mv_config_ctr_yr_refresh();

-- presidential election
DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_ut ON config_data.presidential_election;
CREATE TRIGGER mv_config_ctr_yr_refresh_ut
	AFTER UPDATE OF prselc_id, prs_sdate ON config_data.presidential_election
	FOR EACH STATEMENT EXECUTE PROCEDURE config_data.mv_config_ctr_yr_refresh();

DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_it ON config_data.presidential_election;
CREATE TRIGGER mv_config_ctr_yr_refresh_it 
	AFTER INSERT ON config_data.presidential_election
	FOR EACH STATEMENT EXECUTE PROCEDURE config_data.mv_config_ctr_yr_refresh();

DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_dt ON config_data.presidential_election;
CREATE TRIGGER mv_config_ctr_yr_refresh_dt 
	AFTER DELETE  ON config_data.presidential_election
	FOR EACH STATEMENT EXECUTE PROCEDURE config_data.mv_config_ctr_yr_refresh();
