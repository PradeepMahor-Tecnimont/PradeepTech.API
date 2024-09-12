--------------------------------------------------------
--  DDL for View TIMETRAN_SUMMARY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TIMETRAN_SUMMARY" ("PROJNO", "OPENING", "HRS", "OTHRS") AS 
  select projno,0 as opening,sum(nvl(hours,0)) as hrs,sum(nvl(othours,0)) as othrs from timetran group by projno
union all
select projno,sum(nvl(open01,0)) as opening,0 as hrs,0 as othours from openmast group by projno

;
