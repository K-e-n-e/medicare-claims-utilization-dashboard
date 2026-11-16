DROP VIEW IF EXISTS beneficiary_total_cl;
DROP VIEW IF EXISTS beneficiary_cl;
DROP TABLE IF EXISTS ref_states;

CREATE TABLE ref_states (
sp_state_code  INT PRIMARY KEY,
state_name  TEXT
);

INSERT INTO ref_states 
(sp_state_code, state_name)
VALUES
('01', 	'Alabama'),
('02',	'Alaska'),
('03', 	'Arizona'),
('04', 	'Arkansas'),
('05', 	'California'),
('06', 'Colorado'),
('07', 	'Connecticut'),
('08', 	'Delaware'),
('09', 	'District of Columbia'),
('10', 	'Florida'),
('11', 	'Georgia'),
('12', 	'Hawaii'),
('13', 	'Idaho'),
('14', 	'Illinois'),
('15', 	'Indiana'),
('16', 	'Iowa'),
('17', 	'Kansas'),
('18', 	'Kentucky'),
('19', 	'Louisiana'),
('20', 	'Maine'),
('21', 	'Maryland'),
('22', 	'Massachusetts'),
('23', 	'Michigan'),
('24', 	'Minnesota'),
('25', 	'Mississippi'),
('26', 	'Missouri'),
('27', 	'Montana'),
('28', 	'Nebraska'),
('29', 	'Nevada'),
('30', 	'New Hampshire'),
('31', 	'New Jersey'),
('32', 	'New Mexico'),
('33', 	'New York'),
('34', 	'North Carolina'),
('35', 	'North Dakota'),
('36', 	'Ohio'),
('37', 	'Oklahoma'),
('38', 	'Oregon'),
('39', 	'Pennsylvania'),
('40', 	'Puerto Rico'),
('41', 	'Rhode Island'),
('42', 	'South Carolina'),
('43', 	'South Dakota'),
('44', 	'Tennessee'),
('45', 	'Texas'),
('46', 	'Utah'),
('47', 	'Vermont'),
('48', 	'Virgin Islands'),
('49', 	'Virginia'),
('50', 	'Washington'),
('51', 	'West Virginia'),
('52', 	'Wisconsin'),
('53', 	'Wyoming'),
('54', 	'Others');



CREATE VIEW beneficiary_cl AS

WITH beneficiary_2008_2009_2010 AS (
SELECT 2008 AS bene_year, *
FROM beneficiary_2008
UNION ALL 
SELECT 2009 AS bene_year, * 
FROM beneficiary_2009
UNION ALL
SELECT 2010 AS bene_year, *
FROM beneficiary_2010
),

beneficiary_2008_2009_2010_partclean AS (
SELECT 
bene_year,
TRIM (desynpuf_id) AS desynpuf_id_cl,
TRIM(bene_birth_dt):: date AS bene_birth_dt_cl, 
TRIM(bene_death_dt):: date AS bene_death_dt_cl,
CASE WHEN bene_sex_ident_cd = '1' THEN 'Male'
ELSE 'Female'
END AS bene_sex_ident_cd_cl,
CASE WHEN bene_race_cd = '1' THEN 'White'
WHEN bene_race_cd = '2' THEN 'Black'
WHEN bene_race_cd = '3' THEN 'Others'
ELSE 'Hispanic'
END AS bene_race_cd_cl,
CASE WHEN bene_esrd_ind = '0' THEN 'No'
ELSE 'Yes'
END AS bene_esrd_ind_cl,
TRIM(sp_state_code)::int AS sp_state_code_cl,
TRIM(bene_county_cd)::int AS bene_county_cd_cl,
TRIM(bene_hi_cvrage_tot_mons)::int AS bene_hi_cvrage_tot_mons_cl,
TRIM(bene_smi_cvrage_tot_mons)::int AS bene_smi_cvrage_tot_mons_cl,
TRIM(bene_hmo_cvrage_tot_mons)::int AS bene_hmo_cvrage_tot_mons_cl,
TRIM(plan_cvrg_mos_num)::int AS plan_cvrage_mos_num_cl,
CASE WHEN sp_alzhdmta = '1' THEN 'Yes'
ELSE 'No'
END AS sp_alzhdmta_cl,
CASE WHEN sp_chf = '1' THEN 'Yes'
ELSE 'No'
END AS sp_chf_cl,
CASE WHEN sp_chrnkidn = '1' THEN 'Yes'
ELSE 'No'
END AS sp_chrnkidn_cl,
CASE WHEN sp_cncr = '1' THEN 'Yes'
ELSE 'No'
END AS sp_cncr_cl,
CASE WHEN sp_copd = '1' THEN 'Yes'
ELSE 'No'
END AS sp_copd_cl,
CASE WHEN sp_depressn = '1' THEN 'Yes'
ELSE 'No'
END AS sp_depressn_cl,
CASE WHEN sp_diabetes = '1' THEN 'Yes'
ELSE 'No'
END AS sp_diabetes_cl,
CASE WHEN sp_ischmcht = '1' THEN 'Yes'
ELSE 'No'
END AS sp_ischmcht_cl,
CASE WHEN sp_osteoprs = '1' THEN 'Yes'
ELSE 'No'
END AS sp_osteoprs_cl,
CASE WHEN sp_ra_oa = '1' THEN 'Yes'
ELSE 'No'
END AS sp_ra_oa_cl,
CASE WHEN sp_strketia = '1' THEN 'Yes'
ELSE 'No'
END AS sp_strketia_cl,
TRIM(medreimb_ip)::numeric AS medreimb_ip_cl,
TRIM(benres_ip)::numeric AS benres_ip_cl,
TRIM(pppymt_ip)::numeric AS pppymt_ip_cl,
TRIM(medreimb_op)::numeric AS medreimb_op_cl,
TRIM(benres_op)::numeric AS benres_op_cl,
TRIM(pppymt_op)::numeric AS pppymt_op_cl,
TRIM(medreimb_car)::numeric AS medreimb_car_cl,
TRIM(benres_car)::numeric AS benres_car_cl,
TRIM(pppymt_car)::numeric AS pppymt_car_cl
FROM beneficiary_2008_2009_2010
),

beneficiary_cl AS(
SELECT * 
FROM beneficiary_2008_2009_2010_partclean
LEFT JOIN
ref_states
ON beneficiary_2008_2009_2010_partclean.sp_state_code_cl = ref_states.sp_state_code
)


SELECT COALESCE(medreimb_ip_cl, 0) + COALESCE(medreimb_op_cl, 0) + COALESCE(medreimb_car_cl, 0) AS total_medicare_paid,
COALESCE(benres_ip_cl, 0) + COALESCE(benres_op_cl, 0) + COALESCE(benres_car_cl, 0) AS total_patient_paid,
COALESCE(pppymt_ip_cl, 0) + COALESCE(pppymt_op_cl, 0) + COALESCE(pppymt_car_cl, 0) AS total_other_insurer_paid, *
FROM beneficiary_cl;

