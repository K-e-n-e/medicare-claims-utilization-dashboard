DROP VIEW IF EXISTS PMPM;
CREATE VIEW PMPM AS 
SELECT
bene_year,
SUM(COALESCE(medreimb_ip_cl, 0)) AS sum_ip_cost,
SUM(COALESCE(medreimb_op_cl, 0) + COALESCE(medreimb_car_cl, 0)) AS sum_op_car_cost,
SUM(COALESCE(bene_hi_cvrage_tot_mons_cl, 0)) AS part_a_member_months,
SUM(COALESCE(bene_smi_cvrage_tot_mons_cl, 0)) AS part_b_member_months,
ROUND(SUM(COALESCE(medreimb_ip_cl, 0)) / NULLIF(SUM(COALESCE(bene_hi_cvrage_tot_mons_cl, 0)), 0), 2) AS medicare_ip_cost_pmpm,
ROUND((SUM(COALESCE(medreimb_op_cl, 0)) + SUM(COALESCE(medreimb_car_cl, 0))) / NULLIF(SUM(COALESCE(bene_smi_cvrage_tot_mons_cl, 0)), 0), 2) AS medicare_op_cost_pmpm
FROM beneficiary_cl
GROUP BY bene_year
ORDER BY bene_year;

SELECT *
FROM PMPM;

