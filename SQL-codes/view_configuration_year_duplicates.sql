CREATE OR REPLACE VIEW config_data.view_configuration_year_duplicates
AS
SELECT DISTINCT ctr_id, in_year,
		sdate, edate,
		DATE_PART('year', sdate)::INT AS start_in_year, 
		DATE_PART('year', edate)::INT AS end_in_year,
		NULL::INT AS config_duration_in_year
FROM
(SELECT ctr_id, sdate, edate, DATE_PART('year', sdate)::INT AS in_year
	FROM config_data.mv_configuration_events
	WHERE DATE_PART('year', sdate)::INT = DATE_PART('year', edate)::INT
UNION
SELECT ctr_id, sdate, edate, DATE_PART('year', sdate)::INT AS in_year
	FROM config_data.mv_configuration_events
	WHERE DATE_PART('year', sdate)::INT = (DATE_PART('year', edate)::INT)-1
UNION
SELECT ctr_id, sdate, edate, DATE_PART('year', sdate)::INT AS in_year
	FROM config_data.mv_configuration_events
	WHERE DATE_PART('year', sdate)::INT < (DATE_PART('year', edate)::INT)-1
UNION
SELECT ctr_id, sdate, edate, DATE_PART('year', sdate)::INT+1 AS in_year
	FROM config_data.mv_configuration_events
	WHERE DATE_PART('year', sdate)::INT = (DATE_PART('year', edate)::INT)-1
UNION
SELECT ctr_id, sdate, edate, DATE_PART('year', sdate)::INT+1 AS in_year
	FROM config_data.mv_configuration_events
	WHERE DATE_PART('year', sdate)::INT < (DATE_PART('year', edate)::INT)-1
UNION 
SELECT ctr_id, sdate, edate, DATE_PART('year', sdate)::INT+2 AS in_year
	FROM config_data.mv_configuration_events
	WHERE DATE_PART('year', sdate)::INT < (DATE_PART('year', edate)::INT)-2
UNION 
SELECT ctr_id, sdate, edate, DATE_PART('year', sdate)::INT+3 AS in_year
	FROM config_data.mv_configuration_events
	WHERE DATE_PART('year', sdate)::INT < (DATE_PART('year', edate)::INT)-3
UNION 
SELECT ctr_id, sdate, edate, DATE_PART('year', sdate)::INT+4 AS in_year
	FROM config_data.mv_configuration_events
	WHERE DATE_PART('year', sdate)::INT < (DATE_PART('year', edate)::INT)-4 
UNION 
SELECT ctr_id, sdate, edate, DATE_PART('year', sdate)::INT+5 AS in_year
	FROM config_data.mv_configuration_events
	WHERE DATE_PART('year', sdate)::INT < (DATE_PART('year', edate)::INT)-5
UNION 
SELECT ctr_id, sdate, edate, DATE_PART('year', sdate)::INT+6 AS in_year
	FROM config_data.mv_configuration_events
	WHERE DATE_PART('year', sdate)::INT < (DATE_PART('year', edate)::INT)-6
UNION 
SELECT ctr_id, sdate, edate, DATE_PART('year', sdate)::INT+7 AS in_year
	FROM config_data.mv_configuration_events
	WHERE DATE_PART('year', sdate)::INT < (DATE_PART('year', edate)::INT)-7
UNION 
SELECT ctr_id, sdate, edate, DATE_PART('year', sdate)::INT+8 AS in_year
	FROM config_data.mv_configuration_events
	WHERE DATE_PART('year', sdate)::INT < (DATE_PART('year', edate)::INT)-8
UNION	
SELECT ctr_id, sdate, edate, DATE_PART('year', edate)::INT AS in_year
	FROM config_data.mv_configuration_events 
) AS CONFIG_YEAR_DUPLICATES
WHERE in_year IS NOT NULL
ORDER BY ctr_id, in_year, sdate;

-- the weakness of this procedure is that if a configuration durateed more than 10 years, only 10 are recorded.
