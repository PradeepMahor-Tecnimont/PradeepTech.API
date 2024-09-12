--------------------------------------------------------
--  DDL for View TS_APPROVERS_ROLE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TS_APPROVERS_ROLE" ("EMPNO", "COSTCODE", "PERSONID", "NAME", "APPLSYSTEM", "ROLE", "ROLENAME") AS 
  (SELECT A."EMPNO",A."COSTCODE",B.PERSONID,B.NAME,'Timesheet' APPLSYSTEM ,'Timesheet Approver' as Role,'Timesheet Approver'  RoleName
FROM TS_APpROVERS A, EMPLMAST B WHERE A.EMPnO = B.EMPNO)
;
