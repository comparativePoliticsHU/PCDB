CREATE OR REPLACE VIEW config_data.view_lhelc_eff_thrshlds
AS
SELECT lhelc_id, ctr_id, lhelc_date, lhelc_sts_ttl, lhelc_dstr_mag,
	((0.5/(lhelc_dstr_mag+1)) + 
	 (0.5/(2*lhelc_dstr_mag))
	)::NUMERIC(7,5) AS lhelc_eff_thrshld_lijphart1994,
	(0.75/(((lhelc_dstr_mag*lhelc_sts_ttl)^0.25)^2 +
	       (lhelc_sts_ttl/((lhelc_dstr_mag*lhelc_sts_ttl)^0.25)^2))
	)::NUMERIC(7,5) AS lhelc_eff_thrshld_taagepera2002,
	(0.75/((lhelc_dstr_mag+1)*(lhelc_sts_ttl/lhelc_dstr_mag)^0.5)
	)::NUMERIC(7,5) AS lhelc_eff_thrshld_pcdb 
	FROM config_data.lh_election
ORDER BY lhelc_id, ctr_id, lhelc_date NULLS FIRST;