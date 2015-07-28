-- NOTE: ctr_id/ccode, lh_sdate_id, lhelc_date/id, cab_sdate/id and pty_id identify unique configurations
SELECT ctr_id, ctr_ccode, -- Country
	lhelc_date, lhelc_id, -- LH election from which LH and Cab originate from
	pty_id, pty_abr, pty_lh_sts_shr, pty_lh_vts_shr, -- LH seat and vote shares of Parties participating in corresponding LH election 
	pty_cab, pty_cab_hog, cab_hog_n, cab_sdate, cab_id, -- cabinet, parties in cabinet, and party of Head of Government (HOG)
	lh_sdate, lh_id,  -- Lower House (LH), origination from corresponding LH election
	cab_prv_id, pty_prv_cab, 
	cab_nxt_id, pty_nxt_cab
FROM	
	(SELECT *
	FROM
		(SELECT *
		FROM
			(SELECT *
			FROM
				(SELECT ctr_id, ctr_ccode, pty_id, pty_abr, pty_lh_sts_shr, pty_lh_vts_shr,
					lhelc_date, lhelc_id, lhelc_prv_id, lhelc_nxt_id
					FROM config_data.view_lh_election_party_results
				) AS LHELC_RESULTS
			LEFT OUTER JOIN
				(SELECT lhelc_id, lh_id 
					FROM config_data.lower_house
				) AS LH
			USING(lhelc_id)
			) AS LHELC_RESULTS
		LEFT OUTER JOIN
			(SELECT ctr_id, lh_id, lh_sdate, cab_id, cab_sdate, pty_id, pty_cab, cab_hog_n, pty_cab_hog, cab_prv_id, cab_nxt_id	
			FROM
				(SELECT DISTINCT ctr_id, lh_id, lh_sdate, cab_id, cab_sdate, cab_hog_n 
					FROM public.configuration_detail
				) AS LH_CAB_CONFIGS
			RIGHT OUTER JOIN
				(SELECT *
				FROM
					(SELECT cab_id, cab_prv_id, cab_nxt_id
						FROM config_data.cabinet
					) AS CAB 
				RIGHT OUTER JOIN
					(SELECT cab_id, pty_id, pty_cab, pty_cab_hog 
						FROM config_data.cabinet_portfolios
					WHERE cab_id IN (SELECT DISTINCT cab_id FROM public.configuration_detail)
					-- to exclude cab_ids that are not in view configuration_detail
					) AS CAB_PORTFOLIOS
				USING(cab_id)
				) AS PTY_CAB	
			USING(cab_id)
			ORDER BY ctr_id, lh_sdate, cab_sdate, pty_id
			) AS CURRENT_LH_CAB_PTY_CONFIGS
		USING (ctr_id, lh_id, pty_id)
		) AS CURRENT_LHELC_RES_PTY_CAB_LH_CONFIGS
	LEFT OUTER JOIN
		(SELECT cab_id AS cab_prv_id, pty_id, pty_cab AS pty_prv_cab, pty_cab_hog AS pty_prv_cab_hog
			FROM config_data.cabinet_portfolios 
		) AS PRV_CAB
	USING(cab_prv_id, pty_id)
	) AS CURRENT_PRV_CONFIG
LEFT OUTER JOIN
	(SELECT cab_id AS cab_nxt_id, pty_id, pty_cab AS pty_nxt_cab, pty_cab_hog AS pty_nxt_cab_hog
		FROM config_data.cabinet_portfolios 
	) AS NEXT_CAB
USING(cab_nxt_id, pty_id)
ORDER BY ctr_id, cab_sdate, lh_sdate, lhelc_date, pty_id;

