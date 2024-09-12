--------------------------------------------------------
--  DDL for View TM_ROLES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TM_ROLES" ("EMPNO", "COSTCODE", "PERSONID", "NAME", "APPLSYSTEM", "ROLENAME") AS 
  (select "EMPNO","COSTCODE","PERSONID","NAME","APPLSYSTEM","ROLENAME" from ts_approvers_role union select "EMPNO","COSTCODE","PERSONID","NAME","APPLSYSTEM","ROLENAME" from ts_secretary_role)
;
