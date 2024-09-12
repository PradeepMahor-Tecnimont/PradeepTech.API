--------------------------------------------------------
--  DDL for View TS_SECRETARY_ROLE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TS_SECRETARY_ROLE" ("EMPNO", "COSTCODE", "PERSONID", "NAME", "APPLSYSTEM", "ROLE", "ROLENAME") AS 
  (SELECT A."EMPNO",A."COSTCODE",B.PERSONID,B.NAME,'Timesheet' APPLSYSTEM ,'Timesheet Secretary' as role,'Timesheet Secretary'  RoleName
FROM TS_Secretary A, EMPLMAST B WHERE A.EMPno = B.EMPNO)
;
