--------------------------------------------------------
--  DDL for View MISSMATCH_REIMB_JOB
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."MISSMATCH_REIMB_JOB" ("PROJNO", "NAME", "PROJMAST_REIMB", "JOBMASTER_REIMB") AS 
  (select a.projno, a.name, a.reimb_job projmast_reimb ,b.reimb_job jobmaster_reimb from projmast a ,
jobmaster b  where nvl(a.reimb_job,0) <>  nvl(b.reimb_job,0) and substr(a.projno,1,5) = b.projno)
;
