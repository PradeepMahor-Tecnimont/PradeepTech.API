--------------------------------------------------------
--  DDL for View JOB_DIS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."JOB_DIS" ("GRP_CD", "DIS_CD", "DIS_NAME", "GRP_NAME") AS 
  SELECT  "GRP_CD","DIS_CD","DIS_NAME","GRP_NAME"  FROM timecurr.job_dis
WITH READ ONLY
;
