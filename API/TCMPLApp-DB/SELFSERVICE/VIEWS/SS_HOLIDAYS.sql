--------------------------------------------------------
--  DDL for View SS_HOLIDAYS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_HOLIDAYS" ("SRNO", "HOLIDAY", "YYYYMM", "WEEKDAY") AS 
  select "SRNO","HOLIDAY","YYYYMM","WEEKDAY" from commonmasters.holidays
;
