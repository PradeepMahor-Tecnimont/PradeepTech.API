--------------------------------------------------------
--  DDL for View PROCO_TS_ACT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PROCO_TS_ACT" ("EMPTYPE", "EMPNO", "NAME", "PROJNO", "YYMM", "COSTCODE", "ACTIVITY", "HOURS", "OTHOURS", "TOTHOURS") AS 
  (SELECT c.emptype ,
    A.empNo ,
    C.NAME ,
    a.projno,
    a.yymm,
    a.costcode,
    A.ACTIVITY,
    SUM(NVL(a.hours,0))  Hours,
   SUM(NVL(a.othours,0)) Othours,
   SUM(NVL(a.hours,0))+SUM(NVL(a.othours,0)) TOThours
  FROM timetran a,
    emplmast c
  WHERE a.empno = (c.empno)
  GROUP BY c.emptype,
    A.empNO ,
    C.NAME,
a.projno,
    a.yymm,
    a.costcode,
    A.ACTIVITY
  )
;
