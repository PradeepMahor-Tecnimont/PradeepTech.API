--------------------------------------------------------
--  DDL for View SS_JOB_INDUSTRY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_JOB_INDUSTRY" ("PROJNO", "PROJNAME", "START_DATE", "END_DATE", "INDUSTRY_NAME", "COUNTRY") AS 
  (SELECT "PROJNO","PROJNAME","START_DATE","END_DATE","INDUSTRY_NAME","COUNTRY"
  FROM commonmasters.job_industry
  )
;
