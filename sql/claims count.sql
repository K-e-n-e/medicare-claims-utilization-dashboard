SELECT b.desynpuf_id_cl, b.bene_year, i.clm_yr, COALESCE(ip_cnt_clms, 0) AS ip_cnt_clms, COALESCE(op_cnt_clms, 0) AS op_cnt_clms, COALESCE(crrr_cnt_clms, 0) AS crrr_cnt_clms
FROM beneficiary_cl AS b
LEFT JOIN ip_count AS i
ON b.desynpuf_id_cl = i.desynpuf_id_cl
AND b.bene_year = i.clm_yr
LEFT JOIN op_count AS o
ON b.desynpuf_id_cl = o.desynpuf_id_cl
AND b.bene_year = o.clm_yr
LEFT JOIN carrier_count AS c
ON b.desynpuf_id_cl = c.desynpuf_id_cl
AND b.bene_year = c.clm_yr
ORDER BY 2;