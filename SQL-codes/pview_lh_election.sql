CREATE OR REPLACE VIEW public.lh_election
AS
SELECT lhelc_id, lhelc_prv_id, ctr_id, 
	lhelc_date, lhelc_early, lhelc_valid_date,
	lhelc_reg_vts, lhelc_reg_vts_pr , lhelc_reg_vts_pl, 
	lhelc_vts_pr, lhelc_vts_pl, 
	lhelc_sts_pl, lhelc_sts_pr, lhelc_sts_ttl, 
	lhelc_fml_t1, lhelc_ncst_t1, lhelc_sts_t1,
	lhelc_dstr_mag, lhelc_dstr_mag_med, 
	lhelc_esys_cmt, lhelc_esys_src, lhelc_cmt, 
	lhelc_src,
	lhelc_lsq, lhelc_lsq_computed::NUMERIC(7,5), lhelc_lsq_noothers_computed::NUMERIC(7,5),
	lhelc_vola_sts_computed::NUMERIC(7,5), lhelc_volb_sts_computed::NUMERIC(7,5), 
	lhelc_vola_vts_computed::NUMERIC(7,5), lhelc_volb_vts_computed::NUMERIC(7,5),
	lhelc_eff_thrshld_lijphart1994::NUMERIC, lhelc_eff_thrshld_taagepera2002::NUMERIC, lhelc_eff_thrshld_pcdb::NUMERIC
FROM
	(SELECT * FROM
		(SELECT * FROM config_data.view_lhelc_volb_vts) AS VOLB_VTS
	JOIN
		(SELECT * FROM
			(SELECT * FROM config_data.view_lhelc_vola_vts) AS VOLA_VTS
		JOIN
			(SELECT * FROM
				(SELECT * FROM config_data.view_lhelc_volb_sts) AS VOLB_STS
			JOIN
				(SELECT * FROM
					(SELECT * FROM config_data.view_lhelc_vola_sts) AS VOLA_STS
				JOIN
					(SELECT * FROM
						(SELECT * FROM config_data.view_lhelc_lsq_noothers) AS LSQ_NOOTHERS
					JOIN
						(SELECT * FROM
							(SELECT * FROM config_data.view_lhelc_lsq) AS LSQ
						JOIN
							(SELECT * FROM
								(SELECT lhelc_id, lhelc_eff_thrshld_lijphart1994, 
									lhelc_eff_thrshld_taagepera2002, lhelc_eff_thrshld_pcdb 
									FROM config_data.view_lhelc_eff_thrshlds
								) AS EFF_THRSHLDS
							JOIN
								(SELECT lhelc_id, lhelc_prv_id, ctr_id, 
									lhelc_date, lhelc_early, lhelc_valid_date,
									lhelc_reg_vts, lhelc_reg_vts_pr , lhelc_reg_vts_pl, 
									lhelc_vts_pr, lhelc_vts_pl, 
									lhelc_sts_pl, lhelc_sts_pr, lhelc_sts_ttl, 
									lhelc_fml_t1, lhelc_ncst_t1, lhelc_sts_t1,
									lhelc_dstr_mag, lhelc_dstr_mag_med, 
									lhelc_esys_cmt, lhelc_esys_src, lhelc_cmt, 
									lhelc_src,
									lhelc_lsq
									FROM config_data.lh_election
								) AS LH_ELECTION
							USING(lhelc_id)
							) AS A
						USING(lhelc_id)
						) AS B
						USING(lhelc_id)
					) AS C
					USING(lhelc_id)
				) AS D
				USING(lhelc_id)
			) AS E
			USING(lhelc_id)
		) AS F
		USING(lhelc_id)
	) AS G;