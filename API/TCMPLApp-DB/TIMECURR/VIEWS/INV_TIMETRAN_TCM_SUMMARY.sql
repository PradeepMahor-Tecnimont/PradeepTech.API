--------------------------------------------------------
--  DDL for View INV_TIMETRAN_TCM_SUMMARY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."INV_TIMETRAN_TCM_SUMMARY" ("PROJNO", "COSTCODE", "TICBHRS", "SUBCHRS") AS 
  SELECT
    projno,
    costcode,
    SUM(NVL(ticb_hrs,0)) AS ticbhrs,
    SUM(NVL(subc_hrs,0)) AS subchrs
  FROM
    inv_timetran_tcm2
  WHERE
    yymm >='201904' AND yymm <='202003'
  GROUP BY
    projno,
    costcode
;
