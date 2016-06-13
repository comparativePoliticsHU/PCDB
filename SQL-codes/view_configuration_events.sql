CREATE OR REPLACE VIEW config_data.view_configuration_events
AS
SELECT DISTINCT ctr_id, sdate, cab_id, lh_id, lhelc_id, uh_id, prselc_id, 
	DATE_PART('year', sdate)::NUMERIC AS year, NULL::DATE AS edate
	FROM
		(SELECT prselc_id, prs_sdate AS sdate, ctr_id 
			FROM config_data.presidential_election
		) AS PRES_ELEC
	RIGHT OUTER JOIN
		(SELECT *
			FROM
				(SELECT uh_id, uh_sdate AS sdate, ctr_id 
					FROM config_data.upper_house
				) AS UH
			RIGHT OUTER JOIN 
				(SELECT *
					FROM
						(SELECT lh_id, lh_sdate AS sdate, lhelc_id, ctr_id 
							FROM config_data.lower_house
						) AS LH
					RIGHT OUTER JOIN
						(SELECT *
							FROM
								(SELECT cab_id, cab_sdate AS sdate, ctr_id 
									FROM config_data.cabinet
								) AS CAB
							RIGHT OUTER JOIN
								(
								SELECT cab_sdate AS sdate, ctr_id 
									FROM config_data.cabinet
								UNION
								SELECT lh_sdate AS sdate, ctr_id 
									FROM config_data.lower_house
								UNION
								SELECT uh_sdate AS sdate, ctr_id 
									FROM config_data.upper_house
								UNION
								SELECT prs_sdate AS sdate, ctr_id 
									FROM config_data.presidential_election
								ORDER BY ctr_id, sdate NULLS FIRST
								) AS START_DATES
							USING(ctr_id, sdate)
						) AS CAB_JOIN
					USING(ctr_id, sdate)
				) AS LH_JOIN
			USING(ctr_id, sdate)
		) AS UH_JOIN
	USING(ctr_id, sdate)
ORDER BY ctr_id, sdate;
