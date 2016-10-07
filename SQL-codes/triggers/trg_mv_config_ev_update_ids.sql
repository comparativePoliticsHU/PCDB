-- Define function UPDATE IDs IN MATERIALIZED CONFIGURATON EVENTS 
-- Define triggers that UPDATE IDs IN MATERIALIZED CONFIGURATON EVENTS on change on base tables

-- the structure A is the following:
-- 	(1) define function that takes new and old ID as arguments, and sets ID to new ID in rows where it has been old ID;
--	(2) define trigger that executes the function defined under (1), passing in OLD.* and NEW.* value according to update's stored values

-- define structure A on all base tables

-- cabinet ID 
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_ut_cab_id(NUMERIC(5,0), NUMERIC(5,0)) 
RETURNS VOID
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
DECLARE
	old_cab_id ALIAS FOR $1;
	new_cab_id ALIAS FOR $2;
BEGIN
	ALTER TABLE config_data.mv_configuration_events DISABLE TRIGGER USER;
	
	UPDATE config_data.mv_configuration_events 
		SET cab_id = new_cab_id
		WHERE cab_id = old_cab_id;
			
	ALTER TABLE config_data.mv_configuration_events ENABLE TRIGGER USER;	

  RETURN;
END
';

CREATE OR REPLACE FUNCTION config_data.mv_config_ev_cab_id_ut_trg()
RETURNS trigger 
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_ut_cab_id(OLD.cab_id, NEW.cab_id);
	RETURN NULL;
END';

DROP TRIGGER IF EXISTS mv_config_ev_cab_id_ut_trg ON config_data.cabinet;
CREATE TRIGGER mv_config_ev_cab_id_ut_trg
  AFTER UPDATE OF cab_id ON config_data.cabinet
  FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_cab_id_ut_trg();


CREATE OR REPLACE FUNCTION config_data.mv_config_ev_dt_cab_id(NUMERIC(5,0)) 
RETURNS VOID
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
DECLARE
	old_cab_id ALIAS FOR $1;
BEGIN
	ALTER TABLE config_data.mv_configuration_events DISABLE TRIGGER USER;

		UPDATE config_data.mv_configuration_events 
			SET cab_id = NULL
			WHERE cab_id = old_cab_id;

	ALTER TABLE config_data.mv_configuration_events ENABLE TRIGGER USER;	

  RETURN;
END
';

CREATE OR REPLACE FUNCTION config_data.mv_config_ev_cab_id_dt_trg()
RETURNS trigger 
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_dt_cab_id(OLD.cab_id);
	RETURN NULL;
END';

DROP TRIGGER IF EXISTS mv_config_ev_cab_id_dt_trg ON config_data.cabinet;
CREATE TRIGGER mv_config_ev_cab_id_dt_trg
  AFTER DELETE ON config_data.cabinet
  FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_cab_id_dt_trg();


CREATE OR REPLACE FUNCTION config_data.mv_config_ev_cab_id_it_trg()
RETURNS trigger 
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	EXECUTE ''UPDATE config_data.mv_configuration_events SET cab_id = cab_id'';
	RETURN NULL;
END';

DROP TRIGGER IF EXISTS mv_config_ev_cab_id_it_trg ON config_data.cabinet;
CREATE TRIGGER mv_config_ev_cab_id_it_trg
  AFTER INSERT ON config_data.cabinet
  FOR EACH STATEMENT EXECUTE PROCEDURE config_data.mv_config_ev_cab_id_it_trg();

-- lower house ID 
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_ut_lh_id(NUMERIC(5,0), NUMERIC(5,0)) 
RETURNS VOID
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
DECLARE
	old_lh_id ALIAS FOR $1;
	new_lh_id ALIAS FOR $2;
BEGIN
	ALTER TABLE config_data.mv_configuration_events DISABLE TRIGGER USER;
	
	UPDATE config_data.mv_configuration_events 
		SET lh_id = new_lh_id
		WHERE lh_id = old_lh_id;
			
	ALTER TABLE config_data.mv_configuration_events ENABLE TRIGGER USER;	

  RETURN;
END
';

CREATE OR REPLACE FUNCTION config_data.mv_config_ev_lh_id_ut_trg()
RETURNS trigger 
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_ut_lh_id(OLD.lh_id, NEW.lh_id);
	RETURN NULL;
END';

DROP TRIGGER IF EXISTS mv_config_ev_lh_id_ut_trg ON config_data.lower_house;
CREATE TRIGGER mv_config_ev_lh_id_ut_trg
  AFTER UPDATE OF lh_id ON config_data.lower_house
  FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_lh_id_ut_trg();


CREATE OR REPLACE FUNCTION config_data.mv_config_ev_dt_lh_id(NUMERIC(5,0)) 
RETURNS VOID
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
DECLARE
	old_lh_id ALIAS FOR $1;
BEGIN
	ALTER TABLE config_data.mv_configuration_events DISABLE TRIGGER USER;

		UPDATE config_data.mv_configuration_events 
			SET lh_id = NULL
			WHERE lh_id = old_lh_id;

	ALTER TABLE config_data.mv_configuration_events ENABLE TRIGGER USER;	

  RETURN;
END
';

CREATE OR REPLACE FUNCTION config_data.mv_config_ev_lh_id_dt_trg()
RETURNS trigger 
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_dt_lh_id(OLD.lh_id);
	RETURN NULL;
END';

DROP TRIGGER IF EXISTS mv_config_ev_lh_id_dt_trg ON config_data.lower_house;
CREATE TRIGGER mv_config_ev_lh_id_dt_trg
  AFTER DELETE ON config_data.lower_house
  FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_lh_id_dt_trg();


CREATE OR REPLACE FUNCTION config_data.mv_config_ev_lh_id_it_trg()
RETURNS trigger 
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	EXECUTE ''UPDATE config_data.mv_configuration_events SET lh_id = lh_id'';
	RETURN NULL;
END';

DROP TRIGGER IF EXISTS mv_config_ev_lh_id_it_trg ON config_data.lower_house;
CREATE TRIGGER mv_config_ev_lh_id_it_trg
  AFTER INSERT ON config_data.lower_house
  FOR EACH STATEMENT EXECUTE PROCEDURE config_data.mv_config_ev_lh_id_it_trg();


-- lower house election ID 
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_ut_lhelc_id(NUMERIC(5,0), NUMERIC(5,0)) 
RETURNS VOID
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
DECLARE
	old_lhelc_id ALIAS FOR $1;
	new_lhelc_id ALIAS FOR $2;
BEGIN
	ALTER TABLE config_data.mv_configuration_events DISABLE TRIGGER USER;
	
	UPDATE config_data.mv_configuration_events 
		SET lhelc_id = new_lhelc_id
		WHERE lhelc_id = old_lhelc_id;
			
	ALTER TABLE config_data.mv_configuration_events ENABLE TRIGGER USER;	

  RETURN;
END
';

CREATE OR REPLACE FUNCTION config_data.mv_config_ev_lhelc_id_ut_trg()
RETURNS trigger 
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_ut_lhelc_id(OLD.lhelc_id, NEW.lhelc_id);
	RETURN NULL;
END';

DROP TRIGGER IF EXISTS mv_config_ev_lhelc_id_ut_trg ON config_data.lower_house;
CREATE TRIGGER mv_config_ev_lhelc_id_ut_trg
  AFTER UPDATE OF lhelc_id ON config_data.lower_house
  FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_lhelc_id_ut_trg();
-- exectued when the election ID that is recorded as corresponding to a lower house configuration changes

CREATE OR REPLACE FUNCTION config_data.mv_config_ev_dt_lhelc_id(NUMERIC(5,0)) 
RETURNS VOID
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
DECLARE
	old_lhelc_id ALIAS FOR $1;
BEGIN
	ALTER TABLE config_data.mv_configuration_events DISABLE TRIGGER USER;

		UPDATE config_data.mv_configuration_events 
			SET lhelc_id = NULL
			WHERE lhelc_id = old_lhelc_id;

	ALTER TABLE config_data.mv_configuration_events ENABLE TRIGGER USER;	

  RETURN;
END
';

CREATE OR REPLACE FUNCTION config_data.mv_config_ev_lhelc_id_dt_trg()
RETURNS trigger 
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_dt_lhelc_id(OLD.lhelc_id);
	RETURN NULL;
END';

DROP TRIGGER IF EXISTS mv_config_ev_lhelc_id_dt_trg ON config_data.lower_house;
CREATE TRIGGER mv_config_ev_lhelc_id_dt_trg
  AFTER DELETE ON config_data.lower_house
  FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_lhelc_id_dt_trg();


CREATE OR REPLACE FUNCTION config_data.mv_config_ev_lhelc_id_it_trg()
RETURNS trigger 
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	EXECUTE ''UPDATE config_data.mv_configuration_events SET lhelc_id = lhelc_id'';
	RETURN NULL;
END';

DROP TRIGGER IF EXISTS mv_config_ev_lhelc_id_it_trg ON config_data.lower_house;
CREATE TRIGGER mv_config_ev_lhelc_id_it_trg
  AFTER INSERT ON config_data.lower_house
  FOR EACH STATEMENT EXECUTE PROCEDURE config_data.mv_config_ev_lhelc_id_it_trg();

-- upper house ID 
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_ut_uh_id(NUMERIC(5,0), NUMERIC(5,0)) 
RETURNS VOID
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
DECLARE
	old_uh_id ALIAS FOR $1;
	new_uh_id ALIAS FOR $2;
BEGIN
	ALTER TABLE config_data.mv_configuration_events DISABLE TRIGGER USER;

		UPDATE config_data.mv_configuration_events 
			SET uh_id = new_uh_id
			WHERE uh_id = old_uh_id;

	ALTER TABLE config_data.mv_configuration_events ENABLE TRIGGER USER;	

  RETURN;
END
';

CREATE OR REPLACE FUNCTION config_data.mv_config_ev_uh_id_ut_trg()
RETURNS trigger 
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_ut_uh_id(OLD.uh_id, NEW.uh_id);
	RETURN NULL;
END';

DROP TRIGGER IF EXISTS mv_config_ev_uh_id_ut_trg ON config_data.upper_house;
CREATE TRIGGER mv_config_ev_uh_id_ut_trg
  AFTER UPDATE OF uh_id ON config_data.upper_house
  FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_uh_id_ut_trg();



CREATE OR REPLACE FUNCTION config_data.mv_config_ev_dt_uh_id(NUMERIC(5,0)) 
RETURNS VOID
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
DECLARE
	old_uh_id ALIAS FOR $1;
BEGIN
	ALTER TABLE config_data.mv_configuration_events DISABLE TRIGGER USER;

		UPDATE config_data.mv_configuration_events 
			SET uh_id = NULL
			WHERE uh_id = old_uh_id;

	ALTER TABLE config_data.mv_configuration_events ENABLE TRIGGER USER;	

  RETURN;
END
';

CREATE OR REPLACE FUNCTION config_data.mv_config_ev_uh_id_dt_trg()
RETURNS trigger 
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_dt_uh_id(OLD.uh_id);
	RETURN NULL;
END';

DROP TRIGGER IF EXISTS mv_config_ev_uh_id_dt_trg ON config_data.upper_house;
CREATE TRIGGER mv_config_ev_uh_id_dt_trg
  AFTER DELETE ON config_data.upper_house
  FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_uh_id_dt_trg();


CREATE OR REPLACE FUNCTION config_data.mv_config_ev_uh_id_it_trg()
RETURNS trigger 
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	EXECUTE ''UPDATE config_data.mv_configuration_events SET uh_id = uh_id'';
	RETURN NULL;
END';

DROP TRIGGER IF EXISTS mv_config_ev_uh_id_it_trg ON config_data.upper_house;
CREATE TRIGGER mv_config_ev_uh_id_it_trg
  AFTER INSERT ON config_data.upper_house
  FOR EACH STATEMENT EXECUTE PROCEDURE config_data.mv_config_ev_uh_id_it_trg();



-- presidential election ID 
CREATE OR REPLACE FUNCTION config_data.mv_config_ev_ut_prselc_id(NUMERIC(5,0), NUMERIC(5,0)) 
RETURNS VOID
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
DECLARE
	old_prselc_id ALIAS FOR $1;
	new_prselc_id ALIAS FOR $2;
BEGIN
	ALTER TABLE config_data.mv_configuration_events DISABLE TRIGGER USER;
	
	UPDATE config_data.mv_configuration_events 
		SET prselc_id = new_prselc_id
		WHERE prselc_id = old_prselc_id;
			
	ALTER TABLE config_data.mv_configuration_events ENABLE TRIGGER USER;	

  RETURN;
END
';

CREATE OR REPLACE FUNCTION config_data.mv_config_ev_prselc_id_ut_trg()
RETURNS trigger 
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_ut_prselc_id(OLD.prselc_id, NEW.prselc_id);
	RETURN NULL;
END';

DROP TRIGGER IF EXISTS mv_config_ev_prselc_id_ut_trg ON config_data.presidential_election;
CREATE TRIGGER mv_config_ev_prselc_id_ut_trg
  AFTER UPDATE OF prselc_id ON config_data.presidential_election
  FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_prselc_id_ut_trg();


CREATE OR REPLACE FUNCTION config_data.mv_config_ev_dt_prselc_id(NUMERIC(5,0)) 
RETURNS VOID
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
DECLARE
	old_prselc_id ALIAS FOR $1;
BEGIN
	ALTER TABLE config_data.mv_configuration_events DISABLE TRIGGER USER;

		UPDATE config_data.mv_configuration_events 
			SET prselc_id = NULL
			WHERE prselc_id = old_prselc_id;

	ALTER TABLE config_data.mv_configuration_events ENABLE TRIGGER USER;	

  RETURN;
END
';

CREATE OR REPLACE FUNCTION config_data.mv_config_ev_prselc_id_dt_trg()
RETURNS trigger 
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	PERFORM config_data.mv_config_ev_dt_prselc_id(OLD.prselc_id);
	RETURN NULL;
END';

DROP TRIGGER IF EXISTS mv_config_ev_prselc_id_dt_trg ON config_data.presidential_election;
CREATE TRIGGER mv_config_ev_prselc_id_dt_trg
  AFTER DELETE ON config_data.presidential_election
  FOR EACH ROW EXECUTE PROCEDURE config_data.mv_config_ev_prselc_id_dt_trg();


CREATE OR REPLACE FUNCTION config_data.mv_config_ev_prselc_id_it_trg()
RETURNS trigger 
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
BEGIN
	EXECUTE ''UPDATE config_data.mv_configuration_events SET prselc_id = prselc_id'';
	RETURN NULL;
END';

DROP TRIGGER IF EXISTS mv_config_ev_prselc_id_it_trg ON config_data.presidential_election;
CREATE TRIGGER mv_config_ev_prselc_id_it_trg
  AFTER INSERT ON config_data.presidential_election
  FOR EACH STATEMENT EXECUTE PROCEDURE config_data.mv_config_ev_prselc_id_it_trg();
