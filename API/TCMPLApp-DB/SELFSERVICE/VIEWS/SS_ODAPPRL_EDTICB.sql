--------------------------------------------------------
--  DDL for View SS_ODAPPRL_EDTICB
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_ODAPPRL_EDTICB" ("APP_NO", "EMPNO", "APP_DATE", "BDATE", "EDATE", "DESCRIPTION", "TYPE", "HOD_APPRL", "HOD_CODE", "HOD_APPRL_DT", "HRD_APPRL", "HRD_CODE", "HRD_APPRL_DT", "HH", "MM", "HH1", "MM1", "REASON", "FROMTAB") AS 
  Select "APP_NO","EMPNO","APP_DATE","BDATE","EDATE","DESCRIPTION","TYPE","HOD_APPRL","HOD_CODE","HOD_APPRL_DT","HRD_APPRL","HRD_CODE","HRD_APPRL_DT","HH","MM","HH1","MM1","REASON","FROMTAB" from SelfService_EDTicb.SS_ODApprl WITH READ ONLY
;
