-- cabinet triggers
	-- update
CREATE OR REPLACE FUNCTION beta_version.mv_config_ev_cabinet_ut() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM beta_version.mv_config_ev_refresh_row(OLD.ctr_id, OLD.cab_sdate);
	PERFORM beta_version.mv_config_ev_refresh_row(NEW.ctr_id, NEW.cab_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_update ON beta_version.cabinet;
CREATE TRIGGER mv_config_ev_update 
	AFTER UPDATE OF cab_id, cab_sdate ON beta_version.cabinet
	FOR EACH ROW EXECUTE PROCEDURE beta_version.mv_config_ev_cabinet_ut();

	-- delet
CREATE OR REPLACE FUNCTION beta_version.mv_config_ev_cabinet_dt() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM beta_version.mv_config_ev_refresh_row(OLD.ctr_id, OLD.cab_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_delete ON beta_version.cabinet;
CREATE TRIGGER mv_config_ev_delete 
	AFTER DELETE ON beta_version.cabinet
	FOR EACH ROW EXECUTE PROCEDURE beta_version.mv_config_ev_cabinet_dt();

	-- insert
CREATE OR REPLACE FUNCTION beta_version.mv_config_ev_cabinet_it() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM beta_version.mv_config_ev_refresh_row(NEW.ctr_id, NEW.cab_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_insert ON beta_version.cabinet;
CREATE TRIGGER mv_config_ev_insert 
	AFTER INSERT ON beta_version.cabinet
	FOR EACH ROW EXECUTE PROCEDURE beta_version.mv_config_ev_cabinet_it();

	
-- lower house triggers
	-- update
CREATE OR REPLACE FUNCTION beta_version.mv_config_ev_lower_house_ut() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM beta_version.mv_config_ev_refresh_row(OLD.ctr_id, OLD.lh_sdate);
	PERFORM beta_version.mv_config_ev_refresh_row(NEW.ctr_id, NEW.lh_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_update ON beta_version.lower_house;
CREATE TRIGGER mv_config_ev_update 
	AFTER UPDATE OF lh_id, lh_sdate ON beta_version.lower_house
	FOR EACH ROW EXECUTE PROCEDURE beta_version.mv_config_ev_lower_house_ut();
	
	-- delet
CREATE OR REPLACE FUNCTION beta_version.mv_config_ev_lower_house_dt() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM beta_version.mv_config_ev_refresh_row(OLD.ctr_id, OLD.lh_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_delete ON beta_version.lower_house;
CREATE TRIGGER mv_config_ev_delete 
	AFTER DELETE ON beta_version.lower_house
	FOR EACH ROW EXECUTE PROCEDURE beta_version.mv_config_ev_lower_house_dt();
	
	-- insert
CREATE OR REPLACE FUNCTION beta_version.mv_config_ev_lower_house_it() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM beta_version.mv_config_ev_refresh_row(NEW.ctr_id, NEW.lh_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_insert ON beta_version.lower_house;
CREATE TRIGGER mv_config_ev_insert 
	AFTER INSERT ON beta_version.lower_house
	FOR EACH ROW EXECUTE PROCEDURE beta_version.mv_config_ev_lower_house_it();
	
-- upper house triggers
	-- update
CREATE OR REPLACE FUNCTION beta_version.mv_config_ev_upper_house_ut() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM beta_version.mv_config_ev_refresh_row(OLD.ctr_id, OLD.uh_sdate);
	PERFORM beta_version.mv_config_ev_refresh_row(NEW.ctr_id, NEW.uh_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_update ON beta_version.upper_house;
CREATE TRIGGER mv_config_ev_update 
	AFTER UPDATE OF uh_id, uh_sdate ON beta_version.upper_house
	FOR EACH ROW EXECUTE PROCEDURE beta_version.mv_config_ev_upper_house_ut();
	
	-- delet
CREATE OR REPLACE FUNCTION beta_version.mv_config_ev_upper_house_dt() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM beta_version.mv_config_ev_refresh_row(OLD.ctr_id, OLD.uh_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_delete ON beta_version.upper_house;
CREATE TRIGGER mv_config_ev_delete 
	AFTER DELETE ON beta_version.upper_house
	FOR EACH ROW EXECUTE PROCEDURE beta_version.mv_config_ev_upper_house_dt();
	
	-- insert
CREATE OR REPLACE FUNCTION beta_version.mv_config_ev_upper_house_it() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM beta_version.mv_config_ev_refresh_row(NEW.ctr_id, NEW.uh_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_insert ON beta_version.upper_house;
CREATE TRIGGER mv_config_ev_insert 
	AFTER INSERT ON beta_version.upper_house
	FOR EACH ROW EXECUTE PROCEDURE beta_version.mv_config_ev_upper_house_it();
	
-- presidential election triggers
		-- update
CREATE OR REPLACE FUNCTION beta_version.mv_config_ev_presidential_election_ut() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM beta_version.mv_config_ev_refresh_row(OLD.ctr_id, OLD.prs_sdate);
	PERFORM beta_version.mv_config_ev_refresh_row(NEW.ctr_id, NEW.prs_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_update ON beta_version.presidential_election;
CREATE TRIGGER mv_config_ev_update 
	AFTER UPDATE OF prselc_id, prs_sdate ON beta_version.presidential_election
	FOR EACH ROW EXECUTE PROCEDURE beta_version.mv_config_ev_presidential_election_ut();
	
	-- delet
CREATE OR REPLACE FUNCTION beta_version.mv_config_ev_presidential_election_dt() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM beta_version.mv_config_ev_refresh_row(OLD.ctr_id, OLD.prs_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_delete ON beta_version.presidential_election;
CREATE TRIGGER mv_config_ev_delete 
	AFTER DELETE ON beta_version.presidential_election
	FOR EACH ROW EXECUTE PROCEDURE beta_version.mv_config_ev_presidential_election_dt();
	
	-- insert
CREATE OR REPLACE FUNCTION beta_version.mv_config_ev_presidential_election_it() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM beta_version.mv_config_ev_refresh_row(NEW.ctr_id, NEW.prs_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_insert ON beta_version.presidential_election;
CREATE TRIGGER mv_config_ev_insert 
	AFTER INSERT ON beta_version.presidential_election
	FOR EACH ROW EXECUTE PROCEDURE beta_version.mv_config_ev_presidential_election_it();



-- veto points triggers
		-- update
CREATE OR REPLACE FUNCTION beta_version.mv_config_ev_veto_points_ut() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM beta_version.mv_config_ev_refresh_row(OLD.ctr_id, OLD.vto_inst_sdate);
	PERFORM beta_version.mv_config_ev_refresh_row(NEW.ctr_id, NEW.vto_inst_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_update ON beta_version.veto_points;
CREATE TRIGGER mv_config_ev_update 
	AFTER UPDATE OF vto_id, vto_inst_sdate ON beta_version.veto_points
	FOR EACH ROW EXECUTE PROCEDURE beta_version.mv_config_ev_veto_points_ut();
	
	-- delet
CREATE OR REPLACE FUNCTION beta_version.mv_config_ev_veto_points_dt() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM beta_version.mv_config_ev_refresh_row(OLD.ctr_id, OLD.vto_inst_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_delete ON beta_version.veto_points;
CREATE TRIGGER mv_config_ev_delete 
	AFTER DELETE ON beta_version.veto_points
	FOR EACH ROW EXECUTE PROCEDURE beta_version.mv_config_ev_veto_points_dt();
	
	-- insert
CREATE OR REPLACE FUNCTION beta_version.mv_config_ev_veto_points_it() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM beta_version.mv_config_ev_refresh_row(NEW.ctr_id, NEW.vto_inst_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_insert ON beta_version.veto_points;
CREATE TRIGGER mv_config_ev_insert 
	AFTER INSERT ON beta_version.veto_points
	FOR EACH ROW EXECUTE PROCEDURE beta_version.mv_config_ev_veto_points_it();


	