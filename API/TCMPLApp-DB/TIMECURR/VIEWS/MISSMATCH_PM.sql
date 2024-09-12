--------------------------------------------------------
--  DDL for View MISSMATCH_PM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."MISSMATCH_PM" ("PROJNO", "PROJECT", "ACTUAL_CLOSING_DATE", "FORM_MODE", "REVISION", "FORM_DATE", "PM_COSTCODE", "PRJMNGR", "PM_EMPNO", "NAME") AS 
  (
select a.projno,b.projno as project, a.actual_closing_date,a.form_mode,a.revision,a.form_date ,
a.pm_costcode ,b.prjmngr,
a.pm_empno,b.name
from jobmaster a, projmast b where
a.pm_empno <> b.prjmngr and a.projno = substr(b.projno,1,5)
and substr(b.projno,6,2) <> '52'
and a.actual_closing_date is null)
;
