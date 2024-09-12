--------------------------------------------------------
--  DDL for View TCM_REIMB_WP2
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TCM_REIMB_WP2" ("PROJNO", "COSTCODE", "YYMM", "PROJNAME", "EMPNO", "NAME", "HOURS", "OTHOURS", "TOTHOURS") AS 
  (SELECT a.projno,
    a.costcode,
    a.yymm,
    b.name projname,
    a.empno,
    c.name,
    SUM(a.hours) hours,
    SUM(a.othours) othours,
    SUM(a.hours) + SUM(a.othours) tothours
  FROM timetran a,
    projmast b ,
    emplmast c
  WHERE a.projno  = b.projno
  AND a.empno     = c.empno
  AND a.wpcode    = '2'
  AND b.tcm_jobs  = 1
  AND b.reimb_job = 1
  GROUP BY a.projno,
    a.costcode,
    a.yymm,
    a.empno,
    c.name,
    b.name
  )

;
