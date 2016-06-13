DROP VIEW IF EXISTS public.lower_house;
CREATE VIEW public.lower_house
AS
SELECT ctr_id, ctr_ccode, lh_sdate, lh_valid_sdate, 
	lh_id, lh_prv_id, lhelc_id, 
	lh_sts_ttl::NUMERIC, lh_sts_ttl_computed::NUMERIC, 
	lh_enpp::NUMERIC(9,6), lh_enpp_minfrag::NUMERIC(9,6), lh_enpp_maxfrag::NUMERIC(9,6),
	pty_lh_rght, 
	lh_cmt, lh_src
FROM
	(SELECT ctr_id, ctr_ccode FROM config_data.country) AS COUNTRY
FULL OUTER JOIN
	(SELECT *
		FROM
			(SELECT * FROM config_data.view_lh_enpp_maxfrag) AS LH_ENPP_MAXFRAG
		FULL OUTER JOIN
			(SELECT *
			FROM
				(SELECT * FROM config_data.view_lh_enpp_minfrag) AS LH_ENPP_MINFRAG
			FULL OUTER JOIN
				(SELECT *
					FROM
						(SELECT * FROM config_data.view_lh_sts_ttl_computed) AS LH_STS_TTL_COMPUTED
					RIGHT OUTER JOIN
						(SELECT * FROM config_data.lower_house) AS LOWER_HOUSE
					USING(lh_id)
				) AS I
			USING(lh_id)
			) AS II
		USING(lh_id)
	) AS III
USING(ctr_id)
ORDER BY lh_id;
