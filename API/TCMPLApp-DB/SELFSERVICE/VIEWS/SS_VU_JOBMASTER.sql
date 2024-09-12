--------------------------------------------------------
--  DDL for View SS_VU_JOBMASTER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_JOBMASTER" ("PROJNO", "PHASE", "SHORT_DESC", "TASKFORCE") AS 
  select projno,phase,short_desc,taskforce from TIMECURR.jobmaster 
;
