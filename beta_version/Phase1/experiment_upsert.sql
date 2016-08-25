CREATE SCHEMA IF NOT EXISTS update;

DROP TABLE IF EXISTS update.presidential_election;
CREATE TABLE update.presidential_election (
	prselc_id	numeric(5,0)	not null	,
	ctr_id		smallint	,
	prs_n		name	, 
	prselc_date	date	,
	prs_sdate	date	, 
	date_dif	integer	,
	prs_valid_sdate	boolean	,
	prs_src		text	, 
	prs_comment	text);

DELETE FROM beta_version.presidential_election; --delete all data from table 
INSERT INTO beta_version.presidential_election SELECT * FROM config_data.presidential_election WHERE prs_sdate >= '1995-01-01'::DATE ORDER BY prselc_id; -- insert subset of data into table
SELECT * FROM beta_version.presidential_election; -- visual inspection

DELETE FROM update.presidential_election;
-- insert data manually for the moment
SELECT * FROM update.presidential_election;
Update update.presidential_election SET prselc_date = prselc_date - interval '100 year' WHERE prselc_date > '2040-01-01'::DATE;
Update update.presidential_election SET prs_sdate = prs_sdate - interval '100 year' WHERE prs_sdate > '2040-01-01'::DATE;

INSERT INTO update.presidential_election 
	(prselc_id, ctr_id, prselc_date, prs_sdate, prs_n, prs_src) 
	VALUES (9014, 9, '2016-07-31'::DATE, '2016-08-31'::DATE, 'Hauke Licht'::NAME, 'test upsert function'::TEXT);

SELECT upsert_base_table('beta_version','presidential_election','update','presidential_election');

SELECT prselc_id, prselc_date, prs_sdate, prs_n, prs_src FROM beta_version.presidential_election WHERE ctr_id = 9;

DELETE FROM update.presidential_election WHERE prselc_id = 9014;

SELECT upsert_base_table('beta_version','presidential_election','update','presidential_election');

SELECT prselc_id, prselc_date, prs_sdate, prs_n, prs_src FROM beta_version.presidential_election WHERE ctr_id =9;

SELECT prselc_id, prselc_date, prs_sdate, prs_n, prs_src FROM update.presidential_election WHERE ctr_id =9;
-- apparently update and insert works, but not delete

-- try with cabinet table instead
CREATE TABLE update.cabinet (LIKE config_data.cabinet);
DELETE FROM update.cabinet; --delete all data from table 
-- insert all cabinet configurations for Austria 
INSERT INTO update.cabinet
	SELECT * FROM config_data.cabinet 
	WHERE ctr_id = 1 
	ORDER BY cab_id; -- insert subset of data into table
SELECT * FROM update.cabinet; -- visual inspection

-- apply update function
SELECT upsert_base_table('beta_version','cabinet','update','cabinet');
SELECT * FROM beta_version.cabinet; -- visual inspection -- works nicely 
DELETE FROM beta_version.cabinet; --delete all data from table 
INSERT INTO beta_version.cabinet SELECT * FROM config_data.cabinet ORDER BY cab_id; -- insert subset of data into table