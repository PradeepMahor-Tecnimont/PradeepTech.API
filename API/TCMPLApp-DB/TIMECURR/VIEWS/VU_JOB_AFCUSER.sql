--------------------------------------------------------
--  DDL for View VU_JOB_AFCUSER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."VU_JOB_AFCUSER" ("EMPNO", "PERSONID", "NAME", "APPLICATION", "ROLE") AS 
  (
select empno,personid,name,'Jobform' Application,'AFC User'  Role from emplmast where AMFI_USER = 1  and emptype in ('R','C','S','F','O')
)
;
