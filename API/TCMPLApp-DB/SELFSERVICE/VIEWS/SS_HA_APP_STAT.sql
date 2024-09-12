--------------------------------------------------------
--  DDL for View SS_HA_APP_STAT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_HA_APP_STAT" ("EMPNO", "PDATE", "APP_NO", "APP_DATE", "DESCRIPTION", "LEAD_APPRLDESC", "HOD_APPRLDESC", "HRD_APPRLDESC", "LEAD_APPRL_EMPNO", "LEAD_REASON", "HODREASON", "HRDREASON", "HOD_APPRL", "HRD_APPRL", "FROMTAB") AS 
  SELECT empno,
    TO_CHAR(PDate,'dd-Mon-yyyy')PDate,
    app_No,
    app_date,
    description,
    DECODE(Lead_apprl, 0,'Pending',1,'Apprd',2,'DisApprd',4,'NA') Lead_ApprlDesc,
    DECODE(Hod_apprl, 0,'Pending',1,'Apprd',2,'DisApprd') Hod_ApprlDesc,
    DECODE(Hrd_apprl, 0,'Pending',1,'Apprd',2,'DisApprd') Hrd_ApprlDesc,
    lead_apprl_empno,
    lead_reason,
    HodReason,
    HrdReason,
    Hod_apprl,
    Hrd_Apprl,
    'DP' FromTab
  FROM ss_holiday_attendance
;
