--------------------------------------------------------
--  DDL for View SECRETARY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."SECRETARY" ("EMPNO", "COSTCODE", "CV", "DESKMGMT", "RAPPER", "TIMESHEET", "TRAINING", "TRAVEL") AS 
  SELECT "EMPNO",
    "COSTCODE",
    "CV",
    "DESKMGMT",
    "RAPPER",
    "TIMESHEET",
    "TRAINING",
    "TRAVEL"
  FROM timeCURR.secretary
WITH READ ONLY
;
