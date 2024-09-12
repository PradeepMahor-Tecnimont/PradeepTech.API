--------------------------------------------------------
--  DDL for View SS_ODAPPSTAT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_ODAPPSTAT" ("EMPNO", "PDATE", "START_DATE", "APP_NO", "APP_DATE", "DESCRIPTION", "TYPE", "LEAD_APPRLDESC", "HOD_APPRLDESC", "HRD_APPRLDESC", "LEAD_APPRL_EMPNO", "LEAD_REASON", "HODREASON", "HRDREASON", "HOD_APPRL", "HRD_APPRL", "FROMTAB", "CAN_DELETE_APP") AS 
  Select
    empno,
    to_char(bdate, 'dd-Mon-yyyy')        pdate,
    bdate                                start_date,
    app_no,
    app_date,
    description,
    type,
    ss.approval_text(nvl(lead_apprl, 0)) As lead_apprldesc,
    ss.approval_text(nvl(hod_apprl, 0))  As hod_apprldesc,
    ss.approval_text(nvl(hrd_apprl, 0))  As hrd_apprldesc,
    lead_apprl_empno,
    lead_reason,
    hodreason,
    hrdreason,
    hod_apprl,
    hrd_apprl,
    'DP'                                 fromtab,
    Case
        When nvl(lead_apprl, 0) In (0, 4)
            And nvl(hod_apprl, 0) = 0
        Then
            1
        Else
            0
    End                                  can_delete_app
From
    ss_depu

Union

Select
    empno,
    to_char(pdate, 'dd-Mon-yyyy')        pdate,
    pdate                                start_date,
    app_no,
    app_date,
    description,
    type,
    ss.approval_text(nvl(lead_apprl, 0)) As lead_apprldesc,
    ss.approval_text(nvl(hod_apprl, 0))  As hod_apprldesc,
    ss.approval_text(nvl(hrd_apprl, 0))  As hrd_apprldesc,
    lead_apprl_empno,
    lead_reason,
    hodreason,
    hrdreason,
    hod_apprl,
    hrd_apprl,
    'OD'                                 fromtab,
    Case
        When nvl(lead_apprl, 0) In (0, 4)
            And nvl(hod_apprl, 0) = 0
        Then
            1
        Else
            0
    End                                  can_delete_app
From
    ss_ondutyapp

Union

Select
    a.empno                         As empno,
    to_char(a.pdate, 'dd-Mon-yyyy') pdate,
    pdate                           start_date,

    a.app_no                        As app_no,
    a.app_date                      As app_date,
    a.description                   As description,
    a.type                          As type,
    'NA'                            As lead_apprldesc,
    'Apprd'                         As hod_apprldesc,
    'Apprd'                         As hrd_apprldesc,
    ' '                             As lead_apprl_empno,
    ' '                             As lead_reason,
    ' '                             As hodreason,
    ' '                             As hrdreason,
    1                               As hod_apprl,
    1                               As hrd_apprl,
    'OD'                            fromtab,
    0                               can_delete_app
From
    ss_onduty a
Where
    app_no Not In (
        Select
            app_no
        From
            ss_ondutyapp
    )
;
