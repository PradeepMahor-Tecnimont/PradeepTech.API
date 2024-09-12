--------------------------------------------------------
--  DDL for View SS_HOLIDAYS2001
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_HOLIDAYS2001" ("SRNO", "HOLIDAY", "YYYYMM") AS 
  select "SRNO","HOLIDAY","YYYYMM" from time2002.holidays
;
