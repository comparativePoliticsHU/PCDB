CREATE OR REPLACE VIEW config_data.cc_prs_sdate
AS
SELECT 'President'::TEXT AS inst_name, ctr_id, 
	prselc_id, prselc_date, prs_sdate, 
	(prs_sdate-prselc_date) as date_dif, 
	SIGN(COALESCE(prs_sdate-prselc_date, 0)) AS prob_corr_ddif
	FROM config_data.presidential_election
ORDER BY prselc_id;