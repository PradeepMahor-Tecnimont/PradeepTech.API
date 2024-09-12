--------------------------------------------------------
--  DDL for View TIME_TARACCO_UNION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TIME_TARACCO_UNION" ("YYMM", "PROJNO", "ACTIVITY", "TYPE", "TOTHOURS") AS 
  (select yymm,projno,activity,'Timesheet' as type, sum(nvl(hours,0))+sum(nvl(othours,0)) as tothours from
timetran where costcode = '0221' and projno in (Select distinct projno from tarocco_costprojact)
group by yymm,projno,activity )
union
(select yymm,projno,activity,'Taracco',hours from
tarocco_costprojact where costcode = '0221' )

;
