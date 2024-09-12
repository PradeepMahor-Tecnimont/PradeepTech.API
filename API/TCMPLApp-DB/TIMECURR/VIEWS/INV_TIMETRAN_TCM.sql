--------------------------------------------------------
--  DDL for View INV_TIMETRAN_TCM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."INV_TIMETRAN_TCM" ("YYMM", "PROJNO", "COSTCODE", "ACTIVITY", "TICB_HRS", "SUBC_HRS") AS 
  SELECT
    a.yymm,
    a.projno,
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
 AND a.costcode <> '0217' 
  GROUP BY
    a.yymm,
    a.projno,
    a.costcode,
    a.activity
  UNION ALL
  SELECT
    "YYMM",
    "PROJNO",
    "COSTCODE",
    "ACTIVITY",
    "TICB_HRS",
    "SUBC_HRS"
  FROM
    inv_replace_217 WITH READ ONLY
;
