--------------------------------------------------------
--  DDL for View RAP_TAB_MOVEMAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."RAP_TAB_MOVEMAST" ("COSTCODE", "YYMM", "MOVEMENT", "MOVETOTCM", "MOVETOSITE", "MOVETOOTHERS", "EXT_SUBCONTRACT", "FUT_RECRUIT", "INT_DEPT", "HRS_SUBCONT") AS 
  select "COSTCODE","YYMM","MOVEMENT","MOVETOTCM","MOVETOSITE","MOVETOOTHERS","EXT_SUBCONTRACT","FUT_RECRUIT","INT_DEPT","HRS_SUBCONT" from movemast
where yymm >= '202004' and yymm <= '202103'
;
