--------------------------------------------------------
--  DDL for View FINANCE_TS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."FINANCE_TS" ("EMPTYPE", "EMPNO", "NAME", "PROJNO", "YYMM", "COSTCODE", "PARENT", "HOURS", "OTHOURS") AS 
  (SELECT c.emptype ,
    A.empNo ,
    C.NAME ,
    a.projno,
    a.yymm,
    a.costcode,
    a.parent,
    SUM(NVL(a.hours,0))  Hours,
   SUM(NVL(a.othours,0)) Othours
  FROM timetran a,
    emplmast c
  WHERE a.empno = (c.empno)
  GROUP BY c.emptype,
    A.empNO ,
    C.NAME,
a.projno,
    a.yymm,
    a.costcode,
    a.parent
  )
;
