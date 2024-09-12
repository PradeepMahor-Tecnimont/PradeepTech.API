--------------------------------------------------------
--  DDL for View OT_962709_TILL_MAR2010
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."OT_962709_TILL_MAR2010" ("EMPNO", "NAME", "YYYY", "MON", "OT_HOURS") AS 
  select a.empno,b.name,a.yyyy,a.mon,a.hrd_apprd_ot/60 as ot_hours from ss_otmaster a,ss_emplmast b 
where a.empno = b.empno and a.hrd_apprl = 1 and a.yyyy >= '2009' and (a.mon >='01' and a.mon <='12') and a.empno||a.yyyy||a.mon in (select empno||yymm from time2009.proj_emp)
;
