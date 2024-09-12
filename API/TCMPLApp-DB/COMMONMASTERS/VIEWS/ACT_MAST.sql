--------------------------------------------------------
--  DDL for View ACT_MAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."ACT_MAST" ("COSTCODE", "ACTIVITY", "NAME", "TLPCODE", "ACTIVITY_TYPE", "ACTIVE") AS 
  SELECT COSTCODE,
    ACTIVITY,
    NAME,
    TLPCODE,
    ACTIVITY_TYPE,
    ACTIVE
  FROM timecurr.act_mast
;
