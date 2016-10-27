-- Experiment with eager materialized view definitions on view_configuration_events 


-- (1) 	I have tried to create a materialized view (MV) on view_configuration_events and to define end-date trigger on it; 
--	that is, however, not possible, for postgreSQL raises error "is no table or view," i.e., no triggers can be defined on postgreSQL MVs.

-- (2)	Some further reading of relevant blog topics suggests that the structure I use thus far is in fact appropiate and could be an efficient solution.
--	(see, for instance, https://hashrocket.com/blog/posts/materialized-view-strategies-using-postgresql, 
--	 http://tech.jonathangardner.net/wiki/PostgreSQL/Materialized_Views
--	 and an older contribution here http://www.varlena.com/GeneralBits/Tidbits/matviews.html )

-- in order to mess around with data while preventing data loss, I copy the base table structure and data to the beta_version scheme 

CREATE TABLE IF NOT EXISTS beta_version.cabinet (LIKE config_data.cabinet INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.cabinet; --delete all data from table 
INSERT INTO beta_version.cabinet SELECT * FROM config_data.cabinet WHERE cab_sdate >= '1995-01-01'::DATE ORDER BY cab_id; -- insert subset of data into table
SELECT * FROM beta_version.cabinet; -- visual inspection

CREATE TABLE IF NOT EXISTS beta_version.cabinet_portfolios (LIKE config_data.cabinet_portfolios INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.cabinet_portfolios; --delete all data from table 
INSERT INTO beta_version.cabinet_portfolios SELECT * FROM config_data.cabinet_portfolios 
	--WHERE cab_id 
	--	IN (SELECT min(cab_id) AS cab_id FROM beta_version.cabinet GROUP BY ctr_id)
	ORDER BY cab_id, pty_id; -- insert subset of data into table
SELECT * FROM beta_version.cabinet_portfolios; -- visual inspection

CREATE TABLE IF NOT EXISTS beta_version.lower_house (LIKE config_data.lower_house INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.lower_house; --delete all data from table 
INSERT INTO beta_version.lower_house SELECT * FROM config_data.lower_house WHERE lh_sdate >= '1995-01-01'::DATE ORDER BY lh_id; -- insert subset of data into table
SELECT * FROM beta_version.lower_house; -- visual inspection

CREATE TABLE IF NOT EXISTS beta_version.lh_election (LIKE config_data.lh_election INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.lh_election; --delete all data from table 
INSERT INTO beta_version.lh_election SELECT * FROM config_data.lh_election WHERE lhelc_date >= '1995-01-01'::DATE ORDER BY lhelc_id; -- insert subset of data into table
SELECT * FROM beta_version.lh_election; -- visual inspection


CREATE TABLE IF NOT EXISTS beta_version.lh_seat_results (LIKE config_data.lh_seat_results INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.lh_seat_results; --delete all data from table 
INSERT INTO beta_version.lh_seat_results SELECT * FROM config_data.lh_seat_results 
	--WHERE lh_id 
	--	IN (SELECT min(lh_id) AS lh_id FROM beta_version.lower_house GROUP BY ctr_id)
	ORDER BY lh_id, lhsres_id; -- insert subset of data into table
SELECT * FROM beta_version.lh_seat_results; -- visual inspection

CREATE TABLE IF NOT EXISTS beta_version.upper_house (LIKE config_data.upper_house INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.upper_house; --delete all data from table 
INSERT INTO beta_version.upper_house SELECT * FROM config_data.upper_house WHERE uh_sdate >= '1995-01-01'::DATE ORDER BY uh_id; -- insert subset of data into table
SELECT * FROM beta_version.upper_house; -- visual inspection

CREATE TABLE IF NOT EXISTS beta_version.uh_seat_results (LIKE config_data.uh_seat_results INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.uh_seat_results; --delete all data from table 
INSERT INTO beta_version.uh_seat_results SELECT * FROM config_data.uh_seat_results 
	--WHERE uh_id 
	--	IN (SELECT min(uh_id) AS lh_id FROM beta_version.upper_house GROUP BY ctr_id)
	ORDER BY uh_id, uhsres_id; -- insert subset of data into table
SELECT * FROM beta_version.uh_seat_results; -- visual inspection


CREATE TABLE IF NOT EXISTS beta_version.presidential_election (LIKE config_data.presidential_election INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.presidential_election; --delete all data from table 
INSERT INTO beta_version.presidential_election SELECT * FROM config_data.presidential_election WHERE prs_sdate >= '1995-01-01'::DATE ORDER BY prselc_id; -- insert subset of data into table
SELECT * FROM beta_version.presidential_election; -- visual inspection


CREATE TABLE IF NOT EXISTS beta_version.veto_points (LIKE config_data.veto_points INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.veto_points; --delete all data from table 
INSERT INTO beta_version.veto_points SELECT * FROM config_data.veto_points;
SELECT * FROM beta_version.veto_points; -- visual inspection

CREATE TABLE IF NOT EXISTS beta_version.party (LIKE config_data.party INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.party; --delete all data from table 
INSERT INTO beta_version.party SELECT * FROM config_data.party;
SELECT * FROM beta_version.party; -- visual inspection

-- and create beta_version.view_configuration_events
CREATE OR REPLACE VIEW beta_version.view_configuration_events
AS
SELECT DISTINCT ON (ctr_id, sdate) *
FROM 
	(SELECT DISTINCT ctr_id, sdate, cab_id, lh_id, lhelc_id, uh_id, prselc_id, 
		DATE_PART('year', sdate)::NUMERIC AS year, NULL::DATE AS edate,
		'configuration change'::TEXT AS type_of_change
		FROM
			(SELECT prselc_id, prs_sdate AS sdate, ctr_id 
				FROM beta_version.presidential_election
			) AS PRES_ELEC
		RIGHT OUTER JOIN
			(SELECT *
				FROM
					(SELECT uh_id, uh_sdate AS sdate, ctr_id 
						FROM beta_version.upper_house
					) AS UH
				RIGHT OUTER JOIN 
					(SELECT *
						FROM
							(SELECT lh_id, lh_sdate AS sdate, lhelc_id, ctr_id 
								FROM beta_version.lower_house
							) AS LH
						RIGHT OUTER JOIN
							(SELECT *
								FROM
									(SELECT cab_id, cab_sdate AS sdate, ctr_id 
										FROM beta_version.cabinet
									) AS CAB
								RIGHT OUTER JOIN
									(
									SELECT cab_sdate AS sdate, ctr_id 
										FROM beta_version.cabinet
									UNION
									SELECT lh_sdate AS sdate, ctr_id 
										FROM beta_version.lower_house
									UNION
									SELECT uh_sdate AS sdate, ctr_id 
										FROM beta_version.upper_house
									UNION 
									SELECT prs_sdate AS sdate, ctr_id 
										FROM beta_version.presidential_election
									ORDER BY ctr_id, sdate NULLS FIRST
									) AS START_DATES -- 2167 rows
								USING(ctr_id, sdate)
							) AS CAB_JOIN
						USING(ctr_id, sdate)
					) AS LH_JOIN
				USING(ctr_id, sdate)
			) AS UH_JOIN
		USING(ctr_id, sdate)
	UNION
		SELECT  ctr_id, vto_inst_sdate AS sdate, 
			NULL::NUMERIC(5,0) AS cab_id, NULL::NUMERIC(5,0) AS lh_id, NULL::NUMERIC(5,0) AS lhelc_id, 
			NULL::NUMERIC(5,0) AS uh_id, NULL::NUMERIC(5,0) AS prselc_id, 
			DATE_PART('year', vto_inst_sdate)::NUMERIC AS year, NULL::DATE AS edate,
			vto_inst_typ::TEXT||' veto institution change'AS type_of_change
			FROM beta_version.veto_points
			WHERE vto_inst_sdate >= '1995-01-01'::DATE -- note that here, too, only post 1995's subset is considered 
	ORDER BY ctr_id, sdate) AS FULL_UNION;

SELECT * FROM beta_version.view_configuration_events; -- visual inspection; exectaly seven config changes due to veto inst. change

-- Okay, base table structure established! 

-- (3)	Here, I re-examine the functionality of a view-MV-trigger structure, that is sought to achieve 
--	 (i) configuration end-dates are computed on mv_configuration_events, and empty cells are filled with ID of previous institution configuration
--	(ii) changes (i.e., update, insert, delet) on Base tables (cabinet, lower house, etc.) propagate through into mv_configuration_events 

-- lets review http://www.varlena.com/GeneralBits/Tidbits/matviews.html 

-- Listing 1: create table matviews that keeps track of MV history 
CREATE TABLE IF NOT EXISTS beta_version.matviews (
  mv_name NAME NOT NULL PRIMARY KEY, 
  v_name NAME NOT NULL, 
  last_refresh TIMESTAMP WITH TIME ZONE
);

-- Listing 2: definition of function create_matview 
-- 	The function takes two arguemnts schema.matview_name and schema.view_name, 
-- 	creates matview as exact copy of view (if not exists), and 
-- 	records by time stamp in matviews table as last_refresh

CREATE OR REPLACE FUNCTION beta_version.create_matview(NAME, NAME) -- note change to destination of entry
RETURNS VOID
SECURITY DEFINER
LANGUAGE plpgsql AS '
DECLARE
    matview_name ALIAS FOR $1;
    view_name ALIAS FOR $2;
    entry beta_version.matviews%ROWTYPE; 
BEGIN
    SELECT * INTO entry FROM beta_version.matviews WHERE matviews.mv_name = matview_name;

    IF FOUND THEN
        RAISE EXCEPTION ''Materialized view ''''%'''' already exists.'',
          matview_name;
    END IF;
    
    EXECUTE ''REVOKE ALL ON '' || view_name || '' FROM PUBLIC''; 
    EXECUTE ''GRANT SELECT ON '' || view_name || '' TO PUBLIC'';
    EXECUTE ''CREATE TABLE '' || matview_name || '' AS SELECT * FROM '' || view_name;
    EXECUTE ''REVOKE ALL ON '' || matview_name || '' FROM PUBLIC'';
    EXECUTE ''GRANT SELECT ON '' || matview_name || '' TO PUBLIC'';

    INSERT INTO beta_version.matviews (mv_name, v_name, last_refresh)
      VALUES (matview_name, view_name, CURRENT_TIMESTAMP); 
    
    RETURN;
END
'; 

-- TEST RUN !!!
SELECT beta_version.create_matview('beta_version.mv_configuration_events', 'beta_version.view_configuration_events');
-- REMEBER to use quotation marks to declare names of matview and view ;) 


-- Listing 4: definition of function refresh_matview 
-- 	The function takes one arguemnt schema.matview_name;
-- 	disables all triggers defined on matview, 
--	delets all data from matview, inserts anew from corresponding view (as recorded in table matviews),
--	and enables all triggers defined on matview; and
-- 	records by time stamp in matviews table update in last_refresh
--	NOTE: when triggers on matview are defined, below line that updates row in matviews table, 
--	      a line needs to be added that triggers triggers, e.g. update <some column> of matview 

CREATE OR REPLACE FUNCTION beta_version.refresh_matview(NAME) RETURNS VOID -- note change to destination of entry
SECURITY DEFINER
LANGUAGE plpgsql AS '
DECLARE 
    matview_name ALIAS FOR $1;
    entry beta_version.matviews%ROWTYPE;
BEGIN

    SELECT mv_name, v_name INTO entry FROM beta_version.matviews WHERE matviews.mv_name = matview_name;

    IF NOT FOUND THEN
        RAISE EXCEPTION ''Materialized view % does not exist.'', matview_name;
    END IF;

    EXECUTE ''ALTER TABLE '' || matview_name || '' DISABLE TRIGGER USER'';
    EXECUTE ''DELETE FROM '' || matview_name;
    EXECUTE ''INSERT INTO '' || matview_name
        || '' SELECT * FROM '' || entry.v_name;
    EXECUTE ''ALTER TABLE '' || matview_name || '' ENABLE TRIGGER USER'';

    UPDATE beta_version.matviews
        SET last_refresh=CURRENT_TIMESTAMP
        WHERE matviews.mv_name = matview_name;
        	
    RETURN;
END';

-- TEST RUN !!!
SELECT beta_version.refresh_matview('beta_version.mv_configuration_events');
-- REMEBER to use quotation marks to declare name of matview 

-- Listing 3: definition of function drop_matview 
-- 	The function takes as argument schema.matview_name; 
-- 	drops matview from schema (if not exists), and 
-- 	removes record in matviews table
--	NOTE: as the mv_configuration_events is intended to have multiple dependencies, 
--	      consider executing DROP CASCADE instead, though this is a radical step

CREATE OR REPLACE FUNCTION beta_version.drop_matview(NAME) RETURNS VOID
SECURITY DEFINER
LANGUAGE plpgsql AS '
DECLARE
    matview ALIAS FOR $1;
    entry beta_version.matviews%ROWTYPE;
BEGIN

    SELECT * INTO entry FROM beta_version.matviews WHERE mv_name = matview;

    IF NOT FOUND THEN
        RAISE EXCEPTION ''Materialized view % does not exist.'', matview;
    END IF;

    EXECUTE ''DROP TABLE '' || matview;
    DELETE FROM beta_version.matviews WHERE mv_name=matview;

    RETURN;
END
';

-- TEST RUN !!!
SELECT beta_version.drop_matview('beta_version.mv_configuration_events');
-- REMEBER to use quotation marks to declare names of matview and view ;) 

-- SWEET, everythign works quiet as intended, so lets continue with making the materialized view eager ...
-- Gardner explains ''An eager materialized view will be updated whenever the view changes. This is done with a system of triggers on all of the underlying tables.''

SELECT beta_version.create_matview('beta_version.mv_configuration_events', 'beta_version.view_configuration_events');

-- NOTE: information in the materialized view comes from any tables mentioned in the view definition (here, tables Cabinet, Lower House, Upper House, Presidential Election, and Veto Points);
-- NOTE further that mutiple rows in the view depend on the same row in the underlying table, such a many-to-one relationship is a tricky matter

-- the general algorithm to refresh specific rows in a matview as changes occur in an underlying table is
-- 	(a) Identify the primary key of the materialized view. If there isn't one, you must redefine the view so as to create one. The function will accept the primary key as an argument.
--	(b) In the function, first delete the row with that primary key from the materialized view.
--	(c) select the row with that primary key from the view and insert it into the materialized view.

-- so wrt to mv_configuration_events, (a) declare priamry key:
SELECT beta_version.refresh_matview('beta_version.mv_configuration_events');
ALTER TABLE beta_version.mv_configuration_events ADD PRIMARY KEY (ctr_id, sdate); -- NOTE: this could be executed inside create_matview fundtion by passign argument pkey (here, '(ctr_id, sdate)')


-- here we go, define function mv_config_ev_refresh_row

CREATE OR REPLACE FUNCTION beta_version.mv_config_ev_refresh_row(SMALLINT, DATE) 
RETURNS VOID
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
DECLARE
	country ALIAS FOR $1;
	start_date ALIAS FOR $2;
	entry beta_version.matviews%ROWTYPE;
BEGIN
	ALTER TABLE beta_version.mv_configuration_events DISABLE TRIGGER USER;
	
	DELETE FROM beta_version.mv_configuration_events 
		WHERE mv_configuration_events.ctr_id = country
		AND mv_configuration_events.sdate = start_date;
	
	INSERT INTO beta_version.mv_configuration_events 
	SELECT * 
		FROM beta_version.view_configuration_events 
		WHERE view_configuration_events.ctr_id = country 
		AND view_configuration_events.sdate = start_date;
		
	ALTER TABLE beta_version.mv_configuration_events ENABLE TRIGGER USER;	

	UPDATE beta_version.mv_configuration_events SET cab_id = cab_id, lh_id = lh_id, lhelc_id = lhelc_id, uh_id = uh_id, prselc_id = prselc_id
		WHERE mv_configuration_events.ctr_id = country 
		AND mv_configuration_events.sdate = start_date;

	UPDATE beta_version.mv_configuration_events SET edate = edate
		WHERE mv_configuration_events.ctr_id = country 
		AND mv_configuration_events.sdate = 
			(SELECT sdate FROM beta_version.mv_configuration_events
			WHERE sdate < start_date
			AND ctr_id = country
			ORDER BY ctr_id, sdate DESC
			LIMIT 1);

  RETURN;
END
';

-- TEST RUN with example row !!!
SELECT beta_version.mv_config_ev_refresh_row(99::SMALLINT, '1996-03-02'::DATE) -- works !

-- TRIGGER STRUCTURE to execute refresh of mv_configuration events

-- Suppose, the start date of a cabinet configuration is changed in table cabinet; then we want to pass OLD.sdate to delet from MV, but take NEW.sdate to insert into MV; this is problematic ! 


-- TEST RUN with deleting row from base table 
DELETE FROM beta_version.cabinet WHERE ctr_id = 1::SMALLINT AND cab_sdate = '1996-03-11'::DATE;
-- After delete, the trigger has to call mv_config_ev_refresh_row on OLD.ctr_id and OLD.cab_sdate
SELECT beta_version.mv_config_ev_refresh_row(1::SMALLINT, '1996-03-11'::DATE) -- works !

-- TEST RUN with inserting row into base table 
INSERT INTO beta_version.cabinet (cab_id, ctr_id, cab_sdate) 
VALUES ( (SELECT cab_id FROM beta_version.cabinet WHERE ctr_id = 1::SMALLINT AND cab_sdate > '1996-03-11'::DATE LIMIT 1)-1, -- selects previous ID
	1::SMALLINT, 
	'1996-03-11'::DATE);
-- After insert, the trigger has to call mv_config_ev_refresh_row on NEW.ctr_id and NEW.cab_sdate
SELECT beta_version.mv_config_ev_refresh_row(1::SMALLINT, '1996-03-11'::DATE) -- works !

-- TEST RUN with updating row in base table 
UPDATE beta_version.cabinet SET cab_sdate = '1996-03-12'::DATE WHERE ctr_id = 1::SMALLINT AND cab_sdate = '1996-03-11'::DATE;
-- After insert, the trigger has to call mv_config_ev_refresh_row such that it delets row with OLD.ctr_id and OLD.cab_sdate, and inserts row with NEW.ctr_id and NEW.cab_sdate; the conflict can be seen 
SELECT beta_version.mv_config_ev_refresh_row(1::SMALLINT, '1996-03-11'::DATE) -- this only delets old row from MV but misses new row
SELECT beta_version.mv_config_ev_refresh_row(1::SMALLINT, '1996-03-12'::DATE) -- this only insert new row to MV but fails to delet old row
-- but executing both, once with OLD and once with NEW, guarantees consistency !!!


-- cabinet trigger: on delet
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

-- TEST RUN of trigger
INSERT INTO beta_version.cabinet (cab_id, ctr_id, cab_sdate) 
VALUES ( (SELECT cab_id FROM beta_version.cabinet WHERE ctr_id = 1::SMALLINT AND cab_sdate > '1996-03-11'::DATE LIMIT 1)-1, -- selects previous ID
	1::SMALLINT, 
	'1996-03-12'::DATE);
SELECT beta_version.mv_config_ev_refresh_row(1::SMALLINT, '1996-03-12'::DATE) 
DELETE FROM beta_version.cabinet WHERE ctr_id = 1::SMALLINT AND cab_sdate = '1996-03-12'::DATE;
SELECT * FROM beta_version.mv_configuration_events WHERE ctr_id = 1::SMALLINT AND sdate = '1996-03-12'::DATE; -- works !


-- cabinet trigger: on insert
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

-- TEST RUN of trigger
INSERT INTO beta_version.cabinet (cab_id, ctr_id, cab_sdate) 
VALUES ( (SELECT cab_id FROM beta_version.cabinet WHERE ctr_id = 1::SMALLINT AND cab_sdate > '1996-03-11'::DATE LIMIT 1)-1, -- selects previous ID
	1::SMALLINT, 
	'1996-03-11'::DATE);
SELECT * FROM beta_version.mv_configuration_events WHERE ctr_id = 1::SMALLINT AND sdate = '1996-03-11'::DATE;  -- works !

-- cabinet trigger: on update of cab_id or cab_sdate
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

-- TEST RUN
--	... should trigger when cab_sdate is updated ...
UPDATE beta_version.cabinet SET cab_sdate = '1996-03-12'::DATE WHERE ctr_id = 1::SMALLINT AND cab_sdate = '1996-03-11'::DATE;
SELECT * FROM beta_version.mv_configuration_events WHERE ctr_id = 1::SMALLINT AND sdate = '1996-03-11'::DATE;  -- empty, which is intended !
SELECT * FROM beta_version.mv_configuration_events WHERE ctr_id = 1::SMALLINT AND sdate = '1996-03-12'::DATE;  -- works !

--	... should trigger when cab_id is updated ...
UPDATE beta_version.cabinet SET cab_id = 1026::NUMERIC(5,0) WHERE ctr_id = 1::SMALLINT AND cab_sdate = '1996-03-12'::DATE;
SELECT * FROM beta_version.mv_configuration_events WHERE ctr_id = 1::SMALLINT AND sdate = '1996-03-12'::DATE;  -- works !

--	... should trigger when other columns are updated ...
UPDATE beta_version.cabinet SET cab_hog_n = 'Hauke'::VARCHAR(40) WHERE ctr_id = 1::SMALLINT AND cab_sdate = '1996-03-12'::DATE;
SELECT * FROM beta_version.mv_configuration_events WHERE ctr_id = 1::SMALLINT AND sdate = '1996-03-12'::DATE;  -- works !


-- sweet trigger structure works and makes MV eeagerly respnsive to changes in underlying base tables; 
-- see file Projects/PCDB/beta_version/triggers/trg_mv_config_ev_refresh_row().sql for definition on other base tables

-- restore cabinet data  
DELETE FROM beta_version.cabinet WHERE ctr_id=1; --delete all data from table 
INSERT INTO beta_version.cabinet SELECT * FROM config_data.cabinet WHERE ctr_id=1 AND cab_sdate >= '1995-01-01'::DATE ORDER BY cab_id; 
SELECT * FROM beta_version.cabinet WHERE ctr_id=1 ORDER BY cab_id; -- visual inspection

-- implement edate trigger on mv_configuration_events from file Projects/PCDB/beta_version/triggers/trg_mv_config_ev_edate.sql
UPDATE beta_version.mv_configuration_events SET edate = edate;

-- implement corresponding ID trigger on mv_configuration_events from file Projects/PCDB/beta_version/triggers/trg_mv_config_ev_correspond_ids.sql, and check functionality: 
-- first refresh MV to restore data as in view_configuration_events,
SELECT beta_version.refresh_matview('beta_version.mv_configuration_events');
-- then update to trigger procedure 
UPDATE beta_version.mv_configuration_events SET ctr_id=ctr_id;

-- Some more TEST RUNS ...
UPDATE beta_version.cabinet SET cab_sdate = '1996-03-12'::DATE WHERE ctr_id = 1::SMALLINT AND cab_sdate = '1996-03-11'::DATE;
SELECT * FROM beta_version.mv_configuration_events WHERE ctr_id = 1::SMALLINT AND sdate <= '1996-03-12'::DATE;
-- here we can nicely see that changes in sdate propagate through to edate (as implemented by trg_mv_config_ev_edate and function mv_config_ev_refresh_row)
UPDATE beta_version.cabinet SET cab_sdate = '1996-03-11'::DATE WHERE ctr_id = 1::SMALLINT AND cab_sdate = '1996-03-12'::DATE;

SELECT * FROM beta_version.lower_house WHERE ctr_id = 1::SMALLINT;
SELECT * FROM beta_version.mv_configuration_events WHERE ctr_id = 1::SMALLINT ORDER BY sdate ASC;
UPDATE beta_version.lower_house SET lh_sdate = '1998-09-03'::DATE WHERE ctr_id = 1::SMALLINT AND lh_sdate = '1998-10-03'::DATE;
SELECT * FROM beta_version.mv_configuration_events WHERE ctr_id = 1::SMALLINT ORDER BY sdate ASC; -- propagates through to edate 
UPDATE beta_version.lower_house SET lh_sdate = '1998-10-03'::DATE WHERE ctr_id = 1::SMALLINT AND lh_sdate = '1998-09-03'::DATE;


-- changes of institution IDs in base tables also propagate through to IDs recorded in MV, as implemented by triggers on base tables executing update-function on mv_configuration_events (see Projects/PCDB/beta_version/triggers/trg_mv_config_ev_update_ids.sql)
UPDATE beta_version.cabinet SET cab_id = cab_id-1
	WHERE ctr_id = 3 
	AND cab_id = 3038;
SELECT * FROM beta_version.mv_configuration_events WHERE ctr_id = 3::SMALLINT ORDER BY sdate DESC;

UPDATE beta_version.lower_house SET lh_id = lh_id+1
	WHERE ctr_id = 1 
	AND lh_id IN (SELECT lh_id FROM beta_version.lower_house WHERE ctr_id = 1 ORDER BY lh_sdate DESC LIMIT 1);
SELECT * FROM beta_version.mv_configuration_events WHERE ctr_id = 1::SMALLINT ORDER BY sdate DESC;

UPDATE beta_version.lower_house SET lhelc_id = lhelc_id+1
	WHERE ctr_id = 1 
	AND lhelc_id = (SELECT lhelc_id FROM beta_version.lower_house WHERE ctr_id = 1 ORDER BY lh_sdate DESC LIMIT 1);
SELECT * FROM beta_version.mv_configuration_events WHERE ctr_id = 1::SMALLINT ORDER BY sdate DESC;

UPDATE beta_version.upper_house SET uh_id = uh_id+1 -- uh_id-1
	WHERE ctr_id = 1 
	AND uh_id = (SELECT uh_id FROM beta_version.upper_house WHERE ctr_id = 1 ORDER BY uh_sdate DESC LIMIT 1);
SELECT * FROM beta_version.mv_configuration_events WHERE ctr_id = 1::SMALLINT ORDER BY sdate DESC;

UPDATE beta_version.presidential_election SET prselc_id = prselc_id+1 -- prselc_id-1
	WHERE ctr_id = 17
	AND prselc_id = (SELECT prselc_id FROM beta_version.presidential_election WHERE ctr_id = 17 ORDER BY prs_sdate DESC LIMIT 1);
SELECT * FROM beta_version.mv_configuration_events WHERE ctr_id = 17::SMALLINT ORDER BY sdate DESC;


-- THE NEXT STEP is to define a country-year version of configurations
-- the view that achieves this is defined in Projects/PCDB/beta_version/views/view_configuration_ctr_yr.sql
SELECT beta_version.create_matview('beta_version.mv_configuration_ctr_yr', 'beta_version.view_configuration_ctr_yr');
SELECT beta_version.refresh_matview('beta_version.mv_configuration_ctr_yr');
ALTER TABLE beta_version.mv_configuration_ctr_yr ADD PRIMARY KEY (ctr_id, year); -- NOTE: this could be executed inside create_matview function by passing argument pkey (here, '(ctr_id, year)')

-- On insert/delete/update of basetables, trigger should execute refresh of country-year configuration MV

CREATE OR REPLACE FUNCTION beta_version.mv_config_ctr_yr_refresh_row(SMALLINT) 
RETURNS VOID
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
DECLARE
	country ALIAS FOR $1;
BEGIN	
	
	IF (year, sdate) NOT IN (SELECT DISTINCT ON (year, sdate) year, sdate FROM beta_version.mv_configuration_ctr_yr WHERE ctr_id = country) IS NOT NULL
	THEN 
		PERFORM beta_version.refresh_matview
			WHERE mv_configuration_ctr_yr.ctr_id = country
			AND mv_configuration_ctr_yr.sdate = start_date;

		INSERT INTO beta_version.mv_configuration_ctr_yr 
		SELECT * 
			FROM beta_version.view_configuration_ctr_yr
			WHERE view_configuration_ctr_yr.ctr_id = country 
			AND mv_configuration_ctr_yr.sdate = start_date;
	END IF;
  RETURN;
END
';


DELETE FROM beta_version.upper_house; --delete all data from table 
INSERT INTO beta_version.upper_house SELECT * FROM config_data.upper_house WHERE uh_sdate >= '1995-01-01'::DATE ORDER BY uh_id;

SELECT beta_version.refresh_matview('beta_version.mv_configuration_ctr_yr');

UPDATE beta_version.upper_house 
	SET uh_sdate = '2005-08-01'::DATE 
	WHERE ctr_id = 1::SMALLINT 
	AND uh_sdate = '2005-07-01'::DATE;

SELECT DISTINCT ON (ctr_id, year, sdate, cab_id, lh_id, lhelc_id, uh_id, prselc_id) *
	FROM beta_version.view_configuration_ctr_yr 
	WHERE  (ctr_id, year, sdate) 
		NOT IN (SELECT ctr_id, year, sdate FROM beta_version.mv_configuration_ctr_yr);

DROP FUNCTION IF EXISTS beta_version.refresh_mv_config_ctr_yr_row();
CREATE OR REPLACE FUNCTION beta_version.refresh_mv_config_ctr_yr_row();() RETURNS VOID AS $$
DECLARE 
	ctr_yr_id RECORD;
BEGIN
	DROP TABLE IF EXISTS temp_difference_sdate;

	CREATE TABLE temp_difference_sdate 
		AS SELECT DISTINCT ON (ctr_id, year, sdate) * 
			FROM beta_version.view_configuration_ctr_yr 
			WHERE  (ctr_id, year, sdate) 
				NOT IN (SELECT ctr_id, year, sdate FROM beta_version.mv_configuration_ctr_yr);

    FOR ctr_yr_id IN SELECT DISTINCT ON (ctr_id, year) ctr_id, year FROM temp_difference_sdate
    LOOP
	UPDATE beta_version.mv_configuration_ctr_yr 
		SET 
			sdate = (SELECT sdate FROM temp_difference_sdate WHERE (ctr_id, year) = ctr_yr_id),
			edate = (SELECT edate FROM temp_difference_sdate WHERE (ctr_id, year) = ctr_yr_id),
			cab_id = (SELECT cab_id FROM temp_difference_sdate WHERE (ctr_id, year) = ctr_yr_id),
			lh_id = (SELECT lh_id FROM temp_difference_sdate WHERE (ctr_id, year) = ctr_yr_id),
			lhelc_id = (SELECT lhelc_id FROM temp_difference_sdate WHERE (ctr_id, year) = ctr_yr_id),
			uh_id = (SELECT uh_id FROM temp_difference_sdate WHERE (ctr_id, year) = ctr_yr_id),
			prselc_id = (SELECT prselc_id FROM temp_difference_sdate WHERE (ctr_id, year) = ctr_yr_id)
		WHERE (ctr_id, year) = ctr_yr_id;
    END LOOP;

	DROP TABLE temp_difference_sdate;
	
    RETURN;
END;
$$ LANGUAGE plpgsql;

SELECT beta_version.refresh_mv_config_ctr_yr();

SELECT DISTINCT ON (ctr_id, year, sdate) * 
	FROM beta_version.view_configuration_ctr_yr 
	WHERE  (ctr_id, year, sdate) 
		NOT IN (SELECT ctr_id, year, sdate FROM beta_version.mv_configuration_ctr_yr);

DELETE FROM beta_version.upper_house; --delete all data from table 
INSERT INTO beta_version.upper_house SELECT * FROM config_data.upper_house WHERE uh_sdate >= '1995-01-01'::DATE ORDER BY uh_id;

SELECT beta_version.refresh_matview('beta_version.mv_configuration_ctr_yr');

DELETE FROM beta_version.upper_house 
	WHERE ctr_id = 1::SMALLINT; 


SELECT DISTINCT ON (ctr_id, year, sdate) * 
	FROM beta_version.view_configuration_ctr_yr 
	WHERE  (ctr_id, year, sdate) 
		NOT IN (SELECT ctr_id, year, sdate FROM beta_version.mv_configuration_ctr_yr);

SELECT beta_version.refresh_mv_config_ctr_yr();

SELECT DISTINCT ON (ctr_id, year, sdate) * 
	FROM beta_version.view_configuration_ctr_yr 
	WHERE  (ctr_id, year, sdate) 
		NOT IN (SELECT ctr_id, year, sdate FROM beta_version.mv_configuration_ctr_yr);


