--------------------------------------------------------
--  DDL for View JOB_GRP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."JOB_GRP" ("GRP_CD", "GRP_NAME") AS 
  SELECT  "GRP_CD","GRP_NAME"  FROM timecurr.job_grp
WITH READ ONLY
;
