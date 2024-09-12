--------------------------------------------------------
--  DDL for View WRKHOURS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."WRKHOURS" ("YYMM", "OFFICE", "WORKING_HRS") AS 
  SELECT YYMM,OFFICE,WORKING_HRS FROM timeCURR.wrkhours
WITH READ ONLY
;
