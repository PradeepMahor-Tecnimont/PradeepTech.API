--------------------------------------------------------
--  DDL for View ODAPPRL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."ODAPPRL" ("APP_NO", "EMPNO", "APP_DATE", "BDATE", "EDATE", "DESCRIPTION", "TYPE", "HOD_APPRL", "HOD_CODE", "HOD_APPRL_DT", "HRD_APPRL", "HRD_CODE", "HRD_APPRL_DT") AS 
  (select app_no,empno,app_date, pdate bdate, to_date(null) edate, description,type,hod_apprl, 
hod_code, hod_apprl_dt,hrd_apprl, hrd_code, hrd_apprl_dt from ss_ondutyapp) union (select app_no, empno,
app_date, bdate, edate,description,type,hod_apprl, hod_code, hod_apprl_dt,hrd_apprl, hrd_code, hrd_apprl_dt from ss_depu)
;
