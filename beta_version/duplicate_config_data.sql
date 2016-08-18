
CREATE TABLE IF NOT EXISTS beta_version.country (LIKE config_data.country INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.country; --delete all data from table 
INSERT INTO beta_version.country SELECT * FROM config_data.country ORDER BY ctr_id; -- insert subset of data into table
SELECT * FROM beta_version.country; -- visual inspection

CREATE TABLE IF NOT EXISTS beta_version.cabinet (LIKE config_data.cabinet INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.cabinet; --delete all data from table 
INSERT INTO beta_version.cabinet SELECT * FROM config_data.cabinet ORDER BY cab_id; -- insert subset of data into table
SELECT * FROM beta_version.cabinet; -- visual inspection

CREATE TABLE IF NOT EXISTS beta_version.cabinet_portfolios (LIKE config_data.cabinet_portfolios INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.cabinet_portfolios; --delete all data from table 
INSERT INTO beta_version.cabinet_portfolios SELECT * FROM config_data.cabinet_portfolios ORDER BY cab_id, pty_id; -- insert subset of data into table
SELECT * FROM beta_version.cabinet_portfolios; -- visual inspection

CREATE TABLE IF NOT EXISTS beta_version.lower_house (LIKE config_data.lower_house INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.lower_house; --delete all data from table 
INSERT INTO beta_version.lower_house SELECT * FROM config_data.lower_house ORDER BY lh_id; -- insert subset of data into table
SELECT * FROM beta_version.lower_house; -- visual inspection

CREATE TABLE IF NOT EXISTS beta_version.lh_election (LIKE config_data.lh_election INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.lh_election; --delete all data from table 
INSERT INTO beta_version.lh_election SELECT * FROM config_data.lh_election ORDER BY lhelc_id; -- insert subset of data into table
SELECT * FROM beta_version.lh_election; -- visual inspection


CREATE TABLE IF NOT EXISTS beta_version.lh_seat_results (LIKE config_data.lh_seat_results INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.lh_seat_results; --delete all data from table 
INSERT INTO beta_version.lh_seat_results SELECT * FROM config_data.lh_seat_results ORDER BY lh_id, lhsres_id; -- insert subset of data into table
SELECT * FROM beta_version.lh_seat_results; -- visual inspection

CREATE TABLE IF NOT EXISTS beta_version.lh_vote_results (LIKE config_data.lh_vote_results INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.lh_vote_results; --delete all data from table 
INSERT INTO beta_version.lh_vote_results SELECT * FROM config_data.lh_vote_results ORDER BY lhelc_id, lhvres_id; -- insert subset of data into table
SELECT * FROM beta_version.lh_vote_results; -- visual inspection

CREATE TABLE IF NOT EXISTS beta_version.upper_house (LIKE config_data.upper_house INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.upper_house; --delete all data from table 
INSERT INTO beta_version.upper_house SELECT * FROM config_data.upper_house ORDER BY uh_id; -- insert subset of data into table
SELECT * FROM beta_version.upper_house; -- visual inspection

CREATE TABLE IF NOT EXISTS beta_version.uh_seat_results (LIKE config_data.uh_seat_results INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.uh_seat_results; --delete all data from table 
INSERT INTO beta_version.uh_seat_results SELECT * FROM config_data.uh_seat_results ORDER BY uh_id, uhsres_id; -- insert subset of data into table
SELECT * FROM beta_version.uh_seat_results; -- visual inspection

CREATE TABLE IF NOT EXISTS beta_version.presidential_election (LIKE config_data.presidential_election INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.presidential_election; --delete all data from table 
INSERT INTO beta_version.presidential_election SELECT * FROM config_data.presidential_election ORDER BY prselc_id; -- insert subset of data into table
SELECT * FROM beta_version.presidential_election; -- visual inspection

CREATE TABLE IF NOT EXISTS beta_version.veto_points (LIKE config_data.veto_points INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.veto_points; --delete all data from table 
INSERT INTO beta_version.veto_points SELECT * FROM config_data.veto_points;
SELECT * FROM beta_version.veto_points; -- visual inspection

CREATE TABLE IF NOT EXISTS beta_version.party (LIKE config_data.party INCLUDING ALL); -- duplicate table structure 
DELETE FROM beta_version.party; --delete all data from table 
INSERT INTO beta_version.party SELECT * FROM config_data.party;
SELECT * FROM beta_version.party; -- visual inspection
