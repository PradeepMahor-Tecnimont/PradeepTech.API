--------------------------------------------------------
--  DDL for View SS_ODAPPRL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_ODAPPRL" ("APP_NO", "EMPNO", "APP_DATE", "BDATE", "EDATE", "DESCRIPTION", "TYPE", "HOD_APPRL", "HOD_CODE", "HOD_APPRL_DT", "HRD_APPRL", "HRD_CODE", "HRD_APPRL_DT", "LEAD_APPRL", "LEAD_CODE", "LEAD_APPRL_EMPNO", "HH", "MM", "HH1", "MM1", "REASON", "FROMTAB", "HRDREASON", "HODREASON", "LEAD_REASON") AS 
  (SELECT app_no,
    empno,
    app_date,
    pdate bdate,
    to_date(NULL) edate,
    description,
    type,
    hod_apprl,
    hod_code,
    hod_apprl_dt,
    hrd_apprl,
    hrd_code,
    hrd_apprl_dt,
    lead_apprl,
    lead_code,
    lead_apprl_empno,
    hh,
    mm,
    hh1,
    mm1,
    Reason,
    4 FromTab,
    hrdreason,
    hodreason,
    lead_reason
  FROM ss_ondutyapp where pdate > sysdate -750
  )
UNION
  (SELECT app_no,
    empno,
    app_date,
    bdate,
    edate,
    description,
    type,
    hod_apprl,
    hod_code,
    hod_apprl_dt,
    hrd_apprl,
    hrd_code,
    hrd_apprl_dt,
    lead_apprl,
    lead_code,
    lead_apprl_empno,
    to_number(NULL) hh,
    to_number(NULL) mm,
    to_number(NULL) hh1,
    to_number(NULL) mm1,
    Reason,
    3 FromTab,
    hrdreason,
    hodreason,
    lead_reason
    
  FROM ss_depu where bdate > sysdate -750
  )
;
