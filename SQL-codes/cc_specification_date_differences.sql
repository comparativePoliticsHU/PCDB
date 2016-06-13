CREATE OR REPLACE VIEW config_data.cc_specifaction_date_differences 
AS
SELECT 'Cabinet'::TEXT AS inst_name,
	SUM(date_dif)/COUNT(cab_id) AS mean_date_dif, 
	ROUND(median(date_dif)) AS median_date_dif, 
	SUM(prob_corr_ddif) AS nr_date_difs_recorded, 
	COUNT(cab_id) as N,
	'all measures of date difference (%date_dif%) in days; note that cabinets 
	are assumed to formate from elections of the legislature'::TEXT AS comment
	FROM config_data.cc_cab_sdate
UNION
SELECT 'Lower House'::TEXT AS inst_name, 
	SUM(date_dif)/COUNT(lh_id) AS mean_date_dif, 
	ROUND(median(date_dif)) AS median_date_dif, 
	SUM(prob_corr_ddif) AS nr_date_difs_recorded, 
	COUNT(lh_id) as N, 
	'all measures of date difference (%date_dif%) in days'::TEXT AS comment
	FROM config_data.cc_lh_sdate
UNION
SELECT 'Upper House'::TEXT AS inst_name, 
	SUM(date_dif)/COUNT(uh_id) AS mean_date_dif, 
	ROUND(median(date_dif)) AS median_date_dif, 
	SUM(prob_corr_ddif) AS nr_date_difs_recorded, 
	COUNT(uh_id) as N,
	'all measures of date difference (%date_dif%) in days'::TEXT AS comment
	FROM config_data.cc_uh_sdate
UNION	
SELECT 'President'::TEXT AS inst_name, 
	SUM(date_dif)/COUNT(prselc_id) AS mean_date_dif, 
	ROUND(median(date_dif)) AS median_date_dif,
	SUM(prob_corr_ddif) AS nr_date_difs_recorded, 
	COUNT(prselc_id) as N,
	'all measures of date difference (%date_dif%) in days'::TEXT AS comment
	FROM config_data.cc_prs_sdate;