DROP VIEW IF EXISTS op_count;
DROP VIEW IF EXISTS outpatient_claims_half2;
DROP VIEW IF EXISTS outpatient_claims_half1;
CREATE VIEW outpatient_claims_half1 AS
SELECT 
TRIM(desynpuf_id) AS desynpuf_id_cl,
TRIM(clm_id) AS clm_id_cl,
TRIM(segment)::int AS segment_cl,
TRIM(clm_from_dt)::date AS clm_from_dt_cl,
TRIM(clm_thru_dt)::date AS clm_thru_dt_cl,
TRIM(prvdr_num) AS prvdr_num_cl,
TRIM(clm_pmt_amt)::numeric AS clm_pmt_amt_cl,
TRIM(nch_prmry_pyr_clm_pd_amt)::numeric AS nch_prmry_pyr_clm_pd_amt_cl,
TRIM(at_physn_npi)::bigint AS at_physn_npi_cl,
TRIM(op_physn_npi)::bigint AS op_physn_npi_cl,
TRIM(ot_physn_npi)::bigint AS ot_physn_npi_cl,
TRIM(nch_bene_blood_ddctbl_lblty_am)::numeric AS nch_bene_blood_ddctbl_lblty_am_cl
FROM outpatient_claims;

SELECT string_agg('TRIM(' || column_name || ') AS ' || column_name,
                  E',\n    ' ORDER BY ordinal_position) AS column_list
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name ='outpatient_claims'
AND ordinal_position BETWEEN 13 AND 76;


CREATE VIEW outpatient_claims_half2 AS
SELECT
TRIM(desynpuf_id) AS desynpuf_id_cl,
TRIM(icd9_dgns_cd_1) AS icd9_dgns_cd_1,
    TRIM(icd9_dgns_cd_2) AS icd9_dgns_cd_2,
    TRIM(icd9_dgns_cd_3) AS icd9_dgns_cd_3,
    TRIM(icd9_dgns_cd_4) AS icd9_dgns_cd_4,
    TRIM(icd9_dgns_cd_5) AS icd9_dgns_cd_5,
    TRIM(icd9_dgns_cd_6) AS icd9_dgns_cd_6,
    TRIM(icd9_dgns_cd_7) AS icd9_dgns_cd_7,
    TRIM(icd9_dgns_cd_8) AS icd9_dgns_cd_8,
    TRIM(icd9_dgns_cd_9) AS icd9_dgns_cd_9,
    TRIM(icd9_dgns_cd_10) AS icd9_dgns_cd_10,
    TRIM(icd9_prcdr_cd_1) AS icd9_prcdr_cd_1,
    TRIM(icd9_prcdr_cd_2) AS icd9_prcdr_cd_2,
    TRIM(icd9_prcdr_cd_3) AS icd9_prcdr_cd_3,
    TRIM(icd9_prcdr_cd_4) AS icd9_prcdr_cd_4,
    TRIM(icd9_prcdr_cd_5) AS icd9_prcdr_cd_5,
    TRIM(icd9_prcdr_cd_6) AS icd9_prcdr_cd_6,
    TRIM(nch_bene_ptb_ddctbl_amt) AS nch_bene_ptb_ddctbl_amt,
    TRIM(nch_bene_ptb_coinsrnc_amt) AS nch_bene_ptb_coinsrnc_amt,
    TRIM(admtng_icd9_dgns_cd) AS admtng_icd9_dgns_cd,
    TRIM(hcpcs_cd_1) AS hcpcs_cd_1,
    TRIM(hcpcs_cd_2) AS hcpcs_cd_2,
    TRIM(hcpcs_cd_3) AS hcpcs_cd_3,
    TRIM(hcpcs_cd_4) AS hcpcs_cd_4,
    TRIM(hcpcs_cd_5) AS hcpcs_cd_5,
    TRIM(hcpcs_cd_6) AS hcpcs_cd_6,
    TRIM(hcpcs_cd_7) AS hcpcs_cd_7,
    TRIM(hcpcs_cd_8) AS hcpcs_cd_8,
    TRIM(hcpcs_cd_9) AS hcpcs_cd_9,
    TRIM(hcpcs_cd_10) AS hcpcs_cd_10,
    TRIM(hcpcs_cd_11) AS hcpcs_cd_11,
    TRIM(hcpcs_cd_12) AS hcpcs_cd_12,
    TRIM(hcpcs_cd_13) AS hcpcs_cd_13,
    TRIM(hcpcs_cd_14) AS hcpcs_cd_14,
    TRIM(hcpcs_cd_15) AS hcpcs_cd_15,
    TRIM(hcpcs_cd_16) AS hcpcs_cd_16,
    TRIM(hcpcs_cd_17) AS hcpcs_cd_17,
    TRIM(hcpcs_cd_18) AS hcpcs_cd_18,
    TRIM(hcpcs_cd_19) AS hcpcs_cd_19,
    TRIM(hcpcs_cd_20) AS hcpcs_cd_20,
    TRIM(hcpcs_cd_21) AS hcpcs_cd_21,
    TRIM(hcpcs_cd_22) AS hcpcs_cd_22,
    TRIM(hcpcs_cd_23) AS hcpcs_cd_23,
    TRIM(hcpcs_cd_24) AS hcpcs_cd_24,
    TRIM(hcpcs_cd_25) AS hcpcs_cd_25,
    TRIM(hcpcs_cd_26) AS hcpcs_cd_26,
    TRIM(hcpcs_cd_27) AS hcpcs_cd_27,
    TRIM(hcpcs_cd_28) AS hcpcs_cd_28,
    TRIM(hcpcs_cd_29) AS hcpcs_cd_29,
    TRIM(hcpcs_cd_30) AS hcpcs_cd_30,
    TRIM(hcpcs_cd_31) AS hcpcs_cd_31,
    TRIM(hcpcs_cd_32) AS hcpcs_cd_32,
    TRIM(hcpcs_cd_33) AS hcpcs_cd_33,
    TRIM(hcpcs_cd_34) AS hcpcs_cd_34,
    TRIM(hcpcs_cd_35) AS hcpcs_cd_35,
    TRIM(hcpcs_cd_36) AS hcpcs_cd_36,
    TRIM(hcpcs_cd_37) AS hcpcs_cd_37,
    TRIM(hcpcs_cd_38) AS hcpcs_cd_38,
    TRIM(hcpcs_cd_39) AS hcpcs_cd_39,
    TRIM(hcpcs_cd_40) AS hcpcs_cd_40,
    TRIM(hcpcs_cd_41) AS hcpcs_cd_41,
    TRIM(hcpcs_cd_42) AS hcpcs_cd_42,
    TRIM(hcpcs_cd_43) AS hcpcs_cd_43,
    TRIM(hcpcs_cd_44) AS hcpcs_cd_44,
    TRIM(hcpcs_cd_45) AS hcpcs_cd_45
	FROM outpatient_claims;

CREATE VIEW outpatient_cl AS 
SELECT *
FROM outpatient_claims_half1
FULL OUTER JOIN outpatient_claims_half2
USING(desynpuf_id_cl);


CREATE VIEW op_count AS
SELECT desynpuf_id_cl, EXTRACT (YEAR FROM clm_thru_dt_cl) AS clm_yr, COUNT(clm_id_cl) AS op_cnt_clms
FROM outpatient_claims_half1
GROUP BY 1, 2
ORDER BY 2;