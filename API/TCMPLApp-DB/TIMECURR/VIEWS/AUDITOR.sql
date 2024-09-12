--------------------------------------------------------
--  DDL for View AUDITOR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."AUDITOR" ("COMPANY", "TMAGRP", "EMPTYPE", "LOCATION", "YYMM", "COSTCODE", "PROJNO", "NAME", "HOURS", "OTHOURS", "TOTHOURS") AS 
  (SELECT NVL(b.co,'NOCOMP') Company,
    NVL(b.NEWCOSTCODE,'NOGRP') TmaGrp ,
    NVL(c.emptype,'N') EmpType ,
    NVL(c.location,'X') Location,
    NVL(a.yymm,'YYMM') YYMM,
    NVL(a.costcode,'COST') Costcode,
    NVL(a.projno,'PROJ') Projno ,
    NVL(b.name,'NO NAME') Name,
    SUM(NVL(a.hours,0)) hours,
    SUM(NVL(a.othours,0)) othours,
    SUM(NVL(a.hours,0))+SUM(NVL(a.othours,0)) tothours
  FROM timetran a,
    projmast b ,
    emplmast c
  WHERE nvl(a.projno,'PROJ') = nvl(b.projno,'PROJ')
  AND nvl(a.empno,'EMP')    = nvl(c.empno,'EMP')
  GROUP BY NVL(b.co,'NOCOMP'),
    NVL(b.NEWCOSTCODE,'NOGRP'),
    NVL(c.emptype,'N'),
    NVL(c.location,'X'),
    NVL(a.yymm,'YYMM'),
    NVL(a.costcode,'COST'),
    NVL(a.projno,'PROJ'),
    NVL(b.name,'NO NAME')
  ) 

;
