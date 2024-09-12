--------------------------------------------------------
--  DDL for View RAPHOURS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."RAPHOURS" ("YYMM", "WORK_DAYS", "WEEKEND", "HOLIDAYS", "LEAVE", "TOT_DAYS", "WORKING_HR") AS 
  SELECT "YYMM",
    "WORK_DAYS",
    "WEEKEND",
    "HOLIDAYS",
    "LEAVE",
    "TOT_DAYS",
    "WORKING_HR"
  FROM timeCURR.raphours
WITH READ ONLY
;
