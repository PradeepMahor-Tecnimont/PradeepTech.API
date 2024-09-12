--------------------------------------------------------
--  DDL for View MISSING_TCMNO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."MISSING_TCMNO" ("PROJNO", "TCMNO", "SHORT_DESC", "ACTUAL_CLOSING_DATE", "TCM_JOBS") AS 
  select projno,tcmno ,short_desc,actual_closing_date,tcm_jobs from jobmaster where nvl(tcmno ,'NIL') ='NIL' and nvl(tcm_jobs,0) = 1
;
