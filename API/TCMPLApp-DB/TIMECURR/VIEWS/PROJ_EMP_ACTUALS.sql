--------------------------------------------------------
--  DDL for View PROJ_EMP_ACTUALS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PROJ_EMP_ACTUALS" ("PROJNO", "COSTCODE", "EMPNO", "NAME", "ACTUAL", "OVERTIME") AS 
  (select projno,costcode,empno,name, sum(h) as actual,sum(o) as overtime from
(
(select a.projno,a.costcode,a.empno,b.name,sum(nvl(a.hours,0)) h,sum(nvl(a.othours,0))  o
from timetran0203 a, emplmast b
where a.empno = b.empno  and a.yymm > '200203' group by a.projno,a.costcode,a.empno,b.name)
union
(select a.projno,a.costcode,a.empno,b.name,sum(nvl(a.hours,0)) h,sum(nvl(a.othours,0)) o
from timetran0304 a, emplmast b
where a.empno = b.empno  and a.yymm > '200303' group by a.projno,a.costcode,a.empno,b.name)
union
(select a.projno,a.costcode,a.empno,b.name,sum(nvl(a.hours,0)) h,sum(nvl(a.othours,0)) o
from timetran a, emplmast b
where a.empno = b.empno and a.yymm > '200403' group by a.projno,a.costcode,a.empno,b.name))
group by projno,costcode,empno,name )

;
