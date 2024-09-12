--------------------------------------------------------
--  DDL for View MISDMATCH_TCM_JOBS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."MISDMATCH_TCM_JOBS" ("PROJNO", "NAME", "PROJMAST_TCM", "JOBMASTER_TCM") AS 
  (select a.projno, a.name, a.tcm_jobs projmast_tcm ,b.tcm_jobs jobmaster_tcm from projmast a ,
jobmaster b  where nvl(a.tcm_jobs,0) <>  nvl(b.tcm_jobs,0) and substr(a.projno,1,5) = b.projno)
;
