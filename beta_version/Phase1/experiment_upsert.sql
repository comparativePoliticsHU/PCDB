

DROP TABLE IF EXISTS beta_version.update_presidency;
CREATE TABLE beta_version.update_presidency (
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


-- insert data manually for the moment
SELECT * FROM beta_version.update_presidency;

INSERT INTO beta_version.update_presidency (prselc_id, ctr_id, prselc_date, prs_sdate, prs_n, prs_src) VALUES (9014, 9, '2016-07-31'::Date, '2016-08-31'::Date, 'Hauke Licht'::name, 'Imagination'::text);
DELETE FROM beta_version.update_presidency WHERE prselc_id = 9014;

SELECT beta_version.upsert_base_table('beta_version','presidential_election','update_presidency');

SELECT prselc_id, prselc_date, prs_sdate, prs_n, prs_src FROM beta_version.presidential_election WHERE ctr_id =9;
SELECT prselc_id, prselc_date, prs_sdate, prs_n, prs_src FROM beta_version.update_presidency WHERE ctr_id =9;

SELECT beta_version.upsert_base_table('beta_version','presidential_election','update_presidency');

SELECT prselc_id, prselc_date, prs_sdate, prs_n, prs_src FROM beta_version.presidential_election WHERE ctr_id =9;
-- apparently update works, but insert does not 

-- try with cabinet table instead
CREATE TABLE beta_version.update_cabinet (LIKE config_data.cabinet);
DELETE FROM beta_version.update_cabinet; --delete all data from table 
-- insert all cabinet configurations for Austria 
INSERT INTO beta_version.update_cabinet SELECT * FROM config_data.cabinet WHERE ctr_id = 1 ORDER BY cab_id; -- insert subset of data into table
SELECT * FROM beta_version.update_cabinet; -- visual inspection

-- apply update function
SELECT beta_version.upsert_base_table('beta_version','cabinet','update_cabinet');
SELECT * FROM beta_version.cabinet; -- visual inspection -- works nicely 
DELETE FROM beta_version.cabinet; --delete all data from table 
INSERT INTO beta_version.cabinet SELECT * FROM config_data.cabinet ORDER BY cab_id; -- insert subset of data into table