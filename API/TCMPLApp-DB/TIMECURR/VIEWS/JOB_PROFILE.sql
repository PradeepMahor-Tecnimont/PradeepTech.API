--------------------------------------------------------
--  DDL for View JOB_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."JOB_PROFILE" ("EMPNO", "NAME", "PROJMNGR", "DIRECTOR", "JOB_INCHARGE", "DIROP", "AMFI_USER", "AMFI_AUTH") AS 
  (select empno,name,projmngr,director,job_incharge,dirop,amfi_user,amfi_auth from emplmast where 
(projmngr > 0 or director > 0 or job_incharge > 0 or dirop > 0 or amfi_user > 0  or amfi_auth > 0) and status = 1)
;
