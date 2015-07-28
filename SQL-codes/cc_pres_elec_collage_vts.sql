CREATE VIEW config_data.cc_pres_elec_collage_vts
AS
SELECT *
	FROM 
		(SELECT prselc_id, prs_cnd_pty, prselc_rnd, prs_cnd_vts_clg, prs_cnd_vts_ppl 
			FROM config_data.pres_elec_vres
		) AS PRES_ELEC_VRES
	JOIN
		(SELECT prselc_id, prselc_rnd_ttl, prselc_vts_clg, prselc_clg 
			FROM config_data.presidential_election
		) AS PRES_ELEC
	USING(prselc_id)
	WHERE prselc_clg IS FALSE 
	AND prselc_vts_clg IS NOT NULL;