--------------------------------------------------------
--  DDL for View VU_JOB_AFCAPPROVER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."VU_JOB_AFCAPPROVER" ("EMPNO", "PERSONID", "NAME", "APPLICATION", "ROLE") AS 
  (
select empno,personid,name,'Jobform' Application,'AFC Approver'  Role from emplmast where AMFI_AUTH = 1  and emptype in ('R','C','S','F','O')
)
;
