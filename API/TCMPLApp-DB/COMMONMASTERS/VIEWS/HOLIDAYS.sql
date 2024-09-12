--------------------------------------------------------
--  DDL for View HOLIDAYS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."HOLIDAYS" ("SRNO", "HOLIDAY", "YYYYMM", "WEEKDAY") AS 
  SELECT  SRNO , HOLIDAY , YYYYMM , WEEKDAY  FROM timecurr.holidays
WITH READ ONLY
;
  GRANT SELECT ON "COMMONMASTERS"."HOLIDAYS" TO "REMOTEWORKING";
  GRANT SELECT ON "COMMONMASTERS"."HOLIDAYS" TO "SELFSERVICE";
