-- cabinet triggers
	-- update
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_cabinet_ut() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_refresh_row(OLD.ctr_id, OLD.cab_sdate);
	PERFORM config_data.mv_config_ev_refresh_row(NEW.ctr_id, NEW.cab_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_update ON config_data.cabinet;
CREATE TRIGGER mv_config_ev_update 
	AFTER UPDATE OF cab_id, cab_sdate ON config_data.cabinet
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_cabinet_ut();

	-- delet
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_cabinet_dt() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_refresh_row(OLD.ctr_id, OLD.cab_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_delete ON config_data.cabinet;
CREATE TRIGGER mv_config_ev_delete 
	AFTER DELETE ON config_data.cabinet
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_cabinet_dt();

	-- insert
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_cabinet_it() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_refresh_row(NEW.ctr_id, NEW.cab_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_insert ON config_data.cabinet;
CREATE TRIGGER mv_config_ev_insert 
	AFTER INSERT ON config_data.cabinet
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_cabinet_it();

	
-- lower house triggers
	-- update
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_lower_house_ut() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_refresh_row(OLD.ctr_id, OLD.lh_sdate);
	PERFORM config_data.mv_config_ev_refresh_row(NEW.ctr_id, NEW.lh_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_update ON config_data.lower_house;
CREATE TRIGGER mv_config_ev_update 
	AFTER UPDATE OF lh_id, lh_sdate ON config_data.lower_house
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_lower_house_ut();
	
	-- delet
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_lower_house_dt() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_refresh_row(OLD.ctr_id, OLD.lh_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_delete ON config_data.lower_house;
CREATE TRIGGER mv_config_ev_delete 
	AFTER DELETE ON config_data.lower_house
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_lower_house_dt();
	
	-- insert
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_lower_house_it() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_refresh_row(NEW.ctr_id, NEW.lh_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_insert ON config_data.lower_house;
CREATE TRIGGER mv_config_ev_insert 
	AFTER INSERT ON config_data.lower_house
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_lower_house_it();
	
-- upper house triggers
	-- update
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_upper_house_ut() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_refresh_row(OLD.ctr_id, OLD.uh_sdate);
	PERFORM config_data.mv_config_ev_refresh_row(NEW.ctr_id, NEW.uh_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_update ON config_data.upper_house;
CREATE TRIGGER mv_config_ev_update 
	AFTER UPDATE OF uh_id, uh_sdate ON config_data.upper_house
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_upper_house_ut();
	
	-- delet
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_upper_house_dt() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_refresh_row(OLD.ctr_id, OLD.uh_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_delete ON config_data.upper_house;
CREATE TRIGGER mv_config_ev_delete 
	AFTER DELETE ON config_data.upper_house
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_upper_house_dt();
	
	-- insert
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_upper_house_it() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_refresh_row(NEW.ctr_id, NEW.uh_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_insert ON config_data.upper_house;
CREATE TRIGGER mv_config_ev_insert 
	AFTER INSERT ON config_data.upper_house
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_upper_house_it();
	
-- presidential election triggers
		-- update
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_presidential_election_ut() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_refresh_row(OLD.ctr_id, OLD.prs_sdate);
	PERFORM config_data.mv_config_ev_refresh_row(NEW.ctr_id, NEW.prs_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_update ON config_data.presidential_election;
CREATE TRIGGER mv_config_ev_update 
	AFTER UPDATE OF prselc_id, prs_sdate ON config_data.presidential_election
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_presidential_election_ut();
	
	-- delet
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_presidential_election_dt() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_refresh_row(OLD.ctr_id, OLD.prs_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_delete ON config_data.presidential_election;
CREATE TRIGGER mv_config_ev_delete 
	AFTER DELETE ON config_data.presidential_election
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_presidential_election_dt();
	
	-- insert
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_presidential_election_it() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_refresh_row(NEW.ctr_id, NEW.prs_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_insert ON config_data.presidential_election;
CREATE TRIGGER mv_config_ev_insert 
	AFTER INSERT ON config_data.presidential_election
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_presidential_election_it();



-- veto points triggers
		-- update
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_veto_points_ut() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_refresh_row(OLD.ctr_id, OLD.vto_inst_sdate);
	PERFORM config_data.mv_config_ev_refresh_row(NEW.ctr_id, NEW.vto_inst_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_update ON config_data.veto_points;
CREATE TRIGGER mv_config_ev_update 
	AFTER UPDATE OF vto_id, vto_inst_sdate ON config_data.veto_points
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_veto_points_ut();
	
	-- delet
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_veto_points_dt() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_refresh_row(OLD.ctr_id, OLD.vto_inst_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_delete ON config_data.veto_points;
CREATE TRIGGER mv_config_ev_delete 
	AFTER DELETE ON config_data.veto_points
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_veto_points_dt();
	
	-- insert
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_veto_points_it() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_refresh_row(NEW.ctr_id, NEW.vto_inst_sdate);
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_insert ON config_data.veto_points;
CREATE TRIGGER mv_config_ev_insert 
	AFTER INSERT ON config_data.veto_points
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_veto_points_it();


	