--------------------------------------------------------
--  DDL for View MISSMATCH_ABBR_PROJMAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."MISSMATCH_ABBR_PROJMAST" ("PROJNO", "CDATE", "ABBR", "EMPLABBR", "PRJMNGR", "EMPNO") AS 
  (
select a.projno,a.cdate ,a.abbr ,b.abbr as EMPLABBR ,a.prjmngr,  b.empno 
from projmast a, emplmast b where 
b.abbr <> a.abbr and a.prjmngr = b.empno and a.cdate is null 
)

;
