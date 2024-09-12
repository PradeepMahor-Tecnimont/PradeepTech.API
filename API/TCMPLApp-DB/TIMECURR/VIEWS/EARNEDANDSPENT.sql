--------------------------------------------------------
--  DDL for View EARNEDANDSPENT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."EARNEDANDSPENT" ("YYMM", "PROJNO", "COSTCODE", "SPENT", "EARNED") AS 
  select a.yymm,a.projno,a.costcode,sum(a.hours) + sum(a.othours) as spent, 0000000000 as earned
from timetran a, projmast b, costmast c
where a.projno = b.projno and a.costcode = c.costcode
group by a.yymm,a.projno,a.costcode
union all
select a.yymm,a.projno,a.costcode,0000000000 as spent, sum(a.hours) as earned
from earnedhours a,projmast b, costmast c
where a.projno = b.projno and a.costcode = c.costcode
group by a.yymm,a.projno,a.costcode

;
