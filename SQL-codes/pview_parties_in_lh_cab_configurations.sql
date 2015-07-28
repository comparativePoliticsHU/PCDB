CREATE OR REPLACE VIEW public.parties_in_lh_cab_configurations
AS 
SELECT ctr_id, ctr_ccode, 
	cab_sdate, cab_hog_n, cab_id, 
	lh_sdate, lh_id,  
	lhelc_date, lhelc_id,
	pty_abr, pty_id, pty_lh_sts_shr, pty_lh_vts_shr, 
	pty_cab, pty_cab_hog,
	cab_prv_id, pty_prv_cab, pty_prv_cab_hog, 
	cab_nxt_id, pty_nxt_cab, pty_nxt_cab_hog 
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
			(SELECT ctr_id, lh_id, lh_sdate, cab_id, cab_sdate, pty_id, pty_cab, 
				cab_hog_n, pty_cab_hog, cab_prv_id, cab_nxt_id	
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
							WHERE cab_id 
								IN 
								(SELECT DISTINCT cab_id 
									FROM public.configuration_detail
								)
							) AS CAB_PORTFOLIOS
						USING(cab_id)
					) AS PTY_CAB	
				USING(cab_id)
				ORDER BY ctr_id, lh_sdate, cab_sdate, pty_id
			) AS CURRENT_LH_CAB_PTY_CONFIGS
		USING (ctr_id, lh_id, pty_id)
		) AS CURRENT_LHELC_RES_PTY_CAB_LH_CONFIGS
	LEFT OUTER JOIN
		(SELECT cab_id AS cab_prv_id, pty_id, 
		pty_cab AS pty_prv_cab, 
		pty_cab_hog AS pty_prv_cab_hog
			FROM config_data.cabinet_portfolios 
		) AS PRV_CAB
	USING(cab_prv_id, pty_id)
	) AS CURRENT_PRV_CONFIG
LEFT OUTER JOIN
	(SELECT cab_id AS cab_nxt_id, pty_id, 
		pty_cab AS pty_nxt_cab, 
		pty_cab_hog AS pty_nxt_cab_hog
		FROM config_data.cabinet_portfolios 
	) AS NEXT_CAB
USING(cab_nxt_id, pty_id)
ORDER BY ctr_id, cab_sdate, lh_sdate, lhelc_date, pty_id;

