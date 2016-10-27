-- Define function REFRESH ROW OF MATERIALIZED VIEW CONFIGURATION COUNTRY-YEAR 

-- Rows in mv_configuration_ctr_yr are uniquely identified by primary key (ctr_id, year).
-- Data in mv_configuration_ctr_yr comes from tables that are mentioned in the underlying view view_configuration_ctr_yr,  which, in turn, is based on view_configuration_events (i.e., tables Cabinet, Lower House, Upper House, Presidential Election, and Veto Points)-

-- In order to execute a refresh of rows of mv_configuration_ctr_yr (triggered by insert/delete/update actions on base tables), 
--	(i) drop table, if exists, created in (ii), 
--	(ii) create table that records temporary differences/discrepancy between view and MV, rows identified by ctr_id and year,
--	(iii) for each row in table (ii) identified by ctr_id and year, update corresponding row in mv_configuration_ctr_yr,
-- 	(iv) delete table that recorded temporary differences/discrepancy
  
DROP FUNCTION IF EXISTS beta_version.refresh_mv_config_ctr_yr_row();
CREATE OR REPLACE FUNCTION beta_version.refresh_mv_config_ctr_yr_row() RETURNS VOID AS $$
DECLARE 
	ctr_yr_id RECORD;
BEGIN
	SET LOCAL client_min_messages=warning; 
	DROP TABLE IF EXISTS temp_difference;
	SET LOCAL client_min_messages=notice;
	
	CREATE TABLE temp_difference 
		AS SELECT DISTINCT ON (ctr_id, year, sdate) * 
			FROM beta_version.view_configuration_ctr_yr 
			WHERE  (ctr_id, year, sdate) 
				NOT IN (SELECT ctr_id, year, sdate FROM beta_version.mv_configuration_ctr_yr);

    FOR ctr_yr_id IN SELECT DISTINCT ON (ctr_id, year) ctr_id, year FROM temp_difference
    LOOP
	UPDATE beta_version.mv_configuration_ctr_yr 
		SET 
			sdate = (SELECT sdate FROM temp_difference WHERE (ctr_id, year) = ctr_yr_id),
			edate = (SELECT edate FROM temp_difference WHERE (ctr_id, year) = ctr_yr_id),
			cab_id = (SELECT cab_id FROM temp_difference WHERE (ctr_id, year) = ctr_yr_id),
			lh_id = (SELECT lh_id FROM temp_difference WHERE (ctr_id, year) = ctr_yr_id),
			lhelc_id = (SELECT lhelc_id FROM temp_difference WHERE (ctr_id, year) = ctr_yr_id),
			uh_id = (SELECT uh_id FROM temp_difference WHERE (ctr_id, year) = ctr_yr_id),
			prselc_id = (SELECT prselc_id FROM temp_difference WHERE (ctr_id, year) = ctr_yr_id)
		WHERE (ctr_id, year) = ctr_yr_id;
    END LOOP;

	DROP TABLE temp_difference;
	
    RETURN;
END;
$$ LANGUAGE plpgsql;
