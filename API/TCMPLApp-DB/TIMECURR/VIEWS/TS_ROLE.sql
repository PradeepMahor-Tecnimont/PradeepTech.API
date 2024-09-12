--------------------------------------------------------
--  DDL for View TS_ROLE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TS_ROLE" ("EMPNO", "COSTCODE", "PERSONID", "NAME", "APPLSYSTEM", "ROLE", "ROLENAME") AS 
  (select "EMPNO","COSTCODE","PERSONID","NAME","APPLSYSTEM","ROLE","ROLENAME" from ts_approvers_role union select "EMPNO","COSTCODE","PERSONID","NAME","APPLSYSTEM","ROLE","ROLENAME" from ts_secretary_role)
;
