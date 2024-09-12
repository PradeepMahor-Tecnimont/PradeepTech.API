--------------------------------------------------------
--  DDL for View BREAKUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."BREAKUP" ("YYMM", "CO", "COSTCODE", "NEWCOSTCODE", "NAME", "projno", "HOURS", "OTHOURS") AS 
  (select a.yymm,b.co,a.costcode,b.newcostcode,c.tmagroupdesc name,a.projno,sum(nvl(a.hours,0)) hours,
sum(nvl(a.othours,0))
 othours from timetran a,projmast b, job_tmagroup c
 where
 a.projno = b.projno
and
b.newcostcode = c.tmagroup
group by a.yymm,b.co,a.costcode,b.newcostcode,c.tmagroupdesc,a.projno)
;
