--------------------------------------------------------
--  DDL for View JOB_INDUSTRY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."JOB_INDUSTRY" ("PROJNO", "PROJNAME", "START_DATE", "END_DATE", "INDUSTRY_NAME", "COUNTRY") AS 
  (
SELECT a.projno,
    a.short_desc projname,
    a.job_open_date start_date,    
    to_date(DECODE(a.closing_date_rev1,NULL,DECODE(a.expected_closing_date,NULL ,
    DECODE(a.actual_closing_date,NULL,NULL,a.actual_closing_date),
    a.expected_closing_date),
    a.closing_date_rev1),'dd-mm-yy') End_date,
    b.name Industry_name,
    NVL(T_location,'-NA-') Country
  FROM timecurr.jobmaster a,
    timecurr.job_industry b
  WHERE a.industry = b.industry)
;
  GRANT SELECT ON "COMMONMASTERS"."JOB_INDUSTRY" TO "SELFSERVICE";
