CREATE OR REPLACE VIEW public.configuration_detail
AS 
SELECT ctr_id, ctr_ccode, year, sdate, edate, config_duration, 
	cab_id, cab_sdate, cab_hog_n, cab_care, pty_hog, cab_sts_ttl,
	lh_id, lh_sdate,
	uh_id, uh_sdate,
	prselc_id, prs_sdate, prs_n, pty_prs,
	cab_lh_sts_shr, cab_uh_sts_shr,
	vto_lh, vto_uh, vto_prs, vto_pts, vto_jud, vto_elct, vto_terr, vto_sum
FROM
	(SELECT ctr_id, ctr_ccode 
		FROM config_data.country
	) AS COUNTRY_CCODE	
RIGHT OUTER JOIN
	(SELECT *
	FROM
		(SELECT cab_id, cab_sdate, cab_hog_n, cab_care 
			FROM config_data.cabinet
		) AS HOG_NAME
	RIGHT OUTER JOIN
		(SELECT *
		FROM
			(SELECT DISTINCT cab_id, pty_id AS pty_hog 
				FROM config_data.cabinet_portfolios 
				WHERE pty_cab_hog IS TRUE
			) AS HOG_PARTY
		RIGHT OUTER JOIN
			(SELECT *
			FROM
				(SELECT lh_id, lh_sdate 
					FROM config_data.lower_house
				) AS LH_SDATE
			RIGHT OUTER JOIN
				(SELECT *
				FROM
					(SELECT uh_id, uh_sdate 	
						FROM config_data.upper_house
					) AS UH_SDATE
				RIGHT OUTER JOIN
					(SELECT *
					FROM
						(SELECT prselc_id, prs_sdate, prs_n, pty_id AS pty_prs 
							FROM config_data.presidential_election
						) AS PRESIDENT 
					RIGHT OUTER JOIN
						(SELECT * 
							FROM public.configuration
						) AS CONFIGURATIONS
					USING(prselc_id)
					) AS I
				USING(uh_id)
				) AS II
			USING(lh_id)
			) AS III
		USING(cab_id)
		) AS IV
	USING(cab_id)
	) AS V
USING(ctr_id)
WHERE cab_id IS NOT NULL 
AND lh_id IS NOT NULL 
AND sdate IS NOT NULL 
ORDER BY ctr_id, sdate;