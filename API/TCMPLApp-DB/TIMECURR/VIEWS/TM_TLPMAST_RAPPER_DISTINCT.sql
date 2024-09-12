--------------------------------------------------------
--  DDL for View TM_TLPMAST_RAPPER_DISTINCT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TM_TLPMAST_RAPPER_DISTINCT" ("COSTCODE", "TLPCODE") AS 
  select distinct "COSTCODE","TLPCODE" from tm_tlpmast_rapper WITH READ ONLY

;
