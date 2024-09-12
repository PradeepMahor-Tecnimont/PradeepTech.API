--------------------------------------------------------
--  DDL for View OT_962709_FROM_APR2010
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."OT_962709_FROM_APR2010" ("EMPNO", "NAME", "YYYY", "MON", "OT_HOURS") AS 
  SELECT a.empno,
    b.name,
    a.yyyy,
    a.mon,
    a.hod_apprd_ot/60 AS ot_hours
  FROM ss_otmaster a,
    ss_emplmast b
  WHERE a.empno   = b.empno
  AND a.hod_apprl = 1
  AND a.yyyy     >= '2010'
  AND a.mon      >='04'
  AND a.empno
    ||a.yyyy
    ||a.mon IN
    (SELECT empno||yymm FROM time2010.proj_emp
    )
;
