CREATE OR REPLACE VIEW config_data.view_lhelc_reg_vts_computed
AS
SELECT lhelc_id, ctr_id, lhelc_date, lhelc_reg_vts,
(COALESCE(lhelc_reg_vts_pr,0)+COALESCE(lhelc_reg_vts_pl,0)) AS lhelc_reg_vts_computed
FROM config_data.lh_election 
ORDER BY ctr_id, lhelc_date;
