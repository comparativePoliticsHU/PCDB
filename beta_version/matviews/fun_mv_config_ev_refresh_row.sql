-- Define function REFRESH ROW OF MATERIALIZED VIEW CONFIGURATION EVENTS 

-- Rows in mv_configuration_events are uniquely identified by primary key (ctr_id, sdate).
-- Data in mv_configuration_events comes from tables that are mentioned in the underly the definition of view_configuration events (i.e., tables Cabinet, Lower House, Upper House, Presidential Election, and Veto Points)-

-- In order to execute a refresh of rows of mv_configuration_events (triggered by insert/delete/update actions on base tables), 
--	(i) all triggers on MV are disabled, 
--	(ii) row identified by ctr_id and sdate (defined as arguments to function) is deletedfrom MV,
--	(iii) row identified by ctr_id and sdate (defined as arguments to function) is inserted to MV from underlying view view_configuration_events,
--	(iv) all triggers on MV are enabled, 
-- 	(v) columns containing corresponding IDs of institions in mv_configuration_events are updated in order to trigger trg_mv_config_ev_correspond_ids, and 
--	(vi) column containing end date of given configuration is updated where date is younger then recently refreshed row (for odler start and end dates will not be affected by refresh) 
  

CREATE OR REPLACE FUNCTION beta_version.mv_config_ev_refresh_row(SMALLINT, DATE) 
RETURNS VOID
SECURITY DEFINER
LANGUAGE 'plpgsql' AS $$
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

	UPDATE beta_version.mv_configuration_events 
		SET cab_id = cab_id, 
		    lh_id = lh_id, 
		    lhelc_id = lhelc_id, 
		    uh_id = uh_id, 
		    prselc_id = prselc_id
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
END $$;
