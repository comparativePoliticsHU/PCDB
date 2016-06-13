-- cabinet triggers
	-- update
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_cabinet_ut() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
		PERFORM config_data.refresh_mv_config_events(ctr_id::SMALLINT)
			FROM config_data.cabinet 
			WHERE cabinet.ctr_id = NEW.ctr_id 
			AND cabinet.cab_id = NEW.cab_id 
			AND cabinet.cab_sdate = NEW.cab_sdate;	
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_update ON config_data.cabinet;
CREATE TRIGGER mv_config_ev_update 
	AFTER UPDATE ON config_data.cabinet
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_cabinet_ut();

	-- delet
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_cabinet_dt() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_refresh_row(ctr_id::SMALLINT, cab_sdate::DATE)
		FROM config_data.cabinet 
		WHERE cabinet.cab_id = OLD.cab_id 
		AND cabinet.cab_sdate = OLD.cab_sdate;
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
	PERFORM config_data.mv_config_ev_refresh_row(ctr_id::SMALLINT, cab_sdate::DATE)
		FROM config_data.cabinet 
		WHERE cabinet.cab_id = NEW.cab_id 
		AND cabinet.cab_sdate = NEW.cab_sdate;
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
		PERFORM config_data.refresh_mv_config_events(ctr_id::SMALLINT)
			FROM config_data.lower_house 
			WHERE lower_house.ctr_id = NEW.ctr_id 
			AND lower_house.lh_id = NEW.lh_id 
			AND lower_house.lh_sdate = NEW.lh_sdate;	
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_update ON config_data.lower_house;
CREATE TRIGGER mv_config_ev_update 
	AFTER UPDATE ON config_data.lower_house
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_lower_house_ut();
	
	-- delet
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_lower_house_dt() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_refresh_row(ctr_id::SMALLINT, lh_sdate::DATE)
		FROM config_data.lower_house 
		WHERE lower_house.lh_id = OLD.lh_id 
		AND lower_house.lh_sdate = OLD.lh_sdate;
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
	PERFORM config_data.mv_config_ev_refresh_row(ctr_id::SMALLINT, lh_sdate::DATE)
		FROM config_data.lower_house 
		WHERE lower_house.lh_id = NEW.lh_id 
		AND lower_house.lh_sdate = NEW.lh_sdate;
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
		PERFORM config_data.refresh_mv_config_events(ctr_id::SMALLINT)
			FROM config_data.upper_house 
			WHERE upper_house.ctr_id = NEW.ctr_id 
			AND upper_house.uh_id = NEW.uh_id 
			AND upper_house.uh_sdate = NEW.uh_sdate;	
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_update ON config_data.upper_house;
CREATE TRIGGER mv_config_ev_update 
	AFTER UPDATE ON config_data.upper_house
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_upper_house_ut();
	
	-- delet
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_upper_house_dt() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_refresh_row(ctr_id::SMALLINT, uh_sdate)
		FROM config_data.upper_house 
		WHERE upper_house.uh_id = OLD.uh_id 
		AND upper_house.uh_sdate = OLD.uh_sdate;
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
	PERFORM config_data.mv_config_ev_refresh_row(ctr_id::SMALLINT, uh_sdate::DATE)
		FROM config_data.upper_house 
		WHERE upper_house.uh_id = NEW.uh_id 
		AND upper_house.uh_sdate = NEW.uh_sdate;
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
		PERFORM config_data.refresh_mv_config_events(ctr_id::SMALLINT)
			FROM config_data.presidential_election 
			WHERE presidential_election.ctr_id = NEW.ctr_id 
			AND presidential_election.prselc_id = NEW.prselc_id 
			AND presidential_election.prselc_sdate = NEW.prselc_sdate;	
	RETURN NULL;
	END';
DROP TRIGGER IF EXISTS mv_config_ev_update ON config_data.presidential_election;
CREATE TRIGGER mv_config_ev_update 
	AFTER UPDATE ON config_data.presidential_election
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_presidential_election_ut();
	
	-- delet
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_presidential_election_dt() 
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_refresh_row(ctr_id::SMALLINT, prselc_date::DATE)
		FROM config_data.presidential_election 
		WHERE presidential_election.prselc_id = OLD.prselc_id 
		AND presidential_election.prselc_date = OLD.prselc_date;
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
	PERFORM config_data.mv_config_ev_refresh_row(ctr_id::SMALLINT, prselc_date::DATE)
		FROM config_data.presidential_election 
		WHERE presidential_election.prselc_id = NEW.prselc_id 
		AND presidential_election.prselc_date = NEW.prselc_date;
	RETURN NULL;
END';
DROP TRIGGER IF EXISTS mv_config_ev_insert ON config_data.presidential_election;
CREATE TRIGGER mv_config_ev_insert 
	AFTER INSERT ON config_data.presidential_election
	FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_presidential_election_it();