DROP TABLE IF EXISTS dashboard_member_year;
CREATE TABLE dashboard_member_year AS
WITH base AS (
    SELECT b.*,
           DATE_PART('year', AGE(MAKE_DATE(b.bene_year, 7, 1), b.bene_birth_dt_cl))::int AS age
    FROM beneficiary_cl b
)
SELECT
    base.*,
    CASE WHEN age < 65 THEN 'Under 65'
         WHEN age < 75 THEN '65-74'
         WHEN age < 85 THEN '75-84'
         ELSE '85+' END AS age_band,
    COALESCE(medreimb_ip_cl,0) + COALESCE(medreimb_op_cl,0) + COALESCE(medreimb_car_cl,0) AS total_medicare_cost,
    (sp_alzhdmta_cl='Yes')::int + (sp_chf_cl='Yes')::int + (sp_chrnkidn_cl='Yes')::int
      + (sp_cncr_cl='Yes')::int + (sp_copd_cl='Yes')::int + (sp_depressn_cl='Yes')::int
      + (sp_diabetes_cl='Yes')::int + (sp_ischmcht_cl='Yes')::int + (sp_osteoprs_cl='Yes')::int
      + (sp_ra_oa_cl='Yes')::int + (sp_strketia_cl='Yes')::int AS chronic_count,
    COALESCE(i.ip_cnt_clms,   0) AS ip_cnt_clms,
    COALESCE(i.ip_days,       0) AS ip_days,
    COALESCE(o.op_cnt_clms,   0) AS op_cnt_clms,
    COALESCE(c.crrr_cnt_clms, 0) AS crrr_cnt_clms
FROM base
LEFT JOIN ip_count AS i
ON i.desynpuf_id_cl = base.desynpuf_id_cl AND i.clm_yr = base.bene_year
LEFT JOIN op_count AS o 
ON o.desynpuf_id_cl = base.desynpuf_id_cl AND o.clm_yr = base.bene_year
LEFT JOIN carrier_count AS c
ON c.desynpuf_id_cl = base.desynpuf_id_cl AND c.clm_yr = base.bene_year;

SELECT *
FROM dashboard_member_year;