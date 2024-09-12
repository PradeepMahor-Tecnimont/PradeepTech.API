--------------------------------------------------------
--  DDL for View INV_REPLACE_217
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."INV_REPLACE_217" ("YYMM", "PROJNO", "COSTCODE", "ACTIVITY", "TICB_HRS", "SUBC_HRS") AS 
  SELECT
    a.yymm,
    SUBSTR(a.projno,1,5)||'08' as projno,
    a.costcode,
    a.activity,
    SUM(a.ticb_hrs) AS ticb_hrs,
    SUM(a.subc_hrs) AS subc_hrs
  FROM
    inv_timetran a,
    projmast b
    WHERE
    a.projno             = b.projno
  AND NVL(b.tcm_jobs,0)  > 0
  AND NVL(b.reimb_job,0) > 0
  AND yymm              >='201904'
  AND yymm              <='202003'
 AND a.costcode = '0217' 
      GROUP BY
    a.yymm,
    SUBSTR(a.projno,1,5)||'08',
    a.costcode,
    a.activity
;
