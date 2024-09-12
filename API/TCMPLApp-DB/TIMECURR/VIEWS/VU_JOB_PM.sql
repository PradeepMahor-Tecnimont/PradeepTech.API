--------------------------------------------------------
--  DDL for View VU_JOB_PM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."VU_JOB_PM" ("EMPNO", "PERSONID", "NAME", "APPLICATION", "ROLE") AS 
  (
select empno,personid,name,'Jobform' Application,'Project Manager/ProjectEnggManager'  Role from emplmast where projmngr = 1  and emptype in ('R','C','S','F','O')
)
;
