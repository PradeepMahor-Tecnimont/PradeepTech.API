--------------------------------------------------------
--  DDL for View LEFT_PM_JOBMASTER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."LEFT_PM_JOBMASTER" ("PROJNO", "SHORT_DESC", "PM_EMPNO", "COSTCODE", "PM_COSTCODE", "DOL", "NAME") AS 
  (SELECT a.PROJNO,
    a.short_desc ,
    a.pm_empno,a.costcode,a.pm_costcode,b.dol,b.name
  FROM jobmaster a,emplmast b
  where a.pm_empno = b.empno and 
  a.actual_closing_date IS NULL
  AND a.pm_empno              IN
    (SELECT empno FROM emplmast WHERE dol IS NOT NULL
    )
  )
;
