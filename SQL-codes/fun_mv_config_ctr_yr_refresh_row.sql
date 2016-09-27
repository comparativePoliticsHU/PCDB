-- Define function REFRESH ROW OF MATERIALIZED VIEW CONFIGURATION COUNTRY-YEAR 

-- Rows in mv_configuration_ctr_yr are uniquely identified by primary key (ctr_id, year).
-- Data in mv_configuration_ctr_yr comes from mv_configuration_events, which is defnied on tables Cabinet, Lower House, Upper House, Presidential Election, and Veto Points

-- In order to execute a refresh of rows of mv_configuration_ctr_yr (triggered by insert/delete/update actions on base tables), 
--	(i) row identified by ctr_id and year (defined as arguments to function) is deleted from MV,
--	(ii) row identified by ctr_id and year (defined as arguments to function) is inserted to MV from underlying view view_configuration_ctr_yr,
  

CREATE OR REPLACE FUNCTION config_data.mv_config_ctr_yr_refresh_row(SMALLINT, NUMERIC, DATE) 
RETURNS VOID
SECURITY DEFINER
LANGUAGE 'plpgsql' AS '
DECLARE
	country ALIAS FOR $1;
	in_year ALIAS FOR $2;
	start_date ALIAS FOR $3;
	entry config_data.matviews%ROWTYPE;
BEGIN	
	DELETE FROM config_data.mv_configuration_ctr_yr 
		WHERE mv_configuration_ctr_yr.ctr_id = country
		AND (mv_configuration_ctr_yr.year = in_year OR mv_configuration_ctr_yr.sdate = start_date);
	
	INSERT INTO config_data.mv_configuration_ctr_yr 
	SELECT * 
		FROM config_data.view_configuration_ctr_yr
		WHERE view_configuration_ctr_yr.ctr_id = country 
		AND (view_configuration_ctr_yr.year = in_year OR mv_configuration_ctr_yr.sdate = start_date);
  RETURN;
END
';



