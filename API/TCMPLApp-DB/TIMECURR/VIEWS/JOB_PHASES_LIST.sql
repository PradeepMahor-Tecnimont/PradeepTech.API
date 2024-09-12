--------------------------------------------------------
--  DDL for View JOB_PHASES_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."JOB_PHASES_LIST" ("SCOPE_OF_WORK", "SHORT_DESC", "PM_EMPNO", "CLOSING_DATE_REV1", "ACTUAL_CLOSING_DATE", "REIMB_JOB", "TCM_JOBS", "EOU_JOB", "PROJNO", "PHASE", "TMAGRP", "PHASE_SELECT", "BLOCK_BOOKING", "BLOCK_OT") AS 
  (
select a.scope_of_work,a.short_desc,  a.pm_empno,  a.CLOSING_DATE_REV1,
a.actual_closing_date,a.reimb_job,a.tcm_jobs,a.eou_job ,
b."PROJNO",b."PHASE",b."TMAGRP",b."PHASE_SELECT",b."BLOCK_BOOKING",b."BLOCK_OT" 
from 
jobmaster a ,job_proj_phase b 
where 
a.projno = b.projno 
)

;
