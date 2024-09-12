--------------------------------------------------------
--  DDL for View INV_TIMETRANTCM_NEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."INV_TIMETRANTCM_NEW" ("YYMM", "PROJNO", "COSTCODE", "ACTIVITY", "TICB_HRS", "SUBC_HRS") AS 
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
  AND b.prevco           ='E'
  AND a.yymm            >='201801'
  GROUP BY
    a.yymm,
    a.projno,
    a.costcode,
    a.activity
  UNION ALL
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
  AND b.prevco          <>'E'
  GROUP BY
    a.yymm,
    a.projno,
    a.costcode,
    a.activity
WITH READ ONLY
;
