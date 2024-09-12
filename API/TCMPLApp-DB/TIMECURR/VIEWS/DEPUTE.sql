--------------------------------------------------------
--  DDL for View DEPUTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."DEPUTE" ("COMP", "YYMM", "COSTCODE", "EMPNO", "NAME", "PARENT", "PROJNO", "HOURS", "OTHOURS", "TOTHRS") AS 
  (
select c.comp,a.yymm,a.costcode,a.empno,b.name,b.parent,a.projno ,
sum(nvl(a.hours,0)) Hours ,sum(nvl(a.othours,0)) Othours,
sum(nvl(a.hours,0))+sum(nvl(a.othours,0)) TotHrs
from timetran a, emplmast b , costmast c
where a.empno = b.empno
and b.parent = c.costcode
and a.costcode in ('0236','0238')
and a.yymm  >= '201004'
group by c.comp,a.yymm,a.costcode,a.empno,b.name,b.parent,a.projno
)

;
