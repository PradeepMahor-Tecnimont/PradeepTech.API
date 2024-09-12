--------------------------------------------------------
--  DDL for View PROJHRS_OTBREAKUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PROJHRS_OTBREAKUP" ("PROJNO", "YYMM", "COSTCODE", "EMPNO", "NAME", "HOURS", "OTHOURS") AS 
  (select a.projno,a.yymm,a.costcode,a.empno,b.name,sum(nvl(a.hours,0)) as hours,sum(nvl(a.othours,0)) as othours from timetran a,emplmast b where a.empno = b.empno
  group by a.projno,a.yymm,a.costcode,a.empno,b.name)

;
