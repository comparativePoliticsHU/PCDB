CREATE OR REPLACE VIEW public.configuration
AS
SELECT ctr_id, sdate, edate, cab_id, lh_id, lhelc_id, uh_id, prselc_id, 
	cab_sts_ttl::NUMERIC, 
	cab_lh_sts_shr::NUMERIC(7,5), cab_uh_sts_shr::NUMERIC(7,5),
	vto_lh, vto_uh, vto_prs, vto_pts, vto_jud, vto_elct, vto_terr,
	(COALESCE(vto_lh,0)+COALESCE(vto_uh,0)+COALESCE(vto_prs,0)+
		COALESCE(vto_jud,0)+COALESCE(vto_elct,0)+COALESCE(vto_terr,0)
	)::NUMERIC AS vto_sum, 
	year, (edate-sdate)::NUMERIC AS config_duration
FROM
	(SELECT cab_id, cab_sts_ttl_computed AS cab_sts_ttl 
		FROM config_data.view_cab_sts_ttl
	) AS CAB_STS_TTL
FULL OUTER JOIN
	(SELECT * FROM
		(SELECT ctr_id, sdate, cab_uh_sts_shr 
			FROM config_data.view_cab_uh_sts_shr
		) AS CAB_UH_STS_SHR
	FULL OUTER JOIN
		(SELECT * FROM
			(SELECT ctr_id, sdate, cab_lh_sts_shr 
				FROM config_data.view_cab_lh_sts_shr
			) AS CAB_LH_STS_SHR
		FULL OUTER JOIN
			(SELECT * FROM
				(SELECT ctr_id, sdate, vto_terr 
					FROM config_data.view_configuration_vto_terr
				) AS VTO_TERR	
			FULL OUTER JOIN
				(SELECT *
				FROM
					(SELECT ctr_id, sdate, vto_elct 
						FROM config_data.view_configuration_vto_elct
					) AS VTO_ELCT	
				FULL OUTER JOIN
					(SELECT *
					FROM
						(SELECT ctr_id, sdate, vto_jud 
							FROM config_data.view_configuration_vto_jud
						) AS VTO_JUD	
					FULL OUTER JOIN
						(SELECT *
						FROM
							(SELECT ctr_id, sdate, vto_pts 
								FROM config_data.view_configuration_vto_pts
							) AS VTO_PTS
						FULL OUTER JOIN
							(SELECT *
							FROM
								(SELECT ctr_id, sdate, vto_prs 
									FROM config_data.view_configuration_vto_prs
								) AS VTO_PRS
							FULL OUTER JOIN
								(SELECT *
								FROM
									(SELECT ctr_id, sdate, vto_uh 
										FROM config_data.view_configuration_vto_uh
									) AS VTO_UH
								FULL OUTER JOIN
									(SELECT *
									FROM
										(SELECT ctr_id, sdate, vto_lh 
											FROM config_data.view_configuration_vto_lh
										) AS VTO_LH
									FULL OUTER JOIN
										(SELECT ctr_id, sdate, edate, cab_id, lh_id, lhelc_id, uh_id, prselc_id, year 
											FROM config_data.mv_configuration_events
										) AS CONFIG_EVENTS
									USING(ctr_id, sdate)
									) AS CONFIG_LH
								USING(ctr_id, sdate)
								) AS CONFIG_LH_UH
							USING(ctr_id, sdate)
							) AS CONFIG_LH_UH_PRS
						USING(ctr_id, sdate)
						) AS CONFIG_LH_UH_PRS_PTS
					USING(ctr_id, sdate)
					) AS CONFIG_LH_UH_PRS_PTS_JUD
				USING(ctr_id, sdate)
				) AS CONFIG_LH_UH_PRS_PTS_JUD_ELCT
			USING(ctr_id, sdate)
			) AS CONFIG_LH_UH_PRS_PTS_JUD_ELCT_CLH_SSHR
		USING(ctr_id, sdate)
		) AS CONFIG_LH_UH_PRS_PTS_JUD_ELCT_CLH_SSHR_CUH_SSHR
	USING(ctr_id, sdate)
	) AS CONFIG_LH_UH_PRS_PTS_JUD_ELCT_CLH_SSHR_CUH_SSHR_CAB_STTL
USING(cab_id)
ORDER BY ctr_id, sdate; 