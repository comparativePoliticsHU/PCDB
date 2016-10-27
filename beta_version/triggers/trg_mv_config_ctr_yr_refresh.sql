

CREATE OR REPLACE FUNCTION beta_version.mv_config_ctr_yr_refresh() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM beta_version.refresh_mv_config_ctr_yr_row();
	RETURN NULL;
END';

-- cabinet
DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_ut ON beta_version.cabinet;
CREATE TRIGGER mv_config_ctr_yr_refresh_ut
	AFTER UPDATE OF cab_id, cab_sdate ON beta_version.cabinet
	FOR EACH STATEMENT EXECUTE PROCEDURE beta_version.mv_config_ctr_yr_refresh();

DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_it ON beta_version.cabinet;
CREATE TRIGGER mv_config_ctr_yr_refresh_it 
	AFTER INSERT ON beta_version.cabinet
	FOR EACH STATEMENT EXECUTE PROCEDURE beta_version.mv_config_ctr_yr_refresh();

DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_dt ON beta_version.cabinet;
CREATE TRIGGER mv_config_ctr_yr_refresh_dt 
	AFTER DELETE ON beta_version.cabinet
	FOR EACH STATEMENT EXECUTE PROCEDURE beta_version.mv_config_ctr_yr_refresh();

-- lower house 
DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_ut ON beta_version.lower_house;
CREATE TRIGGER mv_config_ctr_yr_refresh_ut
	AFTER UPDATE OF lh_id, lhelc_id, lh_sdate ON beta_version.lower_house
	FOR EACH STATEMENT EXECUTE PROCEDURE beta_version.mv_config_ctr_yr_refresh();

DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_it ON beta_version.lower_house;
CREATE TRIGGER mv_config_ctr_yr_refresh_it 
	AFTER INSERT ON beta_version.lower_house
	FOR EACH STATEMENT EXECUTE PROCEDURE beta_version.mv_config_ctr_yr_refresh();

DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_dt ON beta_version.lower_house;
CREATE TRIGGER mv_config_ctr_yr_refresh_dt 
	AFTER DELETE ON beta_version.lower_house
	FOR EACH STATEMENT EXECUTE PROCEDURE beta_version.mv_config_ctr_yr_refresh();

-- upper house
DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_ut ON beta_version.upper_house;
CREATE TRIGGER mv_config_ctr_yr_refresh_ut
	AFTER UPDATE OF uh_id, uh_sdate ON beta_version.upper_house
	FOR EACH STATEMENT EXECUTE PROCEDURE beta_version.mv_config_ctr_yr_refresh();

DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_it ON beta_version.upper_house;
CREATE TRIGGER mv_config_ctr_yr_refresh_it 
	AFTER INSERT ON beta_version.upper_house
	FOR EACH STATEMENT EXECUTE PROCEDURE beta_version.mv_config_ctr_yr_refresh();

DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_dt ON beta_version.upper_house;
CREATE TRIGGER mv_config_ctr_yr_refresh_dt 
	AFTER DELETE ON beta_version.upper_house
	FOR EACH STATEMENT EXECUTE PROCEDURE beta_version.mv_config_ctr_yr_refresh();

-- presidential election
DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_ut ON beta_version.presidential_election;
CREATE TRIGGER mv_config_ctr_yr_refresh_ut
	AFTER UPDATE OF prselc_id, prs_sdate ON beta_version.presidential_election
	FOR EACH STATEMENT EXECUTE PROCEDURE beta_version.mv_config_ctr_yr_refresh();

DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_it ON beta_version.presidential_election;
CREATE TRIGGER mv_config_ctr_yr_refresh_it 
	AFTER INSERT ON beta_version.presidential_election
	FOR EACH STATEMENT EXECUTE PROCEDURE beta_version.mv_config_ctr_yr_refresh();

DROP TRIGGER IF EXISTS mv_config_ctr_yr_refresh_dt ON beta_version.presidential_election;
CREATE TRIGGER mv_config_ctr_yr_refresh_dt 
	AFTER DELETE  ON beta_version.presidential_election
	FOR EACH STATEMENT EXECUTE PROCEDURE beta_version.mv_config_ctr_yr_refresh();
