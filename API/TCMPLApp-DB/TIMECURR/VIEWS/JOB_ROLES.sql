--------------------------------------------------------
--  DDL for View JOB_ROLES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."JOB_ROLES" ("EMPNO", "PERSONID", "NAME", "APPLICATION", "ROLE") AS 
  (
select empno,personid,name,'Jobform' Application,'AFC Approver'  Role from emplmast where AMFI_AUTH = 1  and emptype in ('R','C','S','F','O')
union
select empno,personid,name,'Jobform' Application,'AFC User'  Role from emplmast where AMFI_USER = 1  and emptype in ('R','C','S','F','O')
union
select empno,personid,name,'Jobform' Application,'Project Manager/ProjectEnggManager'  Role from emplmast where projmngr = 1  and emptype in ('R','C','S','F','O')
union
select empno,personid,name,'Jobform' Application,'Project Incharge'  Role from emplmast where JOB_INCHARGE = 1 and emptype in ('R','C','S','F','O')
union
select empno,personid,name,'Jobform' Application,'CMD' Role from emplmast where DIROP = 1  and emptype in ('R','C','S','F','O')
)
;
