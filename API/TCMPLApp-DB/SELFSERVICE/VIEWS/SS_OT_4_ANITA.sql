--------------------------------------------------------
--  DDL for View SS_OT_4_ANITA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_OT_4_ANITA" ("YYMM", "EMPNO", "TOTALOT", "ACTOT", "SUNDAY") AS 
  select yyyy || mon as yymm, EMPNO, nvl(Hrd_apprd_ot,0) as TOTALOT,
 nvl(Hrd_apprd_ot,0) - nvl(hrd_sunday_ot,0) as ACTOT,
 Nvl(hrd_sunday_ot,0) as SUNDAY
 from ss_otmaster where
 (nvl(Hrd_apprl,0) = 1)
;
