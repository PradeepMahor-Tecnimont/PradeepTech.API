--------------------------------------------------------
--  DDL for View VU_JOB_SPONSOR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."VU_JOB_SPONSOR" ("EMPNO", "PERSONID", "NAME", "APPLICATION", "ROLE") AS 
  (
select empno,personid,name,'Jobform' Application,'Project Incharge'  Role from emplmast where JOB_INCHARGE = 1 and emptype in ('R','C','S','F','O')
)
;
