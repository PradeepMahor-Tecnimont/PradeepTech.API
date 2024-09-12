--------------------------------------------------------
--  DDL for View JOB_PHASE_DEPT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."JOB_PHASE_DEPT" ("COSTCODE", "PHASE", "COMPANY", "PHASE_SELECT", "PROJNO") AS 
  (
 select a."COSTCODE",a."PHASE",a."COMPANY" ,b.phase_select,b.projno
 from deptphase a,job_proj_phase b where a.phase = b.phase_select 
)

;
