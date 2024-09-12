--------------------------------------------------------
--  DDL for View EXPTPROJ
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."EXPTPROJ" ("PROJNO", "NAME", "Original", "Revised", "Upto") AS 
  (
select a.projno,a.name,sum(nvl(d.ORIGINAL,0))  "Original" ,sum(nvl(d.revised,0)) as "Revised" ,  round(sum(c.hours)+sum(c.othours),0) as "Upto"
from EXPTJOBS a,exptprjc b,timetran c ,budgmast d where  a.projno = b.projno and a.projno = c.projno and a.projno = d.projno(+)  and b.costcode = '0221'
group by a.projno,a.name
)
;
