SELECT *
FROM
	(SELECT *
	FROM
		(SELECT ctr_id, pty_id, lhelc_date, lhelc_id, lhelc_prv_id, lhelc_nxt_id
			FROM config_data.view_lh_election_party_results
		) AS LHELC_RESULTS
	RIGHT OUTER JOIN
		(SELECT lhelc_id, lh_id 
			FROM config_data.lower_house
		) AS LH
	USING(lhelc_id);
	) AS LHELC_RESULTS
,
	(SELECT *
	FROM
			(SELECT lhelc_id, lh_id 
				FROM config_data.lower_house
			) AS LH
		RIGHT OUTER JOIN
			(SELECT * 
			FROM
				(SELECT cab_id, pty_id, pty_cab 
					FROM config_data.cabinet_portfolios
				) AS PTY_CAB
			LEFT OUTER JOIN
				(SELECT ctr_id, lh_id, lh_sdate, cab_id, cab_sdate, cab_hog_n 
					FROM public.configuration_detail
				) AS CORRESP_CAB
			USING(cab_id)
			) AS CAB
		USING(lh_id)
	) AS LH_CAB
WHERE LH_CAB.ctr_id=LHELC_RESULTS.ctr_id 
AND LH_CAB.cab_sdate>LHELC_RESULTS.lhelc_date 
AND LH_CAB.lh_id=LHELC_RESULTS.lh_id;