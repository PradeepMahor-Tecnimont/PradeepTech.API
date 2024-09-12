--------------------------------------------------------
--  DDL for View JOB_TIT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."JOB_TIT" ("TIT_CD", "TITLE", "GRP_CD", "DIS_CD") AS 
  SELECT  "TIT_CD","TITLE","GRP_CD","DIS_CD"  FROM timecurr.job_tit
WITH READ ONLY
;
