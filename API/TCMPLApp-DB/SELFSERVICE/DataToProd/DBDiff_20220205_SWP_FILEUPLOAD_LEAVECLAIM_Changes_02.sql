--------------------------------------------------------
--  File created - Saturday-February-05-2022   
--------------------------------------------------------
---------------------------
--Changed TABLE
--SS_LEAVEAPP_DELETED
---------------------------
ALTER TABLE "SELFSERVICE"."SS_LEAVEAPP_DELETED" ADD ("IS_COVID_SICK_LEAVE" NUMBER(1,0));
ALTER TABLE "SELFSERVICE"."SS_LEAVEAPP_DELETED" ADD ("MED_CERT_FILE_NAME" VARCHAR2(100));

---------------------------
--Changed TABLE
--SWP_EMP_PROJ_MAPPING
---------------------------
ALTER TABLE "SELFSERVICE"."SWP_EMP_PROJ_MAPPING" MODIFY ("KYE_ID" VARCHAR2(10));

---------------------------
--New TABLE
--SWP_DESK_AREA_MAPPING
---------------------------
  CREATE TABLE "SELFSERVICE"."SWP_DESK_AREA_MAPPING" 
   (	"KYE_ID" VARCHAR2(20) NOT NULL ENABLE,
	"DESKID" VARCHAR2(10),
	"AREA_KEY_ID" CHAR(3),
	"MODIFIED_ON" DATE,
	"MODIFIED_BY" CHAR(5),
	CONSTRAINT "SWP_DESK_AREA_MAPPING_PK" PRIMARY KEY ("KYE_ID") ENABLE
   );
---------------------------
--Changed TABLE
--SS_LEAVEAPP_REJECTED
---------------------------
ALTER TABLE "SELFSERVICE"."SS_LEAVEAPP_REJECTED" ADD ("IS_COVID_SICK_LEAVE" NUMBER(1,0));
ALTER TABLE "SELFSERVICE"."SS_LEAVEAPP_REJECTED" ADD ("MED_CERT_FILE_NAME" VARCHAR2(100));

---------------------------
--Changed TABLE
--SWP_SMART_ATTENDANCE_PLAN
---------------------------
ALTER TABLE "SELFSERVICE"."SWP_SMART_ATTENDANCE_PLAN" ADD CONSTRAINT "SWP_SMART_ATTENDANCE_PLAN_UK1" UNIQUE ("ATTENDANCE_DATE","DESKID") ENABLE;

---------------------------
--New VIEW
--SS_VU_DEPU
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_DEPU" 
 ( "EMPNO", "PDATE", "START_DATE", "APP_NO", "APP_DATE", "DESCRIPTION", "TYPE", "LEAD_APPRLDESC", "HOD_APPRLDESC", "HRD_APPRLDESC", "LEAD_APPRL_EMPNO", "LEAD_REASON", "HODREASON", "HRDREASON", "HOD_APPRL", "HRD_APPRL", "FROMTAB", "CAN_DELETE_APP", "BDATE", "EDATE", "REASON", "LEAD_APPRL"
  )  AS 
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
    End                                  can_delete_app,
    bdate,
    edate,
    reason,
    lead_apprl
From
    ss_depu
Union
Select
    empno,
    to_char(bdate, 'dd-Mon-yyyy')        pdate,
    bdate                                start_date,
    app_no,
    app_date,
    description,
    type,
    ss.approval_text(nvl(lead_apprl, 0)) As lead_apprldesc,
    Case nvl(lead_apprl, 0)
        When ss.disapproved Then
            '-'
        Else
            ss.approval_text(nvl(hod_apprl, 0))
    End                                  As hod_approvaldesc,
    Case nvl(hod_apprl, 0)
        When ss.disapproved Then
            '-'
        Else
            ss.approval_text(nvl(hrd_apprl, 0))
    End                                  As hrd_approvaldesc,
    lead_apprl_empno,
    lead_reason,
    hodreason,
    hrdreason,
    hod_apprl,
    hrd_apprl,
    'DP'                                 fromtab,
    0                                    can_delete_app,
    bdate,
    edate,
    reason,
    lead_apprl
From
    ss_depu_rejected;
---------------------------
--New VIEW
--SS_VU_OD_DEPU
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_OD_DEPU" 
 ( "EMPNO", "PDATE", "START_DATE", "APP_NO", "APP_DATE", "DESCRIPTION", "TYPE", "LEAD_APPRLDESC", "HOD_APPRLDESC", "HRD_APPRLDESC", "LEAD_APPRL_EMPNO", "LEAD_REASON", "HODREASON", "HRDREASON", "HOD_APPRL", "HRD_APPRL", "FROMTAB", "CAN_DELETE_APP"
  )  AS 
  select "EMPNO","PDATE","START_DATE","APP_NO","APP_DATE","DESCRIPTION","TYPE","LEAD_APPRLDESC","HOD_APPRLDESC","HRD_APPRLDESC","LEAD_APPRL_EMPNO","LEAD_REASON","HODREASON","HRDREASON","HOD_APPRL","HRD_APPRL","FROMTAB","CAN_DELETE_APP" from ss_vu_ondutyapp
union
select "EMPNO","PDATE","START_DATE","APP_NO","APP_DATE","DESCRIPTION","TYPE","LEAD_APPRLDESC","HOD_APPRLDESC","HRD_APPRLDESC","LEAD_APPRL_EMPNO","LEAD_REASON","HODREASON","HRDREASON","HOD_APPRL","HRD_APPRL","FROMTAB","CAN_DELETE_APP" from ss_vu_depu;
---------------------------
--New VIEW
--SS_VU_LEAVEAPP
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_LEAVEAPP" 
 ( "APP_NO", "EMPNO", "APP_DATE", "REP_TO", "PROJNO", "CARETAKER", "LEAVEPERIOD", "LEAVETYPE", "BDATE", "EDATE", "REASON", "MCERT", "WORK_LDATE", "RESM_DATE", "CONTACT_ADD", "CONTACT_PHN", "CONTACT_STD", "LAST_HRS", "LAST_MN", "RESM_HRS", "RESM_MN", "DATAENTRYBY", "OFFICE", "HOD_APPRL", "HOD_APPRL_DT", "HOD_CODE", "HRD_APPRL", "HRD_APPRL_DT", "HRD_CODE", "DISCREPANCY", "USER_TCP_IP", "HOD_TCP_IP", "HRD_TCP_IP", "HODREASON", "HRDREASON", "HD_DATE", "HD_PART", "LEAD_APPRL", "LEAD_APPRL_DT", "LEAD_CODE", "LEAD_TCP_IP", "LEAD_APPRL_EMPNO", "LEAD_REASON", "MED_CERT_FILE_NAME", "IS_COVID_SICK_LEAVE", "IS_REJECTED"
  )  AS 
  Select
    app_no,
    empno,
    app_date,
    rep_to,
    projno,
    caretaker,
    leaveperiod,
    leavetype,
    bdate,
    edate,
    reason,
    mcert,
    work_ldate,
    resm_date,
    contact_add,
    contact_phn,
    contact_std,
    last_hrs,
    last_mn,
    resm_hrs,
    resm_mn,
    dataentryby,
    office,
    hod_apprl,
    hod_apprl_dt,
    hod_code,
    hrd_apprl,
    hrd_apprl_dt,
    hrd_code,
    discrepancy,
    user_tcp_ip,
    hod_tcp_ip,
    hrd_tcp_ip,
    hodreason,
    hrdreason,
    hd_date,
    hd_part,
    lead_apprl,
    lead_apprl_dt,
    lead_code,
    lead_tcp_ip,
    lead_apprl_empno,
    lead_reason,
    med_cert_file_name,
    is_covid_sick_leave,
    0 is_rejected
From
    ss_leaveapp
Union

Select
    app_no,
    empno,
    app_date,
    rep_to,
    projno,
    caretaker,
    leaveperiod,
    leavetype,
    bdate,
    edate,
    reason,
    mcert,
    work_ldate,
    resm_date,
    contact_add,
    contact_phn,
    contact_std,
    last_hrs,
    last_mn,
    resm_hrs,
    resm_mn,
    dataentryby,
    office,
    hod_apprl,
    hod_apprl_dt,
    hod_code,
    hrd_apprl,
    hrd_apprl_dt,
    hrd_code,
    discrepancy,
    user_tcp_ip,
    hod_tcp_ip,
    hrd_tcp_ip,
    hodreason,
    hrdreason,
    hd_date,
    hd_part,
    lead_apprl,
    lead_apprl_dt,
    lead_code,
    lead_tcp_ip,
    lead_apprl_empno,
    lead_reason,
    med_cert_file_name,
    is_covid_sick_leave,
    1 is_rejected
From
    ss_leaveapp_rejected;
---------------------------
--New VIEW
--SS_VU_ONDUTYAPP
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_ONDUTYAPP" 
 ( "EMPNO", "PDATE", "START_DATE", "APP_NO", "APP_DATE", "DESCRIPTION", "TYPE", "ODTYPE", "HH", "MM", "HH1", "MM1", "REASON", "LEAD_APPRL", "BDATE", "EDATE", "LEAD_APPRLDESC", "HOD_APPRLDESC", "HRD_APPRLDESC", "LEAD_APPRL_EMPNO", "LEAD_REASON", "HODREASON", "HRDREASON", "HOD_APPRL", "HRD_APPRL", "FROMTAB", "CAN_DELETE_APP"
  )  AS 
  Select
    empno,
    to_char(pdate, 'dd-Mon-yyyy')        pdate,
    pdate                                start_date,
    app_no,
    app_date,
    description,
    type,
    odtype,
    hh,
    mm,
    hh1,
    mm1,
    reason,
    lead_apprl,
    Null                                 bdate,
    Null                                 edate,
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
    empno,
    to_char(pdate, 'dd-Mon-yyyy')        pdate,
    pdate                                start_date,
    app_no,
    app_date,
    description,
    type,
    odtype,
    hh,
    mm,
    hh1,
    mm1,
    reason,
    lead_apprl,
    Null                                 bdate,
    Null                                 edate,
    ss.approval_text(nvl(lead_apprl, 0)) As lead_apprldesc,
    Case nvl(lead_apprl, 0)
        When ss.disapproved Then
            '-'
        Else
            ss.approval_text(nvl(hod_apprl, 0))
    End                                  As hod_approvaldesc,
    Case nvl(hod_apprl, 0)
        When ss.disapproved Then
            '-'
        Else
            ss.approval_text(nvl(hrd_apprl, 0))
    End                                  As hrd_approvaldesc,
    lead_apprl_empno,
    lead_reason,
    hodreason,
    hrdreason,
    hod_apprl,
    hrd_apprl,
    'OD'                                 fromtab,
    0                                    can_delete_app
From
    ss_ondutyapp_rejected
Union
Select
    empno,
    to_char(pdate, 'dd-Mon-yyyy') pdate,
    pdate                         start_date,
    app_no,
    app_date,
    description,
    type,
    Null                          odtype,
    Null                          hh,
    Null                          mm,
    Null                          hh1,
    Null                          mm1,
    Null                          reason,
    Null                          lead_apprl,
    Null                          bdate,
    Null                          edate,
    'NA'                          As lead_apprldesc,
    'Apprd'                       As hod_apprldesc,
    'Apprd'                       As hrd_apprldesc,
    ' '                           As lead_apprl_empno,
    ' '                           As lead_reason,
    ' '                           As hodreason,
    ' '                           As hrdreason,
    1                             As hod_apprl,
    1                             As hrd_apprl,
    'OD'                          fromtab,
    0                             can_delete_app
From
    ss_onduty a
Where
    app_no Not In (
        Select
            app_no
        From
            ss_ondutyapp
    );
---------------------------
--New VIEW
--DM_VU_DESK_LOCK
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_VU_DESK_LOCK" 
 ( "UNQID", "EMPNO", "DESKID", "TARGETDESK", "BLOCKFLAG", "BLOCKREASON", "REASON_DESC"
  )  AS 
  select "UNQID","EMPNO","DESKID","TARGETDESK","BLOCKFLAG","BLOCKREASON","REASON_DESC" from dms.dm_vu_desk_lock;
---------------------------
--Changed VIEW
--DM_VU_DESK_AREAS
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_VU_DESK_AREAS" 
 ( "AREA_KEY_ID", "AREA_DESC", "AREA_CATG_CODE", "AREA_INFO"
  )  AS 
  SELECT 
    "AREA_KEY_ID","AREA_DESC","AREA_CATG_CODE","AREA_INFO"
FROM 
    
dms.dm_desk_areas;
---------------------------
--New INDEX
--SWP_SMART_ATTENDANCE_PLAN_UK1
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SWP_SMART_ATTENDANCE_PLAN_UK1" ON "SELFSERVICE"."SWP_SMART_ATTENDANCE_PLAN" ("ATTENDANCE_DATE","DESKID");
---------------------------
--New INDEX
--SWP_DESK_AREA_MAPPING_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SWP_DESK_AREA_MAPPING_PK" ON "SELFSERVICE"."SWP_DESK_AREA_MAPPING" ("KYE_ID");
---------------------------
--New INDEX
--SS_DELEGATE_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_DELEGATE_PK" ON "SELFSERVICE"."SS_DELEGATE" ("EMPNO");
---------------------------
--Changed TRIGGER
--SS_TRIG_ONDUTYAPP_UPDATE
---------------------------
  CREATE OR REPLACE TRIGGER "SELFSERVICE"."SS_TRIG_ONDUTYAPP_UPDATE"
  BEFORE UPDATE OF EMPNO, APP_NO, HOD_APPRL, HRD_APPRL, LEAD_APPRL ON "SELFSERVICE"."SS_ONDUTYAPP"
  REFERENCING FOR EACH ROW
  begin
    if nvl(:new.hod_apprl,ss.pending) = ss.disapproved or nvl(:new.hrd_apprl,ss.pending) = ss.disapproved or nvl(:new.lead_apprl,ss.pending
    ) = ss.disapproved then
        insert into ss_ondutyapp_rejected (
            empno,
            hh,
            mm,
            pdate,
            dd,
            mon,
            yyyy,
            type,
            app_no,
            description,
            hod_apprl,
            hod_apprl_dt,
            hod_code,
            hrd_apprl,
            hrd_apprl_dt,
            hrd_code,
            app_date,
            hh1,
            mm1,
            reason,
            user_tcp_ip,
            hod_tcp_ip,
            hrd_tcp_ip,
            hodreason,
            hrdreason,
            odtype,
            lead_apprl,
            lead_code,
            lead_apprl_dt,
            lead_tcp_ip,
            lead_reason,
            lead_apprl_empno,
            rejected_on
        ) values (
            :old.empno,
            :old.hh,
            :old.mm,
            :old.pdate,
            :old.dd,
            :old.mon,
            :old.yyyy,
            :old.type,
            :old.app_no,
            :old.description,
            :new.hod_apprl,
            :old.hod_apprl_dt,
            :old.hod_code,
            :new.hrd_apprl,
            :old.hrd_apprl_dt,
            :old.hrd_code,
            :old.app_date,
            :old.hh1,
            :old.mm1,
            :old.reason,
            :old.user_tcp_ip,
            :old.hod_tcp_ip,
            :old.hrd_tcp_ip,
            :old.hodreason,
            :old.hrdreason,
            :old.odtype,
            :new.lead_apprl,
            :old.lead_code,
            :old.lead_apprl_dt,
            :old.lead_tcp_ip,
            :old.lead_reason,
            :old.lead_apprl_empno,
            sysdate
        );

        null;
    end if;
end;
/
  ALTER TRIGGER "SELFSERVICE"."SS_TRIG_ONDUTYAPP_UPDATE" DISABLE;
/
---------------------------
--Changed TRIGGER
--SS_TRIG_ONDUTYAPP_DELETE
---------------------------
  CREATE OR REPLACE TRIGGER "SELFSERVICE"."SS_TRIG_ONDUTYAPP_DELETE"
  BEFORE DELETE ON "SELFSERVICE"."SS_ONDUTYAPP"
  REFERENCING FOR EACH ROW
  Begin
    If (nvl(:old.hod_apprl, 0) != ss.disapproved And nvl(:old.hrd_apprl, 0) != ss.disapproved And nvl(:old.lead_apprl, 0) !=
    ss.disapproved) Then
        Insert Into ss_ondutyapp_deleted (
            empno,
            hh,
            mm,
            pdate,
            dd,
            mon,
            yyyy,
            type,
            app_no,
            description,
            hod_apprl,
            hod_apprl_dt,
            hod_code,
            hrd_apprl,
            hrd_apprl_dt,
            hrd_code,
            app_date,
            hh1,
            mm1,
            reason,
            user_tcp_ip,
            hod_tcp_ip,
            hrd_tcp_ip,
            hodreason,
            hrdreason,
            odtype,
            lead_apprl,
            lead_code,
            lead_apprl_dt,
            lead_tcp_ip,
            lead_reason,
            lead_apprl_empno,
            deleted_on
        )
        Values(
            :old.empno,
            :old.hh,
            :old.mm,
            :old.pdate,
            :old.dd,
            :old.mon,
            :old.yyyy,
            :old.type,
            :old.app_no,
            :old.description,
            :old.hod_apprl,
            :old.hod_apprl_dt,
            :old.hod_code,
            :old.hrd_apprl,
            :old.hrd_apprl_dt,
            :old.hrd_code,
            :old.app_date,
            :old.hh1,
            :old.mm1,
            :old.reason,
            :old.user_tcp_ip,
            :old.hod_tcp_ip,
            :old.hrd_tcp_ip,
            :old.hodreason,
            :old.hrdreason,
            :old.odtype,
            :old.lead_apprl,
            :old.lead_code,
            :old.lead_apprl_dt,
            :old.lead_tcp_ip,
            :old.lead_reason,
            :old.lead_apprl_empno,
            sysdate
        );
    End If;
End;
/
---------------------------
--Changed TRIGGER
--SS_TRIG_LEAVE_APP_REJECT
---------------------------
  CREATE OR REPLACE TRIGGER "SELFSERVICE"."SS_TRIG_LEAVE_APP_REJECT"
  BEFORE UPDATE OF APP_NO, HOD_APPRL, HRD_APPRL, LEAD_APPRL ON "SELFSERVICE"."SS_LEAVEAPP"
  REFERENCING FOR EACH ROW
  begin
    if nvl(:new.hod_apprl,ss.pending) = ss.disapproved or nvl(:new.hrd_apprl,ss.pending) = ss.disapproved or nvl(:new.lead_apprl,ss.pending
    ) = ss.disapproved then
        insert into ss_leaveapp_rejected (
            app_no,
            empno,
            app_date,
            rep_to,
            projno,
            caretaker,
            leaveperiod,
            leavetype,
            bdate,
            edate,
            reason,
            mcert,
            work_ldate,
            resm_date,
            contact_add,
            contact_phn,
            contact_std,
            last_hrs,
            last_mn,
            resm_hrs,
            resm_mn,
            dataentryby,
            office,
            hod_apprl,
            hod_apprl_dt,
            hod_code,
            hrd_apprl,
            hrd_apprl_dt,
            hrd_code,
            discrepancy,
            user_tcp_ip,
            hod_tcp_ip,
            hrd_tcp_ip,
            hodreason,
            hrdreason,
            hd_date,
            hd_part,
            lead_apprl,
            lead_apprl_dt,
            lead_code,
            lead_tcp_ip,
            lead_apprl_empno,
            lead_reason,
            rejected_on,
            is_covid_sick_leave,
            med_cert_file_name
        ) values (
            :old.app_no,
            :old.empno,
            :old.app_date,
            :old.rep_to,
            :old.projno,
            :old.caretaker,
            :old.leaveperiod,
            :old.leavetype,
            :old.bdate,
            :old.edate,
            :old.reason,
            :old.mcert,
            :old.work_ldate,
            :old.resm_date,
            :old.contact_add,
            :old.contact_phn,
            :old.contact_std,
            :old.last_hrs,
            :old.last_mn,
            :old.resm_hrs,
            :old.resm_mn,
            :old.dataentryby,
            :old.office,
            :new.hod_apprl,
            :old.hod_apprl_dt,
            :old.hod_code,
            :new.hrd_apprl,
            :old.hrd_apprl_dt,
            :old.hrd_code,
            :old.discrepancy,
            :old.user_tcp_ip,
            :old.hod_tcp_ip,
            :old.hrd_tcp_ip,
            :old.hodreason,
            :old.hrdreason,
            :old.hd_date,
            :old.hd_part,
            :new.lead_apprl,
            :old.lead_apprl_dt,
            :old.lead_code,
            :old.lead_tcp_ip,
            :old.lead_apprl_empno,
            :old.lead_reason,
            sysdate,
            :old.is_covid_sick_leave,
            :old.med_cert_file_name
        );

        null;
    end if;
end;
/
  ALTER TRIGGER "SELFSERVICE"."SS_TRIG_LEAVE_APP_REJECT" DISABLE;
/
---------------------------
--Changed TRIGGER
--SS_TRIG_LEAVE_APP_DEL
---------------------------
  CREATE OR REPLACE TRIGGER "SELFSERVICE"."SS_TRIG_LEAVE_APP_DEL"
  BEFORE DELETE ON "SELFSERVICE"."SS_LEAVEAPP"
  REFERENCING FOR EACH ROW
  Begin
    If (nvl(:old.hod_apprl, 0) != ss.disapproved And nvl(:old.hrd_apprl, 0) != ss.disapproved And nvl(:old.lead_apprl, 0) !=
            ss.disapproved)
    Then

        Insert Into ss_leaveapp_deleted (
            app_no,
            empno,
            app_date,
            rep_to,
            projno,
            caretaker,
            leaveperiod,
            leavetype,
            bdate,
            edate,
            reason,
            mcert,
            work_ldate,
            resm_date,
            contact_add,
            contact_phn,
            contact_std,
            last_hrs,
            last_mn,
            resm_hrs,
            resm_mn,
            dataentryby,
            office,
            hod_apprl,
            hod_apprl_dt,
            hod_code,
            hrd_apprl,
            hrd_apprl_dt,
            hrd_code,
            discrepancy,
            user_tcp_ip,
            hod_tcp_ip,
            hrd_tcp_ip,
            hodreason,
            hrdreason,
            hd_date,
            hd_part,
            lead_apprl,
            lead_apprl_dt,
            lead_code,
            lead_tcp_ip,
            lead_apprl_empno,
            lead_reason,
            deleted_on,
            is_covid_sick_leave,
            med_cert_file_name
        )
        Values(
            :old.app_no,
            :old.empno,
            :old.app_date,
            :old.rep_to,
            :old.projno,
            :old.caretaker,
            :old.leaveperiod,
            :old.leavetype,
            :old.bdate,
            :old.edate,
            :old.reason,
            :old.mcert,
            :old.work_ldate,
            :old.resm_date,
            :old.contact_add,
            :old.contact_phn,
            :old.contact_std,
            :old.last_hrs,
            :old.last_mn,
            :old.resm_hrs,
            :old.resm_mn,
            :old.dataentryby,
            :old.office,
            :old.hod_apprl,
            :old.hod_apprl_dt,
            :old.hod_code,
            :old.hrd_apprl,
            :old.hrd_apprl_dt,
            :old.hrd_code,
            :old.discrepancy,
            :old.user_tcp_ip,
            :old.hod_tcp_ip,
            :old.hrd_tcp_ip,
            :old.hodreason,
            :old.hrdreason,
            :old.hd_date,
            :old.hd_part,
            :old.lead_apprl,
            :old.lead_apprl_dt,
            :old.lead_code,
            :old.lead_tcp_ip,
            :old.lead_apprl_empno,
            :old.lead_reason,
            sysdate,
            :old.is_covid_sick_leave,
            :old.med_cert_file_name
        );
    End If;
End;
/
---------------------------
--Changed TRIGGER
--SS_TRIG_DEPU_UPDATE
---------------------------
  CREATE OR REPLACE TRIGGER "SELFSERVICE"."SS_TRIG_DEPU_UPDATE"
  BEFORE UPDATE OF APP_NO, HOD_APPRL, HRD_APPRL, LEAD_APPRL ON "SELFSERVICE"."SS_DEPU"
  REFERENCING FOR EACH ROW
  begin if nvl(:new.hod_apprl,ss.pending) = ss.disapproved or nvl(:new.hrd_apprl,ss.pending) = ss.disapproved or nvl(:new.lead_apprl
   ,ss.pending) = ss.disapproved then
    insert into ss_depu_rejected (
        empno,
        app_no,
        bdate,
        edate,
        description,
        type,
        hod_apprl,
        hod_apprl_dt,
        hod_code,
        hrd_apprl,
        hrd_apprl_dt,
        hrd_code,
        app_date,
        reason,
        user_tcp_ip,
        hod_tcp_ip,
        hrd_tcp_ip,
        hodreason,
        hrdreason,
        chg_no,
        chg_date,
        lead_apprl,
        lead_apprl_dt,
        lead_code,
        lead_tcp_ip,
        lead_reason,
        lead_apprl_empno,
        chg_by,
        site_code,
        rejected_on
    ) values (
        :old.empno,
        :old.app_no,
        :old.bdate,
        :old.edate,
        :old.description,
        :old.type,
        :new.hod_apprl,
        :old.hod_apprl_dt,
        :old.hod_code,
        :new.hrd_apprl,
        :old.hrd_apprl_dt,
        :old.hrd_code,
        :old.app_date,
        :old.reason,
        :old.user_tcp_ip,
        :old.hod_tcp_ip,
        :old.hrd_tcp_ip,
        :old.hodreason,
        :old.hrdreason,
        :old.chg_no,
        :old.chg_date,
        :new.lead_apprl,
        :old.lead_apprl_dt,
        :old.lead_code,
        :old.lead_tcp_ip,
        :old.lead_reason,
        :old.lead_apprl_empno,
        :old.chg_by,
        :old.site_code,
        sysdate
    );
    end
if;

null;

end;
/
---------------------------
--Changed TRIGGER
--SS_TRIG_DEPU_DELETED
---------------------------
  CREATE OR REPLACE TRIGGER "SELFSERVICE"."SS_TRIG_DEPU_DELETED"
  BEFORE DELETE ON "SELFSERVICE"."SS_DEPU"
  REFERENCING FOR EACH ROW
  Begin
    If (nvl(:old.hod_apprl, 0) != ss.disapproved And nvl(:old.hrd_apprl, 0) != ss.disapproved And nvl(:old.lead_apprl, 0) !=
            ss.disapproved)
    Then

        Insert Into ss_depu_deleted (
            empno,
            app_no,
            bdate,
            edate,
            description,
            type,
            hod_apprl,
            hod_apprl_dt,
            hod_code,
            hrd_apprl,
            hrd_apprl_dt,
            hrd_code,
            app_date,
            reason,
            user_tcp_ip,
            hod_tcp_ip,
            hrd_tcp_ip,
            hodreason,
            hrdreason,
            chg_no,
            chg_date,
            lead_apprl,
            lead_apprl_dt,
            lead_code,
            lead_tcp_ip,
            lead_reason,
            lead_apprl_empno,
            chg_by,
            site_code,
            deleted_on
        )
        Values(
            :old.empno,
            :old.app_no,
            :old.bdate,
            :old.edate,
            :old.description,
            :old.type,
            :old.hod_apprl,
            :old.hod_apprl_dt,
            :old.hod_code,
            :old.hrd_apprl,
            :old.hrd_apprl_dt,
            :old.hrd_code,
            :old.app_date,
            :old.reason,
            :old.user_tcp_ip,
            :old.hod_tcp_ip,
            :old.hrd_tcp_ip,
            :old.hodreason,
            :old.hrdreason,
            :old.chg_no,
            :old.chg_date,
            :old.lead_apprl,
            :old.lead_apprl_dt,
            :old.lead_code,
            :old.lead_tcp_ip,
            :old.lead_reason,
            :old.lead_apprl_empno,
            :old.chg_by,
            :old.site_code,
            sysdate);
    End If;
End;
/
---------------------------
--Changed PROCEDURE
--DEL_OD_APP
---------------------------
CREATE OR REPLACE PROCEDURE "SELFSERVICE"."DEL_OD_APP" (
    p_app_no    In Varchar2,
    p_tab_from  In Varchar2,
    p_force_del In Varchar2 Default 'KO'
) As
    v_empno Char(5);
    v_pdate Date;
Begin
    If trim(p_tab_from) = 'DP' Then
        Delete
            From ss_depu
        Where
            app_no = p_app_no;

        If p_force_del = 'OK' Then
            Delete
                From ss_depu_rejected
            Where
                Trim(app_no) = Trim(p_app_no);
        End If;

    Elsif trim(p_tab_from) = 'OD' Then
        Select
        Distinct empno, pdate
        Into
            v_empno, v_pdate
        From
            (
                Select
                Distinct empno, pdate
                From
                    ss_ondutyapp
                Where
                    Trim(app_no) = Trim(p_app_no)
            )
        Where
            Rownum = 1;
        Delete
            From ss_ondutyapp
        Where
            Trim(app_no) = Trim(p_app_no);

        If p_force_del = 'OK' Then
            Delete
                From ss_ondutyapp_rejected
            Where
                Trim(app_no) = Trim(p_app_no);

        End If;

        Delete
            From ss_onduty
        Where
            Trim(app_no) = Trim(p_app_no);
        generate_auto_punch(v_empno, v_pdate);
    End If;
End del_od_app;
/
---------------------------
--Changed PROCEDURE
--DELETELEAVE
---------------------------
CREATE OR REPLACE PROCEDURE "SELFSERVICE"."DELETELEAVE" (
    appnum      In Varchar2,
    p_force_del In Varchar2 Default 'KO'
) Is
    v_count Number := 0;
Begin  
    --check in ss_leaveapp table
    Select
        Count(app_no)
    Into
        v_count
    From
        ss_leaveapp
    Where
        app_no = Trim(appnum);
    If v_count > 0 Then
        Delete
            From ss_leaveapp
        Where
            app_no = Trim(appnum);
    End If;

    If p_force_del = 'OK' Then
        Select
            Count(app_no)
        Into
            v_count
        From
            ss_leaveapp_rejected
        Where
            trim(app_no) = Trim(appnum);

        If v_count > 0 Then
            Delete
                From ss_leaveapp_rejected
            Where
                app_no = Trim(appnum);
        End If;
    End If;
    --check in ss_leaveledg table
    Select
        Count(app_no)
    Into
        v_count
    From
        ss_leaveledg
    Where
        app_no = Trim(appnum);
    If v_count > 0 Then
        Delete
            From ss_leaveledg
        Where
            app_no = Trim(appnum);
    End If;	

    --check in ss_leave_adj table
    Select
        Count(adj_no)
    Into
        v_count
    From
        ss_leave_adj
    Where
        adj_no = Trim(appnum);
    If v_count > 0 Then
        Delete
            From ss_leave_adj
        Where
            adj_no = Trim(appnum);
    End If;

    Select
        Count(new_app_no)
    Into
        v_count
    From
        ss_pl_revision_mast
    Where
        Trim(new_app_no) = Trim(appnum);
    If v_count > 0 Then
        Delete
            From ss_pl_revision_mast
        Where
            Trim(new_app_no) = Trim(appnum);
    End If;

End;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_SELECT_LIST_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_SELECT_LIST_QRY" As

    Function fn_desk_list_for_smart(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date,
        p_empno     Varchar2
    ) Return Sys_Refcursor;

    Function fn_desk_list_for_office(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date Default Null,
        p_empno     Varchar2
    ) Return Sys_Refcursor;

    Function fn_employee_list_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_costcode_list_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

 Function fn_employee_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

 Function fn_grade_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

 Function fn_project_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;
End iot_swp_select_list_qry;
/
---------------------------
--New PACKAGE
--IOT_SWP_DESK_AREA_MAP_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_DESK_AREA_MAP_QRY" As

Function fn_desk_area_map_list(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      P_area        Varchar2 Default Null,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

end IOT_SWP_DESK_AREA_MAP_QRY;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_SMART_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_SMART_WORKSPACE_QRY" As

    c_qry_attendance_planning Varchar2(4200) := ' 
With
    params As (
        Select
            :p_empno As p_empno, :p_row_number As p_row_number, :p_page_length As p_page_length,
            :p_start_date as p_start_date , :p_end_date as p_end_date,:p_meta_id as p_meta_id,
            :p_person_id as p_person_id, :p_assign_code p_assign_code
        From
            dual
    ),
    assign_codes As (select * from(
        Select
            costcode As assign
        From
            ss_costmast, params
        Where
            hod = params.p_empno
        Union
        Select
            parent As assign
        From
            ss_user_dept_rights, params
        Where
            empno = params.p_empno), params where assign = nvl(params.p_assign_code,assign)
    ),
    attend_plan As (
        Select
            empno, attendance_date
        From
            swp_smart_attendance_plan
        Where
            attendance_date In (
                Select
                    d_date
                From
                    ss_days_details, params
                Where
                    d_date Between params.p_start_date And params.p_end_date
            )
            And empno In (
                Select
                    empno
                From
                    ss_emplmast                  ce, assign_codes cac
                Where
                    ce.assign  = cac.assign
                    And status = 1
            )
    )
Select
    full_data.*
From
    (
        Select
            data.*,
            Row_Number() Over(Order By empno) As row_number,
            Count(*) Over()                   As total_row
        From (
        select * from (

                    Select
                        e.empno                          As empno,
                        e.empno || '' - '' || e.name       As employee_name,
                        e.parent                         As parent,
                        e.grade                          As emp_grade,
                        iot_swp_common.get_emp_work_area(params.p_person_id,params.p_meta_id,e.empno) As work_area,
                        e.emptype                        As emptype,
                        e.assign                         As assign,
                        Null                             As pending,
                        to_char(a.attendance_date, ''yyyymmdd'') As d_days
                    From
                        ss_emplmast  e,
                        attend_plan  a,
                        assign_codes ac,
                        params
                    Where
                        e.empno In (
                            select empno from (
                                Select
                                    *
                                From
                                    swp_primary_workspace m
                                Where
                                    start_date =
                                    (
                                        Select
                                            Max(start_date)
                                        From
                                            swp_primary_workspace c,params
                                        Where
                                            c.empno = m.empno
                                            And start_date <= params.p_end_date
                                    )) where primary_workspace=2
                        )
                        And e.assign = ac.assign
                        And e.status = 1
                        And e.empno  = a.empno(+)                

                    )
                    Pivot
                    (
                    Count(d_days)
                    For d_days In (!MON! As mon, !TUE! As tue, !WED! As wed, !THU! As thu,
                    !FRI! As fri)
                    )

            ) data
    ) full_data, params
Where
    row_number Between (nvl(params.p_row_number, 0) + 1) And (nvl(params.p_row_number, 0) + params.p_page_length)';



    Cursor cur_general_area_list(p_office      Varchar2,
                                 p_floor       Varchar2,
                                 p_wing        Varchar2,
                                 p_row_number  Number,
                                 p_page_length Number) Is

        Select
            *
        From
            (
                Select
                Distinct a.office,
                    a.floor,
                    a.wing,
                    a.work_area,
                    a.area_desc,
                    a.area_catg_code,
                    a.total,
                    a.occupied,
                    a.available,
                    Row_Number() Over (Order By office Desc) As row_number,
                    Count(*) Over ()                         As total_row
                From
                    swp_vu_area_list a
                Where
                    a.area_catg_code = 'A002'
                Order By a.area_desc, a.office, a.floor
            )
        Where
            row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

    Cursor cur_restricted_area_list(p_date        Date,
                                    p_office      Varchar2,
                                    p_floor       Varchar2,
                                    p_wing        Varchar2,
                                    p_row_number  Number,
                                    p_page_length Number) Is

        Select
            *
        From
            (
                Select
                Distinct a.office,
                    a.floor,
                    a.wing,
                    a.work_area,
                    a.area_desc,
                    a.area_catg_code,
                    a.total,
                    a.occupied,
                    a.available,
                    Row_Number() Over (Order By office Desc) As row_number,
                    Count(*) Over ()                         As total_row
                From
                    swp_vu_area_list a
                Where
                    a.area_catg_code = 'A003'
                Order By a.area_desc, a.office, a.floor

            )
        Where
            row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

    Type typ_area_list Is Table Of cur_general_area_list%rowtype;

    Function fn_reserved_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_general_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2 Default Null,
        p_date        Date     Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_work_area_desk(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_date        Date,
        p_work_area   Varchar2,
        p_office      Varchar2 Default Null,
        p_floor       Varchar2 Default Null,
        p_wing        Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_restricted_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return typ_area_list
        Pipelined;

    Function fn_emp_week_attend_planning(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2,
        p_date      Date
    ) Return Sys_Refcursor;

    Function fn_week_attend_planning(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date     Default sysdate,
        p_assign_code Varchar2 Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

End iot_swp_smart_workspace_qry;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_OFFICE_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_OFFICE_WORKSPACE_QRY" As

    c_qry_office_planning Varchar2(4000) := ' 

With
    params As (
        Select
            :p_assign_code As p_assign_code,
            :p_row_number  As p_row_number,
            :p_page_length As p_page_length,
            :p_meta_id     As p_meta_id,
            :p_person_id   As p_person_id
        From
            dual
    ),
    last_status As(
        Select
            empno, Max(start_date) start_date
        From
            swp_primary_workspace
        Group By
            empno
    ),
    primary_ws As (
        Select
            pw.*
        From
            swp_primary_workspace pw, last_status
        Where
            pw.empno                 = last_status.empno
            And pw.start_date        = last_status.start_date
            And pw.primary_workspace = 1
    )
Select
    full_data.*
From
    (
        Select
            data.*,
            Row_Number() Over(Order By empno) As row_number,
            Count(*) Over()                   As total_row
        From
            (
                Select
                    *
                From
                    (

                        Select
                            e.empno                                                                         As empno,
                            e.empno || '' - '' || e.name                                                      As employee_name,
                            e.parent                                                                        As parent,
                            e.grade                                                                         As emp_grade,
                            iot_swp_common.get_emp_work_area(params.p_person_id, params.p_meta_id, e.empno) As work_area,
                            e.emptype                                                                       As emptype,
                            e.assign                                                                        As assign,
                            iot_swp_common.get_desk_from_dms(e.empno)                                       As deskid,
                            Null                                                                            As pending,
                            Null                                                                            As d_days
                        From
                            ss_emplmast e,
                            primary_ws  pws,
                            params
                        Where
                            e.assign     = params.p_assign_code
                            And e.status = 1
                            And e.empno  = pws.empno

                    )
            ) data
    ) full_data, params
Where
    row_number Between (nvl(params.p_row_number, 0) + 1) And (nvl(params.p_row_number, 0) + params.p_page_length)';

    Cursor cur_general_area_list(p_office      Varchar2,
                                 p_floor       Varchar2,
                                 p_wing        Varchar2,
                                 p_row_number  Number,
                                 p_page_length Number) Is

        Select
            *
        From
            (
                Select
                Distinct a.office,
                    a.floor,
                    a.wing,
                    a.work_area,
                    a.area_desc,
                    a.area_catg_code,
                    a.total,
                    a.occupied,
                    a.available,
                    Row_Number() Over (Order By office Desc) As row_number,
                    Count(*) Over ()                         As total_row
                From
                    swp_vu_area_list a
                Where
                    a.area_catg_code = 'A002'
                Order By a.area_desc, a.office, a.floor                 
            /*
             From SWP_VU_AREA_LIST a
              Where a.AREA_CATG_CODE = 'KO'
                And Trim(a.office) = Trim(p_office)
                And Trim(a.floor) = Trim(p_floor)
              Order By a.area_desc, a.office, a.floor
            */
            )
        Where
            row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

    Type typ_area_list Is Table Of cur_general_area_list%rowtype;

    Function fn_office_planning(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date,
        p_assign_code Varchar2 Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_general_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2 Default Null,
        p_date        Date     Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_work_area_desk(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_date        Date,
        p_work_area   Varchar2,
        p_office      Varchar2 Default Null,
        p_floor       Varchar2 Default Null,
        p_wing        Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

End iot_swp_office_workspace_qry;
/
---------------------------
--Changed PACKAGE
--IOT_LEAVE
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_LEAVE" As

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;

    Procedure sp_validate_new_leave(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_leave_type         Varchar2,
        p_start_date         Date,
        p_end_date           Date,
        p_half_day_on        Number,

        p_leave_period   Out Number,
        p_last_reporting Out Varchar2,
        p_resuming       Out Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2

    );

    Procedure sp_validate_pl_revision(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_application_id     Varchar2,
        p_leave_type         Varchar2,
        p_start_date         Date,
        p_end_date           Date,
        p_half_day_on        Number,

        p_leave_period   Out Number,
        p_last_reporting Out Varchar2,
        p_resuming       Out Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2

    );

    Procedure sp_pl_revision_save(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_application_id         Varchar2,
        p_start_date             Date,
        p_end_date               Date,
        p_half_day_on            Number,
        p_lead_empno             Varchar2,
        p_new_application_id Out Varchar2,
        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    );

    Procedure sp_add_leave_application(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_leave_type             Varchar2,
        p_start_date             Date,
        p_end_date               Date,
        p_half_day_on            Number,
        p_projno                 Varchar2,
        p_care_taker             Varchar2,
        p_reason                 Varchar2,
        p_med_cert_available     Varchar2 Default Null,
        p_contact_address        Varchar2 Default Null,
        p_contact_std            Varchar2 Default Null,
        p_contact_phone          Varchar2 Default Null,
        p_office                 Varchar2,
        p_lead_empno             Varchar2,
        p_discrepancy            Varchar2 Default Null,
        p_med_cert_file_nm       Varchar2 Default Null,

        p_new_application_id Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    );

    Procedure sp_leave_details(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_application_id         Varchar2,

        p_emp_name           Out Varchar2,
        p_leave_type         Out Varchar2,
        p_application_date   Out Varchar2,
        p_start_date         Out Varchar2,
        p_end_date           Out Varchar2,

        p_leave_period       Out Number,
        p_last_reporting     Out Varchar2,
        p_resuming           Out Varchar2,

        p_projno             Out Varchar2,
        p_care_taker         Out Varchar2,
        p_reason             Out Varchar2,
        p_med_cert_available Out Varchar2,
        p_contact_address    Out Varchar2,
        p_contact_std        Out Varchar2,
        p_contact_phone      Out Varchar2,
        p_office             Out Varchar2,
        p_lead_name          Out Varchar2,
        p_discrepancy        Out Varchar2,
        p_med_cert_file_nm   Out Varchar2,

        p_lead_approval      Out Varchar2,
        p_hod_approval       Out Varchar2,
        p_hr_approval        Out Varchar2,

        p_lead_reason        Out Varchar2,
        p_hod_reason         Out Varchar2,
        p_hr_reason          Out Varchar2,

        p_flag_is_adj        Out Varchar2,
        p_flag_can_del       Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    );

    Procedure sp_delete_leave_app(
        p_person_id                  Varchar2,
        p_meta_id                    Varchar2,

        p_application_id             Varchar2,

        p_medical_cert_file_name Out Varchar2,
        p_message_type           Out Varchar2,
        p_message_text           Out Varchar2
    );

    Procedure sp_delete_leave_app_force(
        p_person_id                  Varchar2,
        p_meta_id                    Varchar2,

        p_application_id             Varchar2,

        p_medical_cert_file_name Out Varchar2,
        p_message_type           Out Varchar2,
        p_message_text           Out Varchar2
    );

    Procedure sp_leave_balances(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2 Default Null,
        p_start_date       Date     Default Null,
        p_end_date         Date     Default Null,

        p_open_cl      Out Varchar2,
        p_open_sl      Out Varchar2,
        p_open_pl      Out Varchar2,
        p_open_ex      Out Varchar2,
        p_open_co      Out Varchar2,
        p_open_oh      Out Varchar2,
        p_open_lv      Out Varchar2,

        p_close_cl     Out Varchar2,
        p_close_sl     Out Varchar2,
        p_close_pl     Out Varchar2,
        p_close_ex     Out Varchar2,
        p_close_co     Out Varchar2,
        p_close_oh     Out Varchar2,
        p_close_lv     Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_leave_approval_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_leave_approval_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_leave_approval_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );
End iot_leave;
/
---------------------------
--New PACKAGE
--IOT_SWP_DESK_AREA_MAP
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_DESK_AREA_MAP" As

   Procedure sp_add_desk_area(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_deskid           Varchar2,
      p_area             Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   );

   Procedure sp_update_desk_area(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_application_id   Varchar2,
      p_deskid           Varchar2,
      p_area             Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   );

   Procedure sp_delete_desk_area(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_application_id   Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   );

End IOT_SWP_DESK_AREA_MAP;
/
---------------------------
--Changed PACKAGE
--IOT_LEAVE_CLAIMS
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_LEAVE_CLAIMS" As

    half_day_on_none Constant Number := 0;
    hd_bdate_presnt_part_2 Constant Number := 2;
    hd_edate_presnt_part_1 Constant Number := 1;

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;

    Type rec_claim Is Record(
            empno        Char(5),
            leave_type   Char(2),
            leave_period Number,
            start_date   Date,
            end_date     Date,
            half_day_on  Number,
            reason       Varchar2(30)
        );
    Type typ_tab_claims Is Table Of rec_claim Index By Binary_Integer;

    Procedure sp_add_leave_claim(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_leave_type       Varchar2,
        p_leave_period     Number,
        p_start_date       Date,
        p_end_date         Date,
        p_half_day_on      Number,
        p_description      Varchar2,
        p_med_cert_file_nm Varchar2 Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2

    );

    Procedure sp_import(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_leave_claims           typ_tab_string,

        p_leave_claim_errors Out typ_tab_string,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
    );
End iot_leave_claims;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_EMP_PROJ_MAP_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_EMP_PROJ_MAP_QRY" As

Function fn_emp_proj_map_list(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      P_assign_code     Varchar2 Default Null,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

end IOT_SWP_EMP_PROJ_MAP_QRY;
/
---------------------------
--New PACKAGE
--IOT_SWP_EMP_PROJ_MAP
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_EMP_PROJ_MAP" As

   Procedure sp_add_emp_proj(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_empno            Varchar2,
      p_projno           Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   );

   Procedure sp_update_emp_proj(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_application_id   Varchar2,
      p_projno           Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   );

   Procedure sp_delete_emp_proj(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_application_id   Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   );

End IOT_SWP_EMP_PROJ_MAP;
/
---------------------------
--Changed PACKAGE BODY
--IOT_ONDUTY_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_ONDUTY_QRY" As

    Function fn_get_onduty_applications(
        p_empno        Varchar2,
        p_req_for_self Varchar2,
        p_onduty_type  Varchar2 Default Null,
        p_start_date   Date     Default Null,
        p_end_date     Date     Default Null,
        p_row_number   Number,
        p_page_length  Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        a.empno,
                        app_date,
                        to_char(a.app_date, 'dd-Mon-yyyy')      As application_date,
                        a.app_no                                As application_id,
                        a.pdate                                 As application_for_date,
                        a.start_date                            As start_date,
                        description,
                        a.type                                  As onduty_type,
                        get_emp_name(a.lead_apprl_empno)        As lead_name,
                        a.lead_apprldesc                        As lead_approval,
                        hod_apprldesc                           As hod_approval,
                        hrd_apprldesc                           As hr_approval,
                        Case
                            When p_req_for_self = 'OK' Then
                                a.can_delete_app
                            Else
                                0
                        End                                     As can_delete_app,
                        Row_Number() Over (Order By a.start_date desc) As row_number,
                        Count(*) Over ()                        As total_row
                    From
                        ss_vu_od_depu a
                    Where
                        a.empno    = p_empno
                        And a.pdate >= add_months(sysdate, - 24)
                        And a.type = nvl(p_onduty_type, a.type)
                        And a.pdate Between trunc(nvl(p_start_date, a.pdate)) And trunc(nvl(p_end_date, a.pdate))
                    Order By start_date Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                start_date Desc;
        Return c;

    End;

    Function fn_onduty_applications_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_onduty_type Varchar2 Default Null,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_self_empno         Varchar2(5);
        v_req_for_self       Varchar2(2);
        v_for_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_self_empno := get_empno_from_meta_id(p_meta_id);
        If v_self_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Select
            empno
        Into
            v_for_empno
        From
            ss_emplmast
        Where
            empno      = p_empno;
            --And status = 1;
        If v_self_empno = v_for_empno Then
            v_req_for_self := 'OK';
        Else
            v_req_for_self := 'KO';
        End If;

        c            := fn_get_onduty_applications(v_for_empno, v_req_for_self, p_onduty_type, p_start_date, p_end_date, p_row_number,
                                                   p_page_length);
        Return c;
    End fn_onduty_applications_4_other;

    Function fn_onduty_applications_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_onduty_type Varchar2 Default Null,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        c       := fn_get_onduty_applications(v_empno, 'OK', p_onduty_type, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;

    End fn_onduty_applications_4_self;

    Function fn_pending_lead_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_lead_empno         Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_lead_empno := get_empno_from_meta_id(p_meta_id);
        If v_lead_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        to_char(a.app_date, 'dd-Mon-yyyy')      As application_date,
                        a.app_no                                As application_id,
                        to_char(bdate, 'dd-Mon-yyyy')           As start_date,
                        to_char(edate, 'dd-Mon-yyyy')           As end_date,
                        type                                    As onduty_type,
                        dm_get_emp_office(a.empno)              As office,
                        a.empno || ' - ' || name                As emp_name,
                        a.empno                                 As emp_no,
                        parent                                  As parent,
                        getempname(lead_apprl_empno)            As lead_name,
                        lead_reason                             As lead_remarks,
                        Row_Number() Over (Order By a.app_date) As row_number,
                        Count(*) Over ()                        As total_row
                    From
                        ss_odapprl  a,
                        ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0)    = 0)
                        And a.empno            = e.empno
                        And e.status           = 1
                        And a.lead_apprl_empno = Trim(v_lead_empno)
                    Order By parent, a.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_lead_approval;

    Function fn_pending_hod_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hod_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_hod_empno := get_empno_from_meta_id(p_meta_id);
        If v_hod_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        to_char(a.app_date, 'dd-Mon-yyyy')      As application_date,
                        a.app_no                                As application_id,
                        to_char(bdate, 'dd-Mon-yyyy')           As start_date,
                        to_char(edate, 'dd-Mon-yyyy')           As end_date,
                        type                                    As onduty_type,
                        dm_get_emp_office(a.empno)              As office,
                        a.empno || ' - ' || name                As emp_name,
                        a.empno                                 As emp_no,
                        parent                                  As parent,
                        getempname(lead_apprl_empno)            As lead_name,
                        hodreason                               As hod_remarks,
                        Row_Number() Over (Order By a.app_date) As row_number,
                        Count(*) Over ()                        As total_row
                    From
                        ss_odapprl  a,
                        ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0) In (1, 4))
                        And (nvl(hod_apprl, 0) = 0)
                        And a.empno            = e.empno
                        And e.status           = 1
                        And e.mngr             = Trim(v_hod_empno)

                    Order By parent, a.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_hod_approval;

    Function fn_pending_onbehalf_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hod_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_hod_empno := get_empno_from_meta_id(p_meta_id);
        If v_hod_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        to_char(a.app_date, 'dd-Mon-yyyy')      As application_date,
                        a.app_no                                As application_id,
                        to_char(bdate, 'dd-Mon-yyyy')           As start_date,
                        to_char(edate, 'dd-Mon-yyyy')           As end_date,
                        type                                    As onduty_type,
                        dm_get_emp_office(a.empno)              As office,
                        a.empno || ' - ' || name                As emp_name,
                        a.empno                                 As emp_no,
                        parent                                  As parent,
                        getempname(lead_apprl_empno)            As lead_name,
                        hodreason                               As hod_remarks,
                        Row_Number() Over (Order By a.app_date) As row_number,
                        Count(*) Over ()                        As total_row
                    From
                        ss_odapprl  a,
                        ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0) In (1, 4))
                        And (nvl(hod_apprl, 0) = 0)
                        And a.empno            = e.empno
                        And e.status           = 1
                        And e.mngr In (
                            Select
                                mngr
                            From
                                ss_delegate
                            Where
                                empno = Trim(v_hod_empno)
                        )
                    Order By parent, a.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_onbehalf_approval;

    Function fn_pending_hr_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin

        Open c For
            Select
                *
            From
                (
                    Select
                        to_char(a.app_date, 'dd-Mon-yyyy')             As application_date,
                        a.app_no                                       As application_id,
                        to_char(bdate, 'dd-Mon-yyyy')                  As start_date,
                        to_char(edate, 'dd-Mon-yyyy')                  As end_date,
                        type                                           As onduty_type,
                        dm_get_emp_office(a.empno)                     As office,
                        a.empno || ' - ' || name                       As emp_name,
                        a.empno                                        As emp_no,
                        parent                                         As parent,
                        getempname(lead_apprl_empno)                   As lead_name,
                        hrdreason                                      As hr_remarks,
                        Row_Number() Over (Order By e.parent, e.empno) As row_number,
                        Count(*) Over ()                               As total_row
                    From
                        ss_odapprl  a,
                        ss_emplmast e
                    Where
                        (nvl(hod_apprl, 0)     = 1)
                        And a.empno            = e.empno
                        And e.status           = 1
                        And (nvl(hrd_apprl, 0) = 0)
                    Order By e.parent, e.empno Asc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_hr_approval;

End iot_onduty_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_LEAVE_CLAIMS_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_LEAVE_CLAIMS_QRY" As

    Function fn_leave_claims(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
        p_leave_type  Varchar2 Default Null,
        p_empno       Varchar2 Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        la.empno,
                        get_emp_name(la.empno)                                As employee_name,
                        e.parent,
                        la.adj_no                                             As application_id,
                        la.leavetype                                          As leave_type,
                        la.db_cr,
                        la.adj_dt                                             As application_date,
                        la.bdate                                              As start_date,
                        la.edate                                              As end_date,
                        to_days(la.leaveperiod)                               As leave_period,
                        la.med_cert_file_name                                 As med_cert_file_name,
                        --la.entry_date                                         As application_date,
                        Row_Number() Over (Order By la.adj_dt Desc, la.adj_no) As row_number,
                        Count(*) Over ()                                      As total_row
                    From
                        ss_leave_adj la,
                        ss_emplmast  e
                    Where
                        la.empno        = e.empno
                        And la.adj_type = 'LC'
                        And la.db_cr    = 'D'
                        And la.bdate >= add_months(sysdate, - 24)
                        And trunc(la.adj_dt) Between nvl(p_start_date, trunc(la.adj_dt)) And nvl(p_end_date, trunc(la.adj_dt))
                        And la.empno    = nvl(p_empno, la.empno)
                        And leavetype   = nvl(p_leave_type, leavetype)

                    Order By adj_dt Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End;

End iot_leave_claims_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_ONDUTY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_ONDUTY" As

    Procedure sp_onduty_details(
        p_application_id      Varchar2,

        p_emp_name        Out Varchar2,

        p_onduty_type     Out Varchar2,
        p_onduty_sub_type Out Varchar2,
        p_start_date      Out Varchar2,
        p_end_date        Out Varchar2,

        p_hh1             Out Varchar2,
        p_mi1             Out Varchar2,
        p_hh2             Out Varchar2,
        p_mi2             Out Varchar2,

        p_reason          Out Varchar2,
        p_lead_name       Out Varchar2,
        p_lead_approval   Out Varchar2,
        p_hod_approval    Out Varchar2,
        p_hr_approval     Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As

        v_onduty_app ss_vu_ondutyapp%rowtype;
        v_depu       ss_vu_depu%rowtype;
        v_empno      Varchar2(5);
        v_count      Number;

    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_vu_ondutyapp
        Where
            Trim(app_no) = Trim(p_application_id);
        If v_count = 1 Then
            Select
                *
            Into
                v_onduty_app
            From
                ss_vu_ondutyapp
            Where
                Trim(app_no) = Trim(p_application_id);
        Else
            Select
                Count(*)
            Into
                v_count
            From
                ss_vu_depu
            Where
                Trim(app_no) = Trim(p_application_id);

            If v_count = 1 Then
                Select
                    *
                Into
                    v_depu
                From
                    ss_vu_depu
                Where
                    Trim(app_no) = Trim(p_application_id);
            End If;
        End If;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;
        If v_onduty_app.empno Is Not Null Then
            Select
                description
            Into
                p_onduty_type
            From
                ss_ondutymast
            Where
                type = v_onduty_app.type;
            p_onduty_type   := v_onduty_app.type || ' - ' || p_onduty_type;
            If nvl(v_onduty_app.odtype, 0) <> 0 Then
                Select
                    description
                Into
                    p_onduty_sub_type
                From
                    ss_onduty_sub_type
                Where
                    od_sub_type = v_onduty_app.odtype;
                p_onduty_sub_type := v_onduty_app.odtype || ' - ' || p_onduty_sub_type;
            End If;

            p_emp_name      := get_emp_name(v_onduty_app.empno);
            p_start_date    := v_onduty_app.pdate;
            p_hh1           := lpad(v_onduty_app.hh, 2, '0');
            p_mi1           := lpad(v_onduty_app.mm, 2, '0');
            p_hh2           := lpad(v_onduty_app.hh1, 2, '0');
            p_mi2           := lpad(v_onduty_app.mm1, 2, '0');
            p_reason        := v_onduty_app.reason;

            p_lead_name     := get_emp_name(v_onduty_app.lead_apprl_empno);
            p_lead_approval := v_onduty_app.lead_apprldesc;
            p_hod_approval  := v_onduty_app.hod_apprldesc;
            p_hr_approval   := v_onduty_app.hrd_apprldesc;

        Elsif v_depu.empno Is Not Null Then

            Select
                description
            Into
                p_onduty_type
            From
                ss_ondutymast
            Where
                type = v_depu.type;
            p_onduty_type   := v_depu.type || ' - ' || p_onduty_type;

            p_emp_name      := get_emp_name(v_depu.empno);

            p_onduty_type   := v_depu.type || ' - ' || p_onduty_type;
            p_start_date    := v_depu.bdate;
            p_end_date      := v_depu.edate;
            p_reason        := v_depu.reason;

            Select
                description
            Into
                p_onduty_type
            From
                ss_ondutymast
            Where
                type = v_depu.type;
            p_onduty_type   := v_depu.type || ' - ' || p_onduty_type;

            p_emp_name      := get_emp_name(v_depu.empno);
            p_lead_name     := get_emp_name(v_depu.lead_apprl_empno);

            p_lead_approval := v_depu.lead_apprldesc;
            p_hod_approval  := v_depu.hod_apprldesc;
            p_hr_approval   := v_depu.hrd_apprldesc;

        End If;

        p_message_type := 'OK';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_add_punch_entry(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_hh1              Varchar2,
        p_mi1              Varchar2,
        p_hh2              Varchar2 Default Null,
        p_mi2              Varchar2 Default Null,
        p_date             Date,
        p_type             Varchar2,
        p_sub_type         Varchar2 Default Null,
        p_lead_approver    Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_entry_by_empno Varchar2(5);
        v_count          Number;
        v_lead_approval  Number := 0;
        v_hod_approval   Number := 0;
        v_desc           Varchar2(60);
    Begin
        v_entry_by_empno := get_empno_from_meta_id(p_meta_id);
        If v_entry_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        od.add_onduty_type_1(
            p_empno         => p_empno,
            p_od_type       => p_type,
            p_od_sub_type   => nvl(Trim(p_sub_type), 0),
            p_pdate         => to_char(p_date, 'yyyymmdd'),
            p_hh            => to_number(Trim(p_hh1)),
            p_mi            => to_number(Trim(p_mi1)),
            p_hh1           => to_number(Trim(p_hh2)),
            p_mi1           => to_number(Trim(p_mi2)),
            p_lead_approver => p_lead_approver,
            p_reason        => p_reason,
            p_entry_by      => v_entry_by_empno,
            p_user_ip       => Null,
            p_success       => p_message_type,
            p_message       => p_message_text
        );

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_punch_entry;

    Procedure sp_add_depu_tour(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_start_date       Date,
        p_end_date         Date,
        p_type             Varchar2,
        p_lead_approver    Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_entry_by_empno Varchar2(5);
        v_count          Number;

    Begin
        v_entry_by_empno := get_empno_from_meta_id(p_meta_id);
        If v_entry_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        od.add_onduty_type_2(
            p_empno         => p_empno,
            p_od_type       => p_type,
            p_b_yyyymmdd    => to_char(p_start_date, 'yyyymmdd'),
            p_e_yyyymmdd    => to_char(p_end_date, 'yyyymmdd'),
            p_entry_by      => v_entry_by_empno,
            p_lead_approver => p_lead_approver,
            p_user_ip       => Null,
            p_reason        => p_reason,
            p_success       => p_message_type,
            p_message       => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_depu_tour;

    Procedure sp_extend_depu(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,
        p_end_date         Date,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_entry_by_empno Varchar2(5);
        v_count          Number;
        rec_depu         ss_depu%rowtype;
    Begin
        Select
            *
        Into
            rec_depu
        From
            ss_depu
        Where
            Trim(app_no) = Trim(p_application_id);
        If rec_depu.edate > p_end_date Then
            p_message_type := 'KO';
            p_message_text := 'Extension end date should be greater than existing end date.';
            Return;
        End If;
        sp_add_depu_tour(
            p_person_id     => p_person_id,
            p_meta_id       => p_meta_id,

            p_empno         => rec_depu.empno,
            p_start_date    => rec_depu.edate + 1,
            p_end_date      => p_end_date,
            p_type          => rec_depu.type,
            p_lead_approver => 'None',
            p_reason        => p_reason,

            p_message_type  => p_message_type,
            p_message_text  => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;

    --
    Procedure sp_delete_od_app_4_self(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count    Number;
        v_empno    Varchar2(5);
        v_tab_from Varchar2(2);
    Begin
        v_count        := 0;
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_ondutyapp
        Where
            Trim(app_no) = Trim(p_application_id)
            And empno    = v_empno;
        If v_count = 1 Then
            v_tab_from := 'OD';
        Else
            Select
                Count(*)
            Into
                v_count
            From
                ss_depu
            Where
                Trim(app_no) = Trim(p_application_id)
                And empno    = v_empno;
            If v_count = 1 Then
                v_tab_from := 'DP';
            End If;
        End If;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;
        del_od_app(p_app_no   => p_application_id,
                   p_tab_from => v_tab_from);
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_od_app_4_self;

    Procedure sp_delete_od_app_force(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,
        p_empno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count      Number;
        v_self_empno Varchar2(5);

        v_tab_from   Varchar2(2);
    Begin
        v_count        := 0;
        v_self_empno   := get_empno_from_meta_id(p_meta_id);
        If v_self_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_vu_ondutyapp
        Where
            Trim(app_no) = Trim(p_application_id)
            And empno    = p_empno;
        If v_count = 1 Then
            v_tab_from := 'OD';
        Else
            Select
                Count(*)
            Into
                v_count
            From
                ss_vu_depu
            Where
                Trim(app_no) = Trim(p_application_id)
                And empno    = p_empno;
            If v_count = 1 Then
                v_tab_from := 'DP';
            End If;
        End If;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;
        del_od_app(
            p_app_no    => p_application_id,
            p_tab_from  => v_tab_from,
            p_force_del => 'OK'
        );
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_od_app_force;

    Procedure sp_onduty_application_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_application_id      Varchar2,

        p_emp_name        Out Varchar2,

        p_onduty_type     Out Varchar2,
        p_onduty_sub_type Out Varchar2,
        p_start_date      Out Varchar2,
        p_end_date        Out Varchar2,

        p_hh1             Out Varchar2,
        p_mi1             Out Varchar2,
        p_hh2             Out Varchar2,
        p_mi2             Out Varchar2,

        p_reason          Out Varchar2,

        p_lead_name       Out Varchar2,
        p_lead_approval   Out Varchar2,
        p_hod_approval    Out Varchar2,
        p_hr_approval     Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_count    Number;
        v_empno    Varchar2(5);
        v_tab_from Varchar2(2);
    Begin
        v_count := 0;
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        sp_onduty_details(
            p_application_id  => p_application_id,

            p_emp_name        => p_emp_name,

            p_onduty_type     => p_onduty_type,
            p_onduty_sub_type => p_onduty_sub_type,
            p_start_date      => p_start_date,
            p_end_date        => p_end_date,

            p_hh1             => p_hh1,
            p_mi1             => p_mi1,
            p_hh2             => p_hh2,
            p_mi2             => p_mi2,

            p_reason          => p_reason,

            p_lead_name       => p_lead_name,
            p_lead_approval   => p_lead_approval,
            p_hod_approval    => p_hod_approval,
            p_hr_approval     => p_hr_approval,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text

        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_onduty_approval(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,
        p_approver_profile Number,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_app_no         Varchar2(70);
        v_approval       Number;
        v_remarks        Varchar2(70);
        c_onduty         Constant Varchar2(2) := 'OD';
        c_deputation     Constant Varchar2(2) := 'DP';
        v_count          Number;
        v_rec_count      Number;
        sqlpartod        Varchar2(60)         := 'Update SS_OnDutyApp ';
        sqlpartdp        Varchar2(60)         := 'Update SS_Depu ';
        sqlpart2         Varchar2(500);
        strsql           Varchar2(600);
        v_odappstat_rec  ss_odappstat%rowtype;
        v_approver_empno Varchar2(5);
        v_user_tcp_ip    Varchar2(30);
        v_msg_type       Varchar2(10);
        v_msg_text       Varchar2(1000);
    Begin

        v_approver_empno := get_empno_from_meta_id(p_meta_id);
        If v_approver_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        sqlpart2         := ' set ApproverProfile_APPRL = :Approval, ApproverProfile_Code = :Approver_EmpNo, ApproverProfile_APPRL_DT = Sysdate,
                    ApproverProfile_TCP_IP = :User_TCP_IP , ApproverProfileREASON = :Reason where App_No = :paramAppNo';
        If p_approver_profile = user_profile.type_hod Or p_approver_profile = user_profile.type_sec Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HOD');
        Elsif p_approver_profile = user_profile.type_hrd Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HRD');
        Elsif p_approver_profile = user_profile.type_lead Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'LEAD');
        End If;

        For i In 1..p_onduty_approvals.count
        Loop

            With
                csv As (
                    Select
                        p_onduty_approvals(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1))            app_no,
                to_number(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) approval,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3))            remarks
            Into
                v_app_no, v_approval, v_remarks
            From
                csv;

            Select
                *
            Into
                v_odappstat_rec
            From
                ss_odappstat
            Where
                Trim(app_no) = Trim(v_app_no);

            If (v_odappstat_rec.fromtab) = c_deputation Then
                strsql := sqlpartdp || ' ' || sqlpart2;
            Elsif (v_odappstat_rec.fromtab) = c_onduty Then
                strsql := sqlpartod || ' ' || sqlpart2;
            End If;
            /*
            p_message_type := 'OK';
            p_message_text := 'Debug 1 - ' || p_onduty_approvals(i);
            Return;
            */
            strsql := replace(strsql, 'LEADREASON', 'LEAD_REASON');
            Execute Immediate strsql
                Using v_approval, v_approver_empno, v_user_tcp_ip, v_remarks, trim(v_app_no);

            If v_odappstat_rec.fromtab = c_onduty And p_approver_profile = user_profile.type_hrd And v_approval = ss.approved
            Then
                Insert Into ss_onduty value
                (
                    Select
                        empno,
                        hh,
                        mm,
                        pdate,
                        0,
                        dd,
                        mon,
                        yyyy,
                        type,
                        app_no,
                        description,
                        getodhh(app_no, 1),
                        getodmm(app_no, 1),
                        app_date,
                        reason,
                        odtype
                    From
                        ss_ondutyapp
                    Where
                        Trim(app_no)                   = Trim(v_app_no)
                        And nvl(hrd_apprl, ss.pending) = ss.approved
                );

                Insert Into ss_onduty value
                (
                    Select
                        empno,
                        hh1,
                        mm1,
                        pdate,
                        0,
                        dd,
                        mon,
                        yyyy,
                        type,
                        app_no,
                        description,
                        getodhh(app_no, 2),
                        getodmm(app_no, 2),
                        app_date,
                        reason,
                        odtype
                    From
                        ss_ondutyapp
                    Where
                        Trim(app_no)                   = Trim(v_app_no)
                        And (type                      = 'OD'
                            Or type                    = 'IO')
                        And nvl(hrd_apprl, ss.pending) = ss.approved
                );

                If p_approver_profile = user_profile.type_hrd And v_approval = ss.approved Then
                    generate_auto_punch_4od(v_app_no);
                End If;
            Elsif v_approval = ss.disapproved Then

                sp_delete_od_app_force(
                    p_person_id      => p_person_id,
                    p_meta_id        => p_meta_id,

                    p_application_id => Trim(v_app_no),
                    p_empno          => v_odappstat_rec.empno,
                    p_message_type   => v_msg_type,
                    p_message_text   => v_msg_text
                );

            End If;

        End Loop;

        Commit;
        p_message_type   := 'OK';
        p_message_text   := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_onduty_approval_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_onduty_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_onduty_approvals => p_onduty_approvals,
            p_approver_profile => user_profile.type_lead,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_onduty_approval_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_onduty_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_onduty_approvals => p_onduty_approvals,
            p_approver_profile => user_profile.type_hod,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_onduty_approval_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_onduty_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_onduty_approvals => p_onduty_approvals,
            p_approver_profile => user_profile.type_hrd,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

End iot_onduty;
/
---------------------------
--New PACKAGE BODY
--IOT_SWP_DESK_AREA_MAP
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_DESK_AREA_MAP" As

   Procedure sp_add_desk_area(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_deskid           Varchar2,
      p_area             Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   ) As
      v_empno       Varchar2(5);
      v_user_tcp_ip Varchar2(5)  := 'NA';
      v_key_id      Varchar2(10) := dbms_random.string('X', 10);
      v_count       Number       := 0;
   Begin
      v_empno := get_empno_from_meta_id(p_meta_id);

      If v_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;

      Select Count(*) Into v_count
        From SWP_DESK_AREA_MAPPING
       Where deskid = p_deskid;

      If v_count > 0 Then
         p_message_type := 'KO';
         p_message_text := 'Record already present';
         Return;
      End If;

      Insert Into SWP_DESK_AREA_MAPPING
         (KYE_ID, DESKID, AREA_KEY_ID, MODIFIED_ON, MODIFIED_BY)
      Values (v_key_id, p_deskid, p_area, sysdate, v_empno);

      If (Sql%ROWCOUNT > 0) Then
         p_message_type := 'OK';
         p_message_text := 'Procedure executed successfully.';
      Else
         p_message_type := 'KO';
         p_message_text := 'Procedure not executed.';
      End If;

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'Err - '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_add_desk_area;

   Procedure sp_update_desk_area(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_application_id   Varchar2,
      p_deskid           Varchar2,
      p_area             Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   ) As
      v_empno       Varchar2(5);
      v_user_tcp_ip Varchar2(5) := 'NA';
   Begin
      v_empno := get_empno_from_meta_id(p_meta_id);

      If v_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;

      Update SWP_DESK_AREA_MAPPING
         Set DESKID = p_deskid, AREA_KEY_ID = p_area,
             MODIFIED_ON = sysdate, MODIFIED_BY = v_empno
       Where KYE_ID = p_application_id;

      If (Sql%ROWCOUNT > 0) Then
         p_message_type := 'OK';
         p_message_text := 'Procedure executed successfully.';
      Else
         p_message_type := 'KO';
         p_message_text := 'Procedure not executed.';
      End If;

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'Err - '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_update_desk_area;

   Procedure sp_delete_desk_area(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_application_id   Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   ) As
      v_empno        Varchar2(5);
      v_user_tcp_ip  Varchar2(5) := 'NA';
      v_message_type Number      := 0;
   Begin
      v_empno := get_empno_from_meta_id(p_meta_id);

      If v_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;

      Delete From SWP_DESK_AREA_MAPPING
       Where KYE_ID = p_application_id;

      If (Sql%ROWCOUNT > 0) Then
         p_message_type := 'OK';
         p_message_text := 'Procedure executed successfully.';
      Else
         p_message_type := 'KO';
         p_message_text := 'Procedure not executed.';
      End If;

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'Err - '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_delete_desk_area;

End IOT_SWP_DESK_AREA_MAP;
/
---------------------------
--Changed PACKAGE BODY
--LEAVE
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."LEAVE" As
    /*PROCEDURE validate_cl_nu(
        param_empno VARCHAR2,
        param_bdate DATE,
        param_edate DATE,
        param_half_day_on NUMBER,
        param_leave_period out number,
        param_msg_type OUT NUMBER,
        param_msg OUT VARCHAR2);*/

    Function get_date_4_continuous_leave(
        param_empno           Varchar2,
        param_date            Date,
        param_leave_type      Varchar2,
        param_forward_reverse Varchar2
    ) Return Date;

    Function check_co_with_adjacent_leave(
        param_empno           Varchar2,
        param_date            Date,
        param_forward_reverse Varchar2
    ) Return Number;

    Function validate_spc_co_spc(
        param_empno       Varchar2,
        param_bdate       Date,
        param_edate       Date,
        param_half_day_on Number
    ) Return Number;

    Function get_continuous_cl_sum(
        param_empno           Varchar2,
        param_date            Date,
        param_reverse_forward Varchar2
    ) Return Number;

    Function get_continuous_sl_sum(
        param_empno           Varchar2,
        param_date            Date,
        param_reverse_forward Varchar2
    ) Return Number;

    --function validate_co_spc_co(param_empno varchar2, param_bdate date, param_edate date) return number ;

    Function validate_co_spc_co(
        param_empno       Varchar2,
        param_bdate       Date,
        param_edate       Date,
        param_half_day_on Number
    ) Return Number;

    Function validate_cl_sl_co(
        param_empno       Varchar2,
        param_bdate       Date,
        param_edate       Date,
        param_half_day_on Number,
        param_leave_type  Varchar2
    ) Return Number;

    Function get_continuous_leave_sum(
        param_empno           Varchar2,
        param_date            Date,
        param_leave_type      Varchar2,
        param_reverse_forward Varchar2
    ) Return Number;

    Function check_pl_combination(
        param_empno In   Varchar2,
        param_leave_type Varchar2,
        param_bdate      Date,
        param_edate      Date,
        param_app_no     Varchar2 Default ' '
    ) Return Number;
    /*
  function calc_leave_period ( 
        param_bdate date, 
        param_edate date,
        param_leave_type varchar2,
        param_half_day_on number
        ) return number ;

    /*function validate_cl_sl_co
    (
      param_empno VARCHAR2,
      param_bdate DATE,
      param_edate DATE,
      param_half_day_on NUMBER,
      param_leave_type varchar2
    ) return number ;
*/

    Procedure validate_pl(
        param_empno            Varchar2,
        param_bdate            Date,
        param_edate            Date,
        param_half_day_on      Number   Default half_day_on_none,
        param_app_no           Varchar2 Default ' ',
        param_leave_period Out Number,
        param_msg_type     Out Number,
        param_msg          Out Varchar2
    ) As

        v_leave_period   Number;
        v_minimum_days   Number;
        v_failure_number Number := 0;
        v_pl_combined    Number;
        v_co_spc_co      Number;
        v_spc_co_spc     Number;
    Begin
        param_msg_type     := ss.success;

        --Cannot avail leave on holiday.
        If checkholiday(param_bdate) > 0 Or checkholiday(param_edate) > 0 Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Cannot avail leave on holiday. ';
        End If;

        --PL cannot be less then 4 days.

        v_minimum_days     := 0.5;
        v_leave_period     := calc_leave_period(
                                  param_bdate,
                                  param_edate,
                                  'PL',
                                  param_half_day_on
                              );
        param_leave_period := v_leave_period;
        If v_leave_period < v_minimum_days Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - PL cannot be less then 4 days. ';
        End If;

        --Check PL Combined with other Leave

        v_pl_combined      := check_pl_combination(
                                  param_empno,
                                  'PL',
                                  param_bdate,
                                  param_edate,
                                  param_app_no
                              );
        If v_pl_combined = leave_combined_with_none Then
            Return;
        End If;
        If v_pl_combined = leave_combined_with_csp Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - PL and CL/PL/SL cannot be availed together. ';
        Elsif v_pl_combined = leave_combined_over_lap Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Leave has already been availed on same day. ';
        End If;

        -- R E T U R N 

        Return;
        -- R E T U R N 
        --Below processing not required since rule has Changed
        --Can avail leave adjacent to any leavetype except SL cannot be adjacent to SL

        -- X X X X X X X X X X X 
        v_co_spc_co        := validate_co_spc_co(
                                  param_empno,
                                  param_bdate,
                                  param_edate,
                                  param_half_day_on
                              );
        If v_co_spc_co = ss.failure Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - PL cannot be availed with trailing and preceding CO - CO-PL-CO. ';
        End If;

        v_spc_co_spc       := validate_spc_co_spc(
                                  param_empno,
                                  param_bdate,
                                  param_edate,
                                  param_half_day_on
                              );
        If v_spc_co_spc = ss.failure Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - PL cannot be availed when trailing and preceding to CO. "CL-SL-PL  -CO-  CL-SL-PL"';
        End If;

    End validate_pl;

    Function check_pl_combination(
        param_empno In   Varchar2,
        param_leave_type Varchar2,
        param_bdate      Date,
        param_edate      Date,
        param_app_no     Varchar2 Default ' '
    ) Return Number Is
        v_count          Number;
        v_next_work_date Date;
        v_prev_work_date Date;
    Begin
        --Check Overlap
        Select
            Count(*)
        Into
            v_count
        From
            ss_leave_app_ledg
        Where
            empno = param_empno
            And (param_bdate Between bdate And edate
                Or param_edate Between bdate And edate)
            And app_no <> nvl(param_app_no, ' ');

        If v_count > 0 Then
            Return leave_combined_over_lap;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_leave_app_ledg
        Where
            empno = param_empno
            And (bdate Between param_bdate And param_edate
                Or edate Between param_bdate And param_edate)
            And app_no <> nvl(param_app_no, ' ');

        If v_count > 0 Then
            Return leave_combined_over_lap;
        End If;
        --Check Overlap

        --Check CL/SL/PL Combination
        v_prev_work_date := getlastworkingday(param_bdate, '-');
        v_next_work_date := getlastworkingday(param_edate, '+');
        Select
            Count(*)
        Into
            v_count
        From
            ss_leave_app_ledg
        Where
            empno = param_empno
            And (trunc(v_prev_work_date) Between bdate And edate
                Or trunc(v_next_work_date) Between bdate And edate)
            And leavetype Not In (
                'CO', 'PL', 'CL', 'SL'
            )
            And app_no <> nvl(param_app_no, ' ');

        If v_count > 0 Then
            Return leave_combined_with_csp;
        End If;
        --Check CL/SL/PL Combination

        --Check CO Combination
        Declare
            v_prev_co_count Number;
            v_next_co_count Number;
        Begin
            Return leave_combined_with_none;
            /*
            Select
                Count(*)
            Into v_prev_co_count
            From
                ss_leave_app_ledg
            Where
                empno = param_empno
                And ( Trunc(v_prev_work_date) Between bdate And edate )
                And leavetype = 'CO'
                And app_no <> Nvl(param_app_no, ' ');

            Select
                Count(*)
            Into v_next_co_count
            From
                ss_leave_app_ledg
            Where
                empno = param_empno
                And ( Trunc(v_next_work_date) Between bdate And edate )
                And leavetype = 'CO'
                And app_no <> Nvl(param_app_no, ' ');

            If v_prev_co_count > 0 Or v_next_co_count > 0 Then
                Return leave_combined_with_co;
            Else
                Return leave_combined_with_none;
            End If;
            */
        End;
        --Check CO Combination
    End check_pl_combination;

    Procedure validate_sl(
        param_empno            Varchar2,
        param_bdate            Date,
        param_edate            Date,
        param_half_day_on      Number,
        param_leave_period Out Number,
        param_msg_type     Out Number,
        param_msg          Out Varchar2
    ) As

        v_minimum_days   Number;
        v_failure_number Number := 0;
        v_sl_combined    Number;
        v_co_spc_co      Number;
        v_cumu_sl        Number;
        v_max_days       Number := 3;
        v_leave_period   Number;
        v_bdate          Date;
        v_edate          Date;
        v_spc_co_spc     Number;
        v_co_combined    Number;
    Begin
        param_msg_type     := ss.success;

        --Cannot avail leave on holiday.
        If checkholiday(param_bdate) > 0 Or checkholiday(param_edate) > 0 Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Cannot avail leave on holiday. ';
        End If;

        param_leave_period := calc_leave_period(
                                  param_bdate,
                                  param_edate,
                                  'SL',
                                  param_half_day_on
                              );
        v_leave_period     := param_leave_period;
        v_sl_combined      := validate_cl_sl_co(
                                  param_empno,
                                  param_bdate,
                                  param_edate,
                                  param_half_day_on,
                                  'SL'
                              );
        If v_sl_combined = leave_combined_sl_with_sl Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - SL cannot precede / succeed SL. ';
        Elsif v_sl_combined = leave_combined_over_lap Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Leave has already been availed on same day. ';
        End If;

        -- R E T U R N 

        Return;
        -- R E T U R N 
        --Below processing not required since rule has Changed
        --Can avail leave adjacent to any leavetype except SL cannot be adjacent to SL

        -- X X X X X X X X X X X 
        If param_half_day_on In (
                hd_bdate_presnt_part_2, half_day_on_none
            )
        Then
            v_cumu_sl := get_continuous_sl_sum(
                             param_empno,
                             param_edate,
                             c_forward
                         );
        End If;

        If param_half_day_on In (
                hd_edate_presnt_part_1, half_day_on_none
            )
        Then
            v_cumu_sl := nvl(v_cumu_sl, 0) + get_continuous_sl_sum(
                             param_empno,
                             param_bdate,
                             c_reverse
                         );
        End If;

        v_cumu_sl          := nvl(v_cumu_sl, 0);
        v_cumu_sl          := v_cumu_sl / 8;
        If v_cumu_sl <> 0 And v_cumu_sl + v_leave_period > v_max_days Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - SL cannot be availed for more than 3 days in succession. ';
        End If;

        v_bdate            := Null;
        v_edate            := Null;
        If param_half_day_on In (
                hd_edate_presnt_part_1, half_day_on_none
            )
        Then
            v_bdate := get_date_4_continuous_leave(
                           param_empno,
                           param_bdate,
                           leave_type_sl,
                           c_reverse
                       );
        End If;

        If param_half_day_on In (
                hd_bdate_presnt_part_2, half_day_on_none
            )
        Then
            v_edate := get_date_4_continuous_leave(
                           param_empno,
                           param_edate,
                           leave_type_sl,
                           c_forward
                       );
        End If;

        v_co_spc_co        := validate_co_spc_co(
                                  param_empno,
                                  nvl(v_bdate, param_bdate),
                                  nvl(v_edate, param_edate),
                                  param_half_day_on
                              );

        If v_co_spc_co = ss.failure Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - SL cannot be availed with trailing and preceding CO - CO-SL-CO. ';
        End If;

        v_spc_co_spc       := validate_spc_co_spc(
                                  param_empno,
                                  nvl(v_bdate, param_bdate),
                                  nvl(v_edate, param_edate),
                                  param_half_day_on
                              );

        If v_spc_co_spc = ss.failure Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - SL cannot be availed when trailing and preceding to CO. "CL-SL-PL  -CO-  CL-SL-PL"';
        End If;

    End validate_sl;

    Procedure validate_lv(
        param_empno            Varchar2,
        param_bdate            Date,
        param_edate            Date,
        param_half_day_on      Number,
        param_leave_period Out Number,
        param_msg_type     Out Number,
        param_msg          Out Varchar2
    ) As
        v_failure_number Number := 0;
        v_leave_period   Number;
        v_count          Number;
    Begin
        param_msg_type     := ss.success;
        Select
            Count(empno)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno             = param_empno
            And status        = 1
            And (emptype      = 'C'
                Or expatriate = 1);

        If v_count = 0 Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - You Cannot avail leave type "LV". ';
        End If;

        --Cannot avail leave on holiday.

        If checkholiday(param_bdate) > 0 Or checkholiday(param_edate) > 0 Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Cannot avail leave on holiday. ';
        End If;

        param_leave_period := calc_leave_period(
                                  param_bdate,
                                  param_edate,
                                  'LV',
                                  param_half_day_on
                              );
        Select
            Count(*)
        Into
            v_count
        From
            ss_leave_app_ledg
        Where
            empno = param_empno
            And (param_bdate Between bdate And edate
                Or param_edate Between bdate And edate);

        If v_count > 0 Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Leave has already been availed on same day. ';
        End If;

    End;

    Procedure validate_co(
        param_empno            Varchar2,
        param_bdate            Date,
        param_edate            Date,
        param_half_day_on      Number,
        param_leave_period Out Number,
        param_msg_type     Out Number,
        param_msg          Out Varchar2
    ) As

        v_leave_period        Number;
        v_max_days            Number := 3;
        v_failure_number      Number := 0;
        v_co_combined_forward Number;
        v_co_combined_reverse Number;
        v_cumu_co             Number;
        v_co_combined         Number;
    Begin
        param_msg_type     := ss.success;

        --Cannot avail leave on holiday.
        If checkholiday(param_bdate) > 0 Or checkholiday(param_edate) > 0 Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Cannot avail leave on holiday. ';
        End If;

        --CO cannot be less then 3 days.

        v_leave_period     := calc_leave_period(
                                  param_bdate,
                                  param_edate,
                                  'CO',
                                  param_half_day_on
                              );
        param_leave_period := v_leave_period;
        If v_leave_period > v_max_days Then
            param_msg_type := ss.failure;
            param_msg_type := ss.failure;
            param_msg      := param_msg || to_char(v_failure_number) || ' - CO cannot be more then 3 days. ';
        End If;
        --CO cannot be less then 3 days.

        -- R E T U R N 

        Return;
        -- R E T U R N 
        --Below processing not required since rule has Changed
        --Can avail leave adjacent to any leavetype except SL cannot be adjacent to SL

        -- X X X X X X X X X X X 
        If param_half_day_on In (
                hd_bdate_presnt_part_2, half_day_on_none
            )
        Then
            v_cumu_co := get_continuous_leave_sum(
                             param_empno,
                             param_edate,
                             leave_type_co,
                             c_forward
                         );
        End If;

        If param_half_day_on In (
                hd_edate_presnt_part_1, half_day_on_none
            )
        Then
            v_cumu_co := nvl(v_cumu_co, 0) + get_continuous_leave_sum(
                             param_empno,
                             param_bdate,
                             leave_type_co,
                             c_reverse
                         );
        End If;

        v_cumu_co          := v_cumu_co / 8;
        If v_cumu_co + v_leave_period > v_max_days Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - CO cannot be availed for more than 3 days continuously. ';
        End If;

        v_co_combined      := validate_cl_sl_co(
                                  param_empno,
                                  param_bdate,
                                  param_edate,
                                  param_half_day_on,
                                  'CO'
                              );
        If v_co_combined = leave_combined_over_lap Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Leave has already been availed on same day. ';
        End If;

        If param_half_day_on In (
                hd_bdate_presnt_part_2, half_day_on_none
            )
        Then
            v_co_combined_forward := check_co_with_adjacent_leave(
                                         param_empno,
                                         param_edate,
                                         c_forward
                                     );
            If v_co_combined_forward = ss.failure Then
                v_failure_number := v_failure_number + 1;
                param_msg_type   := ss.failure;
                param_msg        := param_msg || to_char(v_failure_number) || ' - CO + CL/SL/PL + CL/SL/PL/CO cannot be availed together. ';
                Return;
            End If;

        End If;

        If param_half_day_on In (
                hd_edate_presnt_part_1, half_day_on_none
            )
        Then
            v_co_combined_reverse := check_co_with_adjacent_leave(
                                         param_empno,
                                         param_bdate,
                                         c_reverse
                                     );
            If v_co_combined_reverse = ss.failure Then
                v_failure_number := v_failure_number + 1;
                param_msg_type   := ss.failure;
                param_msg        := param_msg || to_char(v_failure_number) || ' - CL/SL/PL/CO + CL/SL/PL + CO cannot be availed together. ';
            Elsif leave_with_adjacent = v_co_combined_reverse And leave_with_adjacent = v_co_combined_forward Then
                v_failure_number := v_failure_number + 1;
                param_msg_type   := ss.failure;
                param_msg        := param_msg || to_char(v_failure_number) || ' - CL/SL/PL + CO + CL/SL/PL cannot be availed together. ';
            End If;

        End If;

    End validate_co;

    Procedure validate_cl_old(
        param_empno            Varchar2,
        param_bdate            Date,
        param_edate            Date,
        param_half_day_on      Number,
        param_leave_period Out Number,
        param_msg_type     Out Number,
        param_msg          Out Varchar2
    ) As
        v_leave_period   Number;
        v_max_days       Number;
        v_failure_number Number := 0;
        v_cl_combined    Number;
    Begin
        param_msg_type     := ss.success;

        --Cannot avail leave on holiday.
        If checkholiday(param_bdate) > 0 Or checkholiday(param_edate) > 0 Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Cannot avail leave on holiday. ';
        End If;

        --CL cannot be more then 3 days.

        If param_half_day_on = half_day_on_none Then
            v_max_days := 3;
        Else
            v_max_days := 3;
        End If;

        v_leave_period     := calc_leave_period(
                                  param_bdate,
                                  param_edate,
                                  'CL',
                                  param_half_day_on
                              );
        param_leave_period := v_leave_period;
        If v_leave_period > v_max_days Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - CL cannot be more then 3 days. ';
        End If;
        --CL cannot be less then 3 days.

        v_cl_combined      := validate_cl_sl_co(
                                  param_empno,
                                  param_bdate,
                                  param_edate,
                                  param_half_day_on,
                                  'CL'
                              );
        If v_cl_combined = leave_combined_with_csp Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - CL and CL/PL/SL cannot be availed together. ';
        Elsif v_cl_combined = leave_combined_over_lap Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Leave has already been availed on same day. ';
        Elsif v_cl_combined = leave_combined_with_co Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - CL and CO cannot be availed together. ';
        End If;

    End validate_cl_old;

    Procedure check_co_co_combination(
        param_empno       Varchar2,
        param_bdate       Date,
        param_edate       Date,
        param_success Out Number
    ) As

        Cursor prev_leave Is
            Select
                *
            From
                ss_leave_app_ledg
            Where
                empno = param_empno
                And bdate < param_bdate
            Order By
                edate Desc;

        Cursor next_leave Is
            Select
                *
            From
                ss_leave_app_ledg
            Where
                empno = param_empno
                And bdate > param_edate
            Order By
                bdate Asc;

        v_count          Number;
        v_prev_work_date Date;
        v_next_work_date Date;
    Begin
        v_count := 0;
        For cur_row In prev_leave
        Loop
            v_count := v_count + 1;
            If v_count = 1 Then
                v_prev_work_date := getlastworkingday(param_bdate, '-');
                If Not (trunc(v_prev_work_date) Between cur_row.bdate And cur_row.edate) Or cur_row.leavetype = 'CO' Then
                    --No Error
                    param_success := ss.success;
                    Exit;
                Else
                    v_prev_work_date := getlastworkingday(cur_row.bdate, '-');
                End If;

            End If;

            If v_count = 2 Then
                If trunc(v_prev_work_date) Between cur_row.bdate And cur_row.edate And cur_row.leavetype = 'CO' Then
                    --Error
                    param_success := ss.failure;
                    Return;
                Else
                    --No Error
                    param_success := ss.success;
                    Null;
                End If;

                Exit;
            End If;

        End Loop;

        If param_success = ss.failure Then
            Return;
        End If;
        v_count := 0;
        For cur_row In next_leave
        Loop
            v_count := v_count + 1;
            If v_count = 1 Then
                v_next_work_date := getlastworkingday(param_edate, '+');
                If Not (trunc(v_next_work_date) Between cur_row.bdate And cur_row.edate) Or cur_row.leavetype = 'CO' Then
                    param_success := ss.success;
                    Exit;
                Else
                    v_next_work_date := getlastworkingday(cur_row.edate, '+');
                End If;

            End If;

            If v_count = 2 Then
                If trunc(v_next_work_date) Between cur_row.bdate And cur_row.edate And cur_row.leavetype = 'CO' Then
                    --Error
                    param_success := ss.failure;
                    Return;
                Else
                    param_success := ss.success;
                    Null;
                End If;

                Exit;
            End If;

        End Loop;

    End;

    Procedure validate_leave(
        param_empno              Varchar2,
        param_leave_type         Varchar2,
        param_bdate              Date,
        param_edate              Date,
        param_half_day_on        Number,
        param_app_no             Varchar2 Default Null,
        param_leave_period   Out Number,
        param_last_reporting Out Varchar2,
        param_resuming       Out Varchar2,
        param_msg_type       Out Number,
        param_msg            Out Varchar2
    ) As
        v_last_reporting Varchar2(100);
        v_resuming       Varchar2(100);
        v_count          Number;
        v_leave_type     Varchar2(2);
    Begin
        If param_bdate > param_edate Then
            param_msg_type := ss.failure;
            param_msg      := 'Invalid date range. Cannot proceed.';
            Return;
        End If;

        Begin
            go_come_msg(
                param_bdate,
                param_edate,
                param_half_day_on,
                v_last_reporting,
                v_resuming
            );
            param_last_reporting := v_last_reporting;
            param_resuming       := v_resuming;
        Exception
            When Others Then
                Null;
        End;
        v_leave_type := param_leave_type;
        If v_leave_type = 'SC' Then
            v_leave_type := 'SL';
        End If;
        Case
            When v_leave_type = leave_type_cl Then 
                --if param_empno in ('02320','02079') then
                validate_cl(
                    param_empno,
                    param_bdate,
                    param_edate,
                    param_half_day_on,
                    param_leave_period,
                    param_msg_type,
                    param_msg
                );
                /*else
                  validate_cl( param_empno ,param_bdate , param_edate , param_half_day_on ,param_leave_period , param_msg_type ,param_msg ) ;
                end if;*/
            When v_leave_type = leave_type_pl Then
                validate_pl(
                    param_empno,
                    param_bdate,
                    param_edate,
                    param_half_day_on,
                    param_app_no,
                    param_leave_period,
                    param_msg_type,
                    param_msg
                );
            When v_leave_type = leave_type_sl Then
                validate_sl(
                    param_empno,
                    param_bdate,
                    param_edate,
                    param_half_day_on,
                    param_leave_period,
                    param_msg_type,
                    param_msg
                );
            When v_leave_type = leave_type_co Then
                validate_co(
                    param_empno,
                    param_bdate,
                    param_edate,
                    param_half_day_on,
                    param_leave_period,
                    param_msg_type,
                    param_msg
                );
            When v_leave_type = leave_type_lv Then
                validate_lv(
                    param_empno,
                    param_bdate,
                    param_edate,
                    param_half_day_on,
                    param_leave_period,
                    param_msg_type,
                    param_msg
                );
            When v_leave_type = leave_type_ex Then 
                --validate_ex( param_empno ,param_bdate , param_edate , param_half_day_on ,param_leave_period , param_msg_type ,param_msg ) ;
                param_msg_type := ss.failure;
                param_msg      := 'Cannot avail "' || v_leave_type || '" Leave. Cannot proceed.';
            Else
                param_msg_type := ss.failure;
                param_msg      := '"' || v_leave_type || '" Leave Type not defined. Cannot proceed.';
        End Case;

    Exception
        When Others Then
            param_leave_period := 0;
            param_msg_type     := ss.failure;
            param_msg          := sqlcode || ' - ' || sqlerrm;
    End;

    Procedure go_come_msg(
        param_bdate              Date,
        param_edate              Date,
        param_half_day_on        Number,
        param_last_reporting Out Varchar2,
        param_resuming       Out Varchar2
    ) As
        v_prev_work_date Date;
        v_next_work_date Date;
    Begin
        v_prev_work_date := getlastworkingday(param_bdate, '-');
        v_next_work_date := getlastworkingday(param_edate, '+');
        Case
            When param_half_day_on = hd_bdate_presnt_part_2 Then
                param_last_reporting := to_char(param_bdate, daydateformat) || in_first_half;
                param_resuming       := to_char(v_next_work_date, daydateformat);
            When param_half_day_on = hd_edate_presnt_part_1 Then
                param_last_reporting := to_char(v_prev_work_date, daydateformat);
                param_resuming       := to_char(param_edate, daydateformat) || in_second_half;
            Else
                param_last_reporting := to_char(v_prev_work_date, daydateformat);
                param_resuming       := to_char(v_next_work_date, daydateformat);
        End Case;

    End;

    Function calc_leave_period(
        param_bdate       Date,
        param_edate       Date,
        param_leave_type  Varchar2,
        param_half_day_on Number
    ) Return Number As
        v_ret_val Number := 0;
    Begin
        If param_leave_type = leave_type_sl Then
            v_ret_val := param_edate - param_bdate + 1;
            If nvl(param_half_day_on, half_day_on_none) <> half_day_on_none Then
                v_ret_val := v_ret_val -.5;
            End If;

            Return v_ret_val;
        End If;

        v_ret_val := (param_edate - param_bdate + 1) - holidaysbetween(param_bdate, param_edate);
        If nvl(param_half_day_on, half_day_on_none) <> half_day_on_none Then
            v_ret_val := v_ret_val -.5;
        End If;

        Return v_ret_val;
    End;

    Function get_app_no(
        param_empno Varchar2
    ) Return Varchar2 As

        my_exception Exception;
        Pragma exception_init(my_exception, -20001);
        v_max_app_no Number;
        v_ret_val    Varchar2(60);
    Begin
        Select
            Count(*)
        Into
            v_max_app_no
        From
            ss_vu_leaveapp
        Where
            empno = param_empno
            And app_date >= trunc(sysdate, 'YEAR');

        If v_max_app_no > 0 Then
            Select
                Max(to_number(substr(app_no, instr(app_no, '/', - 1) + 1)))
            Into
                v_max_app_no
            From
                ss_vu_leaveapp
            Where
                empno = Trim(param_empno)
                And app_date >= trunc(sysdate, 'YEAR')
            Order By
                to_number(substr(app_no, instr(app_no, '/', - 1) + 1));

        End If;

        v_ret_val := param_empno || '/' || to_char(sysdate, 'yyyymmdd') || '/' || (v_max_app_no + 1);

        Return v_ret_val;
    Exception
        When Others Then
            raise_application_error(
                -20001,
                'GET_APP_NO - ' || sqlcode || ' - ' || sqlerrm
            );
    End;

    Procedure add_leave_app(
        param_empno            Varchar2,
        param_app_no           Varchar2 Default ' ',
        param_leave_type       Varchar2,
        param_bdate            Date,
        param_edate            Date,
        param_half_day_on      Number,
        param_projno           Varchar2,
        param_caretaker        Varchar2,
        param_reason           Varchar2,
        param_cert             Number,
        param_contact_add      Varchar2,
        param_contact_std      Varchar2,
        param_contact_phn      Varchar2,
        param_office           Varchar2,
        param_dataentryby      Varchar2,
        param_lead_empno       Varchar2,
        param_discrepancy      Varchar2,
        param_tcp_ip           Varchar2,
        param_nu_app_no Out    Varchar2,
        param_msg_type  Out    Number,
        param_msg       Out    Varchar2,
        param_med_cert_file_nm Varchar2 Default Null
    ) As

        v_app_no              Varchar2(60);
        v_last_reporting      Varchar2(150);
        v_resuming_on         Varchar2(150);
        v_l_rep_dt            Date;
        v_resume_dt           Date;
        v_hd_date             Date;
        v_hd_presnt_part      Number;
        v_lead_apprl          Number;
        v_mngr_email          Varchar2(100);
        v_leave_period        Number;
        v_email_success       Number;
        v_email_message       Varchar2(100);
        v_leave_type          Varchar2(2);
        v_is_covid_sick_leave Number(1);
    Begin
        v_leave_type     := param_leave_type;
        If v_leave_type = 'SC' Then
            v_leave_type          := 'SL';
            v_is_covid_sick_leave := 1;
        End If;

        validate_leave(
            param_empno,
            v_leave_type,
            param_bdate,
            param_edate,
            param_half_day_on,
            param_app_no,
            v_leave_period,
            v_last_reporting,
            v_resuming_on,
            param_msg_type,
            param_msg
        );
        --v_leave_period := calc_leave_period( param_bdate, param_edate, v_leave_type, param_half_day_on);

        If param_msg_type = ss.failure Then
            Return;
        End If;
        If v_leave_type = 'SL' And v_leave_period >= 2 Then
            If param_med_cert_file_nm Is Null Then
                param_msg_type := ss.failure;
                param_msg      := 'Err - Medical Certificate not attached.';
                Return;
            End If;
        End If;

        If nvl(param_half_day_on, half_day_on_none) = hd_bdate_presnt_part_2 Then
            v_hd_date        := param_bdate;
            v_hd_presnt_part := 2;
        Elsif nvl(param_half_day_on, half_day_on_none) = hd_edate_presnt_part_1 Then
            v_hd_date        := param_edate;
            v_hd_presnt_part := 1;
        End If;

        If param_lead_empno = 'None' Then
            v_lead_apprl := ss.apprl_none;
        Else
            v_lead_apprl := ss.pending;
        End If;

        v_app_no         := get_app_no(param_empno);
        param_nu_app_no  := v_app_no;
        --go_come_msg( param_bdate, param_edate, param_half_day_on, v_last_reporting, v_resuming_on);
        v_last_reporting := replace(v_last_reporting, in_first_half);
        v_last_reporting := replace(v_last_reporting, in_second_half);
        v_resuming_on    := replace(v_resuming_on, in_first_half);
        v_resuming_on    := replace(v_resuming_on, in_second_half);
        v_l_rep_dt       := to_date(v_last_reporting, daydateformat);
        v_resume_dt      := to_date(v_resuming_on, daydateformat);
        v_leave_period   := v_leave_period * 8;
        Insert Into ss_leaveapp (
            empno,
            app_no,
            app_date,
            projno,
            caretaker,
            leavetype,
            bdate,
            edate,
            mcert,
            work_ldate,
            resm_date,
            contact_phn,
            contact_std,
            dataentryby,
            office,
            hod_apprl,
            discrepancy,
            user_tcp_ip,
            hd_date,
            hd_part,
            lead_apprl,
            lead_apprl_empno,
            hrd_apprl,
            leaveperiod,
            reason,
            med_cert_file_name,
            is_covid_sick_leave
        )
        Values (
            param_empno,
            v_app_no,
            sysdate,
            param_projno,
            param_caretaker,
            v_leave_type,
            param_bdate,
            param_edate,
            param_cert,
            v_l_rep_dt,
            v_resume_dt,
            param_contact_phn,
            param_contact_std,
            param_dataentryby,
            param_office,
            ss.pending,
            param_discrepancy,
            param_tcp_ip,
            v_hd_date,
            v_hd_presnt_part,
            v_lead_apprl,
            param_lead_empno,
            ss.pending,
            v_leave_period,
            param_reason,
            param_med_cert_file_nm,
            v_is_covid_sick_leave
        );

        Commit;
        param_msg        := 'Application successfully Saved. ' || v_app_no;
        param_msg_type   := ss.success;
        If param_empno = '02320' Then
            v_email_success := ss.success;
        Else
            ss_mail.send_msg_new_leave_app(
                v_app_no,
                v_email_success,
                v_email_message
            );
        End If;

        If v_email_success = ss.failure Then
            param_msg_type := ss.warning;
            param_msg      := param_msg || ' Email could not be sent. - ';
        Else
            param_msg := param_msg || ' Email sent to HoD / Lead.';
        End If;

    Exception
        When Others Then
            param_msg_type := ss.failure;
            param_msg      := nvl(param_msg, ' ') || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure save_pl_revision(
        param_empno         Varchar2,
        param_app_no        Varchar2,
        param_bdate         Date,
        param_edate         Date,
        param_half_day_on   Number,
        param_dataentryby   Varchar2,
        param_lead_empno    Varchar2,
        param_discrepancy   Varchar2,
        param_tcp_ip        Varchar2,
        param_nu_app_no Out Varchar2,
        param_msg_type  Out Number,
        param_msg       Out Varchar2
    ) As

        v_contact_add Varchar2(60);
        v_contact_phn Varchar2(30);
        v_contact_std Varchar2(30);
        v_projno      Varchar2(60);
        v_caretaker   Varchar2(60);
        v_mcert       Number(1);
        v_office      Varchar2(30);
        v_count       Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_pl_revision_mast
        Where
            Trim(old_app_no)    = Trim(param_app_no)
            Or Trim(new_app_no) = Trim(param_app_no);

        If v_count > 0 Then
            param_msg_type := ss.failure;
            param_msg      := 'PL application "' || trim(param_app_no) || '" has already been revised.';
            Return;
        End If;

        Begin
            Select
                projno,
                caretaker,
                mcert,
                contact_add,
                contact_phn,
                contact_std,
                office
            Into
                v_projno,
                v_caretaker,
                v_mcert,
                v_contact_add,
                v_contact_phn,
                v_contact_std,
                v_office
            From
                ss_leaveapp
            Where
                Trim(app_no) = Trim(param_app_no);

        Exception
            When Others Then
                param_msg_type := ss.failure;
                param_msg      := nvl(param_msg, ' ') || sqlcode || ' - ' || sqlerrm || '. "' || param_app_no || '" Application not found.';

                Return;
        End;

        add_leave_app(
            param_empno       => param_empno,
            param_app_no      => param_app_no,
            param_leave_type  => 'PL',
            param_bdate       => param_bdate,
            param_edate       => param_edate,
            param_half_day_on => param_half_day_on,
            param_projno      => v_projno,
            param_caretaker   => v_caretaker,
            param_reason      => param_app_no || ' P L   R e v i s e d',
            param_cert        => v_mcert,
            param_contact_add => v_contact_add,
            param_contact_std => v_contact_std,
            param_contact_phn => v_contact_phn,
            param_office      => v_office,
            param_dataentryby => param_dataentryby,
            param_lead_empno  => param_lead_empno,
            param_discrepancy => param_discrepancy,
            param_tcp_ip      => param_tcp_ip,
            param_nu_app_no   => param_nu_app_no,
            param_msg_type    => param_msg_type,
            param_msg         => param_msg
        );

        If param_msg_type = ss.failure Then
            Rollback;
            Return;
        End If;
        Insert Into ss_pl_revision_mast (
            old_app_no,
            new_app_no
        )
        Values (
            Trim(param_app_no),
            Trim(param_nu_app_no)
        );

        Commit;
        param_msg_type := ss.success;
    Exception
        When Others Then
            param_msg_type := ss.failure;
            param_msg      := nvl(param_msg, ' ') || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure get_leave_details(
        param_o_app_no         In  Varchar2,
        param_o_empno          Out Varchar2,
        param_o_emp_name       Out Varchar2,
        param_o_app_date       Out Varchar2,
        param_o_office         Out Varchar2,
        param_o_edate          Out Varchar2,
        param_o_bdate          Out Varchar2,
        param_o_hd_date        Out Varchar2,
        param_o_hd_part        Out Number,
        param_o_leave_period   Out Number,
        param_o_leave_type     Out Varchar2,
        param_o_rep_to         Out Varchar2,
        param_o_projno         Out Varchar2,
        param_o_care_taker     Out Varchar2,
        param_o_reason         Out Varchar2,
        param_o_mcert          Out Number,
        param_o_work_ldate     Out Varchar2,
        param_o_resm_date      Out Varchar2,
        param_o_last_reporting Out Varchar2,
        param_o_resuming       Out Varchar2,
        param_o_contact_add    Out Varchar2,
        param_o_contact_phn    Out Varchar2,
        param_o_std            Out Varchar2,
        param_o_discrepancy    Out Varchar2,
        param_o_lead_empno     Out Varchar2,
        param_o_lead_name      Out Varchar2,
        param_o_msg_type       Out Number,
        param_o_msg            Out Varchar2
    ) As

        v_empno          Varchar2(5);
        v_name           Varchar2(60);
        v_last_reporting Varchar2(100);
        v_resuming       Varchar2(100);
    Begin
        Select
            empno,
            get_emp_name(empno),
            to_char(app_date, 'dd-Mon-yyyy'),
            to_char(edate, 'dd-Mon-yyyy'),
            to_char(bdate, 'dd-Mon-yyyy'),
            to_char(hd_date, 'dd-Mon-yyyy'),
            nvl(hd_part, 0),
            leaveperiod,
            leavetype,
            rep_to,
            projno,
            caretaker,
            reason,
            mcert,
            to_char(work_ldate, 'dd-Mon-yyyy'),
            to_char(resm_date, 'dd-Mon-yyyy'),
            contact_add,
            contact_phn,
            contact_std,
            discrepancy,
            lead_apprl_empno,
            get_emp_name(lead_apprl_empno) leadname,
            office
        Into
            param_o_empno,
            param_o_emp_name,
            param_o_app_date,
            param_o_edate,
            param_o_bdate,
            param_o_hd_date,
            param_o_hd_part,
            param_o_leave_period,
            param_o_leave_type,
            param_o_rep_to,
            param_o_projno,
            param_o_care_taker,
            param_o_reason,
            param_o_mcert,
            param_o_work_ldate,
            param_o_resm_date,
            param_o_contact_add,
            param_o_contact_phn,
            param_o_std,
            param_o_discrepancy,
            param_o_lead_empno,
            param_o_lead_name,
            param_o_office
        From
            ss_leaveapp
        Where
            app_no In (
                param_o_app_no
            );

        Begin
            go_come_msg(
                param_o_bdate,
                param_o_edate,
                param_o_hd_date,
                v_last_reporting,
                v_resuming
            );
            param_o_last_reporting := v_last_reporting;
            param_o_resuming       := v_resuming;
        Exception
            When Others Then
                Null;
        End;

        param_o_msg_type := ss.success;
        param_o_msg_type := 'SUCCESS';
    Exception
        When Others Then
            param_o_msg_type := ss.failure;
            param_o_msg      := sqlcode || ' - ' || sqlerrm;
    End get_leave_details;

    Procedure post_leave_apprl(
        param_list_appno   Varchar2,
        param_msg_type Out Number,
        param_msg      Out Varchar2
    ) As

        Cursor app_recs Is
            Select
                Trim(substr(txt, instr(txt, ',', 1, level) + 1, instr(txt, ',', 1, level + 1) - instr(txt, ',', 1, level) - 1))
                As app_no
            From
                (
                    Select
                        ',' || param_list_appno || ',' As txt
                    From
                        dual
                )
            Connect By
                level <= length(txt) - length(replace(txt, ',', '')) - 1;

        v_cur_app Varchar2(60);
        v_old_app Varchar2(60);
        v_count   Number;
    Begin
        For cur_app In app_recs
        Loop
            v_cur_app := replace(cur_app.app_no, chr(39));

            --check leave is approved
            Select
                Count(*)
            Into
                v_count
            From
                ss_leaveapp
            Where
                Trim(app_no)          = Trim(v_cur_app)
                And nvl(hrd_apprl, 0) = 1;
            If v_count = 0 Then
                Continue;
            End If;
            ---***----

            Select
                Count(*)
            Into
                v_count
            From
                ss_pl_revision_mast
            Where
                Trim(new_app_no) = Trim(v_cur_app);

            If v_count > 0 Then
                Select
                    old_app_no
                Into
                    v_old_app
                From
                    ss_pl_revision_mast
                Where
                    Trim(new_app_no) = Trim(v_cur_app);

                Insert Into ss_pl_revision_app (
                    app_no,
                    empno,
                    app_date,
                    rep_to,
                    projno,
                    caretaker,
                    leaveperiod,
                    leavetype,
                    bdate,
                    edate,
                    reason,
                    mcert,
                    work_ldate,
                    resm_date,
                    contact_add,
                    contact_phn,
                    contact_std,
                    last_hrs,
                    last_mn,
                    resm_hrs,
                    resm_mn,
                    dataentryby,
                    office,
                    hod_apprl,
                    hod_apprl_dt,
                    hod_code,
                    hrd_apprl,
                    hrd_apprl_dt,
                    hrd_code,
                    discrepancy,
                    user_tcp_ip,
                    hod_tcp_ip,
                    hrd_tcp_ip,
                    hodreason,
                    hrdreason,
                    hd_date,
                    hd_part,
                    lead_apprl,
                    lead_apprl_dt,
                    lead_code,
                    lead_tcp_ip,
                    lead_apprl_empno,
                    lead_reason
                )
                Select
                    app_no,
                    empno,
                    app_date,
                    rep_to,
                    projno,
                    caretaker,
                    leaveperiod,
                    leavetype,
                    bdate,
                    edate,
                    reason,
                    mcert,
                    work_ldate,
                    resm_date,
                    contact_add,
                    contact_phn,
                    contact_std,
                    last_hrs,
                    last_mn,
                    resm_hrs,
                    resm_mn,
                    dataentryby,
                    office,
                    hod_apprl,
                    hod_apprl_dt,
                    hod_code,
                    hrd_apprl,
                    hrd_apprl_dt,
                    hrd_code,
                    discrepancy,
                    user_tcp_ip,
                    hod_tcp_ip,
                    hrd_tcp_ip,
                    hodreason,
                    hrdreason,
                    hd_date,
                    hd_part,
                    lead_apprl,
                    lead_apprl_dt,
                    lead_code,
                    lead_tcp_ip,
                    lead_apprl_empno,
                    lead_reason
                From
                    ss_leaveapp
                Where
                    Trim(app_no) = Trim(v_old_app);

                Delete
                    From ss_leaveapp
                Where
                    Trim(app_no) = Trim(v_old_app);

                Delete
                    From ss_leaveledg
                Where
                    Trim(app_no) = Trim(v_old_app);

            End If;

            Insert Into ss_leaveledg(
                app_no,
                app_date,
                leavetype,
                description,
                empno,
                leaveperiod,
                db_cr,
                tabletag,
                bdate,
                edate,
                adj_type,
                hd_date,
                hd_part,
                is_covid_sick_leave
            )
            Select
                app_no,
                app_date,
                leavetype,
                reason,
                empno,
                leaveperiod * - 1,
                'D',
                1,
                bdate,
                edate,
                'LA',
                hd_date,
                hd_part,
                is_covid_sick_leave
            From
                ss_leaveapp
            Where
                Trim(app_no) = Trim(v_cur_app);

            v_cur_app := Null;
        End Loop;

        param_msg_type := ss.success;

    /*      
          for cur_app in app_recs loop
              v_cur_app := trim(replace(cur_app.app_no,chr(39)));
              Select v_old_app_no from ss_pl_revision_mast
                where trim(new_app_no) = trim(v_cur_app);
          end loop;
    */
    Exception
        When Others Then
            param_msg_type := ss.failure;
    End;

    Function is_pl_revision(
        param_app_no Varchar2
    ) Return Number Is
        v_count Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_pl_revision_mast
        Where
            Trim(new_app_no) = Trim(param_app_no);

        If v_count = 0 Then
            Return 0;
        Else
            Return 1;
        End If;
    End;

    Procedure validate_cl(
        param_empno            Varchar2,
        param_bdate            Date,
        param_edate            Date,
        param_half_day_on      Number,
        param_leave_period Out Number,
        param_msg_type     Out Number,
        param_msg          Out Varchar2
    ) As

        v_leave_period   Number;
        v_max_days       Number;
        v_failure_number Number := 0;
        v_cl_combined    Number;
        v_cumu_cl        Number;
        v_co_spc_co      Number;
        v_spc_co_spc     Number;
        v_bdate          Date;
        v_edate          Date;
    Begin
        param_msg_type     := ss.success;
        v_cumu_cl          := 0;
        --Cannot avail leave on holiday.
        If checkholiday(param_bdate) > 0 Or checkholiday(param_edate) > 0 Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Cannot avail leave on holiday. ';
        End If;

        --CL cannot be more then 3 days.

        If param_half_day_on = half_day_on_none Then
            v_max_days := 3;
        Else
            v_max_days := 3;
        End If;

        v_leave_period     := calc_leave_period(
                                  param_bdate,
                                  param_edate,
                                  'CL',
                                  param_half_day_on
                              );
        param_leave_period := v_leave_period;
        If v_leave_period > v_max_days Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - CL cannot be more then 3 days. ';
        End If;
        --CL cannot be less then 3 days.

        v_cl_combined      := validate_cl_sl_co(
                                  param_empno,
                                  param_bdate,
                                  param_edate,
                                  param_half_day_on,
                                  'CL'
                              );
        If v_cl_combined = leave_combined_with_csp Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - CL and CL/PL/SL cannot be availed together. ';
        Elsif v_cl_combined = leave_combined_over_lap Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - Leave has already been availed on same day. ';
        End If;

        --R E T U R N 

        Return;
        --R E T U R N 
        --Below processing not required since rule has Changed
        --Can avail leave adjacent to any leavetype except SL cannot be adjacent to SL

        -- X X X X X X X X X X X 
        If param_half_day_on In (
                hd_bdate_presnt_part_2, half_day_on_none
            )
        Then
            v_cumu_cl := get_continuous_cl_sum(
                             param_empno,
                             param_edate,
                             c_forward
                         );
        End If;

        If param_half_day_on In (
                hd_edate_presnt_part_1, half_day_on_none
            )
        Then
            v_cumu_cl := nvl(v_cumu_cl, 0) + get_continuous_cl_sum(
                             param_empno,
                             param_bdate,
                             c_reverse
                         );
        End If;

        v_cumu_cl          := v_cumu_cl / 8;
        If v_cumu_cl + v_leave_period > v_max_days Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - CL cannot be availed for more than 3 days continuously. ';
        End If;

        v_bdate            := Null;
        v_edate            := Null;
        If param_half_day_on In (
                hd_edate_presnt_part_1, half_day_on_none
            )
        Then
            v_bdate := get_date_4_continuous_leave(
                           param_empno,
                           param_bdate,
                           leave_type_cl,
                           c_reverse
                       );
        End If;

        If param_half_day_on In (
                hd_bdate_presnt_part_2, half_day_on_none
            )
        Then
            v_edate := get_date_4_continuous_leave(
                           param_empno,
                           param_edate,
                           leave_type_cl,
                           c_forward
                       );
        End If;

        v_co_spc_co        := validate_co_spc_co(
                                  param_empno,
                                  nvl(v_bdate, param_bdate),
                                  nvl(v_edate, param_edate),
                                  param_half_day_on
                              );

        If v_co_spc_co = ss.failure Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - CL cannot be availed with trailing and preceding CO - CO-CL-CO. ';
        End If;

        v_spc_co_spc       := validate_spc_co_spc(
                                  param_empno,
                                  nvl(v_bdate, param_bdate),
                                  nvl(v_edate, param_edate),
                                  param_half_day_on
                              );

        If v_spc_co_spc = ss.failure Then
            v_failure_number := v_failure_number + 1;
            param_msg_type   := ss.failure;
            param_msg        := param_msg || to_char(v_failure_number) || ' - CL cannot be availed when trailing and preceding to CO. "CL-SL-PL  -CO-  CL-SL-PL"';
        End If;

    End validate_cl;

    Function get_continuous_leave_sum(
        param_empno           Varchar2,
        param_date            Date,
        param_leave_type      Varchar2,
        param_reverse_forward Varchar2
    ) Return Number Is

        v_app_no       Varchar2(60);
        v_cumu_leave   Number;
        v_lw_date      Date;
        v_leave_period Number;
        v_leave_bdate  Date;
        v_leave_edate  Date;
    Begin
        v_cumu_leave := 0;
        v_lw_date    := getlastworkingday(param_date, param_reverse_forward);
        Loop
            Begin
                Select
                    app_no
                Into
                    v_app_no
                From
                    ss_leave_app_ledg
                Where
                    empno             = param_empno
                    And (v_lw_date Between bdate And edate
                        And leavetype = param_leave_type);

                Select
                    leaveperiod,
                    bdate,
                    edate
                Into
                    v_leave_period,
                    v_leave_bdate,
                    v_leave_edate
                From
                    ss_leaveapp
                Where
                    Trim(app_no) = Trim(v_app_no);

                v_cumu_leave := v_cumu_leave + v_leave_period;
                If param_reverse_forward = c_forward Then
                    v_lw_date := getlastworkingday(v_leave_edate, c_forward);
                Else
                    v_lw_date := getlastworkingday(v_leave_bdate, c_reverse);
                End If;

            Exception
                When Others Then
                    Exit;
            End;
        End Loop;

        Return v_cumu_leave;
    End;

    Function get_continuous_sl_sum(
        param_empno           Varchar2,
        param_date            Date,
        param_reverse_forward Varchar2
    ) Return Number Is

        v_app_no       Varchar2(60);
        v_cumu_leave   Number;
        v_lw_date      Date;
        v_leave_period Number;
        v_leave_bdate  Date;
        v_leave_edate  Date;
        v_prev_lw_dt   Date;
        v_date_diff    Number := 0;
    Begin
        v_cumu_leave := 0;
        v_prev_lw_dt := param_date;
        v_lw_date    := getlastworkingday(param_date, param_reverse_forward);
        Loop
            Begin
                Select
                    app_no
                Into
                    v_app_no
                From
                    ss_leave_app_ledg
                Where
                    empno             = param_empno
                    And (v_lw_date Between bdate And edate
                        And leavetype = leave_type_sl);

                Select
                    leaveperiod,
                    bdate,
                    edate
                Into
                    v_leave_period,
                    v_leave_bdate,
                    v_leave_edate
                From
                    ss_leaveapp
                Where
                    Trim(app_no) = Trim(v_app_no);

                v_cumu_leave := v_cumu_leave + v_leave_period;

                -- S T A R T
                -- ADD UP holidays between Continuous SL
                If param_reverse_forward = c_forward Then
                    v_date_diff  := trunc(v_lw_date, 'DDD') - trunc(v_prev_lw_dt, 'DDD');
                    v_prev_lw_dt := v_lw_date;
                    v_lw_date    := getlastworkingday(v_leave_edate, c_forward);
                Else
                    v_date_diff  := trunc(v_prev_lw_dt, 'DDD') - trunc(v_lw_date, 'DDD');
                    v_prev_lw_dt := v_lw_date;
                    v_lw_date    := getlastworkingday(v_leave_bdate, c_reverse);
                End If;

                If v_date_diff > 1 Then
                    v_cumu_leave := v_cumu_leave + (v_date_diff * 8);
                End If;

                v_date_diff  := 0;
            -- ADD UP holidays between Continuous SL
            -- E N D
            Exception
                When Others Then
                    Exit;
            End;
        End Loop;

        Return v_cumu_leave;
    End;

    Function validate_cl_sl_co(
        param_empno       Varchar2,
        param_bdate       Date,
        param_edate       Date,
        param_half_day_on Number,
        param_leave_type  Varchar2
    ) Return Number Is
        v_count          Number;
        v_prev_work_date Date;
        v_next_work_date Date;
        v_results        Number;
    Begin

        --Check Overlap
        Select
            Count(*)
        Into
            v_count
        From
            ss_leave_app_ledg
        Where
            empno = param_empno
            And ((param_bdate Between bdate And edate
                    Or param_edate Between bdate And edate)
                Or bdate Between param_bdate And param_edate);

        If v_count > 0 Then
            Return leave_combined_over_lap;
        End If;
        --Check Overlap     

        --Check CL/SL/PL Combination
        v_prev_work_date := getlastworkingday(param_bdate, '-');
        v_next_work_date := getlastworkingday(param_edate, '+');
        If param_leave_type In ('PL', 'CL', 'CO') Then
            /*
            Select
                Count(*)
            Into v_count
            From
                ss_leave_app_ledg
            Where
                empno = param_empno
                And ( Trunc(v_prev_work_date) Between bdate And edate
                      Or Trunc(v_next_work_date) Between bdate And edate )
                And leavetype Not In (
                    'CO'
                ); -- Combination with CO is allowed

            If v_count > 0 Then
                Return leave_combined_with_csp;
            End If;
            */
            Null;
        Elsif param_leave_type = 'SL' Then
            Select
                Count(*)
            Into
                v_count
            From
                ss_leave_app_ledg
            Where
                empno = param_empno
                And (trunc(v_prev_work_date) Between bdate And edate
                    Or trunc(v_next_work_date) Between bdate And edate)
                And leavetype Not In (
                    'CL', 'PL', 'CO'
                ); -- Combination with CO is allowed

            If v_count > 0 Then
                Return leave_combined_sl_with_sl;
            End If;
            /*
        Elsif param_leave_type = 'CL' Then
            Select
                Count(*)
            Into v_count
            From
                ss_leave_app_ledg
            Where
                empno = param_empno
                And ( Trunc(v_prev_work_date) Between bdate And edate
                      Or Trunc(v_next_work_date) Between bdate And edate )
                And leavetype Not In (
                    'CO',
                    'CL'
                ); -- Combination with CO is allowed

            If v_count > 0 Then
                Return leave_combined_with_csp;
            End If;
        Elsif param_leave_type = 'CO' Then*/
            /*
              Select count(*) Into v_count From ss_leave_app_ledg
                Where empno = param_empno  
                and (trunc(v_prev_work_date) Between bdate And edate 
                      Or trunc(v_next_work_date) Between bdate And edate 
                    );
              if v_count <> 0 Then
                  --Check   C O   C O   combination
                  check_co_co_combination(param_empno,param_bdate,param_edate,v_results);
                  if v_results = ss.failure Then
                      return leave_combined_with_co;
                  End If;
              End if;
              */
            --Null;
        End If;

        Return leave_combined_with_none;
        --Check CL/SL/PL Combination
    End validate_cl_sl_co;

    Function validate_co_spc_co(
        param_empno       Varchar2,
        param_bdate       Date,
        param_edate       Date,
        param_half_day_on Number
    ) Return Number Is
        v_prev_date Date;
        v_next_date Date;
        v_count     Number;
    Begin
        v_prev_date := getlastworkingday(param_bdate, c_reverse);
        v_next_date := getlastworkingday(param_edate, c_forward);
        If param_half_day_on In (
                hd_bdate_presnt_part_2, half_day_on_none
            )
        Then
            Begin
                Select
                    Count(*)
                Into
                    v_count
                From
                    ss_leave_app_ledg
                Where
                    empno         = param_empno
                    And leavetype = leave_type_co
                    And v_next_date Between bdate And edate;

                If v_count = 0 Then
                    Return ss.success;
                End If;
            End;
        End If;

        If param_half_day_on In (
                hd_edate_presnt_part_1, half_day_on_none
            )
        Then
            Begin
                Select
                    Count(*)
                Into
                    v_count
                From
                    ss_leave_app_ledg
                Where
                    empno         = param_empno
                    And leavetype = leave_type_co
                    And v_prev_date Between bdate And edate;

                If v_count = 0 Then
                    Return ss.success;
                Else
                    Return ss.failure;
                End If;

            End;
        End If;

    End;

    Function validate_spc_co_spc(
        param_empno       Varchar2,
        param_bdate       Date,
        param_edate       Date,
        param_half_day_on Number
    ) Return Number Is

        v_lw_date   Date;
        v_bdate     Date := param_bdate;
        v_edate     Date := param_edate;
        v_count     Number;
        v_leavetype Varchar2(2);
    Begin
        If param_half_day_on In (
                hd_bdate_presnt_part_2, half_day_on_none
            )
        Then
            Begin
                Loop
                    v_edate := getlastworkingday(v_edate, c_forward);
                    Select
                        leavetype,
                        edate
                    Into
                        v_leavetype,
                        v_edate
                    From
                        ss_leave_app_ledg
                    Where
                        empno = param_empno
                        And v_edate Between bdate And edate;

                    If v_leavetype <> leave_type_co Then
                        Return ss.failure;
                    End If;
                End Loop;

            Exception
                When Others Then
                    If param_half_day_on = hd_bdate_presnt_part_2 Then
                        Return ss.success;
                    Else
                        Null;
                    End If;
            End;
        End If;

        If param_half_day_on In (
                hd_edate_presnt_part_1, half_day_on_none
            )
        Then
            Begin
                Loop
                    v_bdate := getlastworkingday(v_bdate, c_reverse);
                    Select
                        leavetype,
                        bdate
                    Into
                        v_leavetype,
                        v_bdate
                    From
                        ss_leave_app_ledg
                    Where
                        empno = param_empno
                        And v_bdate Between bdate And edate;

                    If v_leavetype <> leave_type_co Then
                        Return ss.failure;
                    End If;
                End Loop;

            Exception
                When Others Then
                    Return ss.success;
            End;

        End If;

    Exception
        When Others Then
            Return ss.success;
    End;

    Function get_date_4_continuous_leave(
        param_empno           Varchar2,
        param_date            Date,
        param_leave_type      Varchar2,
        param_forward_reverse Varchar2
    ) Return Date Is
        v_ret_date Date;
        v_date     Date;
        v_bdate    Date;
        v_edate    Date;
    Begin
        v_ret_date := param_date;
        v_date     := param_date;
        Loop
            v_date     := getlastworkingday(v_date, param_forward_reverse);
            Select
                bdate,
                edate
            Into
                v_bdate,
                v_edate
            From
                ss_leave_app_ledg
            Where
                empno         = param_empno
                And v_date Between bdate And edate
                And leavetype = param_leave_type;

            If param_forward_reverse = c_forward Then
                v_date := v_edate;
            Else
                v_date := v_bdate;
            End If;

            v_ret_date := v_date;
        End Loop;

    Exception
        When Others Then
            Return v_ret_date;
    End get_date_4_continuous_leave;

    Function check_co_with_adjacent_leave(
        param_empno           Varchar2,
        param_date            Date,
        param_forward_reverse Varchar2
    ) Return Number Is

        v_lw_date   Date;
        v_leavetype Varchar2(2) := 'CO';
        v_ret_val   Number      := ss.success;
        v_date      Date;
    Begin
        v_date := param_date;
        Loop
            If v_leavetype In ('CL', 'SL', 'CO') Then
                v_date := get_date_4_continuous_leave(
                              param_empno,
                              v_date,
                              v_leavetype,
                              param_forward_reverse
                          );
            End If;

            v_lw_date := getlastworkingday(v_date, param_forward_reverse);
            Select
                Case param_forward_reverse
                    When c_reverse Then
                        bdate
                    Else
                        edate
                End,
                leavetype
            Into
                v_date,
                v_leavetype
            From
                ss_leave_app_ledg
            Where
                empno = param_empno
                And v_lw_date Between bdate And edate;

            If v_ret_val = leave_with_adjacent Then
                Return ss.failure;
            Else
                v_ret_val := leave_with_adjacent;
            End If;

        End Loop;

    Exception
        When Others Then
            Return v_ret_val;
    End;

    Function get_continuous_cl_sum(
        param_empno           Varchar2,
        param_date            Date,
        param_reverse_forward Varchar2
    ) Return Number Is

        v_app_no       Varchar2(60);
        v_cumu_leave   Number;
        v_lw_date      Date;
        v_leave_period Number;
        v_leave_bdate  Date;
        v_leave_edate  Date;
        v_prev_lw_dt   Date;
        v_date_diff    Number := 0;
    Begin
        v_cumu_leave := 0;
        v_prev_lw_dt := param_date;
        v_lw_date    := getlastworkingday(param_date, param_reverse_forward);
        Loop
            Begin
                Select
                    app_no
                Into
                    v_app_no
                From
                    ss_leave_app_ledg
                Where
                    empno             = param_empno
                    And (v_lw_date Between bdate And edate
                        And leavetype = leave_type_cl);

                Select
                    leaveperiod,
                    bdate,
                    edate
                Into
                    v_leave_period,
                    v_leave_bdate,
                    v_leave_edate
                From
                    ss_leaveapp
                Where
                    Trim(app_no) = Trim(v_app_no);

                v_cumu_leave := v_cumu_leave + v_leave_period;
                If param_reverse_forward = c_forward Then
                    v_prev_lw_dt := v_lw_date;
                    v_lw_date    := getlastworkingday(v_leave_edate, c_forward);
                Else
                    v_prev_lw_dt := v_lw_date;
                    v_lw_date    := getlastworkingday(v_leave_bdate, c_reverse);
                End If;

            Exception
                When Others Then
                    Exit;
            End;
        End Loop;

        Return v_cumu_leave;
    End;

    Procedure add_leave_adj(
        param_empno       Varchar2,
        param_adj_date    Date,
        param_adj_type    Varchar2,
        param_leave_type  Varchar2,
        param_adj_period  Number,
        param_entry_by    Varchar2,
        param_desc        Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2,
        param_narration   Varchar2 Default Null
    ) As

        v_count      Number;
        v_row_adj    ss_leave_adj%rowtype;
        v_row_count  Number;
        v_adj_no     Varchar2(30);
        v_db_cr      Varchar2(1);
        v_adj_type   Varchar2(2);
        v_leave_type Varchar2(2);
        v_adj_period Number(5, 1);
        v_adj_desc   Varchar2(30);
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno      = param_empno
            And status = 1;

        If v_count = 0 Then
            param_success := 'KO';
            param_message := 'Error :- Employee - "' || param_empno || '" does not exists.';
            Return;
        End If;

        If param_adj_date Is Null Then
            param_success := 'KO';
            param_message := 'Error - Adjustment date cannot be blank.';
            Return;
        End If;

        Begin
            Select
                *
            Into
                v_row_adj
            From
                (
                    Select
                        *
                    From
                        ss_leave_adj
                    Where
                        adj_no Like 'ADJ/%'
                        And empno = Trim(param_empno)
                    Order By adj_dt Desc,
                        adj_no Desc
                )
            Where
                Rownum = 1;

            If to_char(v_row_adj.adj_dt, 'yyyy') <> to_char(sysdate, 'yyyy') Then
                v_row_count := 0;
            Else
                v_row_count := to_number(substr(v_row_adj.adj_no, instr(v_row_adj.adj_no, '/', -1) + 1));
            End If;

        Exception
            When Others Then
                v_row_count := 0;
        End;

        Select
            Count(*)
        Into
            v_count
        From
            ss_leave_adj_mast
        Where
            adj_type || dc = param_adj_type;

        If v_count = 0 Then
            param_success := 'KO';
            param_message := 'Error - ' || 'Leave Adjustment type ' || param_adj_type || ' not found';
            Return;
        End If;

        If param_narration Is Not Null Then
            v_adj_desc := substr(param_narration, 1, 30);
        Else
            Select
                description
            Into
                v_adj_desc
            From
                ss_leave_adj_mast
            Where
                adj_type || dc = param_adj_type;

        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_leavetype
        Where
            leavetype = Trim(param_leave_type);

        If v_count = 0 Then
            param_success := 'KO';
            param_message := 'Error - ' || 'Leave type ' || param_leave_type || 'not found';
            Return;
        End If;

        v_adj_type    := substr(param_adj_type, 1, 2);
        v_db_cr       := substr(param_adj_type, 3, 1);
        v_adj_no      := 'ADJ/' || param_empno || '/' || to_char(sysdate, 'yyyy') || '/' || lpad(v_row_count + 1, 4, '0');

        If v_db_cr = 'D' Then
            v_adj_period := param_adj_period * -8;
        Else
            v_adj_period := param_adj_period * 8;
        End If;

        Insert Into ss_leave_adj (
            empno,
            adj_dt,
            adj_no,
            leavetype,
            db_cr,
            adj_type,
            bdate,
            leaveperiod,
            description,
            dataentryby,
            entry_date
        )
        Values (
            param_empno,
            sysdate,
            v_adj_no,
            param_leave_type,
            v_db_cr,
            v_adj_type,
            param_adj_date,
            v_adj_period,
            param_desc,
            param_entry_by,
            sysdate
        );

        Insert Into ss_leaveledg (
            empno,
            app_date,
            app_no,
            leavetype,
            db_cr,
            adj_type,
            bdate,
            leaveperiod,
            tabletag,
            description
        )
        Values (
            param_empno,
            sysdate,
            v_adj_no,
            param_leave_type,
            v_db_cr,
            v_adj_type,
            param_adj_date,
            v_adj_period,
            0,
            v_adj_desc
        );

        Commit;
        param_success := 'OK';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Error - ' || sqlcode || ' - ' || sqlerrm;
    End;

End leave;
/
---------------------------
--New PACKAGE BODY
--IOT_SWP_EMP_PROJ_MAP
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_EMP_PROJ_MAP" As

   Procedure sp_add_emp_proj(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_empno            Varchar2,
      p_projno           Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   ) As
      v_empno       Varchar2(5);
      v_user_tcp_ip Varchar2(5)  := 'NA';
      v_key_id      Varchar2(10) := dbms_random.string('X', 10);
      v_count       Number       := 0;
   Begin
      v_empno := get_empno_from_meta_id(p_meta_id);

      If v_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;

      Select Count(*) into  v_count
        From SWP_EMP_PROJ_MAPPING
       Where EMPNO = p_empno ;

      If v_count > 0 Then
         p_message_type := 'KO';
         p_message_text := 'Employee record already present';
         Return;
      End If;

      Insert Into SWP_EMP_PROJ_MAPPING
         (KYE_ID, EMPNO, PROJNO, MODIFIED_ON, MODIFIED_BY)
      Values (v_key_id, p_empno, p_projno, sysdate, v_empno);

      If (Sql%ROWCOUNT > 0) Then
         p_message_type := 'OK';
         p_message_text := 'Procedure executed successfully.';
      Else
         p_message_type := 'KO';
         p_message_text := 'Procedure not executed.';
      End If;

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'Err - '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_add_emp_proj;

   Procedure sp_update_emp_proj(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_application_id   Varchar2,
      p_projno           Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   ) As
      v_empno       Varchar2(5);
      v_user_tcp_ip Varchar2(5) := 'NA';
   Begin
      v_empno := get_empno_from_meta_id(p_meta_id);

      If v_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;

      Update SWP_EMP_PROJ_MAPPING
         Set PROJNO = p_projno,
             MODIFIED_ON = sysdate, MODIFIED_BY = v_empno
       Where KYE_ID = p_application_id;

      If (Sql%ROWCOUNT > 0) Then
         p_message_type := 'OK';
         p_message_text := 'Procedure executed successfully.';
      Else
         p_message_type := 'KO';
         p_message_text := 'Procedure not executed.';
      End If;

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'Err - '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_update_emp_proj;

   Procedure sp_delete_emp_proj(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_application_id   Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   ) As
      v_empno        Varchar2(5);
      v_user_tcp_ip  Varchar2(5) := 'NA';
      v_message_type Number      := 0;
   Begin
      v_empno := get_empno_from_meta_id(p_meta_id);

      If v_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;

      Delete From SWP_EMP_PROJ_MAPPING
       Where KYE_ID = p_application_id;

      If (Sql%ROWCOUNT > 0) Then
         p_message_type := 'OK';
         p_message_text := 'Procedure executed successfully.';
      Else
         p_message_type := 'KO';
         p_message_text := 'Procedure not executed.';
      End If;

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'Err - '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_delete_emp_proj;

End IOT_SWP_EMP_PROJ_MAP;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_EMP_PROJ_MAP_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_EMP_PROJ_MAP_QRY" As
 
Function fn_emp_proj_map_list(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      P_assign_code     Varchar2 Default Null,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor
   Is
   c                    Sys_Refcursor;
   v_count              Number;
   v_empno              Varchar2(5);
   v_hod_sec_assign_code              Varchar2(4);
   e_employee_not_found Exception;
   Pragma exception_init(e_employee_not_found, -20001);

Begin

   v_empno := get_empno_from_meta_id(p_meta_id);
   If v_empno = 'ERRRR' Then
      Raise e_employee_not_found;
      Return Null;
   End If;

   If v_empno Is Null Or p_assign_code Is Not Null Then
            v_hod_sec_assign_code := iot_swp_common.get_default_costcode_hod_sec(
                                         p_hod_sec_empno => v_empno,
                                         p_assign_code   => p_assign_code
                                     );
     end if;                                
   Open c For
      Select *
        From (
                Select empprojmap.KYE_ID As keyid,
                       empprojmap.EMPNO As Empno,
                        a.name As Empname,
                       empprojmap.PROJNO As Projno,
                       b.name As Projname,
                       Row_Number() Over (Order By empprojmap.KYE_ID Desc) row_number,
                       Count(*) Over () total_row
                  From SWP_EMP_PROJ_MAPPING empprojmap , 
                        ss_emplmast a , ss_projmast b
                 Where a.empno = empprojmap.empno 
                     and b.projno = empprojmap.PROJNO
                     and  empprojmap.EMPNO In (
                          Select Distinct empno
                            From ss_emplmast
                           Where status = 1
                            And a.assign = nvl(v_hod_sec_assign_code, a.assign)
                            /*
                            And assign In (
                                    Select parent
                                      From ss_user_dept_rights
                                     Where empno = v_empno
                                    Union
                                    Select costcode
                                      From ss_costmast
                                     Where hod = v_empno
                                 )
                            */ 
                       )

             )
       Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
       Order By Empno,PROJNO;
   Return c;

End fn_emp_proj_map_list;

    --  GRANT EXECUTE ON "IOT_SWP_EMP_PROJ_MAP_QRY" TO "TCMPL_APP_CONFIG";

End IOT_SWP_EMP_PROJ_MAP_QRY;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_OFFICE_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_OFFICE_WORKSPACE" As

   Procedure sp_add_office_ws_desk(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_deskid           Varchar2,
      p_empno            Varchar2,
      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   ) As
      strsql            Varchar2(600);
      v_count           Number;
      v_ststue          Varchar2(5);
      v_mod_by_empno    Varchar2(5);
      v_pk              Varchar2(10);
      v_fk              Varchar2(10);
      v_empno           Varchar2(5);
      v_attendance_date Date;
      v_desk            Varchar2(20);
   Begin

      v_mod_by_empno := get_empno_from_meta_id(p_meta_id);

      If v_mod_by_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;

      Select Count(*)
        Into v_count
        From swp_primary_workspace
       Where Trim(empno) = Trim(p_empno)
         And Trim(primary_workspace) = '1';

      If v_count = 0 Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number ' || p_empno;
         Return;
      End If;

      Insert Into dm_vu_emp_desk_map (
         empno,
         deskid,
         modified_on,
         modified_by
      )
      Values (
         p_empno,
         p_deskid,
         sysdate,
         v_mod_by_empno
      );
      Commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';
   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_add_office_ws_desk;

End IOT_SWP_OFFICE_WORKSPACE;
/
---------------------------
--Changed PACKAGE BODY
--HOLIDAY_ATTENDANCE
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."HOLIDAY_ATTENDANCE" As

    Procedure sp_add_holiday (
        p_person_id     Varchar2,
        p_meta_id       Varchar2,
        p_from_date     Date,
        p_projno        Varchar2,
        p_last_hh       Number,
        p_last_mn       Number,
        p_last_hh1      Number,
        p_last_mn1      Number,
        p_lead_approver Varchar2,
        p_remarks       Varchar2,
        p_location      Varchar2,
        p_user_tcp_ip   Varchar2,
        p_message_type  Out Varchar2,
        p_message_text  Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_message_type Number := 0;
    Begin
        If p_location Is Null Or p_projno Is Null Or p_last_hh Is Null Or p_lead_approver Is Null Or p_from_date Is Null Then
            p_message_type := 'KO';
            p_message_text := 'Blank values found. Cannot proceed';
            Return;
        End If;

        --check credentials
        --v_empno := get_empno_from_person_id(p_person_id);
        v_empno    := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        --save application
        add_holiday(p_person_id, p_meta_id, p_from_date, p_projno, p_last_hh,
                   p_last_mn, p_last_hh1, p_last_mn1, p_lead_approver, p_remarks,
                   p_location, p_user_tcp_ip, p_message_type, p_message_text);

        If p_message_type = 'OK' Then
            -- call send mail
            Return;
        Else
            Return;
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_add_holiday;

    Procedure add_holiday (
        p_person_id     Varchar2,
        p_meta_id       Varchar2,
        p_from_date     Date,
        p_projno        Varchar2,
        p_last_hh       Number,
        p_last_mn       Number,
        p_last_hh1      Number,
        p_last_mn1      Number,
        p_lead_approver Varchar2,
        p_remarks       Varchar2,
        p_location      Varchar2,
        p_user_tcp_ip   Varchar2,
        p_message_type  Out Varchar2,
        p_message_text  Out Varchar2
    ) As

        v_empno              Varchar2(5);
        v_count              Number;
        v_lead_approval_none Number := 4;
        v_lead_approval      Number := 0;
        v_hod_approval       Number := 0;
        v_hrd_approval       Number := 0;
        v_recno              Number;
        v_app_no             ss_holiday_attendance.app_no%Type;
        v_description        ss_holiday_attendance.description%Type;
        v_none               Char(4) := 'None';
    Begin
        --check credentials
        --v_empno := get_empno_from_person_id(p_person_id);
        v_empno    := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        --check if application exists
        Select
            Count(empno)
        Into v_count
        From
            ss_holiday_attendance
        Where
                empno = v_empno
            And pdate = p_from_date;

        If v_count = 0 Then
            -- get last counter no.
            Begin
                Select
                    nvl(Max(to_number(substr(app_no, instr(app_no, '/', - 1) + 1))), 0) recno
                Into v_recno
                From
                    ss_holiday_attendance
                Where
                    empno = v_empno
                Group By
                    empno;

            Exception
                When no_data_found Then
                    v_recno := 0;
            End;
            --application no.
            v_app_no := 'HA/'
                        || v_empno
                        || '/'
                        || to_char(sysdate, 'DDMMYYYY')
                        || '/'
                        || to_char(v_recno + 1);

            -- description
            v_description := 'Appl for Holiday Attendance on '
                             || to_char(p_from_date, 'DD/MM/YYYY')
                             || ' Time '
                             || p_last_hh
                             || ':'
                             || p_last_mn
                             || ' - '
                             || p_last_hh1
                             || ':'
                             || p_last_mn1
                             || ' Location - '
                             || p_location;

            Insert Into ss_holiday_attendance (
                empno,
                pdate,
                app_no,
                app_date,
                start_hh,
                start_mm,
                end_hh,
                end_mm,
                remarks,
                location,
                description,
                lead_apprl_empno,
                projno,
                lead_apprl,
                hod_apprl,
                hrd_apprl,
                user_tcp_ip
            ) Values (
                v_empno,
                p_from_date,
                v_app_no,
                sysdate,
                p_last_hh,
                p_last_mn,
                p_last_hh1,
                p_last_mn1,
                p_remarks,
                p_location,
                v_description,
                p_lead_approver,
                p_projno,
                    Case p_lead_approver
                        When v_none Then
                            v_lead_approval_none
                        Else
                            v_lead_approval
                    End,
                v_hod_approval,
                v_hrd_approval,
                p_user_tcp_ip
            );

            Commit;
            p_message_type := 'OK';
            p_message_text := 'Success';
        Else
            p_message_type := 'KO';
            p_message_text := 'Holiday attendance already created !!!';
            Return;
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End add_holiday;

    Procedure sp_delete_holiday (
        p_person_id     Varchar2,
        p_meta_id       Varchar2,
        p_application_id     Varchar2,
        p_message_type  Out Varchar2,
        p_message_text  Out Varchar2   
    ) AS 
        v_empno              Varchar2(5);
        v_count              Number;
    BEGIN
     --check credentials
        --v_empno := get_empno_from_person_id(p_person_id);
        v_empno    := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        --check if application exists
        Select
            Count(*)
        Into v_count
        From
            ss_holiday_attendance
        Where  app_no = p_application_id and pdate > sysdate;

        If v_count > 0 Then     

            Delete from ss_holiday_attendance Where app_no = p_application_id ;
             Commit;
            p_message_type := 'OK';
            p_message_text := 'Success';

        Else
            p_message_type := 'KO';
            p_message_text := 'Application not exists.!!!';
            Return; 
        end if;

   Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
END sp_delete_holiday;

End holiday_attendance;
/
---------------------------
--Changed PACKAGE BODY
--IOT_LEAVE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_LEAVE_QRY" As

    Function get_leave_applications(
        p_empno        Varchar2,
        p_req_for_self Varchar2,
        p_start_date   Date     Default Null,
        p_end_date     Date     Default Null,
        p_leave_type   Varchar2 Default Null,
        p_row_number   Number,
        p_page_length  Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        app_date_4_sort,
                        lead,
                        app_no,
                        application_date,
                        start_date,
                        end_date,
                        leave_type,
                        leave_period,
                        lead_approval_desc,
                        hod_approval_desc,
                        hrd_approval_desc,
                        lead_reason,
                        hod_reason,
                        hrd_reason,
                        from_tab,
                        db_cr,
                        is_pl,
                        can_delete_app,
                        Sum(is_pl) Over (Order By start_date Desc, app_no)   As pl_total,
                        Case
                            When Sum(is_pl) Over (Order By start_date Desc, app_no) <= 3
                                And is_pl = 1
                            Then
                                1
                            Else
                                0
                        End                                                  As can_edit_pl_app,
                        Trim(med_cert_file_name)                             As med_cert_file_name,
                        Row_Number() Over (Order By start_date Desc, app_no) As row_number,
                        Count(*) Over ()                                     As total_row

                    From
                        (
                                (

                        Select
                            la.app_date                             As app_date_4_sort,
                            get_emp_name(la.lead_apprl_empno)       As lead,
                            ltrim(rtrim(la.app_no))                 As app_no,
                            to_char(la.app_date, 'dd-Mon-yyyy')     As application_date,
                            la.bdate                                As start_date,
                            la.edate                                As end_date,
                            Case
                                When nvl(is_covid_sick_leave, 0) = 1
                                    And Trim(leavetype)          = 'SL'
                                Then
                                    'SL-COVID'
                                Else
                                    Trim(leavetype)
                            End                                     As leave_type,
                            to_days(la.leaveperiod)                 As leave_period,
                            ss.approval_text(nvl(la.lead_apprl, 0)) As lead_approval_desc,
                            Case nvl(la.lead_apprl, 0)
                                When ss.disapproved Then
                                    '-'
                                Else
                                    ss.approval_text(nvl(la.hod_apprl, 0))
                            End                                     As hod_approval_desc,
                            Case nvl(la.hod_apprl, 0)
                                When ss.disapproved Then
                                    '-'
                                Else
                                    ss.approval_text(nvl(la.hrd_apprl, 0))
                            End                                     As hrd_approval_desc,
                            la.lead_reason,
                            la.hodreason                            As hod_reason,
                            la.hrdreason                            As hrd_reason,
                            '1'                                     As from_tab,
                            'D'                                     As db_cr,
                            Case
                                When is_rejected = 1 Then
                                    0
                                When nvl(la.hrd_apprl, 0) = 1
                                    And la.leavetype      = 'PL'
                                Then
                                    1
                                Else
                                    0
                            End                                     As is_pl,
                            med_cert_file_name                      As med_cert_file_name,
                            Case
                                When p_req_for_self                  = 'OK'
                                    And nvl(la.lead_apprl, c_pending) In (c_pending, c_apprl_none)
                                    And nvl(la.hod_apprl, c_pending) = c_pending
                                Then
                                    1
                                Else
                                    0
                            End                                     can_delete_app
                        From
                            ss_vu_leaveapp la
                        Where
                            la.app_no Not Like 'Prev%'
                            And Trim(la.empno) = p_empno
                            And la.leavetype   = nvl(p_leave_type, la.leavetype)

                        )
                        Union
                        (
                        Select
                            a.app_date                                                        As app_date_4_sort,
                            ''                                                                As lead,
                            Trim(a.app_no)                                                    As app_no,
                            to_char(a.app_date, 'dd-Mon-yyyy')                                As application_date,
                            a.bdate                                                           As start_date,
                            a.edate                                                           As end_date,
                            Case
                                When nvl(is_covid_sick_leave, 0) = 1
                                    And Trim(leavetype)          = 'SL'
                                Then
                                    'SL-COVID'
                                Else
                                    Trim(leavetype)
                            End                                                               As leave_type,
                            to_days(decode(a.db_cr, 'D', a.leaveperiod * - 1, a.leaveperiod)) As leave_period,
                            'NONE'                                                            As lead_approval_desc,
                            'Approved'                                                        As hod_approval_desc,
                            'Approved'                                                        As hrd_approval_desc,
                            ''                                                                As lead_reason,
                            ''                                                                As hod_reason,
                            ''                                                                As hrd_reason,
                            '2'                                                               As from_tab,
                            db_cr                                                             As db_cr,
                            0                                                                 As is_pl,
                            Null                                                              As med_cert_file_name,
                            0                                                                 As can_delete
                        From
                            ss_leaveledg a
                        Where
                            a.empno         = lpad(Trim(p_empno), 5, 0)
                            And a.app_no Not Like 'Prev%'
                            And a.leavetype = nvl(p_leave_type, a.leavetype)
                            And ltrim(rtrim(a.app_no)) Not In
                            (
                                Select
                                    ss_vu_leaveapp.app_no
                                From
                                    ss_vu_leaveapp
                                Where
                                    ss_vu_leaveapp.empno = p_empno
                            )
                        )

                        )
                    Where
                        start_date >= add_months(sysdate, - 24)
                        And trunc(start_date) Between nvl(p_start_date, trunc(start_date)) And nvl(p_end_date, trunc(start_date))
                    Order By start_date Desc, app_date_4_sort Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End;

    Function get_leave_ledger(
        p_empno       Varchar2,
        p_start_date  Date Default Null,
        p_end_date    Date Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c            Sys_Refcursor;
        v_start_date Date;
        v_end_date   Date;
    Begin
        If p_start_date Is Null Then
            v_start_date := trunc(nvl(p_start_date, sysdate), 'YEAR');
            v_end_date   := add_months(trunc(nvl(p_end_date, sysdate), 'YEAR'), 12) - 1;
        Else
            v_start_date := trunc(p_start_date);
            v_end_date   := trunc(p_end_date);
        End If;
        Open c For
            Select
                app_no,
                app_date As application_date,
                leave_type,
                description,
                b_date   start_date,
                e_date   end_date,
                no_of_days_db,
                no_of_days_cr,
                row_number,
                total_row
            From
                (
                    Select
                        app_no,
                        app_date,
                        Case
                            When nvl(is_covid_sick_leave, 0) = 1
                                And Trim(leavetype)          = 'SL'
                            Then
                                'SL-COVID'
                            Else
                                Trim(leavetype)
                        End                                    As leave_type,
                        description,
                        dispbdate                              b_date,
                        dispedate                              e_date,
                        to_days(dbday)                         no_of_days_db,
                        to_days(crday)                         no_of_days_cr,
                        Row_Number() Over (Order By dispbdate) row_number,
                        Count(*) Over ()                       total_row
                    From
                        ss_displedg
                    Where
                        empno = p_empno
                        And dispbdate Between v_start_date And v_end_date
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End get_leave_ledger;

    Function fn_leave_ledger_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date Default Null,
        p_end_date    Date Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        c       := get_leave_ledger(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
    End fn_leave_ledger_4_self;

    Function fn_leave_ledger_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_start_date  Date Default Null,
        p_end_date    Date Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        Select
            empno
        Into
            v_empno
        From
            ss_emplmast
        Where
            empno = p_empno;
        --And status = 1;
        c := get_leave_ledger(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
    End fn_leave_ledger_4_other;

    Function fn_leave_applications_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
        p_leave_type  Varchar2 Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_self_empno         Varchar2(5);
        v_req_for_self       Varchar2(2);
        v_for_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_self_empno := get_empno_from_meta_id(p_meta_id);
        If v_self_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Select
            empno
        Into
            v_for_empno
        From
            ss_emplmast
        Where
            empno = p_empno;
        --And status = 1;
        If v_self_empno = v_for_empno Then
            v_req_for_self := 'OK';
        Else
            v_req_for_self := 'KO';
        End If;
        c            := get_leave_applications(v_for_empno, v_req_for_self, p_start_date, p_end_date, p_leave_type, p_row_number,
                                               p_page_length);
        Return c;
    End fn_leave_applications_4_other;

    Function fn_leave_applications_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
        p_leave_type  Varchar2 Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        c       := get_leave_applications(v_empno, 'OK', p_start_date, p_end_date, p_leave_type, p_row_number, p_page_length);
        Return c;
    End fn_leave_applications_4_self;

    Function fn_pending_hod_approval(

        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hod_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_hod_empno := get_empno_from_meta_id(p_meta_id);
        If v_hod_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        l.empno || ' - ' || e.name                   As employee_name,
                        parent,
                        app_date                                     As application_date,
                        app_no                                       As application_id,
                        bdate                                        As start_date,
                        edate                                        As end_date,
                        to_days(leaveperiod)                         As leave_period,
                        Case
                            When nvl(is_covid_sick_leave, 0) = 1
                                And Trim(leavetype)          = 'SL'
                            Then
                                'SL-COVID'
                            Else
                                Trim(leavetype)
                        End                                          As leave_type,
                        get_emp_name(l.lead_apprl_empno)             As lead_name,
                        Trim(med_cert_file_name)                     As med_cert_file_name,
                        lead_reason                                  As lead_remarks,
                        hodreason                                    As hod_remarks,
                        hrdreason                                    As hr_remarks,
                        Row_Number() Over (Order By parent, l.empno) row_number,
                        Count(*) Over ()                             total_row

                    From
                        ss_leaveapp                l, ss_emplmast e
                    Where
                        (nvl(hod_apprl, c_pending) = c_pending)
                        And l.empno                = e.empno
                        And e.status               = 1
                        And nvl(lead_apprl, c_pending) In (c_approved, c_apprl_none)
                        And e.mngr                 = Trim(v_hod_empno)
                    Order By parent,
                        l.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_hod_approval;

    Function fn_pending_onbehalf_approval(

        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hod_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_hod_empno := get_empno_from_meta_id(p_meta_id);
        If v_hod_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        l.empno || ' - ' || e.name                   As employee_name,
                        parent,
                        app_date                                     As application_date,
                        app_no                                       As application_id,
                        bdate                                        As start_date,
                        edate                                        As end_date,
                        to_days(leaveperiod)                         As leave_period,
                        leavetype                                    As leave_type,
                        get_emp_name(l.lead_apprl_empno)             As lead_name,
                        Trim(med_cert_file_name)                     As med_cert_file_name,
                        lead_reason                                  As lead_remarks,
                        hodreason                                    As hod_remarks,
                        hrdreason                                    As hr_remarks,
                        Row_Number() Over (Order By parent, l.empno) row_number,
                        Count(*) Over ()                             total_row

                    From
                        ss_leaveapp                l, ss_emplmast e
                    Where
                        (nvl(hod_apprl, c_pending) = c_pending)
                        And l.empno                = e.empno
                        And e.status               = 1
                        And nvl(lead_apprl, c_pending) In (c_approved, c_apprl_none)
                        And e.mngr In (
                            Select
                                mngr
                            From
                                ss_delegate
                            Where
                                empno = Trim(v_hod_empno)
                        )
                    Order By parent,
                        l.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_onbehalf_approval;

    Function fn_pending_hr_approval(

        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_parent      Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hr_empno           Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        /*
            v_hr_empno := get_empno_from_meta_id(p_meta_id);
            If v_hr_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return Null;
            End If;
        */
        Open c For
            Select
                *
            From
                (
                    Select
                        l.empno || ' - ' || e.name                   As employee_name,
                        parent,
                        app_date                                     As application_date,
                        app_no                                       As application_id,
                        bdate                                        As start_date,
                        edate                                        As end_date,
                        to_days(leaveperiod)                         As leave_period,
                        Case
                            When nvl(is_covid_sick_leave, 0) = 1
                                And Trim(leavetype)          = 'SL'
                            Then
                                'SL-COVID'
                            Else
                                Trim(leavetype)
                        End                                          As leave_type,
                        Case leavetype
                            When 'CL' Then
                                closingclbal(l.empno, trunc(sysdate), 0)
                            When 'SL' Then
                                closingslbal(l.empno, trunc(sysdate), 0)
                            When 'PL' Then
                                closingplbal(l.empno, trunc(sysdate), 0)
                            When 'CO' Then
                                closingcobal(l.empno, trunc(sysdate), 0)
                            When 'EX' Then
                                closingexbal(l.empno, trunc(sysdate), 0)
                            When 'OH' Then
                                closingohbal(l.empno, trunc(sysdate), 0)
                            Else
                                0
                        End                                          As leave_balance,
                        --Get_Leave_Balance(l.empno,sysdate,ss.closing_bal,leavetype, :param_Leave_Count)                        
                        get_emp_name(l.lead_apprl_empno)             As lead_name,
                        Trim(med_cert_file_name)                     As med_cert_file_name,
                        lead_reason                                  As lead_remarks,
                        hodreason                                    As hod_marks,
                        hrdreason                                    As hr_remarks,
                        Row_Number() Over (Order By parent, l.empno) row_number,
                        Count(*) Over ()                             total_row

                    From
                        ss_leaveapp                l, ss_emplmast e
                    Where
                        l.empno                         = e.empno
                        And nvl(l.hod_apprl, c_pending) = c_approved
                        And nvl(l.hrd_apprl, c_pending) = c_pending
                        And e.status                    = 1
                        And e.parent                    = nvl(p_parent, e.parent)
                    Order By parent,
                        l.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_hr_approval;

    Function fn_pending_lead_approval(

        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_lead_empno         Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_lead_empno := get_empno_from_meta_id(p_meta_id);
        If v_lead_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        l.empno || ' - ' || e.name                   As employee_name,
                        parent,
                        app_date                                     As application_date,
                        app_no                                       As application_id,
                        bdate                                        As start_date,
                        edate                                        As end_date,
                        to_days(leaveperiod)                         As leave_period,
                        Case
                            When nvl(is_covid_sick_leave, 0) = 1
                                And Trim(leavetype)          = 'SL'
                            Then
                                'SL-COVID'
                            Else
                                Trim(leavetype)
                        End                                          As leave_type,
                        get_emp_name(l.lead_apprl_empno)             As lead_name,
                        Trim(med_cert_file_name)                     As med_cert_file_name,
                        lead_reason                                  As lead_remarks,
                        hodreason                                    As hod_marks,
                        hrdreason                                    As hr_remarks,
                        Row_Number() Over (Order By parent, l.empno) row_number,
                        Count(*) Over ()                             total_row
                    From
                        ss_leaveapp                l, ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0)    = 0)
                        And l.empno            = e.empno
                        And e.status           = 1
                        And l.lead_apprl_empno = Trim(v_lead_empno)
                    Order By parent,
                        l.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_pending_lead_approval;

End iot_leave_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_OFFICE_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_OFFICE_WORKSPACE_QRY" As

    Function fn_office_planning(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date,
        p_assign_code Varchar2 Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                     Sys_Refcursor;
        v_empno               Varchar2(5);
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_query               Varchar2(4000);
        v_hod_sec_assign_code Varchar2(4);
    Begin

        v_query               := c_qry_office_planning;

        v_empno               := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
        End If;

        v_hod_sec_assign_code := iot_swp_common.get_default_costcode_hod_sec(
                                     p_hod_sec_empno => v_empno,
                                     p_assign_code   => p_assign_code
                                 );

        /*
                Insert Into swp_mail_log (subject, mail_sent_to_cc_bcc, modified_on)
                Values (v_empno || '-' || p_row_number || '-' || p_page_length || '-' || to_char(v_start_date, 'yyyymmdd') || '-' ||
                    to_char(v_end_date, 'yyyymmdd'),
                    v_query, sysdate);
                Commit;
                */
        Open c For v_query Using v_hod_sec_assign_code, p_row_number, p_page_length, p_person_id, p_meta_id;

        Return c;

    End;

    Function fn_general_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2 Default Null,
        p_date        Date     Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                      Sys_Refcursor;
        v_count                Number;
        v_empno                Varchar2(5);
        e_employee_not_found   Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c_restricted_area_catg Constant Varchar2(4) := 'A003';
        v_emp_area_code        Varchar2(3);
    Begin
        v_emp_area_code := iot_swp_common.get_emp_work_area_code(p_empno);
        Open c For
            With
                desk_list As (
                    Select
                        *
                    From
                        dm_vu_desk_list  dl,
                        dm_vu_desk_areas da
                    Where
                        da.area_key_id        = dl.work_area
                        And (da.area_catg_code != c_restricted_area_catg
                            Or da.area_key_id = v_emp_area_code
                        )
                        And deskid Not In(
                            Select
                                deskid
                            From
                                dm_vu_desk_lock
                        )
                )
            Select
                *
            From
                (
                    Select
                        a.*,
                        a.total_count - a.occupied_count                            As available_count,
                        Row_Number() Over (Order By area_desc, office, wing, floor) As row_number,
                        Count(*) Over ()                                            As total_row
                    From
                        (
                            Select
                                d.work_area,
                                d.area_catg_code,
                                d.area_desc,
                                d.office,
                                d.floor,
                                d.wing,
                                Count(d.deskid) total_count,
                                Count(ed.empno) occupied_count
                            From
                                desk_list          d,
                                dm_vu_emp_desk_map ed
                            Where
                                d.deskid = ed.deskid(+)
                            Group By office, wing, floor, work_area, area_desc, area_catg_code
                            Order By area_desc, office, wing, floor
                        ) a
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_general_area_list;

    Function fn_work_area_desk(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_date        Date,
        p_work_area   Varchar2,
        p_office      Varchar2 Default Null,
        p_floor       Varchar2 Default Null,
        p_wing        Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_office             dm_vu_desk_list.office%type;
        v_floor              dm_vu_desk_list.floor%type;
        v_wing               dm_vu_desk_list.wing%type;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_office Is Null Then
            v_office := '%';
        Else
            v_office := p_office;
        End If;

        If p_floor Is Null Then
            v_floor := '%';
        Else
            v_floor := p_floor;
        End If;

        If p_wing Is Null Then
            v_wing := '%';
        Else
            v_wing := p_wing;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        mast.deskid                              As deskid,
                        mast.office                              As office,
                        mast.floor                               As floor,
                        mast.seatno                              As seat_no,
                        mast.wing                                As wing,
                        mast.assetcode                           As asset_code,
                        mast.bay                                 As bay,
                        Row_Number() Over (Order By deskid Desc) row_number,
                        Count(*) Over ()                         total_row
                    From
                        dms.dm_deskmaster mast
                    Where
                        mast.work_area                   = Trim(p_work_area)
                        And mast.office Like v_office
                        And mast.floor Like v_floor
                        And nvl(mast.wing,' ')  Like v_wing

                        And mast.deskid
                        Not In(
                            Select
                            swptbl.deskid
                            From
                                swp_smart_attendance_plan swptbl
                            --where (trunc(ATTENDANCE_DATE) = TRUNC(p_date) or p_date is null)
                            Union
                            Select
                            c.deskid
                            From
                                dm_vu_emp_desk_map c
                                union
                            select deskid from dm_vu_desk_lock    
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                deskid,
                seat_no;
        Return c;
    End fn_work_area_desk;

End iot_swp_office_workspace_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_SMART_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_SMART_WORKSPACE_QRY" As

    Function fn_reserved_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_count              Number;

    Begin

        Open c For
            With
                plan As(
                    Select
                        deskid
                    From
                        swp_smart_attendance_plan ap
                    Where
                        ap.attendance_date = p_date
                    Union
                    Select
                        deskid
                    From
                        dm_vu_emp_desk_map
                )
            Select
                *
            From
                (
                    Select
                        aa.*,
                        aa.total_count - aa.occupied_count As available_count,
                        Row_Number() Over (Order By area_desc,
                                work_area,
                                office,
                                floor,
                                wing)                      row_number,
                        Count(*) Over ()                   total_row

                    From
                        (
                            Select
                                da.area_desc,
                                dl.work_area,
                                dl.office,
                                dl.floor,
                                dl.wing,
                                Count(dl.deskid) total_count,
                                Count(ap.deskid) occupied_count
                            From
                                dm_vu_desk_list  dl,
                                dm_vu_desk_areas da,
                                plan             ap
                            Where
                                da.area_key_id        = dl.work_area
                                And da.area_catg_code = 'A001'
                                And dl.deskid         = ap.deskid(+)
                            Group By da.area_desc,
                                dl.work_area,

                                dl.office,
                                dl.floor,
                                dl.wing
                        ) aa
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                area_desc,
                work_area,
                office,
                floor,
                wing;
        Return c;

    End fn_reserved_area_list;

    Function fn_general_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2 Default Null,
        p_date        Date     Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                      Sys_Refcursor;
        v_count                Number;
        v_empno                Varchar2(5);
        e_employee_not_found   Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c_restricted_area_catg Constant Varchar2(4) := 'A003';
        v_emp_area_code        Varchar2(3);
    Begin
        v_emp_area_code := iot_swp_common.get_emp_work_area_code(p_empno);
        Open c For
            With
                desk_list As (
                    Select
                        *
                    From
                        dm_vu_desk_list  dl,
                        dm_vu_desk_areas da
                    Where
                        da.area_key_id        = dl.work_area
                        And (da.area_catg_code != c_restricted_area_catg
                            Or da.area_key_id = v_emp_area_code
                        )
                        And deskid Not In(
                            Select
                                deskid
                            From
                                dm_vu_desk_lock
                            Where
                                unqid <> 'SWPV'
                        )
                        And deskid Not In(
                            Select
                                deskid
                            From
                                swp_smart_attendance_plan ap
                            Where
                                ap.attendance_date = p_date
                        )
                )
            Select
                *
            From
                (
                    Select
                        a.*,
                        a.total_count - a.occupied_count                            As available_count,
                        Row_Number() Over (Order By area_desc, office, wing, floor) As row_number,
                        Count(*) Over ()                                            As total_row
                    From
                        (
                            Select
                                d.work_area,
                                d.area_catg_code,
                                d.area_desc,
                                d.office,
                                d.floor,
                                d.wing,
                                Count(d.deskid) total_count,
                                Count(ed.empno) occupied_count
                            From
                                desk_list          d,
                                dm_vu_emp_desk_map ed
                            Where
                                d.deskid = ed.deskid(+)
                            Group By office, wing, floor, work_area, area_desc, area_catg_code
                            Order By area_desc, office, wing, floor
                        ) a
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_general_area_list;

    Function fn_work_area_desk(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_date        Date,
        p_work_area   Varchar2,
        p_office      Varchar2 Default Null,
        p_floor       Varchar2 Default Null,
        p_wing        Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_office             Varchar2(5);
        v_floor              dm_vu_desk_list.floor%Type;
        v_wing               dm_vu_desk_list.wing%Type;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        If Trim(p_office) Is Null Then
            v_office := '%';
        Else
            v_office := trim(p_office);
        End If;

        If Trim(p_floor) Is Null Then
            v_floor := '%';
        Else
            v_floor := trim(p_floor);
        End If;

        If Trim(p_wing) Is Null Then
            v_wing := '%';
        Else
            v_wing := trim(p_wing);
        End If;

        Open c For
            Select
                *
            From
                (

                    Select
                        mast.deskid                         As deskid,
                        mast.office                         As office,
                        mast.floor                          As floor,
                        mast.seatno                         As seat_no,
                        mast.wing                           As wing,
                        mast.assetcode                      As asset_code,
                        mast.bay                            As bay,
                        Row_Number() Over (Order By deskid) row_number,
                        Count(*) Over ()                    total_row
                    From
                        dm_vu_desk_list mast
                    Where
                        mast.work_area = Trim(p_work_area)

                        And Trim(mast.office) Like v_office
                        And Trim(mast.floor) Like v_floor
                        And nvl(Trim(mast.wing), '-') Like v_wing

                        And mast.deskid
                        Not In(
                            Select
                            Distinct swptbl.deskid
                            From
                                swp_smart_attendance_plan swptbl
                            Where
                                (attendance_date) = (p_date)
                            Union
                            Select
                            Distinct c.deskid
                            From
                                dm_vu_emp_desk_map c
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                deskid,
                seat_no;
        Return c;
    End fn_work_area_desk;

    Function fn_restricted_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return typ_area_list
        Pipelined
    Is
        tab_area_list_ok     typ_area_list;
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        Open cur_restricted_area_list(p_date, Null, Null, Null, p_row_number, p_page_length);
        Loop
            Fetch cur_restricted_area_list Bulk Collect Into tab_area_list_ok Limit 50;
            For i In 1..tab_area_list_ok.count
            Loop
                Pipe Row(tab_area_list_ok(i));
            End Loop;
            Exit When cur_restricted_area_list%notfound;
        End Loop;
        Close cur_restricted_area_list;
        Return;

    End fn_restricted_area_list;

    Function fn_emp_week_attend_planning(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2,
        p_date      Date
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_query              Varchar2(4000);
        v_start_date         Date := iot_swp_common.get_monday_date(trunc(p_date));
        v_end_date           Date := iot_swp_common.get_friday_date(trunc(p_date));
    Begin

        Open c For
            /*
                     With
                        atnd_days As (
                           Select w.empno,
                                  Trim(w.attendance_date) As attendance_date,
                                  Trim(w.deskid) As deskid,
                                  1 As planned
                             From swp_smart_attendance_plan w
                            Where w.empno = p_empno
                              And attendance_date Between v_start_date And v_end_date
                        )

                     Select e.empno As empno,
                            dd.d_day,
                            dd.d_date,
                            nvl(atnd_days.planned, 0) As planned,
                            atnd_days.deskid As deskid
                       From ss_emplmast e,
                            ss_days_details dd,
                            atnd_days
                      Where e.empno = Trim(p_empno)
                        And dd.d_date = atnd_days.attendance_date(+)
                        And d_date Between v_start_date And v_end_date
                      Order By dd.d_date;
            */

            With
                atnd_days As (
                    Select
                        w.empno,
                        Trim(w.attendance_date) As attendance_date,
                        Trim(w.deskid)          As deskid,
                        1                       As planned
                    From
                        swp_smart_attendance_plan w
                    Where
                        w.empno = p_empno
                        And attendance_date Between v_start_date And v_end_date
                ),
                holiday As (
                    Select
                        holiday, 1 As is_holiday
                    From
                        ss_holidays
                    Where
                        holiday Between v_start_date And v_end_date
                )
            Select
                e.empno                   As empno,
                dd.d_day,
                dd.d_date,
                nvl(atnd_days.planned, 0) As planned,
                atnd_days.deskid          As deskid,
                nvl(hh.is_holiday, 0)     As is_holiday
            From
                ss_emplmast     e,
                ss_days_details dd,
                atnd_days,
                holiday         hh
            Where
                e.empno       = Trim(p_empno)

                And dd.d_date = atnd_days.attendance_date(+)
                And dd.d_date = hh.holiday(+)
                And d_date Between v_start_date And v_end_date
            Order By
                dd.d_date;
        Return c;

    End;
    Function fn_week_attend_planning(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date     Default sysdate,
        p_assign_code Varchar2 Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_query              Varchar2(4200);
        v_start_date         Date := iot_swp_common.get_monday_date(p_date) - 1;
        v_end_date           Date := iot_swp_common.get_friday_date(p_date);
        Cursor cur_days Is
            Select
                to_char(d_date, 'yyyymmdd') yymmdd, to_char(d_date, 'DY') dday
            From
                ss_days_details
            Where
                d_date Between v_start_date And v_end_date;
    Begin
        --v_start_date := get_monday_date(p_date);
        --v_end_date   := get_friday_date(p_date);

        v_query := c_qry_attendance_planning;
        For c1 In cur_days
        Loop
            If c1.dday = 'MON' Then
                v_query := replace(v_query, '!MON!', chr(39) || c1.yymmdd || chr(39));
            Elsif c1.dday = 'TUE' Then
                v_query := replace(v_query, '!TUE!', chr(39) || c1.yymmdd || chr(39));
            Elsif c1.dday = 'WED' Then
                v_query := replace(v_query, '!WED!', chr(39) || c1.yymmdd || chr(39));
            Elsif c1.dday = 'THU' Then
                v_query := replace(v_query, '!THU!', chr(39) || c1.yymmdd || chr(39));
            Elsif c1.dday = 'FRI' Then
                v_query := replace(v_query, '!FRI!', chr(39) || c1.yymmdd || chr(39));
            End If;
        End Loop;
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
        End If;
        /*
                Insert Into swp_mail_log (subject, mail_sent_to_cc_bcc, modified_on)
                Values (v_empno || '-' || p_row_number || '-' || p_page_length || '-' || to_char(v_start_date, 'yyyymmdd') || '-' ||
                    to_char(v_end_date, 'yyyymmdd'),
                    v_query, sysdate);
                Commit;
                */
        Open c For v_query Using v_empno, p_row_number, p_page_length, v_start_date, v_end_date, p_person_id, p_meta_id, p_assign_code;

        Return c;

    End;

End iot_swp_smart_workspace_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_PRIMARY_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_PRIMARY_WORKSPACE" As

    Procedure del_emp_desk_future_planning(
        p_empno               Varchar2,
        p_planning_start_date Date
    ) As
    Begin
        Delete
            From dms.dm_emp_desk_map
        Where
            empno = Trim(p_empno);

        Delete
            From swp_smart_attendance_plan
        Where
            empno = Trim(p_empno)
            And attendance_date >= p_planning_start_date;

        Delete
            From swp_primary_workspace
        Where
            empno = Trim(p_empno)
            And start_date >= p_planning_start_date;

    End;

    /*
        Procedure del_emp_desk_future_planning(
            p_empno               Varchar2,
            p_planning_start_date Date
        ) As
        Begin
            Delete
                From dms.dm_emp_desk_map
            Where
                empno = Trim(p_empno);

            Delete
                From swp_smart_attendance_plan
            Where
                empno = Trim(p_empno)
                And attendance_date >= p_planning_start_date;

            Delete
                From swp_primary_workspace
            Where
                empno = Trim(p_empno)
                And start_date >= p_planning_start_date;

        End;
    */

    Procedure sp_add_weekly_atnd(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_weekly_attendance typ_tab_string,
        p_empno             Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        strsql            Varchar2(600);
        v_count           Number;
        v_status          Varchar2(5);
        v_mod_by_empno    Varchar2(5);
        v_pk              Varchar2(10);
        v_fk              Varchar2(10);
        v_empno           Varchar2(5);
        v_attendance_date Date;
        v_desk            Varchar2(20);
    Begin

        v_mod_by_empno := get_empno_from_meta_id(p_meta_id);

        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            swp_primary_workspace
        Where
            Trim(empno)                 = Trim(p_empno)
            And Trim(primary_workspace) = 2;

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number ' || p_empno;
            Return;
        End If;

        For i In 1..p_weekly_attendance.count
        Loop

            With
                csv As (
                    Select
                        p_weekly_attendance(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1))          empno,
                to_date(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) attendance_date,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3))          desk,
                Trim(regexp_substr(str, '[^~!~]+', 1, 4))          ststue
            Into
                v_empno, v_attendance_date, v_desk, v_status
            From
                csv;

            Delete
                From swp_smart_attendance_plan
            Where
                empno               = v_empno
                And attendance_date = v_attendance_date;

            If v_status = '1' Then

                v_pk := dbms_random.string('X', 10);

                Select
                    key_id
                Into
                    v_fk
                From
                    swp_primary_workspace
                Where
                    Trim(empno)                 = Trim(p_empno)
                    And Trim(primary_workspace) = '2';

                Insert Into swp_smart_attendance_plan
                (
                    key_id,
                    ws_key_id,
                    empno,
                    attendance_date,
                    deskid,
                    modified_on,
                    modified_by
                )
                Values
                (
                    v_pk,
                    v_fk,
                    v_empno,
                    v_attendance_date,
                    v_desk,
                    sysdate,
                    v_mod_by_empno
                );

            End If;

        End Loop;
        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_weekly_atnd;

    Procedure sp_assign_work_space(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_emp_workspace_array typ_tab_string,
        p_message_type Out    Varchar2,
        p_message_text Out    Varchar2
    ) As
        v_workspace_code      Number;
        v_mod_by_empno        Varchar2(5);
        v_count               Number;
        v_key                 Varchar2(10);
        v_empno               Varchar2(5);
        rec_config_week       swp_config_weeks%rowtype;
        c_planning_future     Constant Number(1) := 2;
        c_planning_current    Constant Number(1) := 1;
        c_planning_is_open    Constant Number(1) := 1;
        Type typ_tab_primary_workspace Is Table Of swp_primary_workspace%rowtype Index By Binary_Integer;
        tab_primary_workspace typ_tab_primary_workspace;
    Begin
        v_mod_by_empno := get_empno_from_meta_id(p_meta_id);
        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        Begin

            Select
                *
            Into
                rec_config_week
            From
                swp_config_weeks
            Where
                planning_flag     = c_planning_future
                And planning_open = c_planning_is_open;
        Exception
            When Others Then
                p_message_type := 'KO';
                p_message_text := 'Err - SWP Planning is not open. Cannot proceed.';
                Return;
        End;

        For i In 1..p_emp_workspace_array.count
        Loop

            With
                csv As (
                    Select
                        p_emp_workspace_array(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1)) empno,
                Trim(regexp_substr(str, '[^~!~]+', 1, 2)) workspace_code
            Into
                v_empno, v_workspace_code
            From
                csv;

            Select
                * Bulk Collect
            Into
                tab_primary_workspace
            From
                (
                    Select
                        *
                    From
                        swp_primary_workspace
                    Where
                        empno = Trim(v_empno)
                    Order By start_date Desc
                )
            Where
                Rownum <= 2;

            If tab_primary_workspace.count > 0 Then
                --If same FUTURE record exists in database then continue
                If tab_primary_workspace(1).primary_workspace = v_workspace_code Then
                    Continue;
                End If;

                --Delete existing DESK ASSIGNMENT
                del_emp_desk_future_planning(
                    p_empno               => tab_primary_workspace(1).empno,
                    p_planning_start_date => trunc(rec_config_week.start_date)
                );
                If tab_primary_workspace(1).active_code = c_planning_future Then
                    If tab_primary_workspace.Exists(2) Then
                        If tab_primary_workspace(2).primary_workspace = v_workspace_code Then
                            Continue;
                        End If;
                    End If;
                End If;
            End If;
            v_key := dbms_random.string('X', 10);
            Insert Into swp_primary_workspace (
                key_id,
                empno,
                primary_workspace,
                start_date,
                modified_on,
                modified_by,
                active_code
            )
            Values (
                v_key,
                v_empno,
                v_workspace_code,
                rec_config_week.start_date,
                sysdate,
                v_mod_by_empno,
                c_planning_future
            );
            Commit;
        End Loop;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_add_office_ws_desk(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_deskid           Varchar2,
        p_empno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        strsql            Varchar2(600);
        v_count           Number;
        v_status          Varchar2(5);
        v_mod_by_empno    Varchar2(5);
        v_pk              Varchar2(10);
        v_fk              Varchar2(10);
        v_empno           Varchar2(5);
        v_attendance_date Date;
        v_desk            Varchar2(20);
    Begin

        v_mod_by_empno := get_empno_from_meta_id(p_meta_id);

        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            swp_primary_workspace
        Where
            Trim(empno)                 = Trim(p_empno)
            And Trim(primary_workspace) = '1';

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number ' || p_empno;
            Return;
        End If;

        Insert Into dm_vu_emp_desk_map (
            empno,
            deskid
            --,modified_on,
            --modified_by
        )
        Values (
            p_empno,
            p_deskid
            --,sysdate,
            --v_mod_by_empno
        );
        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_office_ws_desk;

    Procedure sp_workspace_summary(
        p_person_id                      Varchar2,
        p_meta_id                        Varchar2,

        p_assign_code                    Varchar2 Default Null,
        p_start_date                     Date     Default Null,

        p_total_emp_count            Out Number,
        p_emp_count_office_workspace Out Number,
        p_emp_count_smart_workspace  Out Number,
        p_emp_count_not_in_ho        Out Number,

        p_emp_perc_office_workspace       Out Number,
        p_emp_perc_smart_workspace        Out Number,

        p_message_type               Out Varchar2,
        p_message_text               Out Varchar2
    ) As
        v_empno              Varchar2(5);
        v_total               Number;
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_friday_date        Date;
        Cursor cur_sum Is

            With
                assign_codes As (
                    Select
                        assign
                    From
                        (
                            Select
                                assign
                            From
                                (
                                    Select
                                        costcode As assign
                                    From
                                        ss_costmast
                                    Where
                                        hod = v_empno
                                    Union
                                    Select
                                        parent As assign
                                    From
                                        ss_user_dept_rights
                                    Where
                                        empno = v_empno
                                )
                            Where
                                assign = nvl(p_assign_code, assign)
                            Order By assign
                        )
                    Where
                        Rownum = 1
                ),
                primary_work_space As(
                    Select
                        a.empno, a.primary_workspace, a.start_date
                    From
                        swp_primary_workspace a
                    Where
                        trunc(a.start_date) = (
                            Select
                                Max(trunc(start_date))
                            From
                                swp_primary_workspace b
                            Where
                                b.empno = a.empno
                                And b.start_date <= v_friday_date
                        )
                )
            Select
                workspace, Count(empno) emp_count
            From
                (
                    Select
                        empno, nvl(primary_workspace, 3) workspace
                    From
                        (
                            Select
                                e.empno, emptype, status, aw.primary_workspace
                            From
                                ss_emplmast        e,
                                primary_work_space aw,
                                assign_codes       ac
                            Where
                                e.assign    = ac.assign
                                And e.empno = aw.empno(+)
                                And status  = 1
                                And emptype In (
                                    Select
                                        emptype
                                    From
                                        swp_include_emptype
                                )
                                And e.assign Not In (
                                    Select
                                        assign
                                    From
                                        swp_exclude_assign
                                )

                        )
                )
            Group By
                workspace;
    Begin
        v_friday_date     := iot_swp_common.get_friday_date(nvl(p_start_date, sysdate));
        v_empno           := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;
        For c1 In cur_sum
        Loop
            If c1.workspace = 1 Then
                p_emp_count_office_workspace := c1.emp_count;
            Elsif c1.workspace = 2 Then
                p_emp_count_smart_workspace := c1.emp_count;
            Elsif c1.workspace = 3 Then
                p_emp_count_not_in_ho := c1.emp_count;
            End If;

        End Loop;
        p_total_emp_count := nvl(p_emp_count_office_workspace, 0) + nvl(p_emp_count_smart_workspace, 0) + nvl(p_emp_count_not_in_ho, 0);
        v_total := ( nvl(p_total_emp_count, 0)  -  nvl(p_emp_count_not_in_ho, 0)) ;
        p_emp_perc_office_workspace := ROUND( ( (nvl(p_emp_count_office_workspace, 0) / v_total) * 100 ), 1);
        p_emp_perc_smart_workspace := ROUND(( (nvl(p_emp_count_smart_workspace, 0) / v_total) * 100 ) , 1);

        p_message_type    := 'OK';
        p_message_text    := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_workspace_plan_summary(
        p_person_id                      Varchar2,
        p_meta_id                        Varchar2,

        p_assign_code                    Varchar2 Default Null,

        p_total_emp_count            Out Number,
        p_emp_count_office_workspace Out Number,
        p_emp_count_smart_workspace  Out Number,
        p_emp_count_not_in_ho        Out Number,

        p_emp_perc_office_workspace       Out Number,
        p_emp_perc_smart_workspace        Out Number,

        p_message_type               Out Varchar2,
        p_message_text               Out Varchar2
    ) As
        v_plan_friday_date Date;      
        rec_config_week    swp_config_weeks%rowtype;
    Begin
        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = 2;
        v_plan_friday_date := rec_config_week.end_date;
        sp_workspace_summary(
            p_person_id                  => p_person_id,
            p_meta_id                    => p_meta_id,

            p_assign_code                => p_assign_code,
            p_start_date                 => v_plan_friday_date,

            p_total_emp_count            => p_total_emp_count,
            p_emp_count_office_workspace => p_emp_count_office_workspace,
            p_emp_count_smart_workspace  => p_emp_count_smart_workspace,
            p_emp_count_not_in_ho        => p_emp_count_not_in_ho,

            p_emp_perc_office_workspace => p_emp_perc_office_workspace,
            p_emp_perc_smart_workspace  => p_emp_perc_smart_workspace,

            p_message_type               => p_message_type,
            p_message_text               => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_smart_ws_weekly_summary(
        p_person_id                     Varchar2,
        p_meta_id                       Varchar2,

        p_assign_code                   Varchar2,
        p_date                          Date,

        p_emp_count_smart_workspace Out Number,
        p_emp_count_mon             Out Number,
        p_emp_count_tue             Out Number,
        p_emp_count_wed             Out Number,
        p_emp_count_thu             Out Number,
        p_emp_count_fri             Out Number,
        p_costcode_desc             Out Varchar2,
        p_message_type              Out Varchar2,
        p_message_text              Out Varchar2
    ) As
        v_start_date Date;
        v_end_date   Date;
        Cursor cur_summary(cp_start_date Date,
                           cp_end_date   Date) Is
            Select
                attendance_day, Count(empno) emp_count
            From
                (
                    Select
                        e.empno, to_char(attendance_date, 'DY') attendance_day
                    From
                        ss_emplmast               e,
                        swp_smart_attendance_plan wa
                    Where
                        e.assign    = p_assign_code
                        And attendance_date Between cp_start_date And cp_end_date
                        And e.empno = wa.empno(+)
                        And status  = 1
                        And emptype In (
                            Select
                                emptype
                            From
                                swp_include_emptype
                        )
                )
            Group By
                attendance_day;

    Begin
        v_start_date   := iot_swp_qry.get_monday_date(p_date);
        v_end_date     := iot_swp_qry.get_friday_date(p_date);
        Select
            costcode || ' - ' || name
        Into
            p_costcode_desc
        From
            ss_costmast
        Where
            costcode = p_assign_code;

        For c1 In cur_summary(v_start_date, v_end_date)
        Loop
            If c1.attendance_day = 'MON' Then
                p_emp_count_mon := c1.emp_count;
            Elsif c1.attendance_day = 'TUE' Then
                p_emp_count_tue := c1.emp_count;
            Elsif c1.attendance_day = 'WED' Then
                p_emp_count_wed := c1.emp_count;
            Elsif c1.attendance_day = 'THU' Then
                p_emp_count_thu := c1.emp_count;
            Elsif c1.attendance_day = 'FRI' Then
                p_emp_count_fri := c1.emp_count;
            End If;
        End Loop;

        Select
            Count(*)
        Into
            p_emp_count_smart_workspace
        From
            swp_primary_workspace
        Where
            primary_workspace = 2
            And empno In (
                Select
                    empno
                From
                    ss_emplmast
                Where
                    status     = 1
                    And assign = p_assign_code
            );
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

End iot_swp_primary_workspace;
/
---------------------------
--Changed PACKAGE BODY
--IOT_LEAVE
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_LEAVE" As

    Procedure sp_process_disapproved_app(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2
    ) As
        v_medical_cert_file Varchar2(100);
        v_msg_type          Varchar2(15);
        v_msg_text          Varchar2(1000);
    Begin
        Insert Into ss_leaveapp_rejected (
            app_no,
            empno,
            app_date,
            rep_to,
            projno,
            caretaker,
            leaveperiod,
            leavetype,
            bdate,
            edate,
            reason,
            mcert,
            work_ldate,
            resm_date,
            contact_add,
            contact_phn,
            contact_std,
            last_hrs,
            last_mn,
            resm_hrs,
            resm_mn,
            dataentryby,
            office,
            hod_apprl,
            hod_apprl_dt,
            hod_code,
            hrd_apprl,
            hrd_apprl_dt,
            hrd_code,
            discrepancy,
            user_tcp_ip,
            hod_tcp_ip,
            hrd_tcp_ip,
            hodreason,
            hrdreason,
            hd_date,
            hd_part,
            lead_apprl,
            lead_apprl_dt,
            lead_code,
            lead_tcp_ip,
            lead_apprl_empno,
            lead_reason,
            rejected_on,
            is_covid_sick_leave,
            med_cert_file_name
        )
        Select
            app_no,
            empno,
            app_date,
            rep_to,
            projno,
            caretaker,
            leaveperiod,
            leavetype,
            bdate,
            edate,
            reason,
            mcert,
            work_ldate,
            resm_date,
            contact_add,
            contact_phn,
            contact_std,
            last_hrs,
            last_mn,
            resm_hrs,
            resm_mn,
            dataentryby,
            office,
            hod_apprl,
            hod_apprl_dt,
            hod_code,
            hrd_apprl,
            hrd_apprl_dt,
            hrd_code,
            discrepancy,
            user_tcp_ip,
            hod_tcp_ip,
            hrd_tcp_ip,
            hodreason,
            hrdreason,
            hd_date,
            hd_part,
            lead_apprl,
            lead_apprl_dt,
            lead_code,
            lead_tcp_ip,
            lead_apprl_empno,
            lead_reason,
            sysdate,
            is_covid_sick_leave,
            med_cert_file_name
        From
            ss_leaveapp
        Where
            Trim(app_no) = p_application_id;
        sp_delete_leave_app(
            p_person_id              => p_person_id,
            p_meta_id                => p_meta_id,

            p_application_id         => Trim(p_application_id),

            p_medical_cert_file_name => v_medical_cert_file,
            p_message_type           => v_msg_type,
            p_message_text           => v_msg_text
        );
    End;

    Procedure get_leave_balance_all(
        p_empno            Varchar2,
        p_pdate            Date Default Null,
        p_open_close_flag  Number,

        p_cl           Out Varchar2,
        p_sl           Out Varchar2,
        p_pl           Out Varchar2,
        p_ex           Out Varchar2,
        p_co           Out Varchar2,
        p_oh           Out Varchar2,
        p_lv           Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As

        v_cl  Number;
        v_sl  Number;
        v_pl  Number;
        v_ex  Number;
        v_co  Number;
        v_oh  Number;
        v_lv  Number;
        v_tot Number;
    Begin
        get_leave_balance(
            param_empno       => p_empno,
            param_date        => p_pdate,
            param_open_close  => p_open_close_flag,
            param_leave_type  => 'LV',
            param_leave_count => v_lv
        );

        openbal(
            v_empno       => p_empno,
            v_opbaldtfrom => p_pdate,
            v_openbal     => p_open_close_flag,
            v_cl          => v_cl,
            v_pl          => v_pl,
            v_sl          => v_sl,
            v_ex          => v_ex,
            v_co          => v_co,
            v_oh          => v_oh,
            v_tot         => v_tot
        );

        p_cl := to_days(v_cl);
        p_pl := to_days(v_pl);
        p_sl := to_days(v_sl);
        p_ex := to_days(v_ex);
        p_co := to_days(v_co);
        p_oh := to_days(v_oh);
        p_lv := to_days(v_lv);

        p_cl := nvl(trim(p_cl), '0.0');
        p_pl := nvl(trim(p_pl), '0.0');
        p_sl := nvl(trim(p_sl), '0.0');
        p_ex := nvl(trim(p_ex), '0.0');
        p_co := nvl(trim(p_co), '0.0');
        p_oh := nvl(trim(p_oh), '0.0');
        p_lv := nvl(trim(p_lv), '0.0');

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure get_leave_details_from_app(
        p_application_id         Varchar2,

        p_emp_name           Out Varchar2,
        p_leave_type         Out Varchar2,
        p_application_date   Out Varchar2,
        p_start_date         Out Varchar2,
        p_end_date           Out Varchar2,

        p_leave_period       Out Number,
        p_last_reporting     Out Varchar2,
        p_resuming           Out Varchar2,

        p_projno             Out Varchar2,
        p_care_taker         Out Varchar2,
        p_reason             Out Varchar2,
        p_med_cert_available Out Varchar2,
        p_contact_address    Out Varchar2,
        p_contact_std        Out Varchar2,
        p_contact_phone      Out Varchar2,
        p_office             Out Varchar2,
        p_lead_name          Out Varchar2,
        p_discrepancy        Out Varchar2,
        p_med_cert_file_nm   Out Varchar2,

        p_lead_approval      Out Varchar2,
        p_hod_approval       Out Varchar2,
        p_hr_approval        Out Varchar2,

        p_lead_reason        Out Varchar2,
        p_hod_reason         Out Varchar2,
        p_hr_reason          Out Varchar2,

        p_flag_can_del       Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    ) As
        v_leave_app ss_vu_leaveapp%rowtype;
    Begin
        Select
            *
        Into
            v_leave_app
        From
            ss_vu_leaveapp
        Where
            Trim(app_no) = Trim(p_application_id);
        p_emp_name           := get_emp_name(v_leave_app.empno);
        p_leave_type         := v_leave_app.leavetype;
        p_application_date   := to_char(v_leave_app.app_date, 'dd-Mon-yyyy');
        p_start_date         := to_char(v_leave_app.bdate, 'dd-Mon-yyyy');
        p_end_date           := to_char(v_leave_app.edate, 'dd-Mon-yyyy');

        p_leave_period       := to_days(v_leave_app.leaveperiod);
        p_last_reporting     := to_char(v_leave_app.work_ldate, 'dd-Mon-yyyy');
        p_resuming           := to_char(v_leave_app.resm_date, 'dd-Mon-yyyy');

        p_projno             := v_leave_app.projno;
        p_care_taker         := v_leave_app.caretaker;
        p_reason             := v_leave_app.reason;
        p_med_cert_available := v_leave_app.mcert;
        p_contact_address    := v_leave_app.contact_add;
        p_contact_std        := v_leave_app.contact_std;
        p_contact_phone      := v_leave_app.contact_phn;
        p_office             := v_leave_app.office;
        p_lead_name          := get_emp_name(v_leave_app.lead_code);
        p_discrepancy        := v_leave_app.discrepancy;
        p_med_cert_file_nm   := v_leave_app.med_cert_file_name;

        If nvl(v_leave_app.lead_apprl, 0) != 0 Or nvl(v_leave_app.hod_apprl, 0) != 0 Or nvl(v_leave_app.hrd_apprl, 0) != 0
        Then
            p_flag_can_del := 'KO';
        Else
            p_flag_can_del := 'OK';
        End If;

        p_lead_approval      := ss.approval_text(v_leave_app.lead_apprl);
        p_hod_approval       := Case
                                    When v_leave_app.lead_apprl = ss.disapproved Then
                                        '-'
                                    Else
                                        ss.approval_text(v_leave_app.hod_apprl)
                                End;
        p_hr_approval        := Case
                                    When v_leave_app.hod_apprl = ss.disapproved Then
                                        '-'
                                    Else
                                        ss.approval_text(v_leave_app.hrd_apprl)
                                End;
        p_lead_reason        := v_leave_app.lead_reason;
        p_hod_reason         := v_leave_app.hodreason;
        p_hr_reason          := v_leave_app.hrdreason;

        p_message_text       := 'OK';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure get_leave_details_from_adj(
        p_application_id       Varchar2,

        p_emp_name         Out Varchar2,
        p_leave_type       Out Varchar2,
        p_application_date Out Varchar2,
        p_start_date       Out Varchar2,
        p_end_date         Out Varchar2,

        p_leave_period     Out Number,
        p_med_cert_file_nm Out Varchar2,

        p_reason           Out Varchar2,

        p_lead_approval    Out Varchar2,
        p_hod_approval     Out Varchar2,
        p_hr_approval      Out Varchar2,

        p_message_type     Out Varchar2,
        p_message_text     Out Varchar2
    ) As
        v_leave_adj ss_leave_adj%rowtype;
    Begin
        Select
            *
        Into
            v_leave_adj
        From
            ss_leave_adj
        Where
            adj_no = p_application_id;
        p_emp_name         := get_emp_name(v_leave_adj.empno);
        p_leave_type       := v_leave_adj.leavetype;
        p_application_date := to_char(v_leave_adj.adj_dt, 'dd-Mon-yyyy');
        p_start_date       := to_char(v_leave_adj.bdate, 'dd-Mon-yyyy');
        p_end_date         := to_char(v_leave_adj.edate, 'dd-Mon-yyyy');
        p_med_cert_file_nm := v_leave_adj.med_cert_file_name;

        p_leave_period     := to_days(v_leave_adj.leaveperiod);
        p_reason           := v_leave_adj.description;
        p_message_text     := 'OK';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_validate_new_leave(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_leave_type         Varchar2,
        p_start_date         Date,
        p_end_date           Date,
        p_half_day_on        Number,

        p_leave_period   Out Number,
        p_last_reporting Out Varchar2,
        p_resuming       Out Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2

    ) As
        v_empno        Varchar2(5);
        v_message_type Varchar2(2);
        v_count        Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee by person id';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = v_empno;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        leave.validate_leave(
            param_empno          => v_empno,
            param_leave_type     => p_leave_type,
            param_bdate          => trunc(p_start_date),
            param_edate          => trunc(p_end_date),
            param_half_day_on    => p_half_day_on,
            param_app_no         => Null,
            param_leave_period   => p_leave_period,
            param_last_reporting => p_last_reporting,
            param_resuming       => p_resuming,
            param_msg_type       => v_message_type,
            param_msg            => p_message_text
        );
        If v_message_type = ss.failure Then
            p_message_type := 'KO';
        Else
            p_message_type := 'OK';
        End If;
    Exception
        When Others Then
            p_message_type := ss.failure;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_validate_new_leave;

    Procedure sp_validate_pl_revision(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_application_id     Varchar2,
        p_leave_type         Varchar2,
        p_start_date         Date,
        p_end_date           Date,
        p_half_day_on        Number,

        p_leave_period   Out Number,
        p_last_reporting Out Varchar2,
        p_resuming       Out Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2

    ) As
        v_empno        Varchar2(5);
        v_message_type Varchar2(2);
        v_count        Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee by metaid';
            Return;
        End If;

        leave.validate_leave(
            param_empno          => v_empno,
            param_leave_type     => p_leave_type,
            param_bdate          => trunc(p_start_date),
            param_edate          => trunc(p_end_date),
            param_half_day_on    => p_half_day_on,
            param_app_no         => p_application_id,
            param_leave_period   => p_leave_period,
            param_last_reporting => p_last_reporting,
            param_resuming       => p_resuming,
            param_msg_type       => v_message_type,
            param_msg            => p_message_text
        );
        If v_message_type = ss.failure Then
            p_message_type := 'KO';
        Else
            p_message_type := 'OK';
        End If;
    Exception
        When Others Then
            p_message_type := ss.failure;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_validate_pl_revision;

    Procedure sp_add_leave_application(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_leave_type             Varchar2,
        p_start_date             Date,
        p_end_date               Date,
        p_half_day_on            Number,
        p_projno                 Varchar2,
        p_care_taker             Varchar2,
        p_reason                 Varchar2,
        p_med_cert_available     Varchar2 Default Null,
        p_contact_address        Varchar2 Default Null,
        p_contact_std            Varchar2 Default Null,
        p_contact_phone          Varchar2 Default Null,
        p_office                 Varchar2,
        p_lead_empno             Varchar2,
        p_discrepancy            Varchar2 Default Null,
        p_med_cert_file_nm       Varchar2 Default Null,

        p_new_application_id Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    ) As

        v_empno        Varchar2(5);
        v_message_type Varchar2(2);
        v_count        Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee by person id';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = v_empno;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        leave.add_leave_app(
            param_empno            => v_empno,
            param_leave_type       => p_leave_type,
            param_bdate            => p_start_date,
            param_edate            => p_end_date,
            param_half_day_on      => p_half_day_on,
            param_projno           => p_projno,
            param_caretaker        => p_care_taker,
            param_reason           => p_reason,
            param_cert             => p_med_cert_available,
            param_contact_add      => p_contact_address,
            param_contact_std      => p_contact_std,
            param_contact_phn      => p_contact_phone,
            param_office           => p_office,
            param_dataentryby      => v_empno,
            param_lead_empno       => p_lead_empno,
            param_discrepancy      => p_discrepancy,
            param_med_cert_file_nm => p_med_cert_file_nm,
            param_tcp_ip           => Null,
            param_nu_app_no        => p_new_application_id,
            param_msg_type         => v_message_type,
            param_msg              => p_message_text
        );

        If v_message_type = ss.failure Then
            p_message_type := 'KO';
        Else
            p_message_type := 'OK';
        End If;

    End;

    Procedure sp_pl_revision_save(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_application_id         Varchar2,
        p_start_date             Date,
        p_end_date               Date,
        p_half_day_on            Number,
        p_lead_empno             Varchar2,
        p_new_application_id Out Varchar2,
        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    ) As

        v_empno        Varchar2(5);
        v_message_type Varchar2(2);
        v_count        Number;
    Begin
        --v_message_type := '1234';
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee by person id';
            Return;
        End If;

        leave.save_pl_revision(
            param_empno       => v_empno,
            param_app_no      => p_application_id,
            param_bdate       => p_start_date,
            param_edate       => p_end_date,
            param_half_day_on => p_half_day_on,
            param_dataentryby => v_empno,
            param_lead_empno  => p_lead_empno,
            param_discrepancy => Null,
            param_tcp_ip      => Null,
            param_nu_app_no   => p_new_application_id,
            param_msg_type    => v_message_type,
            param_msg         => p_message_text
        );

        If v_message_type = ss.failure Then
            p_message_type := 'KO';
        Else
            p_message_type := 'OK';
        End If;

    End;

    Procedure sp_leave_details(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_application_id         Varchar2,

        p_emp_name           Out Varchar2,
        p_leave_type         Out Varchar2,
        p_application_date   Out Varchar2,
        p_start_date         Out Varchar2,
        p_end_date           Out Varchar2,

        p_leave_period       Out Number,
        p_last_reporting     Out Varchar2,
        p_resuming           Out Varchar2,

        p_projno             Out Varchar2,
        p_care_taker         Out Varchar2,
        p_reason             Out Varchar2,
        p_med_cert_available Out Varchar2,
        p_contact_address    Out Varchar2,
        p_contact_std        Out Varchar2,
        p_contact_phone      Out Varchar2,
        p_office             Out Varchar2,
        p_lead_name          Out Varchar2,
        p_discrepancy        Out Varchar2,
        p_med_cert_file_nm   Out Varchar2,

        p_lead_approval      Out Varchar2,
        p_hod_approval       Out Varchar2,
        p_hr_approval        Out Varchar2,

        p_lead_reason        Out Varchar2,
        p_hod_reason         Out Varchar2,
        p_hr_reason          Out Varchar2,

        p_flag_is_adj        Out Varchar2,
        p_flag_can_del       Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    ) As
        v_count Number;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            ss_vu_leaveapp
        Where
            Trim(app_no) = Trim(p_application_id);
        If v_count = 1 Then
            get_leave_details_from_app(
                p_application_id     => p_application_id,

                p_emp_name           => p_emp_name,
                p_leave_type         => p_leave_type,
                p_application_date   => p_application_date,
                p_start_date         => p_start_date,
                p_end_date           => p_end_date,

                p_leave_period       => p_leave_period,
                p_last_reporting     => p_last_reporting,
                p_resuming           => p_resuming,

                p_projno             => p_projno,
                p_care_taker         => p_care_taker,
                p_reason             => p_reason,
                p_med_cert_available => p_med_cert_available,
                p_contact_address    => p_contact_address,
                p_contact_std        => p_contact_std,
                p_contact_phone      => p_contact_phone,
                p_office             => p_office,
                p_lead_name          => p_lead_name,
                p_discrepancy        => p_discrepancy,
                p_med_cert_file_nm   => p_med_cert_file_nm,

                p_lead_approval      => p_lead_approval,
                p_hod_approval       => p_hod_approval,
                p_hr_approval        => p_hr_approval,

                p_lead_reason      => p_lead_reason,
                p_hod_reason       => p_hod_reason,
                p_hr_reason        => p_hr_reason,

                p_flag_can_del       => p_flag_can_del,

                p_message_type       => p_message_type,
                p_message_text       => p_message_text
            );
            p_flag_is_adj := 'KO';
        Else
            get_leave_details_from_adj(
                p_application_id   => p_application_id,

                p_emp_name         => p_emp_name,
                p_leave_type       => p_leave_type,
                p_application_date => p_application_date,
                p_start_date       => p_start_date,
                p_end_date         => p_end_date,

                p_leave_period     => p_leave_period,
                p_med_cert_file_nm => p_med_cert_file_nm,

                p_reason           => p_reason,

                p_lead_approval    => p_lead_approval,
                p_hod_approval     => p_hod_approval,
                p_hr_approval      => p_hr_approval,

                p_message_type     => p_message_type,
                p_message_text     => p_message_text
            );
            p_flag_is_adj  := 'OK';
            p_flag_can_del := 'KO';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_delete_leave_app(
        p_person_id                  Varchar2,
        p_meta_id                    Varchar2,

        p_application_id             Varchar2,

        p_medical_cert_file_name Out Varchar2,
        p_message_type           Out Varchar2,
        p_message_text           Out Varchar2
    ) As
        v_count      Number;
        v_empno      Varchar2(5);
        rec_leaveapp ss_leaveapp%rowtype;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_leaveapp
        Where
            empno            = v_empno
            And Trim(app_no) = Trim(p_application_id);
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid application id';
            Return;
        End If;
        Select
            med_cert_file_name
        Into
            p_medical_cert_file_name
        From
            ss_leaveapp
        Where
            Trim(app_no) = Trim(p_application_id);

        deleteleave(trim(p_application_id));

        p_message_type := 'OK';
        p_message_text := 'Application deleted successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_delete_leave_app_force(
        p_person_id                  Varchar2,
        p_meta_id                    Varchar2,

        p_application_id             Varchar2,

        p_medical_cert_file_name Out Varchar2,
        p_message_type           Out Varchar2,
        p_message_text           Out Varchar2
    ) As
        v_count      Number;
        v_empno      Varchar2(5);
        rec_leaveapp ss_leaveapp%rowtype;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_vu_leaveapp
        Where
            Trim(app_no) = Trim(p_application_id);
        If v_count = 1 Then
            Select
                med_cert_file_name
            Into
                p_medical_cert_file_name
            From
                ss_vu_leaveapp
            Where
                Trim(app_no) = Trim(p_application_id);
        End If;
        If v_count = 0 Then
            Select
                Count(*)
            Into
                v_count
            From
                ss_leave_adj
            Where
                adj_no = Trim(p_application_id);
            If v_count = 1 Then
                Select
                    med_cert_file_name
                Into
                    p_medical_cert_file_name
                From
                    ss_leave_adj
                Where
                    Trim(adj_no) = Trim(p_application_id);
            End If;
        End If;

        deleteleave(
            appnum      => p_application_id,
            p_force_del => 'OK'
        );

        p_message_type := 'OK';
        p_message_text := 'Application deleted successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_delete_leave_app_force;

    Procedure sp_leave_balances(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2 Default Null,
        p_start_date       Date     Default Null,
        p_end_date         Date     Default Null,

        p_open_cl      Out Varchar2,
        p_open_sl      Out Varchar2,
        p_open_pl      Out Varchar2,
        p_open_ex      Out Varchar2,
        p_open_co      Out Varchar2,
        p_open_oh      Out Varchar2,
        p_open_lv      Out Varchar2,

        p_close_cl     Out Varchar2,
        p_close_sl     Out Varchar2,
        p_close_pl     Out Varchar2,
        p_close_ex     Out Varchar2,
        p_close_co     Out Varchar2,
        p_close_oh     Out Varchar2,
        p_close_lv     Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_message_type Varchar2(2);
        v_count        Number;
    Begin
        If p_empno Is Null Then
            v_empno := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                p_message_type := 'KO';
                p_message_text := 'Invalid employee by person id';
                Return;
            End If;
        Else
            v_empno := p_empno;
        End If;
        /*
        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = p_empno;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        */
        get_leave_balance_all(
            p_empno           => v_empno,
            p_pdate           => p_start_date,
            p_open_close_flag => ss.opening_bal,

            p_cl              => p_open_cl,
            p_sl              => p_open_sl,
            p_pl              => p_open_pl,
            p_ex              => p_open_ex,
            p_co              => p_open_co,
            p_oh              => p_open_oh,
            p_lv              => p_open_lv,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

        If p_message_type = 'KO' Then
            Return;
        End If;

        get_leave_balance_all(
            p_empno           => v_empno,
            p_pdate           => p_end_date,
            p_open_close_flag => ss.closing_bal,

            p_cl              => p_close_cl,
            p_sl              => p_close_sl,
            p_pl              => p_close_pl,
            p_ex              => p_close_ex,
            p_co              => p_close_co,
            p_oh              => p_close_oh,
            p_lv              => p_close_lv,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_leave_approval(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,
        p_approver_profile Number,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_app_no            Varchar2(70);
        v_approval          Number;
        v_remarks           Varchar2(70);
        v_count             Number;
        v_rec_count         Number;
        sqlpart1            Varchar2(60) := 'Update SS_leaveapp ';
        sqlpart2            Varchar2(500);
        strsql              Varchar2(600);
        v_odappstat_rec     ss_odappstat%rowtype;
        v_approver_empno    Varchar2(5);
        v_user_tcp_ip       Varchar2(30);
        v_msg_type          Varchar2(20);
        v_msg_text          Varchar2(1000);
        v_medical_cert_file Varchar2(200);
    Begin

        v_approver_empno := get_empno_from_meta_id(p_meta_id);
        If v_approver_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        sqlpart2         := ' set ApproverProfile_APPRL = :Approval, ApproverProfile_Code = :Approver_EmpNo, ApproverProfile_APPRL_DT = Sysdate,
                    ApproverProfile_TCP_IP = :User_TCP_IP , ApproverProfileREASON = :Reason where App_No = :paramAppNo';
        If p_approver_profile = user_profile.type_hod Or p_approver_profile = user_profile.type_sec Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HOD');
        Elsif p_approver_profile = user_profile.type_hrd Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HRD');
        Elsif p_approver_profile = user_profile.type_lead Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'LEAD');
        End If;

        For i In 1..p_leave_approvals.count
        Loop

            With
                csv As (
                    Select
                        p_leave_approvals(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1))            app_no,
                to_number(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) approval,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3))            remarks
            Into
                v_app_no, v_approval, v_remarks
            From
                csv;

            /*
            p_message_type := 'OK';
            p_message_text := 'Debug 1 - ' || p_leave_approvals(i);
            Return;
            */
            strsql := sqlpart1 || ' ' || sqlpart2;
            strsql := replace(strsql, 'LEADREASON', 'LEAD_REASON');
            Execute Immediate strsql
                Using v_approval, v_approver_empno, v_user_tcp_ip, v_remarks, trim(v_app_no);

            If p_approver_profile = user_profile.type_hrd And v_approval = ss.approved Then
                leave.post_leave_apprl(v_app_no, v_msg_type, v_msg_text);
                /*
                If v_msg_type = ss.success Then
                    generate_auto_punch_4od(v_app_no);
                End If;
                */
            Elsif v_approval = ss.disapproved Then

                sp_process_disapproved_app(
                    p_person_id      => p_person_id,
                    p_meta_id        => p_meta_id,

                    p_application_id => Trim(v_app_no)
                );

            End If;

        End Loop;

        Commit;
        p_message_type   := 'OK';
        p_message_text   := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_leave_approval_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_leave_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_leave_approvals  => p_leave_approvals,
            p_approver_profile => user_profile.type_lead,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_leave_approval_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_leave_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_leave_approvals  => p_leave_approvals,
            p_approver_profile => user_profile.type_hod,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End sp_leave_approval_hod;

    Procedure sp_leave_approval_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_leave_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_leave_approvals  => p_leave_approvals,
            p_approver_profile => user_profile.type_hrd,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End sp_leave_approval_hr;

End iot_leave;
/
---------------------------
--Changed PACKAGE BODY
--OD
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."OD" As

    Procedure add_to_depu (
        p_empno            Varchar2,
        p_depu_type        Varchar2,
        p_bdate            Date,
        p_edate            Date,
        p_entry_by_empno   Varchar2,
        p_lead_approver    Varchar2,
        p_user_ip          Varchar2,
        p_reason           Varchar2,
        p_success          Out                Varchar2,
        p_message          Out                Varchar2
    );

    Procedure set_variables_4_entry_by (
        p_entry_by_empno       Varchar2,
        p_entry_by_hr          Varchar2,
        p_entry_by_hr_4_self   Varchar2,
        p_lead_empno           In Out                 Varchar2,
        p_lead_apprl           Out                    Varchar2,
        p_hod_empno            Out                    Varchar2,
        p_hod_apprl            Out                    Varchar2,
        p_hod_ip               Out                    Varchar2,
        p_hrd_empno            Out                    Varchar2,
        p_hrd_apprl            Out                    Varchar2,
        p_hrd_ip               In Out                 Varchar2,
        p_hod_apprl_dt         Out                    Date,
        p_hrd_apprl_dt         Out                    Date
    ) As
        v_hr_ip      Varchar2(20);
        v_hr_empno   Varchar2(5);
    Begin
        v_hr_ip          := p_hrd_ip;
        p_hod_apprl      := 0;
        p_hrd_apprl      := 0;
        p_lead_apprl     := 0;
        p_hrd_ip         := Null;
        --
        If Lower(p_lead_empno) = 'none' Then
            p_lead_apprl := ss.apprl_none;
        End If;
        If Nvl(p_entry_by_hr, 'KO') != 'OK' Or Nvl(p_entry_by_hr_4_self, 'KO') = 'OK' Then
            return;
        End If;
        --

        p_lead_empno     := 'None';
        p_lead_apprl     := ss.apprl_none;
        --
        p_hod_empno      := p_entry_by_empno;
        p_hrd_empno      := p_entry_by_empno;
            --
        p_hod_apprl      := ss.approved;
        p_hrd_apprl      := ss.approved;
            --p_lead_apprl   := 0;
        p_hod_ip         := v_hr_ip;
        p_hrd_ip         := v_hr_ip;
            --
        p_hod_apprl_dt   := Sysdate;
        p_hrd_apprl_dt   := Sysdate;
    End;

    Procedure nu_app_send_mail (
        param_app_no    Varchar2,
        param_success   Out             Number,
        param_message   Out             Varchar2
    ) As

        v_count        Number;
        v_lead_code    Varchar2(5);
        v_lead_apprl   Number;
        v_empno        Varchar2(5);
        v_email_id     Varchar2(60);
        vsubject       Varchar2(100);
        vbody          Varchar2(5000);
    Begin
        Select
            Count(*)
        Into v_count
        From
            ss_ondutyapp
        Where
            Trim(app_no) = Trim(param_app_no);

        If v_count <> 1 Then
            return;
        End If;
        Select
            lead_code,
            lead_apprl,
            empno
        Into
            v_lead_code,
            v_lead_apprl,
            v_empno
        From
            ss_ondutyapp
        Where
            Trim(app_no) = Trim(param_app_no);

        If Trim(Nvl(v_lead_code, ss.lead_none)) = Trim(ss.lead_none) Then
            Select
                email
            Into v_email_id
            From
                ss_emplmast
            Where
                empno = (
                    Select
                        mngr
                    From
                        ss_emplmast
                    Where
                        empno = v_empno
                );

        Else
            Select
                email
            Into v_email_id
            From
                ss_emplmast
            Where
                empno = v_lead_code;

        End If;

        If v_email_id Is Null Then
            param_success   := ss.failure;
            param_message   := 'Email Id of the approver found blank. Cannot send email.';
            return;
        End If;
        --v_email_id := 'd.bhavsar@ticb.com';

        vsubject   := 'Application of ' || v_empno;
        vbody      := 'There is ' || vsubject || '. Kindly click the following URL to do the needful.';
        vbody      := vbody || '!nuLine!' || ss.application_url || '/SS_OD.asp?App_No=' || param_app_no;

        vbody      := vbody || '!nuLine!' || '!nuLine!' || '!nuLine!' || '!nuLine!' || 'Note : This is a system generated message.';

        ss_mail.send_mail(
            v_email_id,
            vsubject,
            vbody,
            param_success,
            param_message
        );
    End nu_app_send_mail;

    Procedure approve_od (
        param_array_app_no       Varchar2,
        param_array_rem          Varchar2,
        param_array_od_type      Varchar2,
        param_array_apprl_type   Varchar2,
        param_approver_profile   Number,
        param_approver_code      Varchar2,
        param_approver_ip        Varchar2,
        param_success            Out                      Varchar2,
        param_message            Out                      Varchar2
    ) As

        onduty        Constant Number := 2;
        deputation    Constant Number := 3;
        v_count       Number;
        Type type_app Is
            Table Of Varchar2(30) Index By Binary_Integer;
        Type type_rem Is
            Table Of Varchar2(31) Index By Binary_Integer;
        Type type_od Is
            Table Of Varchar2(3) Index By Binary_Integer;
        Type type_apprl Is
            Table Of Varchar2(3) Index By Binary_Integer;
        tab_app       type_app;
        tab_rem       type_rem;
        tab_od        type_od;
        tab_apprl     type_apprl;
        v_rec_count   Number;
        sqlpartod     Varchar2(60) := 'Update SS_OnDutyApp ';
        sqlpartdp     Varchar2(60) := 'Update SS_Depu ';
        sqlpart2      Varchar2(500);
        strsql        Varchar2(600);
    Begin
        sqlpart2        := ' set ApproverProfile_APPRL = :Approval, ApproverProfile_Code = :Approver_EmpNo, ApproverProfile_APPRL_DT = Sysdate,
                    ApproverProfile_TCP_IP = :User_TCP_IP , ApproverProfileREASON = :Reason where App_No = :paramAppNo'
        ;
        If param_approver_profile = user_profile.type_hod Or param_approver_profile = user_profile.type_sec Then
            sqlpart2 := Replace(sqlpart2, 'ApproverProfile', 'HOD');
        Elsif param_approver_profile = user_profile.type_hrd Then
            sqlpart2 := Replace(sqlpart2, 'ApproverProfile', 'HRD');
        Elsif param_approver_profile = user_profile.type_lead Then
            sqlpart2 := Replace(sqlpart2, 'ApproverProfile', 'LEAD');
        End If;

        With tab As (
            Select
                param_array_app_no As txt_app
            From
                dual
        )
        Select
            Regexp_Substr(txt_app, '[^,]+', 1, Level)
        Bulk Collect
        Into tab_app
        From
            tab
        Connect By
            Level <= Length(Regexp_Replace(txt_app, '[^,]*'));

        v_rec_count     := Sql%rowcount;
        With tab As (
            Select
                '  ' || param_array_rem As txt_rem
            From
                dual
        )
        Select
            Regexp_Substr(txt_rem, '[^,]+', 1, Level)
        Bulk Collect
        Into tab_rem
        From
            tab
        Connect By
            Level <= Length(Regexp_Replace(txt_rem, '[^,]*')) + 1;

        With tab As (
            Select
                param_array_od_type As txt_od
            From
                dual
        )
        Select
            Regexp_Substr(txt_od, '[^,]+', 1, Level)
        Bulk Collect
        Into tab_od
        From
            tab
        Connect By
            Level <= Length(Regexp_Replace(txt_od, '[^,]*')) + 1;

        With tab As (
            Select
                param_array_apprl_type As txt_apprl
            From
                dual
        )
        Select
            Regexp_Substr(txt_apprl, '[^,]+', 1, Level)
        Bulk Collect
        Into tab_apprl
        From
            tab
        Connect By
            Level <= Length(Regexp_Replace(txt_apprl, '[^,]*')) + 1;

        For indx In 1..tab_app.count Loop
            If To_Number(tab_od(indx)) = deputation Then
                strsql := sqlpartdp || ' ' || sqlpart2;
            Elsif To_Number(tab_od(indx)) = onduty Then
                strsql := sqlpartod || ' ' || sqlpart2;
            End If;

            Execute Immediate strsql
                Using Trim(tab_apprl(indx)), param_approver_code, param_approver_ip, Trim(tab_rem(indx)), Trim(tab_app(indx));

            If tab_od(indx) = onduty Then
            --IF 1=2 Then
                Insert Into ss_onduty Value
                    ( Select
                        empno,
                        hh,
                        mm,
                        pdate,
                        0,
                        dd,
                        mon,
                        yyyy,
                        type,
                        app_no,
                        description,
                        getodhh(
                            app_no,
                            1
                        ),
                        getodmm(
                            app_no,
                            1
                        ),
                        app_date,
                        reason,
                        odtype
                    From
                        ss_ondutyapp
                    Where
                        Trim(app_no) = Trim(tab_app(indx))
                        And Nvl(hrd_apprl, ss.pending) = ss.approved
                    );

                Insert Into ss_onduty Value
                    ( Select
                        empno,
                        hh1,
                        mm1,
                        pdate,
                        0,
                        dd,
                        mon,
                        yyyy,
                        type,
                        app_no,
                        description,
                        getodhh(
                            app_no,
                            2
                        ),
                        getodmm(
                            app_no,
                            2
                        ),
                        app_date,
                        reason,
                        odtype
                    From
                        ss_ondutyapp
                    Where
                        Trim(app_no) = Trim(tab_app(indx))
                        And ( type = 'OD'
                              Or type                        = 'IO' )
                        And Nvl(hrd_apprl, ss.pending) = ss.approved
                    );

                If param_approver_profile = user_profile.type_hrd And To_Number(tab_apprl(indx)) = ss.approved Then
                    generate_auto_punch_4od(Trim(tab_app(indx)));
                End If;

            End If;

        End Loop;

        Commit;
        param_success   := 'SUCCESS';
    Exception
        When Others Then
            param_success   := 'FAILURE';
            param_message   := 'ERR :- ' || Sqlcode || ' - ' || Sqlerrm;
    End;

    Procedure add_onduty_type_2 (
        p_empno           Varchar2,
        p_od_type         Varchar2,
        p_b_yyyymmdd      Varchar2,
        p_e_yyyymmdd      Varchar2,
        p_entry_by        Varchar2,
        p_lead_approver   Varchar2,
        p_user_ip         Varchar2,
        p_reason          Varchar2,
        p_success         Out               Varchar2,
        p_message         Out               Varchar2
    ) As

        v_count           Number;
        v_empno           Varchar2(5);
        v_entry_by        Varchar2(5);
        v_lead_approver   Varchar2(5);
        v_od_catg         Number;
        v_bdate           Date;
        v_edate           Date;
    Begin
    --Check Employee Exists
        v_empno           := Substr('0000' || p_empno, -5);
        v_entry_by        := Substr('0000' || p_entry_by, -5);
        v_lead_approver   :=
            Case Lower(p_lead_approver)
                When 'none' Then
                    'None'
                Else Lpad(p_lead_approver, 5, '0')
            End;

        Select
            Count(*)
        Into v_count
        From
            ss_emplmast
        Where
            empno = v_empno;

        If v_count = 0 Then
            p_success   := 'KO';
            p_message   := 'Employee not found in Database.' || v_empno || ' - ' || p_empno;
            return;
        End If;

        v_bdate           := To_Date(p_b_yyyymmdd, 'yyyymmdd');
        v_edate           := To_Date(p_e_yyyymmdd, 'yyyymmdd');
        If v_edate < v_bdate Then
            p_success   := 'KO';
            p_message   := 'Incorrect date range specified';
            return;
        End If;

        If v_lead_approver != 'None' Then
            Select
                Count(*)
            Into v_count
            From
                ss_emplmast
            Where
                empno = v_lead_approver;

            If v_count = 0 Then
                p_success   := 'KO';
                p_message   := 'Lead approver not found in Database.';
                return;
            End If;

        End If;

        Select
            tabletag
        Into v_od_catg
        From
            ss_ondutymast
        Where
            type = p_od_type;

        If v_od_catg In (
            - 1,
            3
        ) Then
            add_to_depu(
                p_empno            => v_empno,
                p_depu_type        => p_od_type,
                p_bdate            => v_bdate,
                p_edate            => v_edate,
                p_entry_by_empno   => v_entry_by,
                p_lead_approver    => v_lead_approver,
                p_user_ip          => p_user_ip,
                p_reason           => p_reason,
                p_success          => p_success,
                p_message          => p_message
            );
        Else
            p_success   := 'KO';
            p_message   := 'Invalid OnDuty Type.';
            return;
        End If;

    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'ERR :- ' || Sqlcode || ' - ' || Sqlerrm;
    End;

    Procedure add_to_depu (
        p_empno            Varchar2,
        p_depu_type        Varchar2,
        p_bdate            Date,
        p_edate            Date,
        p_entry_by_empno   Varchar2,
        p_lead_approver    Varchar2,
        p_user_ip          Varchar2,
        p_reason           Varchar2,
        p_success          Out                Varchar2,
        p_message          Out                Varchar2
    ) As

        v_count                   Number;
        v_depu_row                ss_depu%rowtype;
        v_rec_no                  Number;
        v_app_no                  Varchar2(60);
        v_now                     Date;
        v_is_office_ip            Varchar2(10);
        v_entry_by_user_profile   Number;
        v_is_entry_by_hr          Varchar2(2);
        v_is_entry_by_hr_4_self   Varchar2(2);
        v_lead_approver           Varchar2(5);
        v_lead_approval           Number;
        v_hod_empno               Varchar2(5);
        v_hod_ip                  Varchar2(30);
        v_hod_apprl               Number;
        v_hod_apprl_dt            Date;
        v_hrd_empno               Varchar2(5);
        v_hrd_ip                  Varchar2(30);
        v_hrd_apprl               Number;
        v_hrd_apprl_dt            Date;
        v_appl_desc               Varchar2(60);
    Begin
        v_now                     := Sysdate;
        v_lead_approver           := p_lead_approver;
        v_hrd_ip                  := p_user_ip;
        Begin
            Select
                *
            Into v_depu_row
            From
                (
                    Select
                        *
                    From
                        ss_depu
                    Where
                        empno = p_empno
                        And app_date In (
                            Select
                                Max(app_date)
                            From
                                ss_depu
                            Where
                                empno = p_empno
                        )
                        And To_Char(app_date, 'yyyy') = To_Char(v_now, 'yyyy')
                    Order By
                        app_no Desc
                )
            Where
                Rownum = 1;

            v_rec_no := To_Number(Substr(v_depu_row.app_no, Instr(v_depu_row.app_no, '/', -1) + 1));

        Exception
            When Others Then
                p_message   := Sqlcode || ' - ' || Sqlerrm;
                v_rec_no    := 0;
        End;

        v_rec_no                  := v_rec_no + 1;
        /*
        If p_depu_type = 'WF' Then
            v_is_office_ip := self_attendance.valid_office_ip(p_user_ip);
            If v_is_office_ip = 'KO' Then
                p_success   := 'KO';
                p_message   := 'This utility is applicable from selected PC''s in TCMPL Mumbai Office';
                return;
            End If;

        End If;
        */
        v_entry_by_user_profile   := user_profile.get_profile(p_entry_by_empno);
        If v_entry_by_user_profile = user_profile.type_hrd Then
            v_is_entry_by_hr := 'OK';
            If p_entry_by_empno = p_empno Then
                v_is_entry_by_hr_4_self := 'OK';
            End If;
        End If;

        If p_depu_type = 'HT' Then --Home Town
            v_appl_desc := 'Punch HomeTown';
        Elsif p_depu_type = 'DP' Then --Deputation
            v_appl_desc := 'Punch Deputation';
        Elsif p_depu_type = 'TR' Then --ON Tour
            v_appl_desc := 'Punch Tour';
        Elsif p_depu_type = 'VS' Then --Visa Problem
            v_appl_desc := 'Punch Visa Problem';
        Elsif p_depu_type = 'RW' Then --Visa Problem
            v_appl_desc := 'Punch Remote Work';
        End If;

        v_appl_desc               := v_appl_desc || ' from ' || To_Char(p_bdate, 'dd-Mon-yyyy') || ' To ' || To_Char(p_edate, 'dd-Mon-yyyy');

        set_variables_4_entry_by(
            p_entry_by_empno       => p_entry_by_empno,
            p_entry_by_hr          => v_is_entry_by_hr,
            p_entry_by_hr_4_self   => v_is_entry_by_hr_4_self,
            p_lead_empno           => v_lead_approver,
            p_lead_apprl           => v_lead_approval,
            p_hod_empno            => v_hod_empno,
            p_hod_apprl            => v_hod_apprl,
            p_hod_ip               => v_hod_ip,
            p_hrd_empno            => v_hrd_empno,
            p_hrd_apprl            => v_hrd_apprl,
            p_hrd_ip               => v_hrd_ip,
            p_hod_apprl_dt         => v_hod_apprl_dt,
            p_hrd_apprl_dt         => v_hrd_apprl_dt
        );

        v_app_no                  := 'DP/' || p_empno || '/' || To_Char(v_now, 'yyyymmdd') || '/' || Lpad(v_rec_no, 4, '0');

        Insert Into ss_depu (
            empno,
            app_no,
            app_date,
            bdate,
            edate,
            description,
            type,
            reason,
            user_tcp_ip,
            hod_apprl,
            hod_apprl_dt,
            hod_code,
            hod_tcp_ip,
            hrd_apprl,
            hrd_apprl_dt,
            hrd_code,
            hrd_tcp_ip,
            lead_apprl,
            lead_apprl_empno
        ) Values (
            p_empno,
            v_app_no,
            v_now,
            p_bdate,
            p_edate,
            v_appl_desc,
            p_depu_type,
            p_reason,
            p_user_ip,
            v_hod_apprl,
            v_hod_apprl_dt,
            v_hod_empno,
            v_hod_ip,
            v_hrd_apprl,
            v_hrd_apprl_dt,
            v_hrd_empno,
            v_hrd_ip,
            v_lead_approval,
            v_lead_approver
        );

        p_success                 := 'OK';
        p_message                 := 'Your application has been saved successfull. Applicaiton Number :- ' || v_app_no;
    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'ERR :- ' || Sqlcode || ' - ' || Sqlerrm;
    End;

    Procedure add_onduty_type_1 (
        p_empno           Varchar2,
        p_od_type         Varchar2,
        p_od_sub_type     Varchar2,
        p_pdate           Varchar2,
        p_hh              Number,
        p_mi              Number,
        p_hh1             Number,
        p_mi1             Number,
        p_lead_approver   Varchar2,
        p_reason          Varchar2,
        p_entry_by        Varchar2,
        p_user_ip         Varchar2,
        p_success         Out               Varchar2,
        p_message         Out               Varchar2
    ) As

        v_pdate                   Date;
        v_count                   Number;
        v_empno                   Varchar2(5);
        v_entry_by                Varchar2(5);
        v_od_catg                 Number;
        v_onduty_row              ss_vu_ondutyapp%rowtype;
        v_rec_no                  Number;
        v_app_no                  Varchar2(60);
        v_now                     Date;
        v_is_office_ip            Varchar2(10);
        v_entry_by_user_profile   Number;
        v_is_entry_by_hr          Varchar2(2);
        v_is_entry_by_hr_4_self   Varchar2(2);
        v_lead_approver           Varchar2(5);
        v_lead_approval           Number;
        v_hod_empno               Varchar2(5);
        v_hod_ip                  Varchar2(30);
        v_hod_apprl               Number;
        v_hod_apprl_dt            Date;
        v_hrd_empno               Varchar2(5);
        v_hrd_ip                  Varchar2(30);
        v_hrd_apprl               Number;
        v_hrd_apprl_dt            Date;
        v_appl_desc               Varchar2(60);
        v_dd                      Varchar2(2);
        v_mon                     Varchar2(2);
        v_yyyy                    Varchar2(4);
    Begin
        v_pdate                   := To_Date(p_pdate, 'yyyymmdd');
        v_dd                      := To_Char(v_pdate, 'dd');
        v_mon                     := To_Char(v_pdate, 'MM');
        v_yyyy                    := To_Char(v_pdate, 'YYYY');
    --Check Employee Exists
        v_empno                   := Substr('0000' || Trim(p_empno), -5);
        v_entry_by                := Substr('0000' || Trim(p_entry_by), -5);
        v_lead_approver           :=
            Case Lower(p_lead_approver)
                When 'none' Then
                    'None'
                Else Lpad(p_lead_approver, 5, '0')
            End;

        Select
            Count(*)
        Into v_count
        From
            ss_emplmast
        Where
            empno = v_empno;

        If v_count = 0 Then
            p_success   := 'KO';
            p_message   := 'Employee not found in Database.' || v_empno || ' - ' || p_empno;
            return;
        End If;

        If v_lead_approver != 'None' Then
            Select
                Count(*)
            Into v_count
            From
                ss_emplmast
            Where
                empno = v_lead_approver;

            If v_count = 0 Then
                p_success   := 'KO';
                p_message   := 'Lead approver not found in Database.';
                return;
            End If;

        End If;

        p_message                 := 'Debug - A1';
        Select
            tabletag
        Into v_od_catg
        From
            ss_ondutymast
        Where
            type = p_od_type;

        If v_od_catg != 2 Then
            p_success   := 'KO';
            p_message   := 'Invalid OnDuty Type.';
            return;
        End If;

        p_message                 := 'Debug - A2';
        --
        --  * * * * * * * * * * * 
        v_now                     := Sysdate;
        Begin
            Select
                *
            Into v_onduty_row
            From
                (
                    Select
                        *
                    From
                        ss_vu_ondutyapp
                    Where
                        empno = v_empno
                        And app_date In (
                            Select
                                Max(app_date)
                            From
                                ss_vu_ondutyapp
                            Where
                                empno = v_empno
                        )
                        And To_Char(app_date, 'yyyy') = To_Char(Sysdate, 'yyyy')
                    Order By
                        app_no Desc
                )
            Where
                Rownum = 1;

            v_rec_no := To_Number(Substr(v_onduty_row.app_no, Instr(v_onduty_row.app_no, '/', -1) + 1));
--p_message := 'Debug - A3';

        Exception
            When Others Then
                v_rec_no := 0;
        End;

        v_rec_no                  := v_rec_no + 1;
        v_app_no                  := 'OD/' || v_empno || '/' || To_Char(v_now, 'yyyymmdd') || '/' || Lpad(v_rec_no, 4, '0');

        Select
            Count(*)
        Into v_count
        From
            ss_vu_ondutyapp
        Where
            app_no = v_app_no;

        If v_count <> 0 Then
            p_success   := 'KO';
            p_message   := 'There was an unexpected error. Please contact SELFSERVICE-ADMINISTRATOR';
            return;
        End If;

        p_message                 := 'Debug - A3';
        v_entry_by_user_profile   := user_profile.get_profile(v_entry_by);
        If v_entry_by_user_profile = user_profile.type_hrd Then
            v_is_entry_by_hr   := 'OK';
            If v_entry_by = v_empno Then
                v_is_entry_by_hr_4_self := 'OK';
            End If;
            v_hrd_ip           := p_user_ip;
        Else
            v_is_entry_by_hr := 'KO';
        End If;
--p_message := 'Debug - A4';

        v_appl_desc               := 'Appl for Punch Entry of ' || To_Char(v_pdate, 'dd-Mon-yyyy') || ' Time ' || p_hh || ':' || p_mi;

        v_appl_desc               := v_appl_desc || ' - ' || p_hh1 || ':' || p_mi1;
        v_appl_desc               := Replace(Trim(v_appl_desc), ' - 0:0');
        set_variables_4_entry_by(
            p_entry_by_empno       => v_entry_by,
            p_entry_by_hr          => v_is_entry_by_hr,
            p_entry_by_hr_4_self   => v_is_entry_by_hr_4_self,
            p_lead_empno           => v_lead_approver,
            p_lead_apprl           => v_lead_approval,
            p_hod_empno            => v_hod_empno,
            p_hod_apprl            => v_hod_apprl,
            p_hod_ip               => v_hod_ip,
            p_hrd_empno            => v_hrd_empno,
            p_hrd_apprl            => v_hrd_apprl,
            p_hrd_ip               => v_hrd_ip,
            p_hod_apprl_dt         => v_hod_apprl_dt,
            p_hrd_apprl_dt         => v_hrd_apprl_dt
        );
--p_message := 'Debug - A5 - ' || v_empno || ' - ' || v_pdate || ' - ' || p_hh || ' - ' || p_mi || ' - ' || p_hh1 || ' - ' || p_mi1 || ' - ODSubType - ' || p_od_sub_type ;

        If p_od_type = 'LE' And v_is_entry_by_hr = 'KO' Then
            v_lead_approver   := 'None';
            v_lead_approval   := 4;
            v_hod_apprl       := 1;
            v_hod_apprl_dt    := v_now;
            v_hod_empno       := v_entry_by;
            v_hod_ip          := p_user_ip;
        End If;

        Insert Into ss_ondutyapp (
            empno,
            app_no,
            app_date,
            hh,
            mm,
            hh1,
            mm1,
            pdate,
            dd,
            mon,
            yyyy,
            type,
            description,
            odtype,
            reason,
            user_tcp_ip,
            hod_apprl,
            hod_apprl_dt,
            hod_tcp_ip,
            hod_code,
            lead_apprl_empno,
            lead_apprl,
            hrd_apprl,
            hrd_tcp_ip,
            hrd_code,
            hrd_apprl_dt
        ) Values (
            v_empno,
            v_app_no,
            v_now,
            p_hh,
            p_mi,
            p_hh1,
            p_mi1,
            v_pdate,
            v_dd,
            v_mon,
            v_yyyy,
            p_od_type,
            v_appl_desc,
            Nvl(p_od_sub_type, 0),
            p_reason,
            p_user_ip,
            v_hod_apprl,
            v_hod_apprl_dt,
            v_hod_ip,
            v_hod_empno,
            v_lead_approver,
            v_lead_approval,
            v_hrd_apprl,
            v_hrd_ip,
            v_hrd_empno,
            v_hrd_apprl_dt
        );

        p_success                 := 'OK';
        p_message                 := 'Your application has been saved successfull. Applicaiton Number :- ' || v_app_no;
        Commit;
        If v_entry_by_user_profile != user_profile.type_hrd Then
            return;
        End If;
        Insert Into ss_onduty Value
            ( Select
                empno,
                hh,
                mm,
                pdate,
                0,
                dd,
                mon,
                yyyy,
                type,
                app_no,
                description,
                getodhh(
                    app_no,
                    1
                ),
                getodmm(
                    app_no,
                    1
                ),
                app_date,
                reason,
                odtype
            From
                ss_ondutyapp
            Where
                app_no = v_app_no
            );
--p_message := 'Debug - A7';

        If p_od_type Not In (
            'IO',
            'OD'
        ) Then
            return;
        End If;
        Insert Into ss_onduty Value
            ( Select
                empno,
                hh1,
                mm1,
                pdate,
                0,
                dd,
                mon,
                yyyy,
                type,
                app_no,
                description,
                getodhh(
                    app_no,
                    2
                ),
                getodmm(
                    app_no,
                    2
                ),
                app_date,
                reason,
                odtype
            From
                ss_ondutyapp
            Where
                app_no = v_app_no
            );

        p_message                 := 'Debug - A8';
        generate_auto_punch_4od(v_app_no);
--p_message := 'Debug - A9';
        p_success                 := 'OK';
        p_message                 := 'Your application has been saved successfull. Applicaiton Number :- ' || v_app_no;
    Exception
        When dup_val_on_index Then
            p_success   := 'KO';
            p_message   := 'Duplicate values found cannot proceed.' || ' - ' || p_message;
        When Others Then
            p_success   := 'KO';
            p_message   := 'ERR :- ' || Sqlcode || ' - ' || Sqlerrm || ' - ' || p_message;
            --p_message := p_message || 

    End add_onduty_type_1;

    Procedure transfer_od_2_wfh (
        p_success   Out         Varchar2,
        p_message   Out         Varchar2
    ) As

        Cursor cur_od Is
        Select
            empno,
            'RW' od_type,
            To_Char(pdate, 'yyyymmdd') bdate,
            To_Char(pdate, 'yyyymmdd') edate,
            empno entry_by,
            lead_apprl_empno,
            user_tcp_ip,
            reason,
            app_no,
            To_Char(app_date, 'dd-Mon-yyyy') app_date1,
            To_Char(pdate, 'dd-Mon-yyyy') pdate1
        From
            ss_ondutyapp
        Where
            Nvl(hod_apprl, 0) = 1
            And Nvl(hrd_apprl, 0) = 0
            And yyyy In (
                '2021',
                '2022'
            )
            And type              = 'OD';

        Type typ_tab_od Is
            Table Of cur_od%rowtype;
        tab_od     typ_tab_od;
        v_app_no   Varchar2(30);
        v_is_err   Varchar2(10) := 'KO';
    Begin
        Open cur_od;
        Loop
            Fetch cur_od Bulk Collect Into tab_od Limit 50;
            For i In 1..tab_od.count Loop
                p_success   := Null;
                p_message   := Null;
                od.add_onduty_type_2(
                    p_empno           => tab_od(i).empno,
                    p_od_type         => tab_od(i).od_type,
                    p_b_yyyymmdd      => tab_od(i).bdate,
                    p_e_yyyymmdd      => tab_od(i).edate,
                    p_entry_by        => tab_od(i).entry_by,
                    p_lead_approver   => tab_od(i).lead_apprl_empno,
                    p_user_ip         => tab_od(i).user_tcp_ip,
                    p_reason          => tab_od(i).reason,
                    p_success         => p_success,
                    p_message         => p_message
                );

                If p_success = 'OK' Then
                    Delete From ss_ondutyapp
                    Where
                        Trim(app_no) = Trim(tab_od(i).app_no);

                Else
                    v_is_err := 'OK';
                End If;

            End Loop;

            Exit When cur_od%notfound;
        End Loop;

        Commit;
        Update ss_depu
        Set
            lead_code = 'Sys',
            lead_apprl_dt = Sysdate,
            lead_apprl = 1
        Where
            type = 'RW'
            And Trunc(app_date) = Trunc(Sysdate)
            And lead_apprl <> 4;

        Update ss_depu
        Set
            hod_apprl = 1,
            hod_code = 'Sys',
            hod_apprl_dt = Sysdate,
            hrd_apprl = 1,
            hrd_code = 'Sys',
            hrd_apprl_dt = Sysdate
        Where
            type = 'RW'
            And Trunc(app_date) = Trunc(Sysdate);

        Commit;
        If v_is_err = 'OK' Then
            p_success   := 'KO';
            p_message   := 'Err - Some OnDuty applicaitons were not transfered to WFH.';
        Else
            p_success   := 'OK';
            p_message   := 'OnDuty applications successfully transferd to WFH.';
        End If;

    Exception
        When Others Then
            Rollback;
            p_success   := 'OK';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;

End od;
/
---------------------------
--Changed PACKAGE BODY
--IOT_LEAVE_CLAIMS
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_LEAVE_CLAIMS" As

    Procedure sp_add_leave_claim(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_leave_type       Varchar2,
        p_leave_period     Number,
        p_start_date       Date,
        p_end_date         Date,
        p_half_day_on      Number,
        p_description      Varchar2,
        p_med_cert_file_nm Varchar2 Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2

    ) As

        v_empno               Varchar2(5);
        v_app_date            Date;
        v_message_type        Varchar2(2);
        v_count               Number;
        v_adj_date            Date;
        v_adj_seq_no          Number;
        v_hd_date             Date;
        v_entry_by_empno      Varchar2(5);
        v_hd_presnt_part      Number;
        v_adj_no              Varchar2(60);
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_leave_type          Varchar2(2);
        v_is_covid_sick_leave Number(1);
    Begin
        v_leave_type     := p_leave_type;
        If v_leave_type = 'SC' Then
            v_leave_type          := 'SL';
            v_is_covid_sick_leave := 1;
        End If;
        v_entry_by_empno := get_empno_from_meta_id(p_meta_id);
        v_app_date       := sysdate;
        If v_entry_by_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;

        v_empno          := p_empno;
        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = v_empno;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        v_adj_seq_no     := leave_adj_seq.nextval;
        v_adj_no         := 'LC/' || v_empno || '/' || to_char(sysdate, 'ddmmyyyy') || '/' || v_adj_seq_no;
        If nvl(p_half_day_on, half_day_on_none) = hd_bdate_presnt_part_2 Then
            v_hd_date        := p_start_date;
            v_hd_presnt_part := 2;
        Elsif nvl(p_half_day_on, half_day_on_none) = hd_edate_presnt_part_1 Then
            v_hd_date        := p_end_date;
            v_hd_presnt_part := 1;
        End If;

        Insert Into ss_leave_adj (
            empno,
            adj_dt,
            adj_no,
            leavetype,
            dataentryby,
            db_cr,
            adj_type,
            bdate,
            edate,
            leaveperiod,
            description,
            tcp_ip,
            hd_date,
            hd_part,
            entry_date,
            med_cert_file_name,
            is_covid_sick_leave
        )
        Values(
            v_empno,
            sysdate,
            v_adj_no,
            v_leave_type,
            v_entry_by_empno,
            'D',
            'LC',
            p_start_date,
            p_end_date,
            p_leave_period * 8,
            p_description,
            Null,
            v_hd_date,
            v_hd_presnt_part,
            v_app_date,
            p_med_cert_file_nm,
            v_is_covid_sick_leave
        );
        Insert Into ss_leaveledg(
            app_no,
            app_date,
            leavetype,
            description,
            empno,
            leaveperiod,
            db_cr,
            tabletag,
            bdate,
            edate,
            adj_type,
            hd_date,
            hd_part,
            is_covid_sick_leave
        )
        Values(
            v_adj_no,
            v_app_date,
            v_leave_type,
            p_description,
            v_empno,
            p_leave_period * 8 * - 1,
            'D',
            0,
            p_start_date,
            p_end_date,
            'LC',
            v_hd_date,
            v_hd_presnt_part,
            v_is_covid_sick_leave
        );
        Commit;
        p_message_type   := 'OK';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || '-' || sqlerrm;
    End;
    /*
        Procedure sp_delete_leave_claim(
            p_person_id                  Varchar2,
            p_meta_id                    Varchar2,

            p_application_id             Varchar2,

            p_medical_cert_file_name Out Varchar2,
            p_message_type           Out Varchar2,
            p_message_text           Out Varchar2
        ) As
            v_count      Number;
            v_empno      Varchar2(5);
            rec_leaveapp ss_leaveapp%rowtype;
        Begin
            v_empno        := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                p_message_type := 'KO';
                p_message_text := 'Invalid employee number';
                Return;
            End If;

            Select
                Count(*)
            Into
                v_count
            From
                ss_leave_adj
            Where
                empno            = v_empno
                And Trim(app_no) = Trim(p_application_id);
            If v_count = 0 Then
                p_message_type := 'KO';
                p_message_text := 'Invalid application id';
                Return;
            End If;
            Select
                med_cert_file_name
            Into
                p_medical_cert_file_name
            From
                ss_leaveapp
            Where
                Trim(app_no) = Trim(p_application_id);

            deleteleave(trim(p_application_id));

            p_message_type := 'OK';
            p_message_text := 'Application deleted successfully.';
        Exception
            When Others Then
                p_message_type := 'KO';
                p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
        End;
    */

    Procedure sp_import(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_leave_claims           typ_tab_string,

        p_leave_claim_errors Out typ_tab_string,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
    ) As
        v_empno           Varchar2(5);
        v_leave_type      Varchar2(2);
        v_no_of_days      Number;
        v_start_date      Date;
        v_end_date        Date;
        v_remarks         Varchar2(30);

        v_valid_claim_num Number;
        tab_valid_claims  typ_tab_claims;
        v_rec_claim       rec_claim;
        v_err_num         Number;
        is_error_in_row   Boolean;
        v_half_day_on     Number;
        v_msg_text        Varchar2(200);
        v_msg_type        Varchar2(10);
        v_count           Number;
        v_reason          Varchar2(30);
    Begin
        v_err_num := 0;
        For i In 1..p_leave_claims.count
        Loop
            is_error_in_row := false;
            With
                csv As (
                    Select
                        p_leave_claims(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1))                      empno,
                Trim(regexp_substr(str, '[^~!~]+', 1, 2))                      leave_type,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3))                      no_of_days,
                to_date(Trim(regexp_substr(str, '[^~!~]+', 1, 4)), 'yyyymmdd') start_date,
                to_date(Trim(regexp_substr(str, '[^~!~]+', 1, 5)), 'yyyymmdd') end_date,
                Trim(regexp_substr(str, '[^~!~]+', 1, 6))                      reason
            Into
                v_empno,
                v_leave_type,
                v_no_of_days,
                v_start_date,
                v_end_date,
                v_reason
            From
                csv;
            v_end_date      := nvl(v_end_date, v_start_date);
            v_empno         := lpad(v_empno, 5, '0');
            Select
                Count(*)
            Into
                v_count
            From
                ss_emplmast
            Where
                empno = v_empno
                And (dol Is Null Or dol > sysdate - 365);
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_leave_claim_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Empno' || '~!~' ||     --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Employee not found';   --Message
                is_error_in_row := true;
            End If;
            Select
                Count(*)
            Into
                v_count
            From
                ss_leavetype
            Where
                leavetype     = v_leave_type
                And is_active = 1;
            If v_leave_type In ('SL', 'SC') And v_no_of_days >= 2 Then
                v_err_num       := v_err_num + 1;
                p_leave_claim_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'LeaveType' || '~!~' || --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'MEDICAL Certificate required'; --Message
                is_error_in_row := true;
            End If;
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_leave_claim_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'LeaveType' || '~!~' || --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Incorrect leave type'; --Message
                is_error_in_row := true;
            End If;
            If Mod(v_no_of_days, 0.5) <> 0 Then
                v_err_num       := v_err_num + 1;
                p_leave_claim_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'NoOfDays' || '~!~' ||  --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'NoOfDays should be in multiples of 0.5'; --Message
                is_error_in_row := true;
            End If;
            If v_start_date Is Null Or v_end_date Is Null Or v_end_date < v_start_date Then
                v_err_num       := v_err_num + 1;
                p_leave_claim_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'StartDate' || '~!~' || --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Invalid date range';   --Message
                is_error_in_row := true;
            End If;
            If v_reason Is Null Then
                v_err_num       := v_err_num + 1;
                p_leave_claim_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Reason' || '~!~' ||   --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Reason are required'; --Message
                is_error_in_row := true;
            End If;
            If is_error_in_row = false Then
                If Mod(v_no_of_days, 1) > 0 Then
                    v_half_day_on := hd_bdate_presnt_part_2;
                Else
                    v_half_day_on := half_day_on_none;
                End If;
                v_valid_claim_num                                := nvl(v_valid_claim_num, 0) + 1;

                --v_rec_claim.empno := v_empno;

                tab_valid_claims(v_valid_claim_num).empno        := v_empno;
                tab_valid_claims(v_valid_claim_num).leave_type   := v_leave_type;
                tab_valid_claims(v_valid_claim_num).leave_period := v_no_of_days;
                tab_valid_claims(v_valid_claim_num).start_date   := v_start_date;
                tab_valid_claims(v_valid_claim_num).end_date     := v_end_date;
                tab_valid_claims(v_valid_claim_num).half_day_on  := v_half_day_on;
                tab_valid_claims(v_valid_claim_num).reason       := v_reason;
            End If;
        End Loop;
        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';
            Return;
        End If;

        For i In 1..v_valid_claim_num
        Loop
            sp_add_leave_claim(
                p_person_id        => p_person_id,
                p_meta_id          => p_meta_id,

                p_empno            => tab_valid_claims(i).empno,
                p_leave_type       => tab_valid_claims(i).leave_type,
                p_leave_period     => tab_valid_claims(i).leave_period,
                p_start_date       => tab_valid_claims(i).start_date,
                p_end_date         => tab_valid_claims(i).end_date,
                p_half_day_on      => tab_valid_claims(i).half_day_on,
                p_description      => tab_valid_claims(i).reason,
                p_med_cert_file_nm => Null,

                p_message_type     => v_msg_type,
                p_message_text     => v_msg_text

            );

            If v_msg_type <> 'OK' Then
                v_err_num := v_err_num + 1;
                p_leave_claim_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Empno' || '~!~' ||     --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    v_msg_text;             --Message
            End If;
        End Loop;
        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';

        Else
            p_message_type := 'OK';
            p_message_text := 'File imported successfully.';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End;

End iot_leave_claims;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_SELECT_LIST_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_SELECT_LIST_QRY" As

    Function fn_desk_list_for_smart(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date,
        p_empno     Varchar2
    ) Return Sys_Refcursor As
        c                 Sys_Refcursor;
        v_empno           Varchar2(5);
        timesheet_allowed Number;
        c_permanent_desk  Constant Number := 1;
    Begin
        --v_empno := get_empno_from_meta_id(p_meta_id);
        Open c For
            Select
                deskid                             data_value_field,
                rpad(deskid, 7, ' ') || ' | ' ||
                rpad(office, 5, ' ') || ' | ' ||
                rpad(nvl(floor, ' '), 6, ' ') || ' | ' ||
                rpad(nvl(wing, ' '), 5, ' ') || ' | ' ||
                rpad(nvl(bay, ' '), 9, ' ') || ' | ' ||
                rpad(nvl(work_area, ' '), 15, ' ') As data_text_field
            From
                dm_vu_desk_list
            Where
                office Not Like 'Home%'
                And office Like 'MOC1%'
                And nvl(cabin, 'X') <> 'C'
                --and nvl(desk_share_type,-10) = c_permanent_desk --Permanent
                And Trim(deskid) Not In (
                    Select
                        deskid
                    From
                        swp_smart_attendance_plan
                    Where
                        trunc(attendance_date) = trunc(p_date)
                        And empno != Trim(p_empno)
                    Union
                    Select
                        deskid
                    From
                        dm_vu_emp_desk_map
                )
            Order By
                office;

        Return c;
    End fn_desk_list_for_smart;

    Function fn_desk_list_for_office(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date Default Null,
        p_empno     Varchar2
    ) Return Sys_Refcursor As
        c                 Sys_Refcursor;
        v_empno           Varchar2(5);
        c_permanent_desk  Constant Number := 1;
        timesheet_allowed Number;
    Begin
        Open c For

            Select
                deskid                             data_value_field,
                rpad(deskid, 7, ' ') || ' | ' ||
                rpad(office, 5, ' ') || ' | ' ||
                rpad(nvl(floor, ' '), 6, ' ') || ' | ' ||
                rpad(nvl(wing, ' '), 5, ' ') || ' | ' ||
                rpad(nvl(bay, ' '), 9, ' ') || ' | ' ||
                rpad(nvl(work_area, ' '), 15, ' ') As data_text_field
            From
                dms.dm_deskmaster dms
            Where
                office Not Like 'Home%'
                And nvl(cabin, 'X') <> 'C'
                --and nvl(desk_share_type,-10) = c_permanent_desk --Permanent
                And dms.deskid Not In
                (
                    Select
                    Distinct dmst.deskid
                    From
                        dm_vu_emp_desk_map dmst
                )
                And dms.deskid Not In
                (
                    Select
                    Distinct swp_wfm.deskid
                    From
                        swp_smart_attendance_plan swp_wfm
                    Where
                        trunc(swp_wfm.attendance_date) >= trunc(sysdate)
                )
            Order By
                office,
                deskid;

        Return c;
    End fn_desk_list_for_office;

    Function fn_employee_list_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                empno                  data_value_field,
                empno || ' - ' || name data_text_field
            From
                ss_emplmast
            Where
                status = 1
                And assign In (
                    Select
                        parent
                    From
                        ss_user_dept_rights
                    Where
                        empno = v_empno
                    Union
                    Select
                        costcode
                    From
                        ss_costmast
                    Where
                        hod = v_empno
                )
            Order By
                empno;

        Return c;
    End;

    Function fn_costcode_list_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                costcode                  data_value_field,
                costcode || ' - ' || name data_text_field
            From
                ss_costmast
            Where
                costcode In (
                    Select
                        parent
                    From
                        ss_user_dept_rights
                    Where
                        empno = v_empno
                    Union
                    Select
                        costcode
                    From
                        ss_costmast
                    Where
                        hod = v_empno
                )
            Order By
                costcode;

        Return c;
    End;

    Function fn_employee_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                a.emptype                     data_value_field,
                a.emptype || ' - ' || empdesc data_text_field
            From
                ss_vu_emptypes      a,
                swp_include_emptype b
            Where
                a.emptype = b.emptype
            Order By
                empdesc;
        Return c;
    End;

    Function fn_grade_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                grade_id   data_value_field,
                grade_desc data_text_field
            From
                ss_vu_grades
            Where
                grade_id <> '-'
            Order By
                grade_desc;
        -- select grade_id data_value_field, grade_desc data_text_field 
        -- from timecurr.hr_grade_master order by grade_desc;
        Return c;
    End;

   Function fn_project_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                projno   data_value_field,
                projno || ' - ' || name data_text_field
            From
                ss_projmast
            Where
                ACTIVE = 1
            Order By
                projno , name;

        Return c;
    End;

End iot_swp_select_list_qry;
/
---------------------------
--New PACKAGE BODY
--IOT_SWP_DESK_AREA_MAP_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_DESK_AREA_MAP_QRY" As
 
Function fn_desk_area_map_list(
     p_person_id   Varchar2,
      p_meta_id     Varchar2,
      P_area        Varchar2 Default Null,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor
   Is
   c                    Sys_Refcursor;
   v_count              Number;
   v_empno              Varchar2(5);
   v_hod_sec_assign_code              Varchar2(4);
   e_employee_not_found Exception;
   Pragma exception_init(e_employee_not_found, -20001);

Begin

   v_empno := get_empno_from_meta_id(p_meta_id);
   If v_empno = 'ERRRR' Then
      Raise e_employee_not_found;
      Return Null;
   End If;
 /*
   If v_empno Is Null Or p_assign_code Is Not Null Then
            v_hod_sec_assign_code := iot_swp_common.get_default_costcode_hod_sec(
                                         p_hod_sec_empno => v_empno,
                                         p_assign_code   => p_assign_code
                                     );
     end if;       

   Open c For
      Select *
        From (
                Select empprojmap.KYE_ID As keyid,
                       empprojmap.EMPNO As Empno,
                        a.name As Empname,
                       empprojmap.PROJNO As Projno,
                       b.name As Projname,
                       Row_Number() Over (Order By empprojmap.KYE_ID Desc) row_number,
                       Count(*) Over () total_row
                  From SWP_EMP_PROJ_MAPPING empprojmap , 
                        ss_emplmast a , ss_projmast b
                 Where a.empno = empprojmap.empno 
                     and b.projno = empprojmap.PROJNO
                     and  empprojmap.EMPNO In (
                          Select Distinct empno
                            From ss_emplmast
                           Where status = 1
                            And a.assign = nvl(v_hod_sec_assign_code, a.assign)
                       )

             )
       Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
       Order By Empno,PROJNO;
   Return c;
	*/
 RETURN NULL;

End fn_desk_area_map_list;


End IOT_SWP_DESK_AREA_MAP_QRY;
/
