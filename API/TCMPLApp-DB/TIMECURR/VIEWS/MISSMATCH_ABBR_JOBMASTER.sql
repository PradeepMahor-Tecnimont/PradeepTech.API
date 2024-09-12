--------------------------------------------------------
--  DDL for View MISSMATCH_ABBR_JOBMASTER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."MISSMATCH_ABBR_JOBMASTER" ("PROJNO", "ACTUAL_CLOSING_DATE", "FORM_MODE", "REVISION", "FORM_DATE", "PM_COSTCODE", "PARENT", "PM_EMPNO", "EMPNO") AS 
  (
select a.projno, a.actual_closing_date,a.form_mode,a.revision,a.form_date ,a.pm_costcode ,b.parent,a.pm_empno,
  b.empno
from jobmaster a, emplmast b where
b.parent <> a.pm_costcode and a.pm_empno = b.empno 
and a.actual_closing_date is null
)

;
