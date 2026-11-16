WITH ip AS(
SELECT desynpuf_id_cl, EXTRACT(YEAR FROM clm_thru_dt_cl) AS clm_yr, COUNT(DISTINCT clm_id_cl) AS clm_cnt
FROM inpatient_cl
GROUP BY 1, 2
)

SELECT 
b.bene_year,
COUNT (*) AS no_of_bene,
SUM(COALESCE(ip.clm_cnt, 0)) AS no_of_adm,
ROUND(SUM(COALESCE(ip.clm_cnt, 0))/COUNT (*), 2) AS adm_per_1000_mem
FROM beneficiary_cl AS b
LEFT JOIN ip
ON b.desynpuf_id_cl = ip.desynpuf_id_cl
AND b.bene_year = ip.clm_yr
GROUP BY b.bene_year
ORDER BY b.bene_year;

