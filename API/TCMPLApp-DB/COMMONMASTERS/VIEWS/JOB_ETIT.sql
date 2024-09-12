--------------------------------------------------------
--  DDL for View JOB_ETIT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."JOB_ETIT" ("EMPNO", "TIT_CD", "EFFDATE") AS 
  SELECT  "EMPNO","TIT_CD","EFFDATE"  FROM timecurr.job_etit
WITH READ ONLY
;
