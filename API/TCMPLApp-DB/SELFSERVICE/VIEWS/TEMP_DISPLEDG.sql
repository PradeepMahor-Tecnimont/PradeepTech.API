--------------------------------------------------------
--  DDL for View TEMP_DISPLEDG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."TEMP_DISPLEDG" ("APP_NO", "APP_DATE", "LEAVETYPE", "DESCRIPTION", "EMPNO", "LEAVEPERIOD", "DB_CR", "DISPBDATE", "DISPEDATE", "DBDAY", "CRDAY") AS 
  select "APP_NO","APP_DATE","LEAVETYPE","DESCRIPTION","EMPNO","LEAVEPERIOD","DB_CR","DISPBDATE","DISPEDATE","DBDAY","CRDAY" from ss_displedg
;
