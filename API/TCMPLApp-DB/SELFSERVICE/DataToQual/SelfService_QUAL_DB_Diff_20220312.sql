--------------------------------------------------------
--  File created - Saturday-March-12-2022   
--------------------------------------------------------
---------------------------
--Changed TABLE
--SWP_VACCINE_DATES
---------------------------
ALTER TABLE "SELFSERVICE"."SWP_VACCINE_DATES" ADD ("MODIFIED_BY" VARCHAR2(5));

---------------------------
--New TABLE
--SWP_SMART_ATTENDANCE_PLAN
---------------------------
  CREATE TABLE "SELFSERVICE"."SWP_SMART_ATTENDANCE_PLAN" 
   (	"KEY_ID" CHAR(10) NOT NULL ENABLE,
	"WS_KEY_ID" CHAR(10) NOT NULL ENABLE,
	"EMPNO" CHAR(5) NOT NULL ENABLE,
	"ATTENDANCE_DATE" DATE NOT NULL ENABLE,
	"MODIFIED_ON" DATE NOT NULL ENABLE,
	"MODIFIED_BY" VARCHAR2(5) NOT NULL ENABLE,
	"DESKID" VARCHAR2(10) NOT NULL ENABLE,
	"WEEK_KEY_ID" VARCHAR2(8),
	CONSTRAINT "SWP_SMART_ATTENDANCE_PLAN_PK1" PRIMARY KEY ("KEY_ID") ENABLE,
	CONSTRAINT "SWP_SMART_ATTENDANCE_PLAN_UK1" UNIQUE ("ATTENDANCE_DATE","DESKID") ENABLE
   );
---------------------------
--New TABLE
--SWP_PRIMARY_WORKSPACE_TYPES
---------------------------
  CREATE TABLE "SELFSERVICE"."SWP_PRIMARY_WORKSPACE_TYPES" 
   (	"TYPE_CODE" NUMBER(1,0) NOT NULL ENABLE,
	"TYPE_DESC" VARCHAR2(100),
	CONSTRAINT "SWP_PRIMARY_WORKSPACE_TYPE_PK" PRIMARY KEY ("TYPE_CODE") ENABLE
   );
---------------------------
--New TABLE
--SWP_PRIMARY_WORKSPACE_HIST
---------------------------
  CREATE TABLE "SELFSERVICE"."SWP_PRIMARY_WORKSPACE_HIST" 
   (	"KEY" VARCHAR2(10) NOT NULL ENABLE,
	"EMPNO" VARCHAR2(5) NOT NULL ENABLE,
	"WORKSPACE" VARCHAR2(1) NOT NULL ENABLE,
	"STARTDATE" DATE NOT NULL ENABLE,
	"SOURCE_MODIFIEDON" DATE NOT NULL ENABLE,
	"SOURCE_MODIFIEDBY" VARCHAR2(5) NOT NULL ENABLE,
	"MODIFIED_ON" DATE NOT NULL ENABLE,
	"MODIFIED_BY" VARCHAR2(5) NOT NULL ENABLE
   );
---------------------------
--New TABLE
--SWP_PRIMARY_WORKSPACE
---------------------------
  CREATE TABLE "SELFSERVICE"."SWP_PRIMARY_WORKSPACE" 
   (	"KEY_ID" VARCHAR2(10) NOT NULL ENABLE,
	"EMPNO" CHAR(5) NOT NULL ENABLE,
	"PRIMARY_WORKSPACE" NUMBER(1,0),
	"START_DATE" DATE NOT NULL ENABLE,
	"MODIFIED_ON" DATE NOT NULL ENABLE,
	"MODIFIED_BY" VARCHAR2(5) NOT NULL ENABLE,
	"ACTIVE_CODE" NUMBER(1,0),
	"ASSIGN_CODE" VARCHAR2(4),
	CONSTRAINT "SWP_PRIMARY_WORKSPACE_FK1" FOREIGN KEY ("PRIMARY_WORKSPACE")
	 REFERENCES "SELFSERVICE"."SWP_PRIMARY_WORKSPACE_TYPES" ("TYPE_CODE") ENABLE
   );
  COMMENT ON COLUMN "SELFSERVICE"."SWP_PRIMARY_WORKSPACE"."ACTIVE_CODE" IS '2(Current/Future), 1(Current), 0(Past)';
  COMMENT ON COLUMN "SELFSERVICE"."SWP_PRIMARY_WORKSPACE"."PRIMARY_WORKSPACE" IS '1(Office),2(SmartWork),3(Not in mumbai office)';
---------------------------
--Changed TABLE
--SWP_EXCLUDE_ASSIGN
---------------------------
ALTER TABLE "SELFSERVICE"."SWP_EXCLUDE_ASSIGN" ADD ("IS_SITE_CODE" NUMBER(1,0));

---------------------------
--New TABLE
--SWP_EMP_PROJ_MAPPING
---------------------------
  CREATE TABLE "SELFSERVICE"."SWP_EMP_PROJ_MAPPING" 
   (	"KYE_ID" VARCHAR2(10) NOT NULL ENABLE,
	"EMPNO" CHAR(5),
	"PROJNO" VARCHAR2(20),
	"MODIFIED_ON" DATE,
	"MODIFIED_BY" CHAR(5),
	CONSTRAINT "SWP_EMP_PROJ_MAPPING_PK" PRIMARY KEY ("KYE_ID") ENABLE
   );
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
--New TABLE
--SWP_CONFIG_WEEKS
---------------------------
  CREATE TABLE "SELFSERVICE"."SWP_CONFIG_WEEKS" 
   (	"KEY_ID" CHAR(8),
	"START_DATE" DATE,
	"END_DATE" DATE,
	"PLANNING_FLAG" NUMBER(1,0),
	"PLANNING_OPEN" NUMBER(1,0),
	PRIMARY KEY ("KEY_ID") ENABLE
   );
  COMMENT ON COLUMN "SELFSERVICE"."SWP_CONFIG_WEEKS"."PLANNING_FLAG" IS '2(Current/Future), 1(Current), 0(Past)';
  COMMENT ON COLUMN "SELFSERVICE"."SWP_CONFIG_WEEKS"."PLANNING_OPEN" IS '1 - Open / 0 - Close';
---------------------------
--Changed TABLE
--SS_LEAVE_ADJ
---------------------------
ALTER TABLE "SELFSERVICE"."SS_LEAVE_ADJ" ADD ("IS_COVID_SICK_LEAVE" NUMBER(1,0));

---------------------------
--Changed TABLE
--SS_LEAVELEDG
---------------------------
ALTER TABLE "SELFSERVICE"."SS_LEAVELEDG" ADD ("IS_COVID_SICK_LEAVE" NUMBER(1,0));

---------------------------
--Changed TABLE
--SS_LEAVEAPP_REJECTED
---------------------------
ALTER TABLE "SELFSERVICE"."SS_LEAVEAPP_REJECTED" ADD ("IS_COVID_SICK_LEAVE" NUMBER(1,0));
ALTER TABLE "SELFSERVICE"."SS_LEAVEAPP_REJECTED" ADD ("MED_CERT_FILE_NAME" VARCHAR2(100));

---------------------------
--Changed TABLE
--SS_LEAVEAPP_DELETED
---------------------------
ALTER TABLE "SELFSERVICE"."SS_LEAVEAPP_DELETED" ADD ("IS_COVID_SICK_LEAVE" NUMBER(1,0));
ALTER TABLE "SELFSERVICE"."SS_LEAVEAPP_DELETED" ADD ("MED_CERT_FILE_NAME" VARCHAR2(100));

---------------------------
--Changed TABLE
--SS_LEAVEAPP
---------------------------
ALTER TABLE "SELFSERVICE"."SS_LEAVEAPP" ADD ("IS_COVID_SICK_LEAVE" NUMBER(1,0));
COMMENT ON COLUMN "SELFSERVICE"."SS_LEAVEAPP"."IS_COVID_SICK_LEAVE" IS '1-Yes';

---------------------------
--New TABLE
--SS_HEALTH_REMIND_EXP
---------------------------
  CREATE TABLE "SELFSERVICE"."SS_HEALTH_REMIND_EXP" 
   (	"EMPNO" CHAR(5) NOT NULL ENABLE
   );
---------------------------
--New TABLE
--SS_HEALTH_REMIND_ATTACH
---------------------------
  CREATE TABLE "SELFSERVICE"."SS_HEALTH_REMIND_ATTACH" 
   (	"ID" NUMBER NOT NULL ENABLE,
	"NAME" VARCHAR2(2000),
	"CONTENTTYPE" VARCHAR2(4000),
	"DATABLOB" BLOB,
	"ISACTIVE" NUMBER DEFAULT 1,
	CONSTRAINT "SS_HEALTH_REMIND_ATTACH_PK" PRIMARY KEY ("ID") ENABLE
   );
---------------------------
--New TABLE
--SS_HEALTH_MESSAGE
---------------------------
  CREATE TABLE "SELFSERVICE"."SS_HEALTH_MESSAGE" 
   (	"MESSAGETEXT" VARCHAR2(1000) NOT NULL ENABLE,
	"ISACTIVE" NUMBER(1,0) DEFAULT 1,
	"ORD" NUMBER(2,0),
	"TEXTCOLOR" VARCHAR2(20)
   );
  COMMENT ON COLUMN "SELFSERVICE"."SS_HEALTH_MESSAGE"."ISACTIVE" IS '0 - Inactive, 1 - Active';
---------------------------
--Changed TABLE
--SS_HEALTH_EMP
---------------------------
ALTER TABLE "SELFSERVICE"."SS_HEALTH_EMP" ADD ("CLINICLOC" VARCHAR2(4));

---------------------------
--Changed TABLE
--SS_DELEGATE
---------------------------
ALTER TABLE "SELFSERVICE"."SS_DELEGATE" ADD CONSTRAINT "SS_DELEGATE_PK" PRIMARY KEY ("EMPNO") ENABLE;

---------------------------
--Changed TABLE
--SS_ABSENT_TS_MASTER
---------------------------
ALTER TABLE "SELFSERVICE"."SS_ABSENT_TS_MASTER" ADD ("REFRESHED_ON" DATE);

---------------------------
--Changed TABLE
--SS_ABSENT_TS_LEAVE
---------------------------
ALTER TABLE "SELFSERVICE"."SS_ABSENT_TS_LEAVE" MODIFY ("WPCODE" NOT NULL ENABLE);
ALTER TABLE "SELFSERVICE"."SS_ABSENT_TS_LEAVE" ADD CONSTRAINT "SS_ABSENT_TS_LEAVE_PK" PRIMARY KEY ("EMPNO","TDATE","PROJNO","ACTIVITY","WPCODE") ENABLE;

---------------------------
--Changed TABLE
--SS_ABSENT_TS_DETAIL
---------------------------
ALTER TABLE "SELFSERVICE"."SS_ABSENT_TS_DETAIL" ADD ("MODIFIED_ON" DATE);
ALTER TABLE "SELFSERVICE"."SS_ABSENT_TS_DETAIL" MODIFY ("ABSENT_YYYYMM" NOT NULL ENABLE);
ALTER TABLE "SELFSERVICE"."SS_ABSENT_TS_DETAIL" MODIFY ("EMPNO" NOT NULL ENABLE);
ALTER TABLE "SELFSERVICE"."SS_ABSENT_TS_DETAIL" MODIFY ("PAYSLIP_YYYYMM" NOT NULL ENABLE);
ALTER TABLE "SELFSERVICE"."SS_ABSENT_TS_DETAIL" ADD CONSTRAINT "SS_ABSENT_TS_DETAIL_PK" PRIMARY KEY ("ABSENT_YYYYMM","PAYSLIP_YYYYMM","EMPNO") ENABLE;

---------------------------
--Changed TABLE
--SS_ABSENT_PAYSLIP_PERIOD
---------------------------
ALTER TABLE "SELFSERVICE"."SS_ABSENT_PAYSLIP_PERIOD" MODIFY ("PERIOD" NOT NULL ENABLE);
ALTER TABLE "SELFSERVICE"."SS_ABSENT_PAYSLIP_PERIOD" ADD CONSTRAINT "SS_ABSENT_PAYSLIP_PERIOD_PK" PRIMARY KEY ("PERIOD") ENABLE;

---------------------------
--Changed TABLE
--SS_ABSENT_MASTER
---------------------------
ALTER TABLE "SELFSERVICE"."SS_ABSENT_MASTER" ADD ("REFRESHED_ON" DATE);
ALTER TABLE "SELFSERVICE"."SS_ABSENT_MASTER" MODIFY ("ABSENT_YYYYMM" NOT NULL ENABLE);
ALTER TABLE "SELFSERVICE"."SS_ABSENT_MASTER" MODIFY ("PAYSLIP_YYYYMM" NOT NULL ENABLE);
ALTER TABLE "SELFSERVICE"."SS_ABSENT_MASTER" ADD CONSTRAINT "SS_ABSENT_MASTER_PK" PRIMARY KEY ("ABSENT_YYYYMM","PAYSLIP_YYYYMM") ENABLE;

---------------------------
--Changed TABLE
--SS_ABSENT_DETAIL
---------------------------
ALTER TABLE "SELFSERVICE"."SS_ABSENT_DETAIL" MODIFY ("ABSENT_YYYYMM" NOT NULL ENABLE);
ALTER TABLE "SELFSERVICE"."SS_ABSENT_DETAIL" MODIFY ("EMPNO" NOT NULL ENABLE);
ALTER TABLE "SELFSERVICE"."SS_ABSENT_DETAIL" MODIFY ("PAYSLIP_YYYYMM" NOT NULL ENABLE);
ALTER TABLE "SELFSERVICE"."SS_ABSENT_DETAIL" ADD CONSTRAINT "SS_ABSENT_DETAIL_PK" PRIMARY KEY ("ABSENT_YYYYMM","PAYSLIP_YYYYMM","EMPNO") ENABLE;

---------------------------
--New VIEW
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
--New VIEW
--DM_VU_DESK_AREA_CATEGORIES
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_VU_DESK_AREA_CATEGORIES" 
 ( "AREA_CATG_CODE", "DESCRIPTION"
  )  AS 
  select "AREA_CATG_CODE","DESCRIPTION" from dms.dm_desk_area_categories;
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
--SWP_VU_AREA_LIST
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SWP_VU_AREA_LIST" 
 ( "OFFICE", "FLOOR", "WING", "WORK_AREA", "AREA_DESC", "AREA_CATG_CODE", "TOTAL", "OCCUPIED", "AVAILABLE", "ROW_NUMBER", "TOTAL_ROW"
  )  AS 
  Select Distinct
          mast.office office,
          mast.floor floor,
          mast.wing wing,
          mast.work_area work_area,
          area.area_desc area_desc,
          area.AREA_CATG_CODE AREA_CATG_CODE,
          selfservice.iot_swp_common.get_total_desk(mast.work_area, Trim(mast.office), mast.floor, mast.wing) As total,
          selfservice.iot_swp_common.get_occupied_desk(mast.work_area, Trim(mast.office), mast.floor, mast.wing) As occupied,
          (selfservice.iot_swp_common.get_total_desk(mast.work_area, Trim(mast.office), mast.floor, mast.wing) - selfservice.
          iot_swp_common
          .get_occupied_desk(mast.work_area, Trim(mast.office), mast.floor, mast.wing)) As available,
          0 row_number,
          0 total_row
     From dms.dm_deskmaster mast,
          dms.dm_desk_areas area
    Where area.area_key_id = mast.work_area;
---------------------------
--Changed VIEW
--SS_DISPLEDG
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_DISPLEDG" 
 ( "APP_NO", "APP_DATE", "LEAVETYPE", "DESCRIPTION", "EMPNO", "LEAVEPERIOD", "DB_CR", "DISPBDATE", "DISPEDATE", "DBDAY", "CRDAY", "ADJ_TYPE", "IS_COVID_SICK_LEAVE"
  )  AS 
  SELECT SS_LEAVELEDG.APP_NO,
    SS_LEAVELEDG.APP_DATE,
    SS_LEAVELEDG.LEAVETYPE,
    SS_LEAVELEDG.DESCRIPTION,
    SS_LEAVELEDG.EMPNO,
    SS_LEAVELEDG.LEAVEPERIOD,
    SS_LEAVELEDG.DB_CR,
    SS_Leaveledg.BDate DispBDate,
    SS_Leaveledg.EDate DispEDate,
    DECODE(SS_LEAVELEDG.DB_CR, 'D', SS_LEAVELEDG.LEAVEPERIOD*-1, NULL) DbDay,
    DECODE(SS_LEAVELEDG.DB_CR, 'C', SS_LEAVELEDG.LEAVEPERIOD, NULL) CrDay,
    SS_LEAVE_ADJ.ADJ_TYPE,
    SS_LEAVELEDG.IS_COVID_SICK_LEAVE
  FROM SS_LEAVE_ADJ,
    SS_LEAVEAPP,
    SS_LEAVELEDG
  WHERE (SS_LEAVELEDG.APP_NO=SS_LEAVE_ADJ.ADJ_NO(+))
  AND (SS_LEAVELEDG.APP_NO  =SS_LEAVEAPP.APP_NO(+))
  AND (SS_LEAVELEDG.EMPNO   =SS_LEAVE_ADJ.EMPNO(+))
  AND (SS_LEAVELEDG.EMPNO   =SS_LEAVEAPP.EMPNO(+));
---------------------------
--New VIEW
--SS_EMPTYPEMAST
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_EMPTYPEMAST" 
 ( "EMPTYPE", "EMPDESC", "EMPREMARKS", "TM", "PRINTLOGO", "SORTORDER"
  )  AS 
  select "EMPTYPE","EMPDESC","EMPREMARKS","TM","PRINTLOGO","SORTORDER" from timecurr.emptypemast;
---------------------------
--Changed VIEW
--DM_VU_EMP_DESK_MAP
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_VU_EMP_DESK_MAP" 
 ( "EMPNO", "DESKID"
  )  AS 
  SELECT 
    "EMPNO","DESKID"
FROM 
    
dms.dm_vu_emp_desk_map;
---------------------------
--New VIEW
--TCMPL_APP_CONFIG
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
--SS_VU_GRADES
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_GRADES" 
 ( "GRADE_ID", "GRADE_DESC"
  )  AS 
  select "GRADE_ID","GRADE_DESC" from COMMONMASTERS.hr_grade_master;
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
--DM_VU_DESK_LIST
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_VU_DESK_LIST" 
 ( "DESKID", "OFFICE", "FLOOR", "SEATNO", "WING", "ASSETCODE", "NOEXIST", "CABIN", "REMARKS", "DESKID_OLD", "WORK_AREA", "BAY"
  )  AS 
  SELECT "DESKID","OFFICE","FLOOR","SEATNO","WING","ASSETCODE","NOEXIST","CABIN","REMARKS","DESKID_OLD","WORK_AREA","BAY"
    
FROM 
    
dms.dm_deskmaster;
---------------------------
--New VIEW
--SS_VU_EMPTYPES
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_EMPTYPES" 
 ( "EMPTYPE", "EMPDESC", "EMPREMARKS", "TM", "PRINTLOGO", "SORTORDER"
  )  AS 
  select "EMPTYPE","EMPDESC","EMPREMARKS","TM","PRINTLOGO","SORTORDER" from commonmasters.emptypemast;
---------------------------
--New VIEW
--DM_VU_DESKS
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_VU_DESKS" 
 ( "DESKID", "OFFICE", "FLOOR", "SEATNO", "WING", "ASSETCODE", "NOEXIST", "CABIN", "REMARKS", "DESKID_OLD", "WORK_AREA", "BAY", "AREA_DESC", "AREA_CATG_CODE", "catg_desc"
  )  AS 
  Select
    dl."DESKID",dl."OFFICE",dl."FLOOR",dl."SEATNO",dl."WING",dl."ASSETCODE",dl."NOEXIST",dl."CABIN",dl."REMARKS",dl."DESKID_OLD",dl."WORK_AREA",dl."BAY", da.area_desc, da.area_catg_code, dac.description As "catg_desc"
From
    dm_vu_desk_list                                   dl
    Inner Join selfservice.dm_vu_desk_areas           da
    On dl.work_area = da.area_key_id
    Inner Join selfservice.dm_vu_desk_area_categories dac
    On da.area_catg_code = dac.area_catg_code;
---------------------------
--Changed VIEW
--SWP_VU_EMP_VACCINE_DATE
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SWP_VU_EMP_VACCINE_DATE" 
 ( "EMPNO", "NAME", "PARENT", "GRADE", "VACCINE_TYPE", "JAB1_DATE", "FIRST_JAB_SPONSOR", "JAB2_DATE", "SECOND_JAB_SPONSOR", "CAN_EDIT", "MODIFIED_ON"
  )  AS 
  Select
        d.empno,
        e.name,
        e.parent,
        e.grade,
        d.vaccine_type,
        d.jab1_date,
        Case nvl(d.is_jab1_by_office, 'KO')
            When 'OK' Then
                'Office'
            When 'KO' Then
                'Self'
        End first_jab_sponsor,
        d.jab2_date,
        Case d.is_jab2_by_office
            When 'OK' Then
                'Office'
            When 'KO' Then
                'Self'
            Else
                ''
        End second_jab_sponsor,
        Case
            When d.jab2_date Is Null Then
                'OK'
            Else
                'KO'
        End can_edit,
        d.modified_on
    From
        swp_vaccine_dates d,
        ss_emplmast       e
    Where
        d.empno      = e.empno
        And e.status = 1;
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
--Changed VIEW
--SS_VU_ABSENT_TS_LOP
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_ABSENT_TS_LOP" 
 ( "PERSONID", "EMPNO", "NAME", "PARENT", "ASSIGN", "PAYSLIP_YYYYMM", "ABSENT_YYYYMM", "LOP_DAYS_CSV", "EMP_TOT_LOP", "REVERSE_LOP_DAYS_CSV"
  )  AS 
  select
     b.personid,
     a.empno,
     b.name,
     b.parent,
     b.assign,
     a.payslip_yyyymm,
     a.absent_yyyymm,
     a.lop_days_csv,
     a.emp_tot_lop,
     reverse_lop_days_csv
 from
     (
         select
             empno,
             payslip_yyyymm,
             absent_yyyymm,
             listagg(lop_days,', ') within group(
                 order by
                     lop_4_date
             ) lop_days_csv,
             sum(half_full) emp_tot_lop,
             listagg(reverse_lop_days,', ') within group(
                 order by
                     lop_4_date
             ) reverse_lop_days_csv
         from
             (
                 select
                     aa.empno,
                     aa.lop_4_date,
                     aa.payslip_yyyymm,
                     to_char(aa.lop_4_date,'yyyymm') absent_yyyymm,
                     case aa.half_full
                         when 1   then to_char(aa.lop_4_date,'dd')
                         else '*'
                              || to_char(aa.lop_4_date,'dd')
                     end lop_days,
                     aa.half_full,
                     case nvl(bb.half_full,-1)
                         when 1    then to_char(bb.lop_4_date,'dd')
                         when.5   then '*'
                                     || to_char(bb.lop_4_date,'dd')
                         else null
                     end reverse_lop_days
                 from
                     ss_absent_ts_lop aa,
                     ss_absent_ts_lop_reverse bb
                 where
                     aa.empno = bb.empno (+)
                     and aa.lop_4_date = bb.lop_4_date (+)
             )
         group by
             empno,
             payslip_yyyymm,
             absent_yyyymm
         order by
             empno,
             payslip_yyyymm
     ) a,
     ss_emplmast b
 where
     a.empno = b.empno;
---------------------------
--Changed VIEW
--SS_VU_ABSENT_LOP_NU
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_ABSENT_LOP_NU" 
 ( "PERSONID", "EMPNO", "NAME", "PARENT", "ASSIGN", "PAYSLIP_YYYYMM", "ABSENT_YYYYMM", "LOP_DAYS_CSV", "EMP_TOT_LOP", "REVERSE_LOP_DAYS_CSV"
  )  AS 
  select
     b.personid,
     a.empno,
     b.name,
     b.parent,
     b.assign,
     a.payslip_yyyymm,
     a.absent_yyyymm,
     a.lop_days_csv,
     a.emp_tot_lop,
     reverse_lop_days_csv
 from
     (
         select
             empno,
             payslip_yyyymm,
             absent_yyyymm,
             listagg(lop_days,', ') within group(
                 order by
                     lop_4_date
             ) lop_days_csv,
             sum(half_full) emp_tot_lop,
             listagg(reverse_lop_days,', ') within group(
                 order by
                     lop_4_date
             ) reverse_lop_days_csv
         from
             (
                 select
                     aa.empno,
                     aa.lop_4_date,
                     aa.payslip_yyyymm,
                     to_char(aa.lop_4_date,'yyyymm') absent_yyyymm,
                     case aa.half_full
                         when 1   then to_char(aa.lop_4_date,'dd')
                         else '*'
                              || to_char(aa.lop_4_date,'dd')
                     end lop_days,
                     aa.half_full,
                     case nvl(bb.half_full,-1)
                         when 1    then to_char(bb.lop_4_date,'dd')
                         when.5   then '*'
                                     || to_char(bb.lop_4_date,'dd')
                         else null
                     end reverse_lop_days
                 from
                     ss_absent_lop aa,
                     ss_absent_lop_reverse bb
                 where
                     aa.empno = bb.empno (+)
                     and aa.lop_4_date = bb.lop_4_date (+)
             )
         group by
             empno,
             payslip_yyyymm,
             absent_yyyymm
         order by
             empno,
             payslip_yyyymm
     ) a,
     ss_emplmast b
 where
     a.empno = b.empno;
---------------------------
--New VIEW
--DM_VU_EMP_DESK_MAP_SWP_PLAN
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_VU_EMP_DESK_MAP_SWP_PLAN" 
 ( "EMPNO", "DESKID"
  )  AS 
  SELECT 
    empno,
    deskid
FROM 
    dms.dm_vu_emp_desk_map_swp_plan;
---------------------------
--New VIEW
--DM_VU_DESK_LOCK_SWP_PLAN
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_VU_DESK_LOCK_SWP_PLAN" 
 ( "UNQID", "EMPNO", "DESKID", "TARGETDESK", "BLOCKFLAG", "BLOCKREASON", "REASON_DESC"
  )  AS 
  select "UNQID","EMPNO","DESKID","TARGETDESK","BLOCKFLAG","BLOCKREASON","REASON_DESC" from dms.dm_vu_desk_lock_swp_plan;
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
--VU_SYSTEM_GRANTS_HEALTH
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."VU_SYSTEM_GRANTS_HEALTH" 
 ( "APPLSYSTEM", "EMPNO", "NAME", "STATUS", "ROLENAMEBYPROJECT", "ROLENAME", "ROLEDESC", "MODULE"
  )  AS 
  select '011' As "APPLSYSTEM", a.empno, b.name, b.status, a.usertype rolenamebyproject,
Case 
    When a.usertype = 'HRD' Then 'Hr User'
End As rolename,
Case 
   When a.usertype = 'HRD' Then 'HR User'
End As roledesc, 'Health Checkup' module
from (select empno, 'HRD' usertype from ss_health_hrduser) a, ss_emplmast b
where a.empno = b.empno;
---------------------------
--New INDEX
--SS_HEALTH_REMIND_ATTACH_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_HEALTH_REMIND_ATTACH_PK" ON "SELFSERVICE"."SS_HEALTH_REMIND_ATTACH" ("ID");
---------------------------
--New INDEX
--SS_ABSENT_TS_DETAIL_INDEX1
---------------------------
  CREATE INDEX "SELFSERVICE"."SS_ABSENT_TS_DETAIL_INDEX1" ON "SELFSERVICE"."SS_ABSENT_TS_DETAIL" ("KEY_ID");
---------------------------
--New INDEX
--SS_ABSENT_PAYSLIP_PERIOD_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_ABSENT_PAYSLIP_PERIOD_PK" ON "SELFSERVICE"."SS_ABSENT_PAYSLIP_PERIOD" ("PERIOD");
---------------------------
--New INDEX
--SS_ABSENT_TS_LEAVE_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_ABSENT_TS_LEAVE_PK" ON "SELFSERVICE"."SS_ABSENT_TS_LEAVE" ("EMPNO","TDATE","PROJNO","ACTIVITY","WPCODE");
---------------------------
--New INDEX
--SS_ABSENT_DETAIL_INDEX2
---------------------------
  CREATE INDEX "SELFSERVICE"."SS_ABSENT_DETAIL_INDEX2" ON "SELFSERVICE"."SS_ABSENT_DETAIL" ("KEY_ID");
---------------------------
--New INDEX
--SS_ABSENT_DETAIL_INDEX1
---------------------------
  CREATE INDEX "SELFSERVICE"."SS_ABSENT_DETAIL_INDEX1" ON "SELFSERVICE"."SS_ABSENT_DETAIL" ("KEY_ID","ABSENT_YYYYMM","PAYSLIP_YYYYMM","EMPNO");
---------------------------
--New INDEX
--SS_ABSENT_MASTER_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_ABSENT_MASTER_PK" ON "SELFSERVICE"."SS_ABSENT_MASTER" ("ABSENT_YYYYMM","PAYSLIP_YYYYMM");
---------------------------
--New INDEX
--SWP_PRIMARY_WORKSPACE_TYPE_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SWP_PRIMARY_WORKSPACE_TYPE_PK" ON "SELFSERVICE"."SWP_PRIMARY_WORKSPACE_TYPES" ("TYPE_CODE");
---------------------------
--New INDEX
--SWP_DESK_AREA_MAPPING_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SWP_DESK_AREA_MAPPING_PK" ON "SELFSERVICE"."SWP_DESK_AREA_MAPPING" ("KYE_ID");
---------------------------
--Changed INDEX
--SWP_WFH_WEEKATND_PK
---------------------------
DROP INDEX "SELFSERVICE"."SWP_WFH_WEEKATND_PK";
  CREATE UNIQUE INDEX "SELFSERVICE"."SWP_WFH_WEEKATND_PK" ON "SELFSERVICE"."SWP_SMART_ATTENDANCE_PLAN" ("KEY_ID");
---------------------------
--New INDEX
--SS_ABSENT_TS_DETAIL_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_ABSENT_TS_DETAIL_PK" ON "SELFSERVICE"."SS_ABSENT_TS_DETAIL" ("ABSENT_YYYYMM","PAYSLIP_YYYYMM","EMPNO");
---------------------------
--New INDEX
--SS_PRINT_LOG_INDEX4
---------------------------
  CREATE INDEX "SELFSERVICE"."SS_PRINT_LOG_INDEX4" ON "SELFSERVICE"."SS_PRINT_LOG" ("PRINT_DATE","EMPNO");
---------------------------
--New INDEX
--SS_ABSENT_TS_DETAIL_INDEX2
---------------------------
  CREATE INDEX "SELFSERVICE"."SS_ABSENT_TS_DETAIL_INDEX2" ON "SELFSERVICE"."SS_ABSENT_TS_DETAIL" ("KEY_ID","ABSENT_YYYYMM","PAYSLIP_YYYYMM","EMPNO");
---------------------------
--New INDEX
--SS_ABSENT_DETAIL_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_ABSENT_DETAIL_PK" ON "SELFSERVICE"."SS_ABSENT_DETAIL" ("ABSENT_YYYYMM","PAYSLIP_YYYYMM","EMPNO");
---------------------------
--New INDEX
--SS_ABSENT_LOP_INDEX1
---------------------------
  CREATE INDEX "SELFSERVICE"."SS_ABSENT_LOP_INDEX1" ON "SELFSERVICE"."SS_ABSENT_LOP" ("EMPNO","PAYSLIP_YYYYMM");
---------------------------
--New INDEX
--SWP_EMP_PROJ_MAPPING_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SWP_EMP_PROJ_MAPPING_PK" ON "SELFSERVICE"."SWP_EMP_PROJ_MAPPING" ("KYE_ID");
---------------------------
--New INDEX
--SWP_SMART_ATTENDANCE_PLAN_UK1
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SWP_SMART_ATTENDANCE_PLAN_UK1" ON "SELFSERVICE"."SWP_SMART_ATTENDANCE_PLAN" ("ATTENDANCE_DATE","DESKID");
---------------------------
--New INDEX
--SS_ABSENT_MASTER_INDEX1
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_ABSENT_MASTER_INDEX1" ON "SELFSERVICE"."SS_ABSENT_MASTER" ("KEY_ID");
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
--New TRIGGER
--SS_TRIG_ABSENT_TS_DETAIL_01
---------------------------
  CREATE OR REPLACE TRIGGER "SELFSERVICE"."SS_TRIG_ABSENT_TS_DETAIL_01"
  BEFORE INSERT OR UPDATE ON "SELFSERVICE"."SS_ABSENT_TS_DETAIL"
  REFERENCING FOR EACH ROW
  Begin
    :new.modified_on := Sysdate;
End;
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
--New PACKAGE
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
--Changed PACKAGE
--IOT_SELECT_LIST_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SELECT_LIST_QRY" As

    Function fn_leave_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_leave_types_for_leaveclaims(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_approvers_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_onduty_types_list_4_user(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_group_no  Number
    ) Return Sys_Refcursor;

    Function fn_onduty_types_list_4_filter(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_onduty_types_list_4_hr(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_group_no  Number
    ) Return Sys_Refcursor;

    Function fn_employee_list_4_hr(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_emplist_4_mngrhod(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;
    Function fn_emp_list_4_mngrhod_onbehalf(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_project_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_costcode_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_emp_list_for_filter(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_list_for  Varchar2
    -- Lead / Hod /HR
    ) Return Sys_Refcursor;

    Function fn_emp_list_for_lead_filter(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_emp_list_for_hod_filter(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_emp_list_for_hr_filter(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_employee_list_4_secretary(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

End iot_select_list_qry;
/
---------------------------
--New PACKAGE
--IOT_SWP_SMART_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_SMART_WORKSPACE" As
     Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;
    c_office_workspace constant number := 1;
    c_smart_workspace constant number := 2;
    c_not_in_mum_office constant number := 3;

    Procedure sp_add_weekly_atnd(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_weekly_attendance typ_tab_string,
        p_empno             Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    );

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
    );


End IOT_SWP_SMART_WORKSPACE;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_COMMON
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_COMMON" As

    Function get_emp_work_area(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2
    ) Return Varchar2;

    Function get_emp_work_area_code(
        p_empno Varchar2
    ) Return Varchar2;

    Function get_desk_from_dms(
        p_empno In Varchar2
    ) Return Varchar2;

    /*
    Function get_emp_dms_type_desc(
        p_empno In Varchar2
    ) Return Varchar2;

    Function get_emp_dms_type_code(
        p_empno In Varchar2
    ) Return Number;
    */
    Procedure get_planning_week_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_start_date      Out Date,
        p_end_date        Out Date,
        p_planning_exists Out Varchar2,
        p_planning_open   Out Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2

    );
    Function get_total_desk(
        p_work_area Varchar2,
        p_office    Varchar2,
        p_floor     Varchar2,
        p_wing      Varchar2
    ) Return Number;

    Function get_occupied_desk(
        p_work_area Varchar2,
        p_office    Varchar2,
        p_floor     Varchar2,
        p_wing      Varchar2,
        p_date      Date Default Null
    ) Return Number;

    Function get_monday_date(p_date Date) Return Date;

    Function get_friday_date(p_date Date) Return Date;

    --
    Function is_emp_eligible_for_swp(
        p_empno Varchar2
    ) Return Varchar2;

    --
    Function get_default_costcode_hod_sec(
        p_hod_sec_empno Varchar2,
        p_assign_code   Varchar2 Default Null
    ) Return Varchar2;

    Function get_hod_sec_costcodes_csv(
        p_hod_sec_empno    Varchar2,
        p_assign_codes_csv Varchar2 Default Null
    ) Return Varchar2;

    Function is_emp_laptop_user(
        p_empno Varchar2
    ) Return Number;
    --
    Function csv_to_ary_grades(
        p_grades_csv Varchar2 Default Null
    ) Return Sys_Refcursor;

    Function is_desk_in_general_area(p_deskid Varchar2) Return Boolean;
End iot_swp_common;
/
---------------------------
--New PACKAGE
--IOT_SWP_OFFICE_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_OFFICE_WORKSPACE_QRY" As

    c_qry_office_planning Varchar2(4000) := ' 

With
    params As (
        Select
            :p_person_id      As p_person_id,
            :p_meta_id        As p_meta_id,
            :p_row_number     As p_row_number,
            :p_page_length    As p_page_length,

            :p_assign_code    As p_assign_code,
            :p_emptype_csv    As p_emptype_csv,
            :p_grades_csv     As p_grades_csv,
            :p_generic_search As p_generic_search,
            :p_desk_assignment_status as p_desk_assignment_status
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
            Row_Number() Over(Order By planned , employee_name) As row_number,
            Count(*) Over()                   As total_row
        From
            (
                Select
                    base_data.*,
                    case when base_data.deskid is null then 0 else 1 end planned
                From
                    (

                        Select
                            e.empno                                                                         As empno,
                            e.name                                                                          As employee_name,
                            e.parent                                                                        As parent,
                            e.grade                                                                         As emp_grade,
                            iot_swp_common.get_emp_work_area(params.p_person_id, params.p_meta_id, e.empno) As work_area,
                            e.emptype                                                                       As emptype,
                            e.assign                                                                        As assign,
                            iot_swp_common.get_desk_from_dms(e.empno)                                       As deskid
                        From
                            ss_emplmast e,
                            primary_ws  pws,
                            params
                        Where
                            e.status     = 1
                            And e.empno  = pws.empno

                            And e.assign = nvl(params.p_assign_code,e.assign)
                            
                            !GENERIC_SEARCH!            
                            And e.emptype In (
                            !EMPTYPE_SUBQUERY!
                            )
                            !GRADES_SUBQUERY!

                    ) base_data, params
                    !DESK_ASSIGNMENT_STATUS!
            ) data
    ) full_data, params
Where
    row_number Between (nvl(params.p_row_number, 0) + 1) And (nvl(params.p_row_number, 0) + params.p_page_length) order by planned, employee_name';

    where_clause_generic_search Varchar2(200) := ' and (e.name like params.p_generic_search or e.empno like params.p_generic_search ) ';

    sub_qry_emptype_default Varchar2(200) := ' 
Select
    emptype
From
    swp_include_emptype
';

    sub_qry_emptype_csv Varchar2(400) := ' 
Select
    regexp_substr(params.p_emptype_csv, ''[^,]+'', 1, level) emptype
From
    dual
Connect By
    level <=
    length(params.p_emptype_csv) - length(replace(params.p_emptype_csv, '','')) + 1
';

    sub_qry_grades_csv Varchar2(400) := ' and e.grade in (
Select
    regexp_substr(params.p_grades_csv, ''[^,]+'', 1, level) grade
From
    dual
Connect By
    level <=
    length(params.p_grades_csv) - length(replace(params.p_grades_csv, '','')) + 1 )
';


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
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_date                   Date,

        p_assign_code            Varchar2 Default Null,

        p_emptype_csv            Varchar2 Default Null,
        p_grade_csv              Varchar2 Default Null,
        p_generic_search         Varchar2 Default Null,
        p_desk_assignment_status Varchar2 Default Null,

        p_row_number             Number,
        p_page_length            Number
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
--New PACKAGE
--IOT_SWP_OFFICE_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_OFFICE_WORKSPACE" As

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;

    Procedure sp_add_office_ws_desk(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_deskid           Varchar2,
        p_empno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

End iot_swp_office_workspace;
/
---------------------------
--Changed PACKAGE
--IOT_HOLIDAY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_HOLIDAY" As
   Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;

   Procedure sp_add_holiday(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_office           Varchar2,
      p_date             Date,
      p_project          Varchar2,
      p_approver         Varchar2,
      p_hh1              Varchar2,
      p_mi1              Varchar2,
      p_hh2              Varchar2,
      p_mi2              Varchar2,
      p_reason           Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   );

   Procedure sp_delete_holiday(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_application_id   Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   );

   Procedure sp_holiday_approval(
      p_person_id         Varchar2,
      p_meta_id           Varchar2,

      p_holiday_approvals typ_tab_string,
      p_approver_profile  Number,
      p_message_type Out  Varchar2,
      p_message_text Out  Varchar2
   );

   Procedure sp_holiday_approval_lead(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_holiday_approvals  typ_tab_string,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   );

   Procedure sp_holiday_approval_hod(
      p_person_id         Varchar2,
      p_meta_id           Varchar2,

      p_holiday_approvals typ_tab_string,

      p_message_type Out  Varchar2,
      p_message_text Out  Varchar2
   );

   Procedure sp_holiday_approval_hr(
      p_person_id         Varchar2,
      p_meta_id           Varchar2,

      p_holiday_approvals typ_tab_string,

      p_message_type Out  Varchar2,
      p_message_text Out  Varchar2
   );

End iot_holiday;
/
---------------------------
--Changed PACKAGE
--IOT_HOLIDAY_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_HOLIDAY_QRY" As

   Function fn_holiday_attendance(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_start_date  Date Default Null,
      p_end_date    Date Default Null,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

   Function fn_pending_lead_approval(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

   Function fn_pending_hod_approval(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

   Function fn_pending_onbehalf_approval(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

   Function fn_pending_hr_approval(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

Procedure sp_holiday_details(
          p_person_id            Varchar2,
          p_meta_id              Varchar2,

          p_Application_Id       Varchar2,

          P_Employee            Out Varchar2,
          P_PROJNO           Out Varchar2,
          P_Lead_Name        Out Varchar2,
          P_Attendance_Date  Out Varchar2,
          P_Punch_In_Time    Out Varchar2,
          P_Punch_Out_Time   Out Varchar2,
          P_REMARKS          Out Varchar2,
          P_Office           Out Varchar2,
          P_LEAD_APPRL       Out Varchar2,
          P_LEAD_APPRL_DATE  Out Varchar2,
          P_LEAD_APPRL_EMPNO Out Varchar2,
          P_HOD_APPRL        Out Varchar2,
          P_HOD_APPRL_DATE   Out Varchar2,
          P_HR_APPRL         Out Varchar2,
          P_HR_APPRL_DATE    Out Varchar2,
          P_DESCRIPTION      Out Varchar2,
          P_Application_Date Out Varchar2,
          P_HOD_Remarks      Out Varchar2,
          P_Hr_Remarks       Out Varchar2,
          P_Lead_Remarks     Out Varchar2,

          p_message_type     Out Varchar2,
          p_message_text     Out Varchar2
   );
End iot_holiday_qry;
/
---------------------------
--Changed PACKAGE
--SS_MAIL
---------------------------
set define off;
CREATE OR REPLACE PACKAGE "SELFSERVICE"."SS_MAIL" As
    c_smtp_mail_server Constant Varchar2(60) := 'ticbexhcn1.ticb.comp';
    c_sender_mail_id Constant Varchar2(60) := 'selfservice@tecnimont.in';
    c_web_server Constant Varchar2(60) := 'http://tplapps02.ticb.comp:80';
    c_empno Constant Varchar2(10) := '&EmpNo&';
    c_app_no Constant Varchar2(10) := '&App_No&';
    c_emp_name Constant Varchar2(10) := '&Emp_Name&';
    c_leave_period Constant Varchar2(20) := '&Leave_Period&';
    c_approval_url Constant Varchar2(20) := '!@ApprovalUrl@!';
    c_msg_type_new_leave_app Constant Number := 1;

    --c_leave_app_msg constant varchar2(2000) := ' Test ';

    c_leave_app_msg Constant Varchar2(2000) := 'There is a Leave application of  ' || c_empno || '  -  ' || c_emp_name ||
        '  for ' || c_leave_period || ' Days.' || chr(13) || chr(10) ||
        'For necessary action, please navigate to ' || chr(13) || chr(10) || c_approval_url || ' .'
        || chr(13) || chr(10) ||
        chr(13) || chr(10) || chr(13) || chr(10) ||
        'Note : This is a system generated message.'
        || chr(13) || chr(10)
        || 'Please do not reply to this message';

    c_leave_app_subject Constant Varchar2(1000) := 'Leave application of ' || c_empno || ' - ' || c_emp_name;

    pkg_var_msg Varchar2(1000);
    pkg_var_sub Varchar2(200);

    Procedure send_mail_2_user_nu(
        param_to_mail_id In Varchar2,
        param_subject    In Varchar2,
        param_body       In Varchar2
    );
    Procedure send_mail(param_to_mail_id  Varchar2,
                        param_subject     Varchar2,
                        param_body        Varchar2,
                        param_success Out Number,
                        param_message Out Varchar2);
    Procedure send_msg_new_leave_app(param_app_no      Varchar2,
                                     param_success Out Number,
                                     param_message Out Varchar2);
    Procedure send_test_email_2_user(param_to_mail_id In Varchar2);
    Procedure send_html_mail(param_to_mail_id  Varchar2,
                             param_subject     Varchar2,
                             param_body        Varchar2,
                             param_success Out Number,
                             param_message Out Varchar2);
    Procedure send_email_2_user_async(
        param_to_mail_id In Varchar2
    );

    c_leave_rejected_body Varchar2(4000) := '<p>You leave application has been rejected.<\/p>\r\n<p>Following are the details<\/p>\r\n<table style=\"border-collapse: collapse;\" border=\"1\">\r\n<tbody>\r\n<tr>\r\n<td>Application Id<\/td>\r\n<td><strong>@app_id<\/strong><\/td>\r\n<td><strong>_____<\/strong><\/td>\r\n<td>Date<\/td>\r\n<td><strong>@app_date<\/strong><\/td>\r\n<\/tr>\r\n<tr>\r\n<td>Leave Start Date<\/td>\r\n<td><strong>@start_date<\/strong><\/td>\r\n<td><\/td>\r\n<td>Leave end date<\/td>\r\n<td><strong>@end_date<\/strong><\/td>\r\n<\/tr>\r\n<tr>\r\n<td>Leave period<\/td>\r\n<td><strong>@leave_period<\/strong><\/td>\r\n<td><\/td>\r\n<td>Leave type<\/td>\r\n<td><strong>@leave_type<\/strong><\/td>\r\n<\/tr>\r\n<tr>\r\n<td>Lead approval<\/td>\r\n<td><strong>@lead_approval<\/strong><\/td>\r\n<td><\/td>\r\n<td>Lead remarks<\/td>\r\n<td><strong>@lead_remarks<\/strong><\/td>\r\n<\/tr>\r\n<tr>\r\n<td>HoD approval<\/td>\r\n<td><strong>@hod_approval<\/strong><\/td>\r\n<td><\/td>\r\n<td>HoD remarks<\/td>\r\n<td><strong>@hod_remarks<\/strong><\/td>\r\n<\/tr>\r\n<tr>\r\n<td>HR approval<\/td>\r\n<td><strong>@hrd_approval<\/strong><\/td>\r\n<td><\/td>\r\n<td>HR remarks<\/td>\r\n<td><strong>@hrd_remarks<\/strong><\/td>\r\n<\/tr>\r\n<\/tbody>\r\n<\/table>\r\n<p>Note - This is a system generated message.<\/p>\r\n<p>Please do not reply to this message<\/p>';
    Procedure send_mail_leave_rejected(
        p_app_id Varchar2
    );

    Procedure send_mail_leave_reject_async(
        p_app_id In Varchar2
    );

End ss_mail;
/
---------------------------
--Changed PACKAGE
--SWP_VACCINEDATE
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."SWP_VACCINEDATE" As

    Procedure add_new(
        param_win_uid      Varchar2,
        param_vaccine_type Varchar2,
        param_first_jab    Date,
        param_second_jab   Date,
        param_success Out  Varchar2,
        param_message Out  Varchar2
    );

    Procedure add_emp_vaccine_dates(
        param_win_uid         Varchar2,
        param_vaccine_type    Varchar2,
        param_for_empno       Varchar2,
        param_first_jab_date  Date,
        param_second_jab_date Date default null,
        param_success Out     Varchar2,
        param_message Out     Varchar2
    );

    Procedure update_second_jab(
        param_win_uid     Varchar2,
        param_second_jab  Date,
        param_success Out Varchar2,
        param_message Out Varchar2
    );

    Procedure delete_emp_vaccine_dates(
        param_empno       Varchar2,
        param_hr_win_uid  Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2
    );

    Procedure update_vaccine_type(
        param_win_uid      Varchar2,
        param_vaccine_type Varchar2,
        param_second_jab   Date,
        param_success Out  Varchar2,
        param_message Out  Varchar2
    );

    Procedure update_emp_second_jab(
        param_win_uid         Varchar2,
        param_for_empno       Varchar2,
        param_second_jab_date Date,
        param_success Out     Varchar2,
        param_message Out     Varchar2
    );

End swp_vaccinedate;
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
--New PACKAGE
--IOT_SWP_SMART_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_SMART_WORKSPACE_QRY" As

    c_qry_attendance_planning Varchar2(6000) := ' 
With
    params As (
        Select
            :p_person_id   As p_person_id,
            :p_meta_id     As p_meta_id,
            :p_row_number  As p_row_number,
            :p_page_length As p_page_length,
            
            :p_start_date  As p_start_date,
            :p_end_date    As p_end_date,
            :p_assign_code    As p_assign_code,
            :p_emptype_csv    As p_emptype_csv,
            :p_grades_csv     As p_grades_csv,
            :p_generic_search As p_generic_search,
            :p_desk_assignment_status as p_desk_assignment_status
        From
            dual
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
                    ss_emplmast                  ce, 
					params 
                Where
                    ce.assign  = params.p_assign_code
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
                        case when a.empno is null then 0 else 1 end planned,
                        to_char(a.attendance_date, ''yyyymmdd'') As d_days
                    From
                        ss_emplmast  e,
                        attend_plan  a,
                        
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
                        And e.assign = params.p_assign_code
                        And e.status = 1
                        And e.empno  = a.empno(+)                
                            !DESK_ASSIGNMENT_STATUS!
                            !GENERIC_SEARCH!            
                            And e.emptype In (
                            !EMPTYPE_SUBQUERY!
                    )
                            !GRADES_SUBQUERY!

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


    where_clause_generic_search Varchar2(200) := ' and (e.name like params.p_generic_search or e.empno like params.p_generic_search ) ';

    sub_qry_emptype_default Varchar2(200) := ' 
Select
    emptype
From
    swp_include_emptype
';

    sub_qry_emptype_csv Varchar2(400) := ' 
Select
    regexp_substr(params.p_emptype_csv, ''[^,]+'', 1, level) emptype
From
    dual
Connect By
    level <=
    length(params.p_emptype_csv) - length(replace(params.p_emptype_csv, '','')) + 1
';

    sub_qry_grades_csv Varchar2(400) := ' and e.grade in (
Select
    regexp_substr(params.p_grades_csv, ''[^,]+'', 1, level) grade
From
    dual
Connect By
    level <=
    length(params.p_grades_csv) - length(replace(params.p_grades_csv, '','')) + 1 )
';



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
        p_area_category Varchar2 Default Null,
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

        p_emptype_csv            Varchar2 Default Null,
        p_grade_csv              Varchar2 Default Null,
        p_generic_search         Varchar2 Default Null,
        p_desk_assignment_status Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

End iot_swp_smart_workspace_qry;
/
---------------------------
--Changed PACKAGE
--IOT_ONDUTY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_ONDUTY" As

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;

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
    );

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
    );

    Procedure sp_extend_depu(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,
        p_end_date         Date,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_delete_od_app_4_self(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_delete_od_app_force(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,

        p_empno            Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

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
    );

    Procedure sp_onduty_approval_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_onduty_approval_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_onduty_approval_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

End iot_onduty;
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
--New PACKAGE
--IOT_SWP_PRIMARY_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_PRIMARY_WORKSPACE_QRY" As

    Function fn_emp_primary_ws_list(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,

        p_assign_code           Varchar2 Default Null,
        p_start_date            Date     Default Null,

        p_empno                 Varchar2 Default Null,

        p_emptype_csv           Varchar2 Default Null,
        p_grade_csv             Varchar2 Default Null,
        p_primary_workspace_csv Varchar2 Default Null,
        p_laptop_user           Varchar2 Default Null,
        p_eligible_for_swp      Varchar2 Default Null,
        p_generic_search        Varchar2 Default Null,

        p_row_number            Number,
        p_page_length           Number
    ) Return Sys_Refcursor;

    --**--
    /*
    Function fn_emp_primary_ws_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_assign_code Varchar2 Default Null,
        p_start_date  Date     Default Null,

        p_empno       Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;
    */

    Function fn_emp_primary_ws_plan_list(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,

        p_assign_code           Varchar2 Default Null,

        p_empno                 Varchar2 Default Null,

        p_emptype_csv           Varchar2 Default Null,
        p_grade_csv             Varchar2 Default Null,
        p_primary_workspace_csv Varchar2 Default Null,
        p_laptop_user           Varchar2 Default Null,
        p_eligible_for_swp      Varchar2 Default Null,
        p_generic_search        Varchar2 Default Null,

        p_row_number            Number,
        p_page_length           Number
    ) Return Sys_Refcursor;

    Function fn_emp_pws_excel(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_assign_codes_csv Varchar2 Default Null,
        p_start_date       Date Default Null
    ) Return Sys_Refcursor;

    Function fn_emp_pws_plan_excel(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_assign_codes_csv Varchar2 Default Null
    ) Return Sys_Refcursor;

    query_pws Varchar2(4000) := '
With
    params As
    (
        Select
            :p_friday_date     As p_friday_date,
            :p_row_number      As p_row_number,
            :p_page_length     As p_page_length,
            :p_empno           As p_empno,
            :p_assign_code     As p_assign_code,
            :p_pws_csv         As p_pws_csv,
            :p_grades_csv      As p_grades_csv,
            :p_emptype_csv     As p_emptype_csv,
            :p_swp_eligibility As p_swp_eligibility,
            :p_laptop_user     As p_laptop_user,
            :p_generic_search  As p_generic_search
        From
            dual
    ),
    primary_work_space As(
        Select
            a.empno, a.primary_workspace, a.start_date
        From
            swp_primary_workspace a, params
        Where
            trunc(a.start_date) = (
                Select
                    Max(trunc(start_date))
                From
                    swp_primary_workspace b
                Where
                    b.empno = a.empno
                    And b.start_date <= params.p_friday_date
            )
    )
Select
    data.*
From
    (
        Select
            a.empno                                               As empno,
            a.name                                                As employee_name,
            a.assign,
            a.parent,
            a.office,
            a.emptype,
            iot_swp_common.get_emp_work_area(Null, Null, a.empno) As work_area,
            iot_swp_common.is_emp_laptop_user(a.empno)            As is_laptop_user,
            Case iot_swp_common.is_emp_laptop_user(a.empno)
                When 1 Then
                    ''Yes''
                Else
                    ''No''
            End                                                   As is_laptop_user_text,
            a.grade                                               As emp_grade,
            nvl(b.primary_workspace, 0)                           As primary_workspace,
            Row_Number() Over(Order By a.name)                    As row_number,
            Case iot_swp_common.is_emp_eligible_for_swp(a.empno)
                When ''OK'' Then
                    ''Yes''
                Else
                    ''No''
            End                                                   As is_eligible_desc,
            iot_swp_common.is_emp_eligible_for_swp(a.empno)       As is_eligible,
            Count(*) Over()                                       As total_row
        From
            ss_emplmast        a,
            primary_work_space b,
            swp_include_emptype c,
            params
        Where
            a.empno      = b.empno(+)
            And a.assign = nvl(params.p_assign_code, a.assign)
            And a.status = 1
            And a.empno  = nvl(params.p_empno, a.empno)
            And a.emptype = c.emptype

            And a.assign Not In (
                Select
                    assign
                From
                    swp_exclude_assign
            )
            !GENERIC_SEARCH!            
            And a.emptype In (
            !EMPTYPE_SUBQUERY!
            )
            !LAPTOP_USER_WHERE_CLAUSE!
            !SWP_ELIGIBLE_WHERE_CLAUSE!
            !GRADES_SUBQUERY!
            !PWS_TYPE_SUBQUERY!
        Order By a.name
    ) data, params
Where
    row_number Between (nvl(params.p_row_number, 0) + 1) And (nvl(params.p_row_number, 0) + params.p_page_length)
';

    sub_qry_grades_csv Varchar2(400) := ' and a.grade in (
Select
    regexp_substr(params.p_grades_csv, ''[^,]+'', 1, level) grade
From
    dual
Connect By
    level <=
    length(params.p_grades_csv) - length(replace(params.p_grades_csv, '','')) + 1 )
';

    sub_qry_emptype_default Varchar2(200) := ' 
Select
    emptype
From
    swp_include_emptype
';

    sub_qry_emptype_csv Varchar2(400) := ' 
Select
    regexp_substr(params.p_emptype_csv, ''[^,]+'', 1, level) emptype
From
    dual
Connect By
    level <=
    length(params.p_emptype_csv) - length(replace(params.p_emptype_csv, '','')) + 1
';
    sub_qry_pws_csv Varchar2(200) := ' 
and
nvl(b.primary_workspace,0) in ( params.p_pws_csv )
';

    where_clause_laptop_user Varchar2(200) := ' and iot_swp_common.is_emp_laptop_user(a.empno) = params.p_laptop_user ';

    where_clause_swp_eligible Varchar2(200) := ' and iot_swp_common.is_emp_eligible_for_swp(a.empno) = params.p_swp_eligibility ';

    where_clause_generic_search Varchar2(200) := ' and (a.name like params.p_generic_search or a.empno like params.p_generic_search ) ';

End iot_swp_primary_workspace_qry;
/
---------------------------
--New PACKAGE
--IOT_SWP_CONFIG_WEEK
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_CONFIG_WEEK" As

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;

    Procedure sp_cofiguration;

    Procedure sp_update_primary_workspace;

End iot_swp_config_week;
/
---------------------------
--New PACKAGE
--IOT_SWP_DMS
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_DMS" As

    Procedure sp_add_desk_user(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_deskid           Varchar2,
        p_parent           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_remove_desk_user(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_empno     Varchar2,
        p_deskid    Varchar2
    );

    Procedure sp_lock_desk(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_deskid    Varchar2
    );

    Procedure sp_unlock_desk(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_deskid      Varchar2,
        p_week_key_id Varchar2

    );

    Procedure sp_clear_desk(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_deskid    Varchar2
    );

End iot_swp_dms;
/
---------------------------
--New PACKAGE
--IOT_SWP_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_QRY" As
   /*

   With
       params As (
           Select
               :p_empno As p_empno, :p_row_number As p_row_number, :p_page_length As p_page_length,
               :p_start_date as p_start_date , :p_end_date as p_end_date
           From
               dual
       ),
       assign_codes As (
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
               empno = params.p_empno
       ),
       attend_plan As (
           Select
               empno, attendance_date, 
               to_char(attendance_date,'DY') || '_DESK' as day_desk,
               deskid
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
           select * from (
                   Select
                           e.empno                          As empno,
                           e.empno || ' - ' || e.name       As employee_name,
                           e.parent                         As parent,
                           e.grade                          As emp_grade,
                           Null                             As projno,
                           e.emptype                        As emptype,
                           e.assign                         As assign,
                           Null                             As pending,
                           a.attendance_date as attendance_date,
                           to_char(a.attendance_date, 'yyyymmdd') As d_days,
                           a.day_desk as day_desk,
                           a.deskid
                       From
                           ss_emplmast  e,
                           attend_plan  a,
                           assign_codes ac,
                           params
                       Where
                           e.empno In (
                               Select
                                   empno
                               From
                                   swp_primary_workspace w
                               Where
                                   w.primary_workspace = 2
                           )
                           And e.assign = ac.assign
                           And e.status = 1
                           And e.empno  = a.empno(+)
                       )
                       Pivot
                       (
                       Count(d_days) as atnd, Listagg( deskid,',') within group (order by attendance_date) dsk
                       For d_days In ('20211122' As mon, '20211123' As tue, '20211124'  As wed, '20211125' As thu,
                       '20211126' As fri)
                       )

   */
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

   c_qry_office_planning Varchar2(4000) := ' 
With
    params As (
        Select
            :p_empno As p_empno, :p_row_number As p_row_number, :p_page_length As p_page_length,
            :p_start_date as p_start_date , :p_end_date as p_end_date,:p_meta_id as p_meta_id,:p_person_id as p_person_id
        From
            dual
    ),
    assign_codes As (
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
            empno = params.p_empno
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
                        iot_swp_common.get_desk_from_dms(e.empno) As deskid,
                        Null                             As pending,
                        to_char(a.attendance_date, ''yyyymmdd'') As d_days
                    From
                        ss_emplmast  e,
                        attend_plan  a,
                        assign_codes ac,
                        params
                    Where
                        e.empno In (
                            Select
                                empno
                            From
                                swp_primary_workspace w
                            Where
                                w.primary_workspace = 1
                        )
                        And e.assign = ac.assign
                        And e.status = 1
                        And e.empno  = a.empno(+)                

                    )
            ) data
    ) full_data, params
Where
    row_number Between (nvl(params.p_row_number, 0) + 1) And (nvl(params.p_row_number, 0) + params.p_page_length)';

   Function fn_emp_primary_workspace_list(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_assign_code Varchar2 Default Null,
      p_empno       Varchar2 Default Null,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

   Function fn_week_attend_planning(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_date        Date     Default sysdate,
      p_assign_code Varchar2 Default Null,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

   Function fn_emp_week_attend_planning(
      p_person_id Varchar2,
      p_meta_id   Varchar2,
      p_empno     Varchar2,
      p_date      Date
   ) Return Sys_Refcursor;

   Function fn_office_planning(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_date        Date,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

   Function fn_work_area_for_smartwork(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_date        Date,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

   Function fn_work_area_for_officework(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,

      p_date        Date,

      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

   Function fn_work_area_desk(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,

      p_date        Date,
      p_work_area   Varchar2,
      p_wing        Varchar2 Default null,

      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

   Function get_monday_date(p_date Date) Return Date;
   Function get_friday_date(p_date Date) Return Date;
   Function get_area_total_desk(p_area_key_id Varchar2) Return Number;
   Function get_area_occupied_desk(p_area_key_id Varchar2) Return Number;

   Cursor cur_area_list_for_ok(p_date        Date ,
                               p_office      Varchar2,
                               p_floor       Varchar2,
                               p_wing        Varchar2,
                               p_row_number  Number,
                               p_page_length Number) Is

      Select *
        From (
                Select Distinct a.OFFICE,
                       a.FLOOR,
                       a.WING,
                       a.WORK_AREA,
                       a.AREA_DESC,
                       a.AREA_CATG_CODE,
                       a.TOTAL,
                       a.OCCUPIED,
                       a.AVAILABLE,
                       Row_Number() Over (Order By office Desc) As row_number,
                       Count(*) Over () As total_row
                  From SWP_VU_AREA_LIST a
                 Where a.AREA_CATG_CODE = 'A001'
                 Order By a.area_desc, a.office, a.floor
                 /*

                 Select Distinct
                      mast.office office,
                      mast.floor floor,
                      mast.wing wing,
                      mast.work_area work_area,
                      area.area_desc area_desc,
                      area.AREA_CATG_CODE AREA_CATG_CODE,
                      selfservice.iot_swp_common.get_total_desk(mast.work_area, Trim(mast.office), mast.floor, mast.wing) As total,
                      selfservice.iot_swp_common.get_occupied_desk(mast.work_area, Trim(mast.office), mast.floor, mast.wing, p_date) As occupied,
                      (selfservice.iot_swp_common.get_total_desk(mast.work_area, Trim(mast.office), mast.floor, mast.wing) - selfservice.
                      iot_swp_common
                      .get_occupied_desk(mast.work_area, Trim(mast.office), mast.floor, mast.wing, p_date)) As available,
                      0 row_number,
                      0 total_row
                 From dms.dm_deskmaster mast,
                      dms.dm_desk_areas area
                Where area.area_key_id = mast.work_area
                     and area.AREA_CATG_CODE = 'OK'
                 Order By area.area_desc, mast.office, mast.floor
                 */

             )
       Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

   Cursor cur_area_list_for_ko(p_office      Varchar2,
                               p_floor       Varchar2,
                               p_wing        Varchar2,
                               p_row_number  Number,
                               p_page_length Number) Is

      Select *
        From (
                Select Distinct a.OFFICE,
                       a.FLOOR,
                       a.WING,
                       a.WORK_AREA,
                       a.AREA_DESC,
                       a.AREA_CATG_CODE,
                       a.TOTAL,
                       a.OCCUPIED,
                       a.AVAILABLE,
                       Row_Number() Over (Order By office Desc) As row_number,
                       Count(*) Over () As total_row
                        From SWP_VU_AREA_LIST a
                 Where a.AREA_CATG_CODE = 'A002'
                 Order By a.area_desc, a.office, a.floor                 
               /*
                From SWP_VU_AREA_LIST a
                 Where a.AREA_CATG_CODE = 'KO'
                   And Trim(a.office) = Trim(p_office)
                   And Trim(a.floor) = Trim(p_floor)
                 Order By a.area_desc, a.office, a.floor
               */  
             )
       Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

   Type typ_area_list Is Table Of cur_area_list_for_ko%rowtype;

   Function fn_area_list_for_smartwork(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_date        Date Default Null,

      p_row_number  Number,
      p_page_length Number
   ) Return typ_area_list
      Pipelined;

 Function fn_reserved_area_list(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_date        Date Default Null,

      p_row_number  Number,
      p_page_length Number
   ) Return typ_area_list
      Pipelined;

 Function fn_general_area_list(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_date        Date Default Null,

      p_row_number  Number,
      p_page_length Number
   ) Return typ_area_list
      Pipelined;	  

End iot_swp_qry;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_PRIMARY_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_PRIMARY_WORKSPACE" As

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;
    c_office_workspace constant number := 1;
    c_smart_workspace constant number := 2;
    c_not_in_mum_office constant number := 3;


    Procedure sp_add_office_ws_desk(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_deskid           Varchar2,
        p_empno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_assign_work_space(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_emp_workspace_array typ_tab_string,
        p_message_type Out    Varchar2,
        p_message_text Out    Varchar2
    );

    Procedure sp_workspace_summary(
        p_person_id                      Varchar2,
        p_meta_id                        Varchar2,

        p_assign_code                    Varchar2 Default Null,
        p_start_date                     Date     Default Null,

        p_total_emp_count            Out Number,
        p_emp_count_office_workspace Out Number,
        p_emp_count_smart_workspace  Out Number,
        p_emp_count_not_in_ho        Out Number,

        p_emp_perc_office_workspace        Out Number,
        p_emp_perc_smart_workspace        Out Number,

        p_message_type               Out Varchar2,
        p_message_text               Out Varchar2
    );

    Procedure sp_workspace_plan_summary(
        p_person_id                      Varchar2,
        p_meta_id                        Varchar2,

        p_assign_code                    Varchar2 default null,

        p_total_emp_count            Out Number,
        p_emp_count_office_workspace Out Number,
        p_emp_count_smart_workspace  Out Number,
        p_emp_count_not_in_ho        Out Number,

        p_emp_perc_office_workspace       Out Number,
        p_emp_perc_smart_workspace        Out Number,

        p_message_type               Out Varchar2,
        p_message_text               Out Varchar2
    );



End iot_swp_primary_workspace;
/
---------------------------
--New PACKAGE BODY
--IOT_SWP_SMART_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_SMART_WORKSPACE_QRY" As

    c_reserved_catagory    Varchar2(4)          := 'A001';
    c_restricted_area_catg Constant Varchar2(4) := 'A003';
    c_deskblock_4_swpf     Constant Number(1)   := 6;
    c_deskblock_4_swpv     Constant Number(1)   := 7;
    c_deskblock_not_swpf   Constant Number(1)   := -1;
    Function fn_reserved_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        v_area_catg_code     Constant Varchar2(4) := 'A001';
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
                        DM_VU_EMP_DESK_MAP_SWP_PLAN
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
                                da.area_catg_code area_category,
                                da.area_desc,
                                dl.work_area,
                                dl.office,
                                dl.floor,
                                dl.wing,
                                Count(dl.deskid)  total_count,
                                Count(ap.deskid)  occupied_count
                            From
                                dm_vu_desk_list  dl,
                                dm_vu_desk_areas da,
                                plan             ap
                            Where
                                da.area_key_id        = dl.work_area
                                And da.area_catg_code = c_reserved_catagory
                                And dl.deskid         = ap.deskid(+)
                            Group By da.area_catg_code,
                                da.area_desc,
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
        c                    Sys_Refcursor;
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_emp_area_code      Varchar2(3);
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
                                dm_vu_desk_lock_swp_plan
                            Where
                                blockreason <> c_deskblock_4_swpv

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
                                d.area_catg_code area_category,
                                d.area_desc,
                                d.office,
                                d.floor,
                                d.wing,
                                Count(d.deskid)  total_count,
                                Count(ed.empno)  occupied_count
                            From
                                desk_list          d,
                                DM_VU_EMP_DESK_MAP_SWP_PLAN ed
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
        p_person_id     Varchar2,
        p_meta_id       Varchar2,

        p_date          Date,
        p_work_area     Varchar2,
        p_area_category Varchar2 Default Null,
        p_office        Varchar2 Default Null,
        p_floor         Varchar2 Default Null,
        p_wing          Varchar2 Default Null,

        p_row_number    Number,
        p_page_length   Number
    ) Return Sys_Refcursor As
        c                        Sys_Refcursor;
        v_empno                  Varchar2(5);
        e_employee_not_found     Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_office                 Varchar2(5);
        v_floor                  dm_vu_desk_list.floor%Type;
        v_wing                   dm_vu_desk_list.wing%Type;
        v_exclude_deskblock_type Number(1);

    Begin
        If p_area_category = c_reserved_catagory Then
            v_exclude_deskblock_type := c_deskblock_4_swpf;
        Else
            v_exclude_deskblock_type := c_deskblock_4_swpv;
        End If;

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
                        da.area_catg_code                   As area_category,
                        Row_Number() Over (Order By deskid) row_number,
                        Count(*) Over ()                    total_row
                    From
                        dm_vu_desk_list  mast,
                        dm_vu_desk_areas da
                    Where
                        mast.work_area     = da.area_key_id
                        And mast.work_area = Trim(p_work_area)

                        And Trim(mast.office) Like v_office
                        And Trim(mast.floor) Like v_floor
                        And nvl(Trim(mast.wing), '-') Like v_wing

                        And mast.deskid
                        Not In(
                            Select
                                swptbl.deskid
                            From
                                swp_smart_attendance_plan swptbl
                            Where
                                (attendance_date) = (p_date)
                            Union
                            Select
                                c.deskid
                            From
                                DM_VU_EMP_DESK_MAP_SWP_PLAN c
                            Union
                            Select
                                deskid
                            From
                                dms.dm_desklock_swp_plan dl
                            Where
                                dl.blockreason <> v_exclude_deskblock_type
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

        p_emptype_csv            Varchar2 Default Null,
        p_grade_csv              Varchar2 Default Null,
        p_generic_search         Varchar2 Default Null,
        p_desk_assignment_status Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hod_sec_empno       Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_query               Varchar2(7000);
        v_start_date         Date := iot_swp_common.get_monday_date(p_date) - 1;
        v_end_date           Date := iot_swp_common.get_friday_date(p_date);
        v_hod_sec_assign_code Varchar2(4);
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
        v_hod_sec_empno       := get_empno_from_meta_id(p_meta_id);
        If v_hod_sec_empno = 'ERRRR' Then
            Raise e_employee_not_found;
        End If;

        v_hod_sec_assign_code := iot_swp_common.get_default_costcode_hod_sec(
                                     p_hod_sec_empno => v_hod_sec_empno,
                                     p_assign_code   => p_assign_code
                                 );

        If p_grade_csv Is Not Null Then
            v_query := replace(v_query, '!GRADES_SUBQUERY!', sub_qry_grades_csv);
        Else
            v_query := replace(v_query, '!GRADES_SUBQUERY!', '');
        End If;

        If p_emptype_csv Is Not Null Then
            v_query := replace(v_query, '!EMPTYPE_SUBQUERY!', sub_qry_emptype_csv);
        Else
            v_query := replace(v_query, '!EMPTYPE_SUBQUERY!', sub_qry_emptype_default);
        End If;

        If Trim(p_generic_search) Is Not Null Then
            v_query := replace(v_query, '!GENERIC_SEARCH!', where_clause_generic_search);
        Else
            v_query := replace(v_query, '!GENERIC_SEARCH!', '');
        End If;

        If p_desk_assignment_status = 'Pending' Then
            v_query := replace(v_query, '!DESK_ASSIGNMENT_STATUS!', ' and a.empno is null ');
        Elsif p_desk_assignment_status = 'Assigned' Then
            v_query := replace(v_query, '!DESK_ASSIGNMENT_STATUS!', ' and a.empno is not null ');
        Else
            v_query := replace(v_query, '!DESK_ASSIGNMENT_STATUS!', '');
        End If;

        /*
                Insert Into swp_mail_log (subject, mail_sent_to_cc_bcc, modified_on)
                Values (v_empno || '-' || p_row_number || '-' || p_page_length || '-' || to_char(v_start_date, 'yyyymmdd') || '-' ||
                    to_char(v_end_date, 'yyyymmdd'),
                    v_query, sysdate);
                Commit;
                */
        Open c For v_query Using
            p_person_id,
            p_meta_id,
            p_row_number,
            p_page_length,

            v_start_date,
            v_end_date,

            v_hod_sec_assign_code,
            p_emptype_csv,
            p_grade_csv,
            '%' || upper(trim(p_generic_search)) || '%',
            p_desk_assignment_status;

        Return c;

    End;

End iot_swp_smart_workspace_qry;
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
        commit;
        sp_delete_leave_app(
            p_person_id              => p_person_id,
            p_meta_id                => p_meta_id,

            p_application_id         => Trim(p_application_id),

            p_medical_cert_file_name => v_medical_cert_file,
            p_message_type           => v_msg_type,
            p_message_text           => v_msg_text
        );

        ss_mail.send_mail_leave_reject_async(
            p_app_id => p_application_id
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
            Trim(app_no) = Trim(p_application_id);
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
            commit;
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
--SS_MAIL
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."SS_MAIL" As

    Procedure set_msg(param_obj_id     Varchar2,
                      param_apprl_desc Varchar2,
                      param_obj_name   Varchar2) As
    Begin
        --Discard
        --pkg_var_sub := replace(c_subject,'null' || chr(38) || '',c_obj_nm_tr);
        --pkg_var_msg := replace(c_message,'null' || chr(38) || '',c_obj_nm_tr);

        pkg_var_sub := replace(pkg_var_sub, 'null' || chr(38) || '', param_apprl_desc);
        pkg_var_msg := replace(pkg_var_msg, 'null' || chr(38) || '', param_apprl_desc);

        --pkg_var_msg := replace(pkg_var_msg,'null' || chr(38) || '',param_tr_id);
        --pkg_var_sub := replace(pkg_var_sub,'null' || chr(38) || '',param_tr_id);
    End;

    Procedure set_new_leave_app_subject(param_empno    In Varchar2,
                                        param_emp_name In Varchar2) As
    Begin
        pkg_var_sub := replace(c_leave_app_subject, c_empno, param_empno);
        pkg_var_sub := replace(pkg_var_sub, c_emp_name, param_emp_name);
    End;

    Procedure set_new_leave_app_body(
        param_empno        Varchar2,
        param_emp_name     Varchar2,
        param_leave_period Number,
        param_app_no       Varchar2,
        param_mail_to_hod  Varchar2
    )
    As
        v_leave_period Number;
        v_approval_url Varchar2(200);
    Begin
        If param_mail_to_hod = 'OK' Then
            v_approval_url := 'http://tplapps02.ticb.comp/TCMPLApp/SelfService/Attendance/HoDApprovalLeaveIndex';
        Else
            v_approval_url := 'http://tplapps02.ticb.comp/TCMPLApp/SelfService/Attendance/LeadApprovalLeaveIndex';
        End If;
        v_leave_period := param_leave_period / 8;
        pkg_var_msg    := replace(c_leave_app_msg, '');
        pkg_var_msg    := replace(pkg_var_msg, c_app_no, param_app_no);
        pkg_var_msg    := replace(pkg_var_msg, c_approval_url, v_approval_url);
        pkg_var_msg    := replace(pkg_var_msg, c_emp_name, param_emp_name);
        pkg_var_msg    := replace(pkg_var_msg, c_empno, param_empno);
        pkg_var_msg    := replace(pkg_var_msg, c_leave_period, param_leave_period);
    End;

    Procedure send_email_2_user_async(
        param_to_mail_id In Varchar2
    )
    As
    Begin
        dbms_scheduler.create_job(
            job_name            => 'SEND_MAIL_JOB_4_SELFSERVICE',
            job_type            => 'STORED_PROCEDURE',
            job_action          => 'ss_mail.send_mail_2_user_nu',
            number_of_arguments => 3,
            enabled             => false,
            job_class           => 'TCMPL_JOB_CLASS',
            comments            => 'to send Email'
        );

        dbms_scheduler.set_job_argument_value(
            job_name          => 'SEND_MAIL_JOB_4_SELFSERVICE',
            argument_position => 1,
            argument_value    => param_to_mail_id
        );
        dbms_scheduler.set_job_argument_value(
            job_name          => 'SEND_MAIL_JOB_4_SELFSERVICE',
            argument_position => 2,
            argument_value    => pkg_var_sub
        );
        dbms_scheduler.set_job_argument_value(
            job_name          => 'SEND_MAIL_JOB_4_SELFSERVICE',
            argument_position => 3,
            argument_value    => pkg_var_msg
        );
        dbms_scheduler.enable('SEND_MAIL_JOB_4_SELFSERVICE');
    End;

    Procedure send_email_2_user(
        param_to_mail_id In Varchar2
    ) As
        l_mail_conn utl_smtp.connection;
        l_boundary  Varchar2(50) := '----=*#abc1234321cba#*=';
    Begin

        If Trim(param_to_mail_id) Is Null Then
            Return;
        End If;

        l_mail_conn := utl_smtp.open_connection(c_smtp_mail_server, 25);
        utl_smtp.helo(l_mail_conn, c_smtp_mail_server);
        utl_smtp.mail(l_mail_conn, c_sender_mail_id);
        utl_smtp.rcpt(l_mail_conn, param_to_mail_id);
        utl_smtp.open_data(l_mail_conn);
        utl_smtp.write_data(l_mail_conn, 'Date: ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'To: ' || param_to_mail_id || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'From: ' || c_sender_mail_id || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Subject: ' || pkg_var_sub || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, 'MIME-Version: 1.0' || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Content-Type: multipart/alternative; boundary="' || l_boundary || '"' || utl_tcp.
        crlf ||
            utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, '--' || l_boundary || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Content-Type: text/plain; charset="iso-8859-1"' || utl_tcp.crlf || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, pkg_var_msg);
        utl_smtp.write_data(l_mail_conn, utl_tcp.crlf || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, '--' || l_boundary || '--' || utl_tcp.crlf);
        utl_smtp.close_data(l_mail_conn);

        utl_smtp.quit(l_mail_conn);

    End send_email_2_user;

    Procedure send_msg As
    Begin
        /* TODO implementation required */
        Null;
    End send_msg;

    Procedure send_msg_new_leave_app(param_app_no      Varchar2,
                                     param_success Out Number,
                                     param_message Out Varchar2) As
        v_empno        Varchar2(5);
        v_mngr         Varchar2(5);
        v_mngr_email   Varchar2(60);
        v_lead_empno   Varchar2(5);
        v_emp_name     Varchar2(60);
        v_leave_period Number;
        v_mail_to_hod  Varchar2(2) := 'OK';
    Begin
        Select
            empno, leaveperiod / 8, lead_apprl_empno
        Into
            v_empno, v_leave_period, v_lead_empno
        From
            ss_leaveapp
        Where
            app_no = param_app_no;

        Select
            name, mngr
        Into
            v_emp_name, v_mngr
        From
            ss_emplmast
        Where
            empno = v_empno;
        If v_lead_empno <> 'None' Then
            v_mngr        := v_lead_empno;
            v_mail_to_hod := 'KO';
            --v_mngr := '02320';
        End If;

        Select
            email
        Into
            v_mngr_email
        From
            ss_emplmast
        Where
            empno = v_mngr;

        set_new_leave_app_subject(v_empno, v_emp_name);

        set_new_leave_app_body(
            param_empno        => v_empno,
            param_emp_name     => v_emp_name,
            param_leave_period => v_leave_period,
            param_app_no       => param_app_no,
            param_mail_to_hod  => v_mail_to_hod
        );

        --send_email_2_user(v_mngr_email);
        send_email_2_user_async(v_mngr_email);
    Exception
        When Others Then
            param_success := ss.failure;
            param_message := 'Error : ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure send_mail(param_to_mail_id  Varchar2,
                        param_subject     Varchar2,
                        param_body        Varchar2,
                        param_success Out Number,
                        param_message Out Varchar2) As

        l_mail_conn utl_smtp.connection;
        l_boundary  Varchar2(50) := '----=*#abc1234321cba#*=';
    Begin

        l_mail_conn   := utl_smtp.open_connection(c_smtp_mail_server, 25);
        utl_smtp.helo(l_mail_conn, c_smtp_mail_server);
        utl_smtp.mail(l_mail_conn, c_sender_mail_id);
        utl_smtp.rcpt(l_mail_conn, param_to_mail_id);
        utl_smtp.open_data(l_mail_conn);
        utl_smtp.write_data(l_mail_conn, 'Date: ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'To: ' || param_to_mail_id || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'From: ' || c_sender_mail_id || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Subject: ' || param_subject || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, 'MIME-Version: 1.0' || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Content-Type: multipart/alternative; boundary="' || l_boundary || '"' || utl_tcp.
        crlf ||
            utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, '--' || l_boundary || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Content-Type: text/plain; charset="iso-8859-1"' || utl_tcp.crlf || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, replace(param_body, '!nuLine!', utl_tcp.crlf));
        utl_smtp.write_data(l_mail_conn, utl_tcp.crlf || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, '--' || l_boundary || '--' || utl_tcp.crlf);
        utl_smtp.close_data(l_mail_conn);

        utl_smtp.quit(l_mail_conn);
        param_success := ss.success;
        param_message := 'Email was successfully sent.';
        /*exception
            when others then
                param_success := ss.failure;
                param_message := 'Error : ' || sqlcode || ' - ' || sqlerrm;*/
    End;

    Procedure send_test_email_2_user(
        param_to_mail_id In Varchar2
    ) As
        l_mail_conn utl_smtp.connection;
        l_boundary  Varchar2(50) := '----=*#abc1234321cba#*=';
    Begin

        If Trim(param_to_mail_id) Is Null Then
            Return;
        End If;

        l_mail_conn := utl_smtp.open_connection(c_smtp_mail_server, 25);
        utl_smtp.helo(l_mail_conn, c_smtp_mail_server);
        utl_smtp.mail(l_mail_conn, c_sender_mail_id);
        utl_smtp.rcpt(l_mail_conn, param_to_mail_id);
        utl_smtp.open_data(l_mail_conn);
        utl_smtp.write_data(l_mail_conn, 'Date: ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'To: ' || param_to_mail_id || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'From: ' || c_sender_mail_id || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Subject: ' || 'Test by Deven' || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, 'MIME-Version: 1.0' || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Content-Type: multipart/alternative; boundary="' || l_boundary || '"' || utl_tcp.
        crlf ||
            utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, '--' || l_boundary || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Content-Type: text/plain; charset="iso-8859-1"' || utl_tcp.crlf || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, 'Test By Deven');
        utl_smtp.write_data(l_mail_conn, utl_tcp.crlf || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, '--' || l_boundary || '--' || utl_tcp.crlf);
        utl_smtp.close_data(l_mail_conn);

        utl_smtp.quit(l_mail_conn);

    End send_test_email_2_user;

    Procedure send_html_mail(param_to_mail_id  Varchar2,
                             param_subject     Varchar2,
                             param_body        Varchar2,
                             param_success Out Number,
                             param_message Out Varchar2) As

        l_mail_conn utl_smtp.connection;
        l_boundary  Varchar2(50) := '----=*#abc1234321cba#*=';
    Begin

        l_mail_conn   := utl_smtp.open_connection(c_smtp_mail_server, 25);
        utl_smtp.helo(l_mail_conn, c_smtp_mail_server);
        utl_smtp.mail(l_mail_conn, c_sender_mail_id);
        utl_smtp.rcpt(l_mail_conn, param_to_mail_id);
        utl_smtp.open_data(l_mail_conn);
        utl_smtp.write_data(l_mail_conn, 'Date: ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'To: ' || param_to_mail_id || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'From: ' || c_sender_mail_id || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Subject: ' || param_subject || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, 'MIME-Version: 1.0' || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Content-Type: multipart/alternative; boundary="' || l_boundary || '"' || utl_tcp.
        crlf ||
            utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, '--' || l_boundary || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Content-Type: text/html; charset="iso-8859-1"' || utl_tcp.crlf || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, replace(param_body, '!nuLine!', utl_tcp.crlf));
        utl_smtp.write_data(l_mail_conn, utl_tcp.crlf || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, '--' || l_boundary || '--' || utl_tcp.crlf);
        utl_smtp.close_data(l_mail_conn);

        utl_smtp.quit(l_mail_conn);
        param_success := ss.success;
        param_message := 'Email was successfully sent.';
    Exception
        When Others Then
            param_success := ss.failure;
            param_message := 'Error : ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure send_mail_2_user_nu(
        param_to_mail_id In Varchar2,
        param_subject    In Varchar2,
        param_body       In Varchar2
    ) As
    Begin
        utl_mail.send(
            sender     => c_sender_mail_id,
            recipients => param_to_mail_id,
            subject    => param_subject,
            message    => param_body,
            mime_type  => 'text; charset=us-ascii'
        );
    End;

    Procedure send_mail_leave_reject_async(
        p_app_id In Varchar2
    )    As
        v_key_id   Varchar2(8);
        v_job_name Varchar2(30);
    Begin

        v_key_id   := dbms_random.string('X', 8);
        v_job_name := 'MAIL_JOB_4_SS_' || v_key_id;
        dbms_scheduler.create_job(
            job_name            => v_job_name,
            job_type            => 'STORED_PROCEDURE',
            job_action          => 'ss_mail.send_mail_leave_rejected',
            number_of_arguments => 1,
            enabled             => false,
            job_class           => 'TCMPL_JOB_CLASS',
            comments            => 'to send Email'
        );

        dbms_scheduler.set_job_argument_value(
            job_name          => v_job_name,
            argument_position => 1,
            argument_value    => p_app_id
        );
        dbms_scheduler.enable(v_job_name);
    End;

    Procedure send_mail_leave_rejected(
        p_app_id Varchar2
    ) As
        rec_rejected_leave ss_leaveapp_rejected%rowtype;
        v_emp_email        ss_emplmast.email%Type;
        v_mail_body        Varchar2(4000);
        v_mail_subject     Varchar2(400);
        v_success          Varchar2(10);
        v_message          Varchar2(1000);
        e                  Exception;

        Pragma exception_init(e, -20100);
    Begin

        Select
            *
        Into
            rec_rejected_leave
        From
            ss_leaveapp_rejected
        Where
            Trim(app_no) = Trim(p_app_id);
        Select
            email
        Into
            v_emp_email
        From
            ss_emplmast
        Where
            empno      = rec_rejected_leave.empno
            And status = 1;
        If Trim(v_emp_email) Is Null Then
            raise_application_error(-20100, 'Employee email address not found. Mail not sent.');
        End If;
        v_mail_body    := c_leave_rejected_body;
        v_mail_subject := 'Leave application rejected';

        v_mail_body    := replace(v_mail_body, '@app_id', p_app_id);
        v_mail_body    := replace(v_mail_body, '@app_date', to_char(rec_rejected_leave.app_date, 'dd-Mon-yyyy'));
        v_mail_body    := replace(v_mail_body, '@start_date', to_char(rec_rejected_leave.bdate, 'dd-Mon-yyyy'));
        v_mail_body    := replace(v_mail_body, '@end_date', to_char(nvl(rec_rejected_leave.edate, rec_rejected_leave.bdate),
                                                                    'dd-Mon-yyyy'));
        v_mail_body    := replace(v_mail_body, '@leave_period', rec_rejected_leave.leaveperiod / 8);
        v_mail_body    := replace(v_mail_body, '@leave_type', rec_rejected_leave.leavetype);
        v_mail_body    := replace(v_mail_body, '@lead_approval', ss.approval_text(rec_rejected_leave.lead_apprl));
        v_mail_body    := replace(v_mail_body, '@lead_remarks', rec_rejected_leave.lead_reason);
        v_mail_body    := replace(v_mail_body, '@hod_approval', ss.approval_text(rec_rejected_leave.hod_apprl));
        v_mail_body    := replace(v_mail_body, '@hod_remarks', rec_rejected_leave.hodreason);
        v_mail_body    := replace(v_mail_body, '@hrd_approval', ss.approval_text(rec_rejected_leave.hrd_apprl));
        v_mail_body    := replace(v_mail_body, '@hrd_remarks', rec_rejected_leave.hrdreason);

        send_mail_from_api(
            p_mail_to      => v_emp_email,
            p_mail_cc      => Null,
            p_mail_bcc     => Null,
            p_mail_subject => v_mail_subject,
            p_mail_body    => v_mail_body,
            p_mail_profile => Null,
            p_mail_format  => 'HTML',
            p_success      => v_success,
            p_message      => v_message
        );
    End send_mail_leave_rejected;

End ss_mail;
/
---------------------------
--Changed PACKAGE BODY
--IOT_GUEST_MEET_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_GUEST_MEET_QRY" As

    Function get_guest_attendance(
        p_empno       Varchar2,
        p_start_date  Date Default null,
        p_end_date    Date Default null,
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
                        to_char(ss_guest_register.modified_on, 'dd-Mon-yyyy') As applied_on,
                        ss_guest_register.app_no                              As app_no,
                        to_char(ss_guest_register.meet_date, 'dd-Mon-yyyy')   As meeting_date,
                        to_char(ss_guest_register.meet_date, 'hh:mi AM')      As meeting_time,
                        ss_guest_register.host_name                           As host_name,
                        ss_guest_register.guest_name                          As guest_name,
                        ss_guest_register.guest_co                            As guest_company,
                        ss_guest_register.meet_off                            As meeting_place,
                        ss_guest_register.remarks                             As remarks,
                        Case
                            When trunc(ss_guest_register.meet_date) > trunc(sysdate) Then
                                1
                            Else
                                0
                        End                                                   delete_allowed,
                        Row_Number() Over (Order By ss_guest_register.modified_on Desc) row_number,
                        Count(*) Over ()                             total_row
                    From
                        ss_guest_register
                    Where                           
                        ss_guest_register.modified_by = p_empno 
                         And trunc(ss_guest_register.meet_date) >= nvl(p_start_date, trunc(sysdate))
                        And trunc(ss_guest_register.meet_date) <= nvl(p_end_date, trunc(ss_guest_register.meet_date))                             
                    Order By ss_guest_register.meet_date, ss_guest_register.modified_on
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End;

    Function fn_guest_attendance(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date Default null,
        p_end_date    Date Default null,
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
        c       := get_guest_attendance(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
    End fn_guest_attendance;

End iot_guest_meet_qry;
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
--New PACKAGE BODY
--IOT_SWP_SMART_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_SMART_WORKSPACE" As
    Procedure del_emp_sws_atend_plan(
        p_empno Varchar2,
        p_date  Date
    )
    As
        rec_smart_attendance_plan swp_smart_attendance_plan%rowtype;
        v_plan_start_date         Date;
        v_plan_end_date           Date;
        v_planning_exists         Varchar2(2);
        v_planning_open           Varchar2(2);
        v_message_type            Varchar2(10);
        v_message_text            Varchar2(1000);

        v_general_area            Varchar2(4) := 'A002';
        v_count                   Number;
        rec_config_week           swp_config_weeks%rowtype;
    Begin
        Begin
            Select
                *
            Into
                rec_smart_attendance_plan
            From
                swp_smart_attendance_plan
            Where
                empno               = p_empno
                And attendance_date = p_date;
        Exception
            When no_data_found Then
                Return;
        End;
        --Delete from Planning table

        Delete
            From swp_smart_attendance_plan
        Where
            key_id = rec_smart_attendance_plan.key_id;

        --Check if the desk is General desk.

        If Not iot_swp_common.is_desk_in_general_area(rec_smart_attendance_plan.deskid) Then
            Return;
        End If;
        --

        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_open = 1;

        iot_swp_dms.sp_unlock_desk(
            p_person_id   => Null,
            p_meta_id     => Null,

            p_deskid      => rec_smart_attendance_plan.deskid,
            p_week_key_id => rec_config_week.key_id
        );

    End;

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
        rec_config_week   swp_config_weeks%rowtype;
    Begin

        v_mod_by_empno := get_empno_from_meta_id(p_meta_id);

        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_open = 1;
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
                Trim(regexp_substr(str, '[^~!~]+', 1, 4))          status
            Into
                v_empno, v_attendance_date, v_desk, v_status
            From
                csv;

            If v_status = 0 Then
                del_emp_sws_atend_plan(
                    p_empno => v_empno,
                    p_date  => trunc(v_attendance_date)
                );
            End If;

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
                    modified_by,
                    week_key_id
                )
                Values
                (
                    v_pk,
                    v_fk,
                    v_empno,
                    v_attendance_date,
                    v_desk,
                    sysdate,
                    v_mod_by_empno,
                    rec_config_week.key_id
                );
                If iot_swp_common.is_desk_in_general_area(v_desk) Then

                    iot_swp_dms.sp_clear_desk(
                        p_person_id => Null,
                        p_meta_id   => p_meta_id,

                        p_deskid    => v_desk

                    );

                    iot_swp_dms.sp_lock_desk(
                        p_person_id => Null,
                        p_meta_id   => Null,

                        p_deskid    => v_desk
                    );
                End If;
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
        v_start_date   := iot_swp_common.get_monday_date(p_date);
        v_end_date     := iot_swp_common.get_friday_date(p_date);
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

        --Total Count
        Select
            --e.empno, emptype, status, aw.primary_workspace
            Count(*)
        Into
            p_emp_count_smart_workspace
        From
            ss_emplmast           e,
            swp_primary_workspace aw

        Where
            e.assign                 = p_assign_code
            And e.empno              = aw.empno
            And status               = 1
            And emptype In (
                Select
                    emptype
                From
                    swp_include_emptype
            )
            And aw.primary_workspace = 2
            And
            trunc(aw.start_date)     = (
                    Select
                        Max(trunc(start_date))
                    From
                        swp_primary_workspace b
                    Where
                        b.empno = aw.empno
                        And b.start_date <= v_end_date
                );

        /*

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
        */
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

End iot_swp_smart_workspace;
/
---------------------------
--Changed PACKAGE BODY
--LEAVE_ADJ
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."LEAVE_ADJ" As

    Procedure debit_leave(
        p_empno        Varchar2,
        p_pdate        Date,
        p_adj_type     Varchar2,
        p_leavetype    Varchar2,
        p_leave_period Number
    ) As
        v_success Varchar2(10);
        v_message Varchar2(1000);
        v_desc    Varchar2(30);
    Begin
        Select
            description
        Into
            v_desc
        From
            ss_leave_adj_mast
        Where
            adj_type = p_adj_type
            And dc   = 'D';

        leave.add_leave_adj(
            param_empno      => p_empno,
            param_adj_date   => p_pdate,
            param_adj_type   => p_adj_type || 'D',
            param_leave_type => p_leavetype,
            param_adj_period => p_leave_period,
            param_entry_by   => 'SYS',
            param_desc       => v_desc,
            param_success    => v_success,
            param_message    => v_message
        );

    End;

    Procedure adjust_leave_202012(
        p_empno       Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As

        Cursor cur_emplist(
            cp_empno Varchar2
        ) Is
            Select
                empno
            From
                ss_emplmast
            Where
                status = 1
                And emptype In (
                    'R', 'F'
                )
                And empno Like cp_empno;

        v_max_leave_bal_limit ss_leave_bal_max_limit.max_leave_bal%Type;
        Type typ_tab_emplist Is
            Table Of cur_emplist%rowtype;
        tab_emplist           typ_tab_emplist;
        v_processing_date     Date;
        v_count               Number;
        v_cl_bal              Number;
        v_pl_bal              Number;
        v_sl_bal              Number;
        v_p_empno             Varchar2(5);
        c_yyyymm              Constant Varchar2(6) := '202012';
        c_adj_type            Constant Varchar(2)  := 'YA';
    Begin
        v_p_empno := nvl(trim(p_empno), '%');
        Begin
            v_processing_date := last_day(to_date(c_yyyymm, 'yyyymm'));
        Exception
            When Others Then
                p_success := 'KO';
                p_message := 'Invalid YYYYMM.';
                Return;
        End;

        Begin
            Select
                max_leave_bal
            Into
                v_max_leave_bal_limit
            From
                ss_leave_bal_max_limit
            Where
                yyyymm = c_yyyymm;

        Exception
            When Others Then
                v_max_leave_bal_limit := c_max_leave_bal_limit;
        End;

        If v_p_empno <> '%' Then
            Select
                Count(*)
            Into
                v_count
            From
                ss_emplmast
            Where
                empno      = v_p_empno
                And status = 1
                And emptype In (
                    'R', 'F'
                );

            If v_count = 0 Then
                p_success := 'KO';
                p_message := 'Err - Incorrect Employee number.';
                Return;
            End If;

        End If;

        Open cur_emplist(v_p_empno);
        Loop
            Fetch cur_emplist Bulk Collect Into tab_emplist Limit 50;
            For i In 1..tab_emplist.count
            Loop
                Delete
                    From ss_leave_adj
                Where
                    empno            = tab_emplist(i).empno
                    And adj_type     = c_adj_type
                    And db_cr        = 'D'
                    And trunc(bdate) = trunc(v_processing_date)
                    And leavetype In (
                        'CL', 'PL', 'SL'
                    );

                Delete
                    From ss_leaveledg
                Where
                    empno        = tab_emplist(i).empno
                    And adj_type = c_adj_type
                    And db_cr    = 'D'
                    And bdate    = v_processing_date
                    And app_no Like '%'
                    And leavetype In (
                        'CL', 'PL', 'SL'
                    );

                v_cl_bal := leave_bal.get_cl_bal(tab_emplist(i).empno, v_processing_date);
                v_pl_bal := leave_bal.get_pl_bal(tab_emplist(i).empno, v_processing_date);
                v_sl_bal := leave_bal.get_sl_bal(tab_emplist(i).empno, v_processing_date);
                If v_cl_bal > 0 Then
                    debit_leave(
                        p_empno        => tab_emplist(i).empno,
                        p_pdate        => v_processing_date,
                        p_adj_type     => c_adj_type,
                        p_leavetype    => 'CL',
                        p_leave_period => v_cl_bal
                    );
                End If;

                If v_sl_bal > 0 Then
                    debit_leave(
                        p_empno        => tab_emplist(i).empno,
                        p_pdate        => v_processing_date,
                        p_adj_type     => c_adj_type,
                        p_leavetype    => 'SL',
                        p_leave_period => v_sl_bal
                    );
                End If;

                If v_pl_bal > v_max_leave_bal_limit Then
                    v_pl_bal := v_pl_bal - v_max_leave_bal_limit;
                    debit_leave(
                        p_empno        => tab_emplist(i).empno,
                        p_pdate        => v_processing_date,
                        p_adj_type     => c_adj_type,
                        p_leavetype    => 'PL',
                        p_leave_period => v_pl_bal
                    );

                End If;

            End Loop;

            Exit When cur_emplist%notfound;
        End Loop;

    End adjust_leave_202012;

    Procedure adjust_leave_yearly(
        p_empno       Varchar2,
        p_yyyymm      Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As

        Cursor cur_emplist(
            cp_empno Varchar2
        ) Is
            Select
                empno
            From
                ss_emplmast
            Where
                status = 1
                And emptype In (
                    'R', 'F'
                )
                And empno Like cp_empno;

        v_max_leave_bal_limit ss_leave_bal_max_limit.max_leave_bal%Type;
        Type typ_tab_emplist Is
            Table Of cur_emplist%rowtype;
        tab_emplist           typ_tab_emplist;
        v_processing_date     Date;
        v_count               Number;
        v_cl_bal              Number;
        v_pl_bal              Number;
        v_sl_bal              Number;
        v_co_bal              Number;
        v_p_empno             Varchar2(5);
        --c_yyyymm                Constant Varchar2(6) := '202012';
        c_adj_type            Constant Varchar(2) := 'YA';
    Begin
        v_p_empno := nvl(trim(p_empno), '%');
        Begin
            v_processing_date := last_day(to_date(p_yyyymm, 'yyyymm'));
        Exception
            When Others Then
                p_success := 'KO';
                p_message := 'Invalid YYYYMM.';
                Return;
        End;

        Begin
            Select
                max_leave_bal
            Into
                v_max_leave_bal_limit
            From
                ss_leave_bal_max_limit
            Where
                yyyymm = p_yyyymm;

        Exception
            When Others Then
                v_max_leave_bal_limit := c_max_leave_bal_limit;
        End;

        If v_p_empno <> '%' Then
            Select
                Count(*)
            Into
                v_count
            From
                ss_emplmast
            Where
                empno      = v_p_empno
                And status = 1
                And emptype In (
                    'R', 'F'
                );

            If v_count = 0 Then
                p_success := 'KO';
                p_message := 'Err - Incorrect Employee number.';
                Return;
            End If;

        End If;

        Open cur_emplist(v_p_empno);
        Loop
            Fetch cur_emplist Bulk Collect Into tab_emplist Limit 50;
            For i In 1..tab_emplist.count
            Loop
                Delete
                    From ss_leave_adj
                Where
                    empno            = tab_emplist(i).empno
                    And adj_type     = c_adj_type
                    And db_cr        = 'D'
                    And trunc(bdate) = trunc(v_processing_date)
                    And leavetype In (
                        'CL', 'PL', 'SL', 'CO'
                    );

                Delete
                    From ss_leaveledg
                Where
                    empno        = tab_emplist(i).empno
                    And adj_type = c_adj_type
                    And db_cr    = 'D'
                    And bdate    = v_processing_date
                    And app_no Like '%'
                    And leavetype In (
                        'CL', 'PL', 'SL', 'CO'
                    );

                v_cl_bal := leave_bal.get_cl_bal(tab_emplist(i).empno, v_processing_date);
                v_pl_bal := leave_bal.get_pl_bal(tab_emplist(i).empno, v_processing_date);
                v_sl_bal := leave_bal.get_sl_bal(tab_emplist(i).empno, v_processing_date);
                v_co_bal := leave_bal.get_co_bal(tab_emplist(i).empno, v_processing_date);
                If v_cl_bal > 0 Then
                    debit_leave(
                        p_empno        => tab_emplist(i).empno,
                        p_pdate        => v_processing_date,
                        p_adj_type     => c_adj_type,
                        p_leavetype    => 'CL',
                        p_leave_period => v_cl_bal
                    );
                End If;

                If v_sl_bal > 0 Then
                    debit_leave(
                        p_empno        => tab_emplist(i).empno,
                        p_pdate        => v_processing_date,
                        p_adj_type     => c_adj_type,
                        p_leavetype    => 'SL',
                        p_leave_period => v_sl_bal
                    );
                End If;

                If v_co_bal > 0 Then
                    debit_leave(
                        p_empno        => tab_emplist(i).empno,
                        p_pdate        => v_processing_date,
                        p_adj_type     => c_adj_type,
                        p_leavetype    => 'CO',
                        p_leave_period => v_co_bal
                    );
                End If;

                If v_pl_bal > v_max_leave_bal_limit Then
                    v_pl_bal := v_pl_bal - v_max_leave_bal_limit;
                    debit_leave(
                        p_empno        => tab_emplist(i).empno,
                        p_pdate        => v_processing_date,
                        p_adj_type     => c_adj_type,
                        p_leavetype    => 'PL',
                        p_leave_period => v_pl_bal
                    );

                End If;

            End Loop;

            Exit When cur_emplist%notfound;
        End Loop;

    End adjust_leave_yearly;

    Procedure adjust_leave_monthly(
        p_empno       Varchar2,
        p_yyyymm      Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As

        Cursor cur_emplist(
            cp_empno Varchar2
        ) Is
            Select
                empno
            From
                ss_emplmast
            Where
                status = 1
                And emptype In (
                    'R', 'F'
                )
                And empno Like cp_empno;

        v_max_leave_bal_limit ss_leave_bal_max_limit.max_leave_bal%Type;
        Type typ_tab_emplist Is
            Table Of cur_emplist%rowtype;
        tab_emplist           typ_tab_emplist;
        v_processing_date     Date;
        v_count               Number;
        v_cl_bal              Number;
        v_pl_bal              Number;
        v_sl_bal              Number;
        v_p_empno             Varchar2(5);
        c_202012              Constant Varchar2(6) := '202012';

        c_adj_type            Constant Varchar(2)  := 'MA';
    Begin
        v_p_empno := nvl(trim(p_empno), '%');
        Begin
            v_processing_date := last_day(to_date(p_yyyymm, 'yyyymm'));
            If v_processing_date <= to_date(c_202012, 'yyyymm') Then
                p_success := 'KO';
                p_message := 'Invalid YYYYMM.';
                Return;
            End If;

        Exception
            When Others Then
                p_success := 'KO';
                p_message := 'Invalid YYYYMM.';
                Return;
        End;

        Begin
            Select
                max_leave_bal
            Into
                v_max_leave_bal_limit
            From
                ss_leave_bal_max_limit
            Where
                yyyymm = p_yyyymm;

        Exception
            When Others Then
                v_max_leave_bal_limit := c_max_leave_bal_limit;
        End;

        If v_p_empno <> '%' Then
            Select
                Count(*)
            Into
                v_count
            From
                ss_emplmast
            Where
                empno      = v_p_empno
                And status = 1
                And emptype In (
                    'R', 'F'
                );

            If v_count = 0 Then
                p_success := 'KO';
                p_message := 'Err - Incorrect Employee number.';
                Return;
            End If;

        End If;

        Open cur_emplist(v_p_empno);
        Loop
            Fetch cur_emplist Bulk Collect Into tab_emplist Limit 50;
            For i In 1..tab_emplist.count
            Loop
                Delete
                    From ss_leave_adj
                Where
                    empno            = tab_emplist(i).empno
                    And adj_type     = c_adj_type
                    And db_cr        = 'D'
                    And trunc(bdate) = trunc(v_processing_date)
                    And leavetype    = 'PL';

                Delete
                    From ss_leaveledg
                Where
                    empno         = tab_emplist(i).empno
                    And adj_type  = c_adj_type
                    And db_cr     = 'D'
                    And bdate     = v_processing_date
                    And app_no Like '%'
                    And leavetype = 'PL';

                --v_cl_bal   := leave_bal.get_cl_bal(tab_emplist(i).empno, v_processing_date);

                v_pl_bal := leave_bal.get_pl_bal(tab_emplist(i).empno, v_processing_date);
                --v_sl_bal   := leave_bal.get_sl_bal(tab_emplist(i).empno, v_processing_date);
                /*
                If v_cl_bal > 0 Then
                    debit_leave(
                        p_empno          => tab_emplist(i).empno,
                        p_pdate          => v_processing_date,
                        p_adj_type       => c_adj_type,
                        p_leavetype      => 'CL',
                        p_leave_period   => v_cl_bal
                    );
                End If;

                If v_sl_bal > 0 Then
                    debit_leave(
                        p_empno          => tab_emplist(i).empno,
                        p_pdate          => v_processing_date,
                        p_adj_type       => c_adj_type,
                        p_leavetype      => 'SL',
                        p_leave_period   => v_sl_bal
                    );
                End If;
                */
                If v_pl_bal > v_max_leave_bal_limit Then
                    v_pl_bal := v_pl_bal - v_max_leave_bal_limit;
                    debit_leave(
                        p_empno        => tab_emplist(i).empno,
                        p_pdate        => v_processing_date,
                        p_adj_type     => c_adj_type,
                        p_leavetype    => 'PL',
                        p_leave_period => v_pl_bal
                    );

                End If;

            End Loop;

            Exit When cur_emplist%notfound;
        End Loop;

    End adjust_leave_monthly;

    Procedure lapse_leave(
        p_yyyymm   Varchar2,
        p_adj_type Varchar2,
        p_empno    Varchar2
    ) As
        v_success Varchar2(10);
        v_msg     Varchar2(1000);
    Begin
        If p_yyyymm = '202012' Then
            adjust_leave_202012(
                p_empno   => p_empno,
                p_success => v_success,
                p_message => v_msg
            );
        Elsif p_adj_type = 'YA' and p_yyyymm = '202112'  Then
            adjust_leave_yearly(
                p_empno   => p_empno,
                p_yyyymm  => p_yyyymm,
                p_success => v_success,
                p_message => v_msg
            );
        Else
            adjust_leave_monthly(
                p_empno   => p_empno,
                p_yyyymm  => p_yyyymm,
                p_success => v_success,
                p_message => v_msg
            );
        End If;
    End;

    Procedure adjust_leave_async(
        p_yyyymm      Varchar2,
        p_adj_type    Varchar2,
        p_empno       Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
        v_result Varchar2(10);
        v_msg    Varchar2(1000);
        v_count  Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            all_scheduler_running_jobs
        Where
            job_name = c_lapse_leave_job;

        If v_count > 0 Then
            p_success := 'KO';
            p_message := 'Err - Previously scheduled job is still running.';
            Return;
        End If;

        dbms_scheduler.create_job(
            job_name            => c_lapse_leave_job,
            job_type            => 'STORED_PROCEDURE',
            job_action          => 'leave_adj.lapse_leave',
            number_of_arguments => 3,
            enabled             => false,
            job_class           => 'TCMPL_JOB_CLASS',
            comments            => 'to send Email'
        );

        dbms_scheduler.set_job_argument_value(
            job_name          => c_lapse_leave_job,
            argument_position => 1,
            argument_value    => p_yyyymm
        );

        dbms_scheduler.set_job_argument_value(
            job_name          => c_lapse_leave_job,
            argument_position => 2,
            argument_value    => p_adj_type
        );

        dbms_scheduler.set_job_argument_value(
            job_name          => c_lapse_leave_job,
            argument_position => 3,
            argument_value    => p_empno
        );

        dbms_scheduler.enable(c_lapse_leave_job);
        p_success := 'OK';
        p_message := 'Lapse Employee Leave Job has been scheduled.';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure rollback_lapse_leave(
        p_yyyymm      Varchar2,
        p_adj_type    Varchar2,
        p_empno       Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
        v_processing_date Date;
        v_p_empno         Varchar2(5);
        v_count           Number;
    Begin
        v_p_empno := nvl(trim(p_empno), '%');
        Begin
            v_processing_date := last_day(to_date(p_yyyymm, 'yyyymm'));
        Exception
            When Others Then
                p_success := 'KO';
                p_message := 'Invalid YYYYMM.';
                Return;
        End;

        Select
            Count(*)
        Into
            v_count
        From
            ss_leaveledg
        Where
            adj_type         = p_adj_type
            And db_cr        = 'D'
            And trunc(bdate) = trunc(v_processing_date)
            And leavetype In (
                'CL', 'PL', 'SL','CO'
            )
            And empno Like v_p_empno;

        If v_count = 0 Then
            p_success := 'KK';
            p_message := 'No Employee Leave Lapse found for the given criteria.';
            Return;
        End If;

        Delete
            From ss_leave_adj
        Where
            adj_type         = p_adj_type
            And db_cr        = 'D'
            And trunc(bdate) = trunc(v_processing_date)
            And leavetype In (
                'CL', 'PL', 'SL','CO'
            )
            And empno Like v_p_empno;

        Delete
            From ss_leaveledg
        Where
            adj_type  = p_adj_type
            And db_cr = 'D'
            And bdate = v_processing_date
            And app_no Like '%'
            And leavetype In (
                'CL', 'PL', 'SL','CO'
            )
            And empno Like v_p_empno;

        Commit;
        p_success := 'OK';
        p_message := 'Lapse Leave successfully rolled back.';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure lapse_leave_single_emp(
        p_yyyymm      Varchar2,
        p_adj_type    Varchar2,
        p_empno       Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
    Begin
        lapse_leave(
            p_yyyymm   => p_yyyymm,
            p_adj_type => p_adj_type,
            p_empno    => p_empno
        );
        p_success := 'OK';
        p_message := 'Procedure executed.';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    ---
    --Procedure to be delete after Use
    --
    --Procedures to Debit TimeSheet Leave

    Procedure post_leave_as_per_ts(
        p_empno                   Varchar2,
        p_leave_type              Varchar2,
        p_actual_leave_bal        Number,
        p_leave_to_adjust         Number,
        p_leave_adj_date          Date,
        p_bal_leave_to_adjust Out Number,
        p_success             Out Varchar2,
        p_message             Out Varchar2
    ) As
        v_bal_leave_to_adj Number;
    Begin
        If nvl(p_actual_leave_bal, 0) <= 0 Then
            p_bal_leave_to_adjust := p_leave_to_adjust;
            p_success             := 'OK';
            Return;
        End If;

        v_bal_leave_to_adj := 0;
        If p_leave_type <> 'PL' Then
            If p_actual_leave_bal > p_leave_to_adjust Then
                v_bal_leave_to_adj    := p_leave_to_adjust;
                p_bal_leave_to_adjust := 0;
            Else
                v_bal_leave_to_adj    := p_actual_leave_bal;
                p_bal_leave_to_adjust := p_leave_to_adjust - p_actual_leave_bal;
            End If;
        End If;
        --call post leave procedure

        leave.add_leave_adj(
            param_empno      => p_empno,
            param_adj_date   => p_leave_adj_date,
            param_adj_type   => 'TSD',
            param_leave_type => p_leave_type,
            param_adj_period => v_bal_leave_to_adj,
            param_entry_by   => 'Sys',
            param_desc       => 'Timesheet Leave Debit',
            param_success    => p_success,
            param_message    => p_message
        );

    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure ts_leave_update_remarks(
        p_empno   Varchar2,
        p_success Varchar2,
        p_message Varchar2
    ) As
    Begin
        Update
            ss_debit_ts_leave
        Set
            remark = p_success || ' - ' || p_message
        Where
            empno = p_empno;

    End;

    Procedure process_leave_as_per_ts As

        Cursor cur_ts_leave Is
            Select
                empno,
                leave_period
            From
                ss_debit_ts_leave
            Order By
                empno;

        Type typ_tab Is
            Table Of cur_ts_leave%rowtype;
        tab_emplist        typ_tab;
        v_count            Number;
        v_processing_date  Date;
        v_cl_bal           Number;
        v_pl_bal           Number;
        v_sl_bal           Number;
        v_p_empno          Varchar2(5);
        c_yyyymm           Constant Varchar2(6) := '202012';
        c_ya_adj_type      Constant Varchar(2)  := 'YA';
        v_success          Varchar2(10);
        v_message          Varchar2(1000);
        v_leave_to_adj     Number;
        v_bal_leave_to_adj Number;
    Begin
        v_processing_date := last_day(to_date(c_yyyymm, 'yyyymm'));
        Update
            ss_debit_ts_leave
        Set
            remark = Null;

        Open cur_ts_leave;
        Loop
            Fetch cur_ts_leave Bulk Collect Into tab_emplist Limit 50;
            Commit;
            For i In 1..tab_emplist.count
            Loop
                Update
                    ss_debit_ts_leave
                Set
                    remark = 'Started'
                Where
                    empno = tab_emplist(i).empno;

                Commit;
                Delete
                    From ss_leave_adj
                Where
                    empno        = tab_emplist(i).empno
                    And adj_type = 'TS'
                    And db_cr    = 'D'
                    And adj_dt   = v_processing_date;

                Delete
                    From ss_leaveledg
                Where
                    empno        = tab_emplist(i).empno
                    And adj_type = 'TS'
                    And db_cr    = 'D'
                    And bdate    = v_processing_date;

                rollback_lapse_leave(
                    p_yyyymm   => c_yyyymm,
                    p_adj_type => c_ya_adj_type,
                    p_empno    => tab_emplist(i).empno,
                    p_success  => v_success,
                    p_message  => v_message
                );

                If v_success = 'KO' Then
                    ts_leave_update_remarks(
                        p_empno   => tab_emplist(i).empno,
                        p_success => v_success,
                        p_message => v_message
                    );

                    Rollback;
                    Continue;
                End If;

                v_cl_bal           := leave_bal.get_cl_bal(tab_emplist(i).empno, v_processing_date);
                v_pl_bal           := leave_bal.get_pl_bal(tab_emplist(i).empno, v_processing_date);
                v_sl_bal           := leave_bal.get_sl_bal(tab_emplist(i).empno, v_processing_date);
                v_bal_leave_to_adj := tab_emplist(i).leave_period;

                --
                --
                --1st CL
                post_leave_as_per_ts(
                    p_empno               => tab_emplist(i).empno,
                    p_leave_type          => 'CL',
                    p_actual_leave_bal    => v_cl_bal,
                    p_leave_to_adjust     => v_bal_leave_to_adj,
                    p_leave_adj_date      => v_processing_date,
                    p_bal_leave_to_adjust => v_bal_leave_to_adj,
                    p_success             => v_success,
                    p_message             => v_message
                );

                If v_success != 'OK' Then
                    ts_leave_update_remarks(
                        p_empno   => tab_emplist(i).empno,
                        p_success => v_success,
                        p_message => v_message
                    );
                End If;

                If v_bal_leave_to_adj = 0 Then
                    adjust_leave_202012(
                        p_empno   => tab_emplist(i).empno,
                        p_success => v_success,
                        p_message => v_message
                    );

                    Continue;
                End If;

                --2nd SL

                post_leave_as_per_ts(
                    p_empno               => tab_emplist(i).empno,
                    p_leave_type          => 'SL',
                    p_actual_leave_bal    => v_sl_bal,
                    p_leave_to_adjust     => v_bal_leave_to_adj,
                    p_leave_adj_date      => v_processing_date,
                    p_bal_leave_to_adjust => v_bal_leave_to_adj,
                    p_success             => v_success,
                    p_message             => v_message
                );

                If v_bal_leave_to_adj = 0 Then
                    adjust_leave_202012(
                        p_empno   => tab_emplist(i).empno,
                        p_success => v_success,
                        p_message => v_message
                    );

                    Continue;
                End If;

                --post PL leave directly
                --Last PL

                leave.add_leave_adj(
                    param_empno      => tab_emplist(i).empno,
                    param_adj_date   => v_processing_date,
                    param_adj_type   => 'TSD',
                    param_leave_type => 'PL',
                    param_adj_period => v_bal_leave_to_adj,
                    param_entry_by   => 'Sys',
                    param_desc       => 'Timesheet Leave Debit',
                    param_success    => v_success,
                    param_message    => v_message
                );

                --XXXXX
                --Do Year End Lapse

                adjust_leave_202012(
                    p_empno   => tab_emplist(i).empno,
                    p_success => v_success,
                    p_message => v_message
                );

                If v_success != 'OK' Then
                    ts_leave_update_remarks(
                        p_empno   => tab_emplist(i).empno,
                        p_success => v_success,
                        p_message => v_message
                    );
                End If;

            End Loop;

            Exit When cur_ts_leave%notfound;
        End Loop;

        Close cur_ts_leave;
    End;

End leave_adj;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SELECT_LIST_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SELECT_LIST_QRY" As

    Function fn_leave_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                leavetype   data_value_field,
                description data_text_field
            From
                ss_leavetype
            Where
                is_active = 1
            Order By
                leavetype;
        Return c;
    End fn_leave_type_list;

    Function fn_leave_types_for_leaveclaims(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                leavetype   data_value_field,
                description data_text_field
            From
                ss_leavetype
            Order By
                leavetype;
        Return c;
    End fn_leave_types_for_leaveclaims;

    Function fn_approvers_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                'None'          data_value_field,
                'Head Of Dept.' data_text_field
            From
                dual
            Union
            Select
                a.empno data_value_field,
                b.name  data_text_field
            From
                ss_lead_approver a,
                ss_emplmast      b
            Where
                a.empno      = b.empno
                And a.parent In
                (
                    Select
                        e.assign
                    From
                        ss_emplmast e
                    Where
                        e.metaid = p_meta_id
                )
                And b.status = 1;
        Return c;
    End;

    Function fn_onduty_types_list_4_user(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_group_no  Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                type        data_value_field,
                description data_text_field
            From
                ss_ondutymast
            Where
                is_active    = 1
                And group_no = p_group_no
            Order By
                sort_order;

        Return c;
    End;

    Function fn_onduty_types_list_4_filter(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                type        data_value_field,
                description data_text_field
            From
                ss_ondutymast
            Where
                is_active = 1
            Order By
                sort_order;

        Return c;
    End;

    Function fn_onduty_types_list_4_hr(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_group_no  Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                type        data_value_field,
                description data_text_field
            From
                ss_ondutymast
            Where
                group_no = p_group_no
            Order By
                sort_order;

        Return c;
    End;

    Function fn_employee_list_4_hr(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                empno                  data_value_field,
                empno || ' - ' || name data_text_field
            From
                ss_emplmast
            Where
                (status = 1
                    Or nvl(dol, sysdate) > sysdate - 730)
            Order By
                empno;

        Return c;
    End;

    Function fn_emplist_4_mngrhod(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_mngr_empno         Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_mngr_empno := get_empno_from_meta_id(p_meta_id);
        If v_mngr_empno = 'ERRRR' Then
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
                status       = 1
                And (mngr    = v_mngr_empno
                    Or empno = v_mngr_empno)
            Order By
                empno;

        Return c;
    End;

    Function fn_emp_list_4_mngrhod_onbehalf(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                     Sys_Refcursor;
        v_mngr_onbehalf_empno Varchar2(5);
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_mngr_onbehalf_empno := get_empno_from_meta_id(p_meta_id);
        If v_mngr_onbehalf_empno = 'ERRRR' Then
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
                And mngr In (
                    Select
                        mngr
                    From
                        ss_delegate
                    Where
                        empno = v_mngr_onbehalf_empno
                )
            Order By
                empno;

        Return c;
    End;

    Function fn_employee_list_4_secretary(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_secretary_empno    Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_secretary_empno := get_empno_from_meta_id(p_meta_id);
        If v_secretary_empno = 'ERRRR' Then
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
                And parent In (
                    Select
                        parent
                    From
                        ss_user_dept_rights
                    Where
                        empno = v_secretary_empno
                )
            Order By
                empno;

        Return c;
    End;

    Function fn_project_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                 Sys_Refcursor;
        v_empno           Varchar2(5);
        timesheet_allowed Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        Select
            n_timesheetallowed(v_empno)
        Into
            timesheet_allowed
        From
            dual;

        If (timesheet_allowed = 1) Then
            Open c For
                Select
                    projno                  data_value_field,
                    projno || ' - ' || name data_text_field
                From
                    ss_projmast
                Where
                    active = 1
                    And (
                        Select
                            n_timesheetallowed(v_empno)
                        From
                            dual
                    )      = 1;

            Return c;
        Else
            Open c For
                Select
                    'None' data_value_field,
                    'None' data_text_field
                From
                    dual;
            Return c;
        End If;
    End;

    Function fn_costcode_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                 Sys_Refcursor;
        v_empno           Varchar2(5);
        timesheet_allowed Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        Open c For
            Select
                costcode                  data_value_field,
                costcode || ' - ' || name data_text_field
            From
                ss_costmast
            Where
                noofemps > 0;

        Return c;
    End;

    Function fn_emp_list_for_filter(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_list_for  Varchar2
    -- Lead / Hod /HR
    ) Return Sys_Refcursor As
        c               Sys_Refcursor;
        v_empno         Varchar2(5);
        v_list_for_lead Varchar2(4) := 'Lead';
        v_list_for_hod  Varchar2(4) := 'Hod';
        v_list_for_hr   Varchar2(4) := 'HR';

    Begin

        -- v_empno := get_empno_from_meta_id(p_meta_id);
        v_empno := '10426';

        If (p_list_for = v_list_for_lead) Then
            Open c For
                Select
                Distinct
                    e.empno                    data_value_field,
                    a.empno || ' - ' || e.name data_text_field
                From
                    ss_leaveapp                a, ss_emplmast e
                Where
                    a.empno              = e.empno
                    And e.status         = 1
                    And personid Is Not Null
                    And lead_apprl_empno = v_empno;

            Return c;

        Elsif (p_list_for = v_list_for_hod) Then
            Open c For
                Select
                Distinct
                    e.empno                    data_value_field,
                    a.empno || ' - ' || e.name data_text_field
                From
                    ss_leaveapp                a, ss_emplmast e
                Where
                    a.empno      = e.empno
                    And e.status = 1
                    And personid Is Not Null
                    And a.empno In
                    (
                        Select
                            empno
                        From
                            ss_emplmast
                        Where
                            mngr = Trim(v_empno)
                    );

            Return c;

        Elsif (p_list_for = v_list_for_hr) Then
            Open c For
                Select
                Distinct
                    e.empno                    data_value_field,
                    a.empno || ' - ' || e.name data_text_field
                From
                    ss_leaveapp                a, ss_emplmast e
                Where
                    a.empno      = e.empno
                    And e.status = 1
                    And personid Is Not Null
                    And (
                        Select
                            Count(empno)
                        From
                            ss_usermast
                        Where
                            empno      = Trim(v_empno)
                            And active = 1
                            And type   = 1
                    ) >= 1;

            Return c;

        Else
            Open c For
                Select
                    'None' data_value_field,
                    'None' data_text_field
                From
                    dual;
            Return c;
        End If;
    End;

    Function fn_emp_list_for_lead_filter(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        --v_empno := '10426';
        Open c For
            Select
            Distinct
                e.empno                    data_value_field,
                a.empno || ' - ' || e.name data_text_field
            From
                ss_leaveapp                a, ss_emplmast e
            Where
                a.empno              = e.empno
                And e.status         = 1
                And personid Is Not Null
                And lead_apprl_empno = v_empno;
        Return c;
    End;

    Function fn_emp_list_for_hod_filter(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);

        Open c For
            Select
            Distinct
                e.empno                    data_value_field,
                a.empno || ' - ' || e.name data_text_field
            From
                ss_leaveapp                a, ss_emplmast e
            Where
                a.empno      = e.empno
                And e.status = 1
                And personid Is Not Null
                And a.empno
                In
                (
                    Select
                        empno
                    From
                        ss_emplmast
                    Where
                        mngr = Trim(v_empno)
                );

        Return c;

    End;

    Function fn_emp_list_for_hr_filter(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);

        Open c For
            Select
            Distinct
                e.empno                    data_value_field,
                a.empno || ' - ' || e.name data_text_field
            From
                ss_leaveapp                a, ss_emplmast e
            Where
                a.empno      = e.empno
                And e.status = 1
                And personid Is Not Null
                And (
                    Select
                        Count(empno)
                    From
                        ss_usermast
                    Where
                        empno      = Trim(v_empno)
                        And active = 1
                        And type   = 1
                ) >= 1;

        Return c;

    End;

End iot_select_list_qry;
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
--IOT_PUNCH_DETAILS
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_PUNCH_DETAILS" As

    Procedure calculate_weekly_cfwd_hrs(
        p_wk_bfwd_dhrs   Number,
        p_wk_dhrs        Number,
        p_lday_lcome_ego Number,
        p_fri_sl_app     Number,
        p_cfwd_dhrs Out  Number,
        p_pn_hrs    Out  Number
    )
    As
        v_wk_negative_delta Number;
    Begin
        v_wk_negative_delta := nvl(p_wk_bfwd_dhrs, 0) + nvl(p_wk_dhrs, 0);
        If v_wk_negative_delta >= 0 Then
            p_pn_hrs    := 0;
            p_cfwd_dhrs := 0;
            Return;
        End If;
        If p_fri_sl_app <> 1 Then
            p_pn_hrs := ceil((v_wk_negative_delta * -1) / 60);
            If p_pn_hrs Between 5 And 8 Then
                p_pn_hrs := 8;
            End If;

            If p_pn_hrs * 60 > v_wk_negative_delta * -1 Then
                p_cfwd_dhrs := 0;
            Else
                p_cfwd_dhrs := v_wk_negative_delta + p_pn_hrs * 60;
            End If;
        Elsif p_fri_sl_app = 1 Then
            If v_wk_negative_delta > p_lday_lcome_ego Then
                p_pn_hrs    := 0;
                p_cfwd_dhrs := v_wk_negative_delta;
            Elsif v_wk_negative_delta < p_lday_lcome_ego Then
                p_pn_hrs := ceil((v_wk_negative_delta + (p_lday_lcome_ego * -1)) * -1 / 60);
                If p_pn_hrs Between 5 And 8 Then
                    p_pn_hrs := 8;
                End If;
                If p_pn_hrs * 60 > v_wk_negative_delta * -1 Then
                    p_cfwd_dhrs := 0;
                Else
                    p_cfwd_dhrs := v_wk_negative_delta + p_pn_hrs * 60;
                End If;
            End If;
        End If;
        p_pn_hrs            := nvl(p_pn_hrs, 0) * 60;
    End;
    /*
        Function fn_punch_details_4_self(
            p_person_id Varchar2,
            p_meta_id   Varchar2,
            p_yyyymm    Varchar2
        ) Return Sys_Refcursor As
            v_start_date             Date;
            v_end_date               Date;
            v_max_punch              Number;
            v_empno                  Varchar2(5);
            v_prev_delta_hrs         Number;
            v_prev_cfwd_lwd_deltahrs Number;
            v_prev_lc_app_cntr       Number;
            c                        Sys_Refcursor;
            e_employee_not_found     Exception;
            Pragma exception_init(e_employee_not_found, -20001);
        Begin
            v_empno      := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return Null;
            End If;
            v_end_date   := last_day(to_date(p_yyyymm, 'yyyymm'));
            v_start_date := n_getstartdate(to_char(v_end_date, 'mm'), to_char(v_end_date, 'yyyy'));

            v_max_punch  := n_maxpunch(v_empno, v_start_date, v_end_date);

            --n_cfwd_lwd_deltahrs(v_empno, to_date(p_yyyymm, 'yyyymm'), 0, v_prev_delta_hrs, v_prev_cfwd_lwd_deltahrs, v_prev_lc_app_cntr);

            Open c For
                Select
                    empno,
                    days,
                    wk_of_year,
                    penaltyhrs,
                    mdate,
                    sday,
                    d_date,
                    shiftcode,
                    islod,
                    issunday,
                    islwd,
                    islcapp,
                    issleaveapp,
                    is_absent,
                    slappcntr,

                    ego,
                    wrkhrs,
                    tot_punch_nos,
                    deltahrs,
                    extra_hours,
                    last_day_c_fwd_dhrs,
                    Sum(wrkhrs) Over (Partition By wk_of_year)   As sum_work_hrs,
                    Sum(deltahrs) Over (Partition By wk_of_year) As sum_delta_hrs,
                    0                                            bfwd_delta_hrs,
                    0                                            cfwd_delta_hrs,
                    0                                            penalty_leave_hrs
                From
                    (
                        Select
                            main_main_query.*,
                            n_otperiod(v_empno, d_date, shiftcode, deltahrs) As extra_hours,
                            Case
                                When islwd = 1 Then

                                    lastday_cfwd_dhrs1(
                                        p_deltahrs  => deltahrs,
                                        p_ego       => ego,
                                        p_slapp     => issleaveapp,
                                        p_slappcntr => slappcntr,
                                        p_islwd     => islwd
                                    )
                                Else
                                    0
                            End                                              As last_day_c_fwd_dhrs

                        From
                            (
                                Select
                                    main_query.*, n_deltahrs(v_empno, d_date, shiftcode, penaltyhrs) As deltahrs
                                From
                                    (
                                        Select
                                            v_empno                                                  As empno,
                                            to_char(d_date, 'dd')                                    As days,
                                            wk_of_year,
                                            penaltyleave1(

                                                latecome1(v_empno, d_date),
                                                earlygo1(v_empno, d_date),
                                                islastworkday1(v_empno, d_date),

                                                Sum(islcomeegoapp(v_empno, d_date))
                                                    Over ( Partition By wk_of_year Order By d_date
                                                        Range Between Unbounded Preceding And Current Row),

                                                n_sum_slapp_count(v_empno, d_date),

                                                islcomeegoapp(v_empno, d_date),
                                                issleaveapp(v_empno, d_date)
                                            )                                                        As penaltyhrs,

                                            to_char(d_date, 'dd-Mon-yyyy')                           As mdate,
                                            d_dd                                                     As sday,
                                            d_date,
                                            getshift1(v_empno, d_date)                               As shiftcode,
                                            isleavedeputour(d_date, v_empno)                         As islod,
                                            get_holiday(d_date)                                      As issunday,
                                            islastworkday1(v_empno, d_date)                          As islwd,
                                            lc_appcount(v_empno, d_date)                             As islcapp,
                                            issleaveapp(v_empno, d_date)                             As issleaveapp,

                                            n_sum_slapp_count(v_empno, d_date)                       As slappcntr,

                                            isabsent(v_empno, d_date)                                As is_absent,
                                            earlygo1(v_empno, d_date)                                As ego,
                                            n_workedhrs(v_empno, d_date, getshift1(v_empno, d_date)) As wrkhrs,

                                            v_max_punch                                              tot_punch_nos

                                        From
                                            ss_days_details
                                        Where
                                            d_date Between v_start_date And v_end_date
                                        Order By d_date
                                    ) main_query
                            ) main_main_query
                    );

            Return c;
        End fn_punch_details_4_self;
    */
    Function fn_punch_details_4_self(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2 Default Null,
        p_yyyymm    Varchar2,
        p_for_ot    Varchar2 Default 'KO'
    ) Return typ_tab_punch_data
        Pipelined
    Is
        v_prev_delta_hrs               Number;
        v_prev_lwrk_day_cfwd_delta_hrs Number;
        v_prev_lcome_app_cntr          Number;
        tab_punch_data                 typ_tab_punch_data;
        v_start_date                   Date;
        v_end_date                     Date;
        v_max_punch                    Number;
        v_empno                        Varchar2(5);
        e_employee_not_found           Exception;
        v_is_fri_lcome_ego_app         Number;
        c_absent                       Constant Number := 1;
        c_ldt_leave                    Constant Number := 1;
        c_ldt_tour_depu                Constant Number := 2;
        c_ldt_remote_work              Constant Number := 3;
        v_count                        Number;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        If Trim(p_empno) Is Null Then
            v_empno := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return;
            End If;
            /*Else
                Select
                    Count(*)
                Into
                    v_count
                From
                    ss_emplmast
                Where
                    empno      = p_empno
                    And status = 1;

                If v_count = 0 Then
                    Raise e_employee_not_found;
                    Return;
                Else
                    v_empno := p_empno;
                End If;*/
        Else
            v_empno := p_empno;

        End If;
        If p_for_ot = 'OK' Then
            v_end_date := n_getenddate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));
        Else
            v_end_date := last_day(to_date(p_yyyymm, 'yyyymm'));
        End If;
        v_start_date := n_getstartdate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));

        v_max_punch  := n_maxpunch(v_empno, v_start_date, v_end_date);

        n_cfwd_lwd_deltahrs(
            p_empno       => v_empno,
            p_pdate       => to_date(p_yyyymm, 'yyyymm'),
            p_savetot     => 0,
            p_deltahrs    => v_prev_delta_hrs,
            p_lwddeltahrs => v_prev_lwrk_day_cfwd_delta_hrs,
            p_lcappcntr   => v_prev_lcome_app_cntr
        );

        Open cur_for_punch_data(v_empno, v_start_date, v_end_date);
        Loop
            Fetch cur_for_punch_data Bulk Collect Into tab_punch_data Limit 7;
            For i In 1..tab_punch_data.count
            Loop

                --tab_punch_data(i).str_wrk_hrs              := to_hrs(tab_punch_data(i).wrk_hrs);
                --tab_punch_data(i).str_delta_hrs            := to_hrs(tab_punch_data(i).delta_hrs);
                --tab_punch_data(i).str_extra_hrs            := to_hrs(tab_punch_data(i).extra_hrs);

                If tab_punch_data(i).is_absent = 1 Then
                    tab_punch_data(i).remarks := 'Absent';
                Elsif tab_punch_data(i).penalty_hrs > 0 Then
                    If tab_punch_data(i).day_punch_count = 1 Then
                        tab_punch_data(i).remarks := tab_punch_data(i).penalty_hrs || '_HrsLeaveDedu(MissedPunch)';
                    Else
                        tab_punch_data(i).remarks := tab_punch_data(i).penalty_hrs || '_HrsLeaveDeducted';
                    End If;
                Elsif tab_punch_data(i).is_ldt = c_ldt_leave Then
                    tab_punch_data(i).remarks := 'OnLeave';
                Elsif tab_punch_data(i).is_ldt = c_ldt_tour_depu Then
                    tab_punch_data(i).remarks := 'OnTour-Depu';
                Elsif tab_punch_data(i).is_ldt = c_ldt_remote_work Then
                    tab_punch_data(i).remarks := 'RemoteWork';
                Elsif (tab_punch_data(i).is_sleave_app > 0 And tab_punch_data(i).sl_app_cntr < 3) Then
                    tab_punch_data(i).remarks := 'SLeave(Apprd)';
                Elsif tab_punch_data(i).is_lc_app > 0 Then
                    tab_punch_data(i).remarks := 'LCome(Apprd)';
                Elsif tab_punch_data(i).day_punch_count = 1 Then
                    tab_punch_data(i).remarks := 'MissedPunch';
                End If;
                If tab_punch_data(i).is_lwd = 1 And tab_punch_data(i).is_sleave_app = 1 And tab_punch_data(i).sl_app_cntr < 3
                Then
                    v_is_fri_lcome_ego_app := 1;
                Else
                    v_is_fri_lcome_ego_app := 0;
                End If;

                If i = 7 Then
                    tab_punch_data(i).wk_bfwd_delta_hrs := v_prev_lwrk_day_cfwd_delta_hrs;
                    calculate_weekly_cfwd_hrs(
                        p_wk_bfwd_dhrs   => tab_punch_data(i).wk_bfwd_delta_hrs,
                        p_wk_dhrs        => tab_punch_data(i).wk_sum_delta_hrs,
                        p_lday_lcome_ego => tab_punch_data(i).last_day_cfwd_dhrs,
                        p_fri_sl_app     => v_is_fri_lcome_ego_app,
                        p_cfwd_dhrs      => tab_punch_data(i).wk_cfwd_delta_hrs,
                        p_pn_hrs         => tab_punch_data(i).wk_penalty_leave_hrs
                    );
                    v_prev_lwrk_day_cfwd_delta_hrs      := tab_punch_data(i).wk_cfwd_delta_hrs;
                End If;

                --tab_punch_data(i).str_wk_sum_work_hrs      := to_hrs(tab_punch_data(i).wk_sum_work_hrs);
                --tab_punch_data(i).str_wk_sum_delta_hrs     := to_hrs(tab_punch_data(i).wk_sum_delta_hrs);
                --tab_punch_data(i).str_wk_bfwd_delta_hrs    := to_hrs(tab_punch_data(i).wk_bfwd_delta_hrs);
                --tab_punch_data(i).str_wk_cfwd_delta_hrs    := to_hrs(tab_punch_data(i).wk_cfwd_delta_hrs);
                --tab_punch_data(i).str_wk_penalty_leave_hrs := to_hrs(tab_punch_data(i).wk_penalty_leave_hrs);

                Pipe Row(tab_punch_data(i));
            End Loop;
            tab_punch_data := Null;
            Exit When cur_for_punch_data%notfound;
        End Loop;
        Close cur_for_punch_data;
        Return;
    End fn_punch_details_4_self;

    Function fn_day_punch_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2,
        p_date      Date
    ) Return typ_tab_day_punch_list
        Pipelined
    Is
        tab_day_punch_list   typ_tab_day_punch_list;
        v_count              Number;

        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = p_empno;
        If v_count = 0 Then
            Raise e_employee_not_found;
            Return;
        End If;

        Open cur_day_punch_list(p_empno, p_date);
        Loop
            Fetch cur_day_punch_list Bulk Collect Into tab_day_punch_list Limit 50;
            For i In 1..tab_day_punch_list.count
            Loop
                Pipe Row(tab_day_punch_list(i));
            End Loop;
            Exit When cur_day_punch_list%notfound;
        End Loop;
        Close cur_day_punch_list;
        Return;
    End fn_day_punch_list;

    Procedure punch_details_pipe(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2 Default Null,
        p_yyyymm    Varchar2,
        p_for_ot    Varchar2 Default 'KO'
    )
    Is
        v_prev_delta_hrs               Number;
        v_prev_lwrk_day_cfwd_delta_hrs Number;
        v_prev_lcome_app_cntr          Number;
        tab_punch_data                 typ_tab_punch_data;
        v_start_date                   Date;
        v_end_date                     Date;
        v_max_punch                    Number;
        v_empno                        Varchar2(5);
        e_employee_not_found           Exception;
        v_is_fri_lcome_ego_app         Number;
        c_absent                       Constant Number := 1;
        c_ldt_leave                    Constant Number := 1;
        c_ldt_tour_depu                Constant Number := 2;
        c_ldt_remote_work              Constant Number := 3;
        v_count                        Number;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        If Trim(p_empno) Is Null Then
            v_empno := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return;
            End If;
        Else
            Select
                Count(*)
            Into
                v_count
            From
                ss_emplmast
            Where
                empno      = p_empno
                And status = 1;

            If v_count = 0 Then
                Raise e_employee_not_found;
                Return;
            Else
                v_empno := p_empno;
            End If;
        End If;
        If p_for_ot = 'OK' Then
            v_end_date := n_getenddate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));
        Else
            v_end_date := last_day(to_date(p_yyyymm, 'yyyymm'));
        End If;
        v_start_date := n_getstartdate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));

        v_max_punch  := n_maxpunch(v_empno, v_start_date, v_end_date);

        n_cfwd_lwd_deltahrs(
            p_empno       => v_empno,
            p_pdate       => to_date(p_yyyymm, 'yyyymm'),
            p_savetot     => 0,
            p_deltahrs    => v_prev_delta_hrs,
            p_lwddeltahrs => v_prev_lwrk_day_cfwd_delta_hrs,
            p_lcappcntr   => v_prev_lcome_app_cntr
        );

        Open cur_for_punch_data(v_empno, v_start_date, v_end_date);
        Loop
            Fetch cur_for_punch_data Bulk Collect Into tab_punch_data Limit 7;
            For i In 1..tab_punch_data.count
            Loop

                --tab_punch_data(i).str_wrk_hrs              := to_hrs(tab_punch_data(i).wrk_hrs);
                --tab_punch_data(i).str_delta_hrs            := to_hrs(tab_punch_data(i).delta_hrs);
                --tab_punch_data(i).str_extra_hrs            := to_hrs(tab_punch_data(i).extra_hrs);

                If tab_punch_data(i).is_absent = 1 Then
                    tab_punch_data(i).remarks := 'Absent';
                Elsif tab_punch_data(i).penalty_hrs > 0 Then
                    If tab_punch_data(i).day_punch_count = 1 Then
                        tab_punch_data(i).remarks := tab_punch_data(i).penalty_hrs || '-HoursLeaveDeducted(MissedPunch)';
                    Else
                        tab_punch_data(i).remarks := tab_punch_data(i).penalty_hrs || '-HoursLeaveDeducted';
                    End If;
                Elsif tab_punch_data(i).is_ldt = c_ldt_leave Then
                    tab_punch_data(i).remarks := 'OnLeave';
                Elsif tab_punch_data(i).is_ldt = c_ldt_tour_depu Then
                    tab_punch_data(i).remarks := 'OnTour-Depu';
                Elsif tab_punch_data(i).is_ldt = c_ldt_remote_work Then
                    tab_punch_data(i).remarks := 'RemoteWork';
                Elsif tab_punch_data(i).day_punch_count = 1 Then
                    tab_punch_data(i).remarks := 'MissedPunch';
                End If;
                If tab_punch_data(i).is_lwd = 1 And tab_punch_data(i).is_sleave_app = 1 And tab_punch_data(i).sl_app_cntr < 3
                Then
                    v_is_fri_lcome_ego_app := 1;
                Else
                    v_is_fri_lcome_ego_app := 0;
                End If;

                If i = 7 Then
                    tab_punch_data(i).wk_bfwd_delta_hrs := v_prev_lwrk_day_cfwd_delta_hrs;
                    calculate_weekly_cfwd_hrs(
                        p_wk_bfwd_dhrs   => tab_punch_data(i).wk_bfwd_delta_hrs,
                        p_wk_dhrs        => tab_punch_data(i).wk_sum_delta_hrs,
                        p_lday_lcome_ego => tab_punch_data(i).last_day_cfwd_dhrs,
                        p_fri_sl_app     => v_is_fri_lcome_ego_app,
                        p_cfwd_dhrs      => tab_punch_data(i).wk_cfwd_delta_hrs,
                        p_pn_hrs         => tab_punch_data(i).wk_penalty_leave_hrs
                    );
                    v_prev_lwrk_day_cfwd_delta_hrs      := tab_punch_data(i).wk_cfwd_delta_hrs;
                End If;

                --tab_punch_data(i).str_wk_sum_work_hrs      := to_hrs(tab_punch_data(i).wk_sum_work_hrs);
                --tab_punch_data(i).str_wk_sum_delta_hrs     := to_hrs(tab_punch_data(i).wk_sum_delta_hrs);
                --tab_punch_data(i).str_wk_bfwd_delta_hrs    := to_hrs(tab_punch_data(i).wk_bfwd_delta_hrs);
                --tab_punch_data(i).str_wk_cfwd_delta_hrs    := to_hrs(tab_punch_data(i).wk_cfwd_delta_hrs);
                --tab_punch_data(i).str_wk_penalty_leave_hrs := to_hrs(tab_punch_data(i).wk_penalty_leave_hrs);

            End Loop;
            tab_punch_data := Null;
            Exit When cur_for_punch_data%notfound;
        End Loop;
        Close cur_for_punch_data;
        Return;
    End;

End iot_punch_details;
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
--IOT_HOLIDAY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_HOLIDAY" As

   Procedure sp_add_holiday(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_office           Varchar2,
      p_date             Date,
      p_project          Varchar2,
      p_approver         Varchar2,
      p_hh1              Varchar2,
      p_mi1              Varchar2,
      p_hh2              Varchar2,
      p_mi2              Varchar2,
      p_reason           Varchar2,

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

      holiday_attendance.sp_add_holiday(
         p_person_id     => p_person_id,
         p_meta_id       => p_meta_id,
         p_from_date     => p_date,
         p_projno        => p_project,
         p_last_hh       => to_number(Trim(p_hh1)),
         p_last_mn       => to_number(Trim(p_mi1)),
         p_last_hh1      => to_number(Trim(p_hh2)),
         p_last_mn1      => to_number(Trim(p_mi2)),
         p_lead_approver => p_approver,
         p_remarks       => p_reason,
         p_location      => Trim(P_office),
         p_user_tcp_ip   => Trim(v_user_tcp_ip),
         p_message_type  => p_message_type,
         p_message_text  => p_message_text
      );

      If v_message_type = ss.failure Then
         p_message_type := 'KO';
      Else
         p_message_type := 'OK';
      End If;

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'Err - '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_add_holiday;

   Procedure sp_delete_holiday(
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

      holiday_attendance.sp_delete_holiday(
         p_person_id      => p_person_id,
         p_meta_id        => p_meta_id,
         p_application_id => p_application_id,
         p_message_type   => p_message_type,
         p_message_text   => p_message_text
      );

      If v_message_type = ss.failure Then
         p_message_type := 'KO';
      Else
         p_message_type := 'OK';
      End If;

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'Err - '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_delete_holiday;

   Procedure sp_holiday_approval(
      p_person_id         Varchar2,
      p_meta_id           Varchar2,

      p_holiday_approvals typ_tab_string,
      p_approver_profile  Number,
      p_message_type Out  Varchar2,
      p_message_text Out  Varchar2
   ) As
      v_app_no            Varchar2(70);
      v_approval          Number;
      v_remarks           Varchar2(70);
      v_count             Number;
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

      Null;

      Commit;
      p_message_type   := 'OK';
      p_message_text   := 'Procedure executed successfully.';
   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   End;

   Procedure sp_holiday_approval_lead(
      p_person_id         Varchar2,
      p_meta_id           Varchar2,

      p_holiday_approvals typ_tab_string,

      p_message_type Out  Varchar2,
      p_message_text Out  Varchar2
   )
   As
   Begin
      sp_holiday_approval(
         p_person_id         => p_person_id,
         p_meta_id           => p_meta_id,

         p_holiday_approvals => p_holiday_approvals,
         p_approver_profile  => user_profile.type_lead,
         p_message_type      => p_message_type,
         p_message_text      => p_message_text
      );
   End;

   Procedure sp_holiday_approval_hod(
      p_person_id         Varchar2,
      p_meta_id           Varchar2,

      p_holiday_approvals typ_tab_string,

      p_message_type Out  Varchar2,
      p_message_text Out  Varchar2
   )
   As
   Begin
      sp_holiday_approval(
         p_person_id         => p_person_id,
         p_meta_id           => p_meta_id,

         p_holiday_approvals => p_holiday_approvals,
         p_approver_profile  => user_profile.type_hod,
         p_message_type      => p_message_type,
         p_message_text      => p_message_text
      );
   End sp_holiday_approval_hod;

   Procedure sp_holiday_approval_hr(
      p_person_id         Varchar2,
      p_meta_id           Varchar2,

      p_holiday_approvals typ_tab_string,

      p_message_type Out  Varchar2,
      p_message_text Out  Varchar2
   )
   As
   Begin
      sp_holiday_approval(
         p_person_id         => p_person_id,
         p_meta_id           => p_meta_id,

         p_holiday_approvals => p_holiday_approvals,
         p_approver_profile  => user_profile.type_hrd,
         p_message_type      => p_message_type,
         p_message_text      => p_message_text
      );
   End sp_holiday_approval_hr;

End IOT_HOLIDAY;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_ACTION
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_ACTION" As

    Procedure sp_add_atnd(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_weekly_attendance typ_tab_string,
        p_empno             Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        strsql         Varchar2(600);
        vcount         Number;
        v_ststue       Varchar2(5);
        -- 0 for delete only , 1 delete old and insert new
        v_mod_by_empno Varchar2(5);
        v_pk           Varchar2(10);
        v_fk           Varchar2(10);
        v_empno        Varchar2(5);
        v_atnd_date    Date;
        v_desk         Varchar2(20);
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
            vcount
        From
            swp_primary_workspace
        Where
            Trim(empno)         = Trim(p_empno)
            And Trim(primary_workspace) = '2';

        If vcount = 0 Then
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
                to_date(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) atnd_date,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3))          desk,
                Trim(regexp_substr(str, '[^~!~]+', 1, 4))          ststue
            Into
                v_empno, v_atnd_date, v_desk, v_ststue
            From
                csv;

            Delete
                From swp_smart_attendance_plan
            Where
                empno         = v_empno
                And attendance_date = v_atnd_date;

            If v_ststue = '1' Then

                v_pk := dbms_random.string('X', 10);

                Select
                    key_id
                Into
                    v_fk
                From
                    swp_primary_workspace
                Where
                    Trim(empno)         = Trim(p_empno)
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
                    v_atnd_date,
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

    End sp_add_atnd;

End iot_swp_action;
/
---------------------------
--Changed PACKAGE BODY
--IOT_GUEST_MEET
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_GUEST_MEET" AS

    Procedure sp_add_meet(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

		P_guest_name       Varchar2,
		P_guest_company    Varchar2,
        p_hh1              Varchar2,
        p_mi1              Varchar2,
        p_date             Date,
        P_office           Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno         Varchar2(5);
        v_emp_name      Varchar2(60);
        v_count         Number;
        v_lead_approval Number := 0;
        v_hod_approval  Number := 0;
        v_desc          Varchar2(60);
        v_message_type  Number := 0;
    Begin
        v_empno    := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        v_emp_name := get_emp_name(v_empno);

        meet.add_meet(
            param_host_name		=> v_emp_name,
            param_guest_name	=> P_guest_name,
            param_guest_co		=> P_guest_company,
            param_meet_date		=> to_char(p_date, 'dd/mm/yyyy'),
            param_meet_hh		=> to_number(Trim(p_hh1)),
            param_meet_mn		=> to_number(Trim(p_mi1)),
            param_meet_off		=> Trim(P_office),
            param_remarks		=> p_reason,
            param_modified_by	=> v_empno,
            param_success		=> v_message_type,
            param_msg			=> p_message_text
        );

        If v_message_type = ss.failure Then
             p_message_type := 'KO';
         Else
             p_message_type := 'OK';
         End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_meet;

    Procedure sp_delete_meet(
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
            ss_guest_register
        Where
            Trim(app_no) = Trim(p_application_id)
            And modified_by    = v_empno;

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;

        meet.del_meet(paramappno   => p_application_id);

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_meet;

END iot_guest_meet;
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
--New PACKAGE BODY
--IOT_SWP_OFFICE_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_OFFICE_WORKSPACE_QRY" As

    Function fn_office_planning(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_date                   Date,
        p_assign_code            Varchar2 Default Null,

        p_emptype_csv            Varchar2 Default Null,
        p_grade_csv              Varchar2 Default Null,
        p_generic_search         Varchar2 Default Null,
        p_desk_assignment_status Varchar2 Default Null,

        p_row_number             Number,
        p_page_length            Number

    ) Return Sys_Refcursor As
        c                     Sys_Refcursor;
        v_hod_sec_empno       Varchar2(5);
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_query               Varchar2(6000);
        v_hod_sec_assign_code Varchar2(4);
    Begin

        v_query               := c_qry_office_planning;

        v_hod_sec_empno       := get_empno_from_meta_id(p_meta_id);
        If v_hod_sec_empno = 'ERRRR' Then
            Raise e_employee_not_found;
        End If;

        v_hod_sec_assign_code := iot_swp_common.get_default_costcode_hod_sec(
                                     p_hod_sec_empno => v_hod_sec_empno,
                                     p_assign_code   => p_assign_code
                                 );

        If p_grade_csv Is Not Null Then
            v_query := replace(v_query, '!GRADES_SUBQUERY!', sub_qry_grades_csv);
        Else
            v_query := replace(v_query, '!GRADES_SUBQUERY!', '');
        End If;

        If p_emptype_csv Is Not Null Then
            v_query := replace(v_query, '!EMPTYPE_SUBQUERY!', sub_qry_emptype_csv);
        Else
            v_query := replace(v_query, '!EMPTYPE_SUBQUERY!', sub_qry_emptype_default);
        End If;

        If Trim(p_generic_search) Is Not Null Then
            v_query := replace(v_query, '!GENERIC_SEARCH!', where_clause_generic_search);
        Else
            v_query := replace(v_query, '!GENERIC_SEARCH!', '');
        End If;

        If p_desk_assignment_status = 'Pending' Then
            v_query := replace(v_query, '!DESK_ASSIGNMENT_STATUS!', ' where deskid is null ');
        Elsif p_desk_assignment_status = 'Assigned' Then
            v_query := replace(v_query, '!DESK_ASSIGNMENT_STATUS!', ' where deskid is not null ');
        Else
            v_query := replace(v_query, '!DESK_ASSIGNMENT_STATUS!', '');
        End If;

        /*
                Insert Into swp_mail_log (subject, mail_sent_to_cc_bcc, modified_on)
                Values (v_empno || '-' || p_row_number || '-' || p_page_length || '-' || to_char(v_start_date, 'yyyymmdd') || '-' ||
                    to_char(v_end_date, 'yyyymmdd'),
                    v_query, sysdate);
                Commit;
          */
        Open c For v_query Using
            p_person_id,
            p_meta_id,
            p_row_number,
            p_page_length,

            v_hod_sec_assign_code,
            p_emptype_csv,
            p_grade_csv,
            '%' || upper(trim(p_generic_search)) || '%',
            p_desk_assignment_status;
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
                                dm_vu_desk_lock_swp_plan
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
                                DM_VU_EMP_DESK_MAP_SWP_PLAN ed
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
        v_office             dm_vu_desk_list.office%Type;
        v_floor              dm_vu_desk_list.floor%Type;
        v_wing               dm_vu_desk_list.wing%Type;
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
                        mast.work_area = Trim(p_work_area)
                        And mast.office Like v_office
                        And mast.floor Like v_floor
                        And nvl(mast.wing, '-') Like v_wing

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
                                DM_VU_EMP_DESK_MAP_SWP_PLAN c
                            Union
                            Select
                                deskid
                            From
                                dm_vu_desk_lock_swp_plan
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
--New PACKAGE BODY
--IOT_SWP_PRIMARY_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_PRIMARY_WORKSPACE_QRY" As

    Function fn_emp_primary_ws_list(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,

        p_assign_code           Varchar2 Default Null,
        p_start_date            Date     Default Null,

        p_empno                 Varchar2 Default Null,

        p_emptype_csv           Varchar2 Default Null,
        p_grade_csv             Varchar2 Default Null,
        p_primary_workspace_csv Varchar2 Default Null,
        p_laptop_user           Varchar2 Default Null,
        p_eligible_for_swp      Varchar2 Default Null,
        p_generic_search        Varchar2 Default Null,

        p_row_number            Number,
        p_page_length           Number
    ) Return Sys_Refcursor As
        c                     Sys_Refcursor;

        v_hod_sec_empno       Varchar2(5);
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_friday_date         Date;
        v_hod_sec_assign_code Varchar2(4);
        v_query               Varchar2(6000);
    Begin
        v_friday_date   := iot_swp_common.get_friday_date(nvl(p_start_date, sysdate));

        v_hod_sec_empno := get_empno_from_meta_id(p_meta_id);

        If v_hod_sec_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        --If EMPNO is not null then set assign code filter as null else validate assign code
        If p_empno Is Null Or p_assign_code Is Not Null Then
            v_hod_sec_assign_code := iot_swp_common.get_default_costcode_hod_sec(
                                         p_hod_sec_empno => v_hod_sec_empno,
                                         p_assign_code   => p_assign_code
                                     );
        End If;

        v_query         := query_pws;

        If p_grade_csv Is Not Null Then
            v_query := replace(v_query, '!GRADES_SUBQUERY!', sub_qry_grades_csv);
        Else
            v_query := replace(v_query, '!GRADES_SUBQUERY!', '');
        End If;

        If p_primary_workspace_csv Is Not Null Then
            v_query := replace(v_query, '!PWS_TYPE_SUBQUERY!', sub_qry_pws_csv);
        Else
            v_query := replace(v_query, '!PWS_TYPE_SUBQUERY!', '');
        End If;

        If p_emptype_csv Is Not Null Then
            v_query := replace(v_query, '!EMPTYPE_SUBQUERY!', sub_qry_emptype_csv);
        Else
            v_query := replace(v_query, '!EMPTYPE_SUBQUERY!', sub_qry_emptype_default);
        End If;

        If p_laptop_user Is Not Null Then
            v_query := replace(v_query, '!LAPTOP_USER_WHERE_CLAUSE!', where_clause_laptop_user);
        Else
            v_query := replace(v_query, '!LAPTOP_USER_WHERE_CLAUSE!', '');
        End If;

        If p_eligible_for_swp Is Not Null Then
            v_query := replace(v_query, '!SWP_ELIGIBLE_WHERE_CLAUSE!', where_clause_swp_eligible);
        Else
            v_query := replace(v_query, '!SWP_ELIGIBLE_WHERE_CLAUSE!', '');
        End If;

        If Trim(p_generic_search) Is Not Null Then
            v_query := replace(v_query, '!GENERIC_SEARCH!', where_clause_generic_search);
        Else
            v_query := replace(v_query, '!GENERIC_SEARCH!', '');
        End If;

        /*
            :p_friday_date     As p_friday_date,
            :p_row_number      As p_row_number,
            :p_page_length     As p_page_length,
            :p_for_empno       As p_for_empno,
            :p_hod_assign_code As p_hod_assign_code,
            :p_pws_csv         As p_pws_csv,
            :p_grades_csv      As p_grades_csv,
            :p_emptype_csv     As p_emptype_csv,
            :p_swp_eligibility As p_swp_eligibility,
            :p_laptop_user     As p_laptop_user
        */
        Open c For v_query Using
            v_friday_date,
            p_row_number,
            p_page_length,
            p_empno,
            v_hod_sec_assign_code,
            p_primary_workspace_csv,
            p_grade_csv,
            p_emptype_csv,
            p_eligible_for_swp,
            p_laptop_user,
            '%'|| upper(trim(p_generic_search)) || '%';

        Return c;

    End;

    /*
        Function fn_emp_primary_ws_list(
            p_person_id   Varchar2,
            p_meta_id     Varchar2,

            p_assign_code Varchar2 Default Null,
            p_start_date  Date     Default Null,

            p_empno       Varchar2 Default Null,

            p_row_number  Number,
            p_page_length Number
        ) Return Sys_Refcursor As
            c                     Sys_Refcursor;
            c_grades              Sys_Refcursor;
            v_hod_sec_empno       Varchar2(5);
            e_employee_not_found  Exception;
            Pragma exception_init(e_employee_not_found, -20001);
            v_friday_date         Date;
            v_hod_sec_assign_code Varchar2(4);

        Begin
            v_friday_date   := iot_swp_common.get_friday_date(nvl(p_start_date, sysdate));

            v_hod_sec_empno := get_empno_from_meta_id(p_meta_id);

            If v_hod_sec_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return Null;
            End If;

            If p_empno Is Null Or p_assign_code Is Not Null Then
                v_hod_sec_assign_code := iot_swp_common.get_default_costcode_hod_sec(
                                             p_hod_sec_empno => v_hod_sec_empno,
                                             p_assign_code   => p_assign_code
                                         );
            End If;

            Open c For
                With
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
                    *
                From
                    (
                        Select
                            a.empno                                                           As empno,
                            a.name                                                            As employee_name,
                            a.assign,
                            a.parent,
                            a.office,
                            a.emptype,
                            iot_swp_common.get_emp_work_area(p_person_id, p_meta_id, a.empno) work_area,
                            iot_swp_common.is_emp_laptop_user(a.empno)                        As is_laptop_user,
                            Case iot_swp_common.is_emp_laptop_user(a.empno)
                                When 1 Then
                                    'Yes'
                                Else
                                    'No'
                            End                                                               As is_laptop_user_text,
                            a.grade                                                           As emp_grade,
                            nvl(b.primary_workspace, 0)                                       As primary_workspace,
                            Row_Number() Over(Order By a.name)                                As row_number,
                            Case iot_swp_common.is_emp_eligible_for_swp(a.empno)
                                When 'OK' Then
                                    'Yes'
                                Else
                                    'No'
                            End                                                               As is_eligible_desc,
                            iot_swp_common.is_emp_eligible_for_swp(a.empno)                   As is_eligible,
                            Count(*) Over()                                                   As total_row
                        From
                            ss_emplmast        a,
                            primary_work_space b
                        Where
                            a.empno      = b.empno(+)
                            And a.assign = nvl(v_hod_sec_assign_code, a.assign)
                            And a.status = 1
                            And a.empno  = nvl(p_empno, a.empno)
                            And a.assign Not In (
                                Select
                                    assign
                                From
                                    swp_exclude_assign
                            )
                            And a.emptype In (
                                Select
                                    emptype
                                From
                                    swp_include_emptype
                            )
                        Order By a.name
                    )
                Where
                    row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

            Return c;

        End fn_emp_primary_ws_list;
    */
    Function fn_emp_primary_ws_plan_list(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,

        p_assign_code           Varchar2 Default Null,

        p_empno                 Varchar2 Default Null,

        p_emptype_csv           Varchar2 Default Null,
        p_grade_csv             Varchar2 Default Null,
        p_primary_workspace_csv Varchar2 Default Null,
        p_laptop_user           Varchar2 Default Null,
        p_eligible_for_swp      Varchar2 Default Null,
        p_generic_search        Varchar2 Default Null,

        p_row_number            Number,
        p_page_length           Number
    ) Return Sys_Refcursor As
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
        Return fn_emp_primary_ws_list(
            p_person_id             => p_person_id,
            p_meta_id               => p_meta_id,

            p_assign_code           => p_assign_code,
            p_start_date            => v_plan_friday_date,

            p_empno                 => p_empno,

            p_emptype_csv           => p_emptype_csv,
            p_grade_csv             => p_grade_csv,
            p_primary_workspace_csv => p_primary_workspace_csv,
            p_laptop_user           => p_laptop_user,
            p_eligible_for_swp      => p_eligible_for_swp,
            p_generic_search        => p_generic_search,

            p_row_number            => p_row_number,
            p_page_length           => p_page_length
        );

    End fn_emp_primary_ws_plan_list;

    Function fn_emp_pws_excel(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_assign_codes_csv Varchar2 Default Null,
        p_start_date       Date Default Null
    ) Return Sys_Refcursor As
        c                          Sys_Refcursor;
        v_hod_sec_empno            Varchar2(5);
        e_employee_not_found       Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_friday_date              Date;
        v_hod_sec_assign_codes_csv Varchar2(4000);
    Begin
        v_friday_date              := iot_swp_common.get_friday_date(nvl(p_start_date, sysdate));

        v_hod_sec_empno            := get_empno_from_meta_id(p_meta_id);

        If v_hod_sec_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        v_hod_sec_assign_codes_csv := iot_swp_common.get_hod_sec_costcodes_csv(
                                          p_hod_sec_empno    => v_hod_sec_empno,
                                          p_assign_codes_csv => p_assign_codes_csv
                                      );

        Open c For
            With
                assign_codes As (
                    Select
                        regexp_substr(v_hod_sec_assign_codes_csv, '[^,]+', 1, level) assign
                    From
                        dual
                    Connect By
                        level <=
                        length(v_hod_sec_assign_codes_csv) - length(replace(v_hod_sec_assign_codes_csv, ',')) + 1
                ),
                primary_work_space As(
                    Select
                        a.empno, a.primary_workspace, a.start_date, c.type_desc primary_workspace_desc
                    From
                        swp_primary_workspace       a,
                        swp_primary_workspace_types c
                    Where
                        a.primary_workspace     = c.type_code
                        And trunc(a.start_date) = (
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
                *
            From
                (
                    Select
                        a.empno                                                           As empno,
                        a.name                                                            As employee_name,
                        a.assign,
                        a.parent,
                        a.office,
                        a.emptype,
                        iot_swp_common.get_emp_work_area(p_person_id, p_meta_id, a.empno) work_area,
                        --iot_swp_common.is_emp_laptop_user(a.empno)                        As is_laptop_user,
                        Case iot_swp_common.is_emp_laptop_user(a.empno)
                            When 1 Then
                                'Yes'
                            Else
                                'No'
                        End                                                               As is_laptop_user_text,
                        a.grade                                                           As emp_grade,
                        nvl(b.primary_workspace_desc, '')                                  As primary_workspace,
                        Case iot_swp_common.is_emp_eligible_for_swp(a.empno)
                            When 'OK' Then
                                'Yes'
                            Else
                                'No'
                        End                                                               As is_eligible_desc

                    --iot_swp_common.is_emp_eligible_for_swp(a.empno)                   As is_eligible
                    From
                        ss_emplmast        a,
                        primary_work_space b,
                        assign_codes       c
                    Where
                        a.empno      = b.empno(+)
                        And a.assign = c.assign
                        And a.status = 1
                        And a.assign Not In (
                            Select
                                assign
                            From
                                swp_exclude_assign
                        )
                        And a.emptype In (
                            Select
                                emptype
                            From
                                swp_include_emptype
                        )

                );

        Return c;

    End fn_emp_pws_excel;

    Function fn_emp_pws_plan_excel(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_assign_codes_csv Varchar2 Default Null

    ) Return Sys_Refcursor As
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

        Return fn_emp_pws_excel(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_assign_codes_csv => p_assign_codes_csv,
            p_start_date       => v_plan_friday_date
        );

    End fn_emp_pws_plan_excel;

End iot_swp_primary_workspace_qry;
/
---------------------------
--Changed PACKAGE BODY
--SWP_VACCINEDATE
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."SWP_VACCINEDATE" As

    Procedure sendmail(
        param_empno Varchar2
    ) As

        v_email         ss_emplmast.email%Type;
        v_name          ss_emplmast.name%Type;
        v_email_body    Varchar2(4000);
        v_email_subject Varchar2(200);
        v_success       Varchar2(10);
        v_message       Varchar2(1000);
    Begin
        Select
            name,
            email
        Into
            v_name,
            v_email
        From
            ss_emplmast
        Where
            empno = param_empno;

        v_email_subject := 'Vaccine Date deletion.';
        v_email_body    := 'Dear User,

Your input in Employee Vaccine Dates has been deleted as it was for a future date.

Please input your actual 1st vaccine date after taking the 1st jab and follow the same for the 2nd vaccine date.';
        v_email_body    := v_email_body || chr(13) || chr(10) || chr(13) || chr(10);

        v_email_body    := v_email_body || 'Thanks,' || chr(13) || chr(10);

        v_email_body    := v_email_body || 'This is an automated TCMPL Mail.';
        If v_email Is Not Null Then
            send_mail_from_api(
                p_mail_to      => v_email,
                p_mail_cc      => Null,
                p_mail_bcc     => Null,
                p_mail_subject => v_email_subject,
                p_mail_body    => v_email_body,
                p_mail_profile => 'SELFSERVICE',
                p_mail_format  => 'Text',
                p_success      => v_success,
                p_message      => v_message
            );
        End If;

    End sendmail;

    Procedure add_new(
        param_win_uid      Varchar2,
        param_vaccine_type Varchar2,
        param_first_jab    Date,
        param_second_jab   Date,
        param_success Out  Varchar2,
        param_message Out  Varchar2
    ) As
        v_empno Char(5);
    Begin
        v_empno       := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If v_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Insert Into swp_vaccine_dates (
            empno,
            vaccine_type,
            jab1_date,
            is_jab1_by_office,
            jab2_date,
            is_jab2_by_office,
            modified_on,
            modified_by
        )
        Values (
            v_empno,
            param_vaccine_type,
            param_first_jab,
            'KO',
            param_second_jab,
            'KO',
            sysdate,
            v_empno
        );

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed successfully';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End add_new;

    Procedure add_emp_vaccine_dates(
        param_win_uid         Varchar2,
        param_vaccine_type    Varchar2,
        param_for_empno       Varchar2,
        param_first_jab_date  Date,
        param_second_jab_date Date default null,
        param_success Out     Varchar2,
        param_message Out     Varchar2
    ) As
        v_empno Char(5);
        v_second_jab_by_office varchar2(2);
    Begin
        v_empno       := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If v_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;
        v_second_jab_by_office := case when param_second_jab_date is null then null else 'KO' end;
        Insert Into swp_vaccine_dates (
            empno,
            vaccine_type,
            jab1_date,
            is_jab1_by_office,
            jab2_date,
            is_jab2_by_office,
            modified_on,
            modified_by
        )
        Values (
            param_for_empno,
            param_vaccine_type,
            param_first_jab_date,
            'KO',
            param_second_jab_date,
            'KO',
            sysdate,
            v_empno
        );

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed successfully';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End add_emp_vaccine_dates;

    Procedure update_emp_second_jab(
        param_win_uid         Varchar2,
        param_for_empno       Varchar2,
        param_second_jab_date Date,
        param_success Out     Varchar2,
        param_message Out     Varchar2
    ) As
        by_empno Char(5);
    Begin
        by_empno      := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If by_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Update
            swp_vaccine_dates
        Set
            jab2_date = param_second_jab_date,
            is_jab2_by_office = 'KO',
            modified_on = sysdate,
            modified_by = by_empno
        Where
            empno = param_for_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Second Jab info could not be updated.';
            Return;
        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End update_emp_second_jab;

    Procedure update_second_jab(
        param_win_uid     Varchar2,
        param_second_jab  Date,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) As
        v_empno Char(5);
    Begin
        v_empno       := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If v_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Update
            swp_vaccine_dates
        Set
            jab2_date = param_second_jab,
            is_jab2_by_office = 'KO',
            modified_on = sysdate,
            modified_by = v_empno
        Where
            empno = v_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Second Jab info could not be updated.';
            Return;
        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End update_second_jab;

    Procedure update_vaccine_type(
        param_win_uid      Varchar2,
        param_vaccine_type Varchar2,
        param_second_jab   Date,
        param_success Out  Varchar2,
        param_message Out  Varchar2
    ) As
        v_empno Char(5);
    Begin
        v_empno       := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If v_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Update
            swp_vaccine_dates
        Set
            vaccine_type = param_vaccine_type,
            jab2_date = param_second_jab,
            modified_on = sysdate
        Where
            empno = v_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Second Jab info could not be updated.';
            Return;
        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End update_vaccine_type;

    Procedure delete_emp_vaccine_dates(
        param_empno       Varchar2,
        param_hr_win_uid  Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) As
        --v_empno          Char(5);
        v_hr_empno Char(5);
        v_count    Number;
    Begin
        v_hr_empno    := swp_users.get_empno_from_win_uid(param_win_uid => param_hr_win_uid);
        If v_hr_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving HR EMP Detials';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno      = param_empno
            And status = 1;

        If v_hr_empno Is Null Then
            param_success := 'KO';
            param_message := 'Err - Select Employee details not found.';
            Return;
        End If;

        Delete
            From swp_vaccine_dates
        Where
            empno = param_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Jab info could not be updated.';
            Return;
        End If;

        Commit;
        sendmail(param_empno);
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End delete_emp_vaccine_dates;

End swp_vaccinedate;
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
--IOT_SWP_COMMON
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_COMMON" As

    Function get_emp_work_area(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2
    ) Return Varchar2 As
        v_count  Number;
        v_projno Varchar2(5);
        v_area   Varchar2(20);
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_vu_jobmaster
        Where
            projno In (
                Select
                    projno
                From
                    swp_map_emp_project
                Where
                    empno = p_empno
            )
            And taskforce Is Not Null
            And Rownum = 1;

        If (v_count > 0) Then

            Select
                taskforce
            Into
                v_area
            From
                ss_vu_jobmaster
            Where
                projno In (
                    Select
                        projno
                    From
                        swp_map_emp_project
                    Where
                        empno = p_empno
                )
                And taskforce Is Not Null
                And Rownum = 1;
        Else
            Begin
                Select
                    da.area_desc
                Into
                    v_area
                From
                    dms.dm_desk_area_dept_map dad,
                    dms.dm_desk_areas         da,
                    ss_emplmast               e
                Where
                    dad.area_code = da.area_key_id
                    And e.assign  = dad.assign
                    And e.empno   = p_empno;

            Exception
                When Others Then
                    v_area := Null;
            End;
        End If;

        Return v_area;
    Exception
        When Others Then
            Return Null;
    End get_emp_work_area;

    Function get_emp_work_area_code(
        p_empno Varchar2
    ) Return Varchar2 As
        v_count     Number;
        v_projno    Varchar2(5);
        v_area_code Varchar2(3);
    Begin
        Select
            da.area_key_id
        Into
            v_area_code
        From
            dms.dm_desk_area_dept_map dad,
            dms.dm_desk_areas         da,
            ss_emplmast               e
        Where
            dad.area_code = da.area_key_id
            And e.assign  = dad.assign
            And e.empno   = p_empno;

        Return v_area_code;
    Exception
        When Others Then
            Return Null;
    End get_emp_work_area_code;

    Function get_desk_from_dms(
        p_empno In Varchar2
    ) Return Varchar2 As
        v_retval Varchar(50) := 'NA';
    Begin

        Select
        Distinct dmst.deskid As desk
        Into
            v_retval
        From
            dm_vu_emp_desk_map dmst
        Where
            dmst.empno = Trim(p_empno);

        Return v_retval;
    Exception
        When Others Then
            Return Null;
    End get_desk_from_dms;

    Procedure get_planning_week_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_start_date      Out Date,
        p_end_date        Out Date,
        p_planning_exists Out Varchar2,
        p_planning_open   Out Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2

    ) As
        v_count           Number;
        v_rec_config_week swp_config_weeks%rowtype;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            swp_config_weeks
        Where
            planning_flag = 2;
        If v_count = 0 Then
            p_planning_exists := 'KO';
            p_planning_open   := 'KO';
            p_message_type    := 'OK';
            Return;
        End If;

        Select
            *
        Into
            v_rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = 2;
        p_start_date      := v_rec_config_week.start_date;
        p_end_date        := v_rec_config_week.end_date;
        p_planning_exists := 'OK';
        p_planning_open   := Case
                                 When nvl(v_rec_config_week.planning_open, 0) = 1 Then
                                     'OK'
                                 Else
                                     'KO'
                             End;
        p_message_type    := 'OK';
        p_message_text    := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End get_planning_week_details;

    Function get_total_desk(
        p_work_area Varchar2,
        p_office    Varchar2,
        p_floor     Varchar2,
        p_wing      Varchar2
    ) Return Number As
        v_count Number := 0;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_deskmaster                         mast, dms.dm_desk_areas area
        Where
            mast.work_area       = p_work_area
            And area.area_key_id = mast.work_area
            And mast.office      = Trim(p_office)
            And mast.floor       = Trim(p_floor)
            And (mast.wing       = p_wing Or p_wing Is Null);

        Return v_count;
    End;

    Function get_occupied_desk(
        p_work_area Varchar2,
        p_office    Varchar2,
        p_floor     Varchar2,
        p_wing      Varchar2,
        p_date      Date Default Null
    ) Return Number As
        v_count Number := 0;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_deskmaster                         mast, dms.dm_desk_areas area
        Where
            mast.work_area        = p_work_area
            And area.area_key_id  = mast.work_area
            And Trim(mast.office) = Trim(p_office)
            And Trim(mast.floor)  = Trim(p_floor)
            And (mast.wing        = p_wing Or p_wing Is Null)
            And mast.deskid
            In (
                (
                    Select
                    Distinct swptbl.deskid
                    From
                        swp_smart_attendance_plan swptbl
                    Where
                        (trunc(attendance_date) = trunc(p_date) Or p_date Is Null)
                    Union
                    Select
                    Distinct c.deskid
                    From
                        DM_VU_EMP_DESK_MAP_SWP_PLAN c
                )
            );
        Return v_count;
    End;

    Function get_monday_date(p_date Date) Return Date As
        v_day_num Number;
    Begin
        v_day_num := to_number(to_char(p_date, 'd'));
        If v_day_num <= 2 Then
            Return p_date + (2 - v_day_num);
        Else
            Return p_date - v_day_num + 2;
        End If;

    End;

    Function get_friday_date(p_date Date) Return Date As
        v_day_num Number;
    Begin
        v_day_num := to_char(p_date, 'd');

        Return p_date + (6 - v_day_num);

    End;

    Function is_emp_eligible_for_swp(
        p_empno Varchar2
    ) Return Varchar2
    As
        v_count Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            swp_emp_response
        Where
            empno        = p_empno
            And hr_apprl = 'OK';
        If v_count = 1 Then
            Return 'OK';
        Else
            Return 'KO';
        End If;
    End;

    Function get_default_costcode_hod_sec(
        p_hod_sec_empno Varchar2,
        p_assign_code   Varchar2 Default Null
    ) Return Varchar2
    As
        v_assign        Varchar2(4);
        v_hod_sec_empno Varchar2(5);
    Begin
        Select
            p_hod_sec_empno
        Into
            v_hod_sec_empno
        From
            ss_emplmast
        Where
            status    = 1
            And empno = lpad(p_hod_sec_empno, 5, '0');
        Select
            assign
        Into
            v_assign
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
                            hod = v_hod_sec_empno
                        Union
                        Select
                            parent As assign
                        From
                            ss_user_dept_rights
                        Where
                            empno = v_hod_sec_empno
                    )
                Where
                    assign = nvl(p_assign_code, assign)
                Order By assign
            )
        Where
            Rownum = 1;
        Return v_assign;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_hod_sec_costcodes_csv(
        p_hod_sec_empno    Varchar2,
        p_assign_codes_csv Varchar2 Default Null
    ) Return Varchar2
    As
        v_assign        Varchar2(4);
        v_hod_sec_empno Varchar2(5);
        v_ret_val       Varchar2(4000);
    Begin
        Select
            p_hod_sec_empno
        Into
            v_hod_sec_empno
        From
            ss_emplmast
        Where
            status    = 1
            And empno = lpad(p_hod_sec_empno, 5, '0');
        If p_assign_codes_csv Is Null Then
            Select
                Listagg(assign, ',') Within
                    Group (Order By
                        assign)
            Into
                v_ret_val
            From
                (
                    Select
                        costcode As assign
                    From
                        ss_costmast
                    Where
                        hod = v_hod_sec_empno
                    Union
                    Select
                        parent As assign
                    From
                        ss_user_dept_rights
                    Where
                        empno = v_hod_sec_empno
                );
        Else
            Select
                Listagg(assign, ',') Within
                    Group (Order By
                        assign)
            Into
                v_ret_val
            From
                (
                    Select
                        costcode As assign
                    From
                        ss_costmast
                    Where
                        hod = v_hod_sec_empno
                    Union
                    Select
                        parent As assign
                    From
                        ss_user_dept_rights
                    Where
                        empno = v_hod_sec_empno
                )
            Where
                assign In (
                    Select
                        regexp_substr(p_assign_codes_csv, '[^,]+', 1, level) value
                    From
                        dual
                    Connect By
                        level <=
                        length(p_assign_codes_csv) - length(replace(p_assign_codes_csv, ',')) + 1
                );

        End If;
        Return v_ret_val;
    Exception
        When Others Then
            Return Null;
    End;

    Function is_emp_laptop_user(
        p_empno Varchar2
    ) Return Number
    As
        v_laptop_count Number;
    Begin
        v_laptop_count := itinv_stk.dist.is_laptop_user(p_empno);
        If v_laptop_count > 0 Then
            Return 1;
        Else
            Return 0;
        End If;
    End;

    Function csv_to_ary_grades(
        p_grades_csv Varchar2 Default Null
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        If p_grades_csv Is Null Then
            Open c For
                Select
                    grade_id grade
                From
                    ss_vu_grades
                Where
                    grade_id <> '-';
        Else
            Open c For
                Select
                    regexp_substr(p_grades_csv, '[^,]+', 1, level) grade
                From
                    dual
                Connect By
                    level <=
                    length(p_grades_csv) - length(replace(p_grades_csv, ',')) + 1;
        End If;
    End;

    Function is_desk_in_general_area(p_deskid Varchar2) Return Boolean

    As
        v_general_area Varchar2(4) := 'A002';
        v_count        Number;
    Begin
        --Check if the desk is General desk.
        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_deskmaster d,
            dms.dm_desk_areas da
        Where
            deskid                = p_deskid
            And d.work_area       = da.area_key_id
            And da.area_catg_code = v_general_area;
        Return v_count = 1;

    End;


End iot_swp_common;
/
---------------------------
--New PACKAGE BODY
--IOT_SWP_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_QRY" As

    Function get_monday_date(p_date Date) Return Date As
        v_day_num Number;
    Begin
        v_day_num := to_number(to_char(p_date, 'd'));
        If v_day_num <= 2 Then
            Return p_date + (2 - v_day_num);
        Else
            Return p_date - v_day_num + 2;
        End If;

    End;

    Function get_friday_date(p_date Date) Return Date As
        v_day_num Number;
    Begin
        v_day_num := to_char(p_date, 'd');

        Return p_date + (6 - v_day_num);

    End;

    Function fn_emp_primary_workspace_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_assign_code Varchar2 Default Null,
        p_empno       Varchar2 Default Null,

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
        Open c For
            With
                assign_codes As (
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
                ),
                primary_work_space As(
                    Select
                        empno, a.primary_workspace, active_code
                    From
                        swp_primary_workspace a
                    Where
                        active_code = (
                            Select
                                Max(active_code)
                            From
                                swp_primary_workspace b
                            Where
                                b.empno = a.empno
                        )
                )
            Select
                *
            From
                (
                    Select
                        a.empno                                                           As empno,
                        a.name                                                            As employee_name,
                        a.assign,
                        a.parent,
                        a.office,
                        a.emptype,
                        iot_swp_common.get_emp_work_area(p_person_id, p_meta_id, a.empno) work_area,
                        --iot_swp_common.get_emp_dms_type_code(a.empno)                     emp_dms_type_code,
                        --iot_swp_common.get_emp_dms_type_desc(a.empno)                     emp_dms_type_desc,
                        a.grade                                                           As emp_grade,
                        nvl(b.primary_workspace, 0)                                       As primary_workspace,
                        Row_Number() Over(Order By a.empno)                               As row_number,
                        Count(*) Over()                                                   As total_row
                    From
                        ss_emplmast        a,
                        primary_work_space b,
                        assign_codes       ac
                    Where
                        a.empno      = b.empno(+)
                        And a.assign = ac.assign
                        And a.status = 1
                        And a.empno  = nvl(p_empno, a.empno)
                        And a.assign Not In (
                            Select
                                assign
                            From
                                swp_exclude_assign
                        )
                        And a.emptype In (
                            Select
                                emptype
                            From
                                swp_include_emptype
                        )

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End fn_emp_primary_workspace_list;

    /*
    Pass Date(dd-Mon-yyyy) and Get Week days 

     select
      next_day(to_date(:x,'DD-MON-YYYY'),'MON') +
        case when to_number(to_char(to_date(:x,'DD-MON-YYYY'),'D')) in (1,7) then -1 else -8 end +
        rownum dte
    from  dual
    connect by level <= 5;

    */

    Function fn_office_planning(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_query              Varchar2(4000);
        v_start_date         Date := get_monday_date(p_date) - 1;
        v_end_date           Date := get_friday_date(p_date);
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

        v_query := c_qry_office_planning;

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
        Open c For v_query Using v_empno, p_row_number, p_page_length, v_start_date, v_end_date, p_person_id, p_meta_id;

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
        v_start_date         Date := get_monday_date(p_date) - 1;
        v_end_date           Date := get_friday_date(p_date);
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
        v_start_date         Date := get_monday_date(trunc(p_date));
        v_end_date           Date := get_friday_date(trunc(p_date));
    Begin

        Open c For

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
                )

            Select
                e.empno                   As empno,
                dd.d_day,
                dd.d_date,
                nvl(atnd_days.planned, 0) As planned,
                atnd_days.deskid          As deskid
            From
                ss_emplmast     e,
                ss_days_details dd,
                atnd_days
            Where
                e.empno       = Trim(p_empno)
                And dd.d_date = atnd_days.attendance_date(+)
                And d_date Between v_start_date And v_end_date
            Order By
                dd.d_date;

        Return c;

    End;

    Function fn_work_area_for_smartwork(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_date        Date,

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

        Open c For
            Select
                *
            From
                (
                    /*Select
                    Distinct
                        area.area_key_id                              As work_area,
                        area.area_desc                                As area_desc,
                        area.AREA_CATG_CODE                           As AREA_CATG_CODE,
                        iot_swp_qry.get_area_total_desk(area.area_key_id)      As total_count, 
                        iot_swp_qry.get_area_occupied_desk(area.area_key_id)   As occupied_count,                         
                        ( 
                           iot_swp_qry.get_area_total_desk(area.area_key_id) 
                                -
                           iot_swp_qry.get_area_occupied_desk(area.area_key_id)                        
                        )                                             As available_count,
                        Row_Number() Over (Order By area_key_id Desc) row_number,
                        Count(*) Over ()                              total_row
                    From
                        dms.dm_desk_areas area*/

                    Select
                    Distinct
                        area.area_key_id                                     As work_area,
                        area.area_desc                                       As area_desc,
                        area.AREA_CATG_CODE                                  As AREA_CATG_CODE,
                        iot_swp_qry.get_area_total_desk(area.area_key_id)    As total_count,
                        iot_swp_qry.get_area_occupied_desk(area.area_key_id) As occupied_count,
                        (
                        iot_swp_qry.get_area_total_desk(area.area_key_id)
                        -
                        iot_swp_qry.get_area_occupied_desk(area.area_key_id)
                        )                                                    As available_count,
                        Row_Number() Over (Order By area_key_id Desc)        As row_number,
                        Count(*) Over ()                                     As total_row
                    From
                        dms.dm_desk_areas area
                    Where
                        area.AREA_CATG_CODE = 'OK'
                        And ((
                        iot_swp_qry.get_area_total_desk(area.area_key_id)
                        -
                        iot_swp_qry.get_area_occupied_desk(area.area_key_id)
                        ) > 0)
                    Union All
                    Select
                    Distinct
                        area.area_key_id                                     As work_area,
                        area.area_desc                                       As area_desc,
                        area.AREA_CATG_CODE                                  As AREA_CATG_CODE,
                        iot_swp_qry.get_area_total_desk(area.area_key_id)    As total_count,
                        iot_swp_qry.get_area_occupied_desk(area.area_key_id) As occupied_count,
                        (
                        iot_swp_qry.get_area_total_desk(area.area_key_id)
                        -
                        iot_swp_qry.get_area_occupied_desk(area.area_key_id)
                        )                                                    As available_count,
                        Row_Number() Over (Order By area_key_id Desc)        As row_number,
                        Count(*) Over ()                                     As total_row
                    From
                        dms.dm_desk_areas area
                    Where
                        area.AREA_CATG_CODE = 'KO'
                        And ((
                        iot_swp_qry.get_area_total_desk(area.area_key_id)
                        -
                        iot_swp_qry.get_area_occupied_desk(area.area_key_id)
                        ) > 0)
                        And Not Exists (
                            Select
                                *
                            From
                                dms.dm_desk_areas da
                            Where
                                da.AREA_CATG_CODE = 'OK'
                                And ((
                                iot_swp_qry.get_area_total_desk(da.area_key_id)
                                -
                                iot_swp_qry.get_area_occupied_desk(da.area_key_id)
                                ) > 0)
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                work_area;
        Return c;

    End fn_work_area_for_smartwork;

    Function fn_work_area_for_officework(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_date        Date,

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

        Open c For
            Select
                *
            From
                (
                    Select
                    Distinct
                        area.area_key_id                                     As work_area,
                        area.area_desc                                       As area_desc,
                        area.AREA_CATG_CODE                                  As AREA_CATG_CODE,
                        iot_swp_qry.get_area_total_desk(area.area_key_id)    As total_count,
                        iot_swp_qry.get_area_occupied_desk(area.area_key_id) As occupied_count,
                        (
                        iot_swp_qry.get_area_total_desk(area.area_key_id)
                        -
                        iot_swp_qry.get_area_occupied_desk(area.area_key_id)
                        )                                                    As available_count,
                        Row_Number() Over (Order By area_key_id Desc)        As row_number,
                        Count(*) Over ()                                     As total_row
                    From
                        dms.dm_desk_areas area
                    Where
                        area.AREA_CATG_CODE = 'KO'
                        And ((
                        iot_swp_qry.get_area_total_desk(area.area_key_id)
                        -
                        iot_swp_qry.get_area_occupied_desk(area.area_key_id)
                        ) > 0)

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                work_area;
        Return c;

    End fn_work_area_for_officework;

    Function fn_work_area_desk(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_date        Date,
        p_work_area   Varchar2,
        p_wing        Varchar2 Default Null,

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
                        And (p_wing Is Null Or mast.wing = p_wing)
                        --And mast.deskid Not In (Select Distinct b.deskid From swp_smart_attendance_plan b)
                        And mast.deskid
                        Not In(
                            Select
                            Distinct swptbl.deskid
                            From
                                swp_smart_attendance_plan swptbl
                                where (trunc(ATTENDANCE_DATE) = TRUNC(p_date) or p_date is null)
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

    Function get_area_total_desk(
        p_area_key_id Varchar2
    ) Return Number As
        v_count Number := 0;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_deskmaster mast
        Where
            Trim(mast.work_area) = Trim(p_area_key_id);

        Return v_count;
    End;

    Function get_area_occupied_desk(
        p_area_key_id Varchar2
    ) Return Number As
        v_count Number := 0;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_deskmaster mast
        Where
            Trim(mast.work_area) = Trim(p_area_key_id)
            And mast.deskid
            In (
                Select
                    swptbl.deskid
                From
                    swp_smart_attendance_plan swptbl
                Where
                    swptbl.attendance_date > sysdate
            );
        Return v_count;
    End;

    Function fn_area_list_for_smartwork(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return typ_area_list
        Pipelined
    Is
        tab_area_list_ok     typ_area_list;
        tab_area_list_ko     typ_area_list;
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        Open cur_area_list_for_ok(p_date,Null, Null, Null, p_row_number, p_page_length);
        Loop
            Fetch cur_area_list_for_ok Bulk Collect Into tab_area_list_ok Limit 50;
            For i In 1..tab_area_list_ok.count
            Loop
                /*
                  If (tab_area_list_ok(i).AVAILABLE_COUNT <= 0) Then

                               Open cur_area_list_for_ko(tab_area_list_ok(i).OFFICE, tab_area_list_ok(i).FLOOR, tab_area_list_ok(i).WING,
                               p_row_number,
                                                         p_page_length);
                               Loop
                                  Fetch cur_area_list_for_ko Bulk Collect Into tab_area_list_ko Limit 50;
                                  For i In 1..tab_area_list_ko.count
                                  Loop
                                     Pipe Row(tab_area_list_ko(i));
                                  End Loop;
                                  Exit When cur_area_list_for_ko%notfound;
                               End Loop;
                               Close cur_area_list_for_ko;

                             else

                              Pipe Row(tab_area_list_ok(i));

                            End If;
                */

                Pipe Row(tab_area_list_ok(i));

            End Loop;
            Exit When cur_area_list_for_ok%notfound;
        End Loop;
        Close cur_area_list_for_ok;
        Return;

    End fn_area_list_for_smartwork;

    Function fn_reserved_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return typ_area_list
        Pipelined
    Is
        tab_area_list_ok     typ_area_list;
        tab_area_list_ko     typ_area_list;
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        Open cur_area_list_for_ok(p_date,Null, Null, Null, p_row_number, p_page_length);
        Loop
            Fetch cur_area_list_for_ok Bulk Collect Into tab_area_list_ok Limit 50;
            For i In 1..tab_area_list_ok.count
            Loop
                Pipe Row(tab_area_list_ok(i));

            End Loop;
            Exit When cur_area_list_for_ok%notfound;
        End Loop;
        Close cur_area_list_for_ok;
        Return;

    End fn_reserved_area_list;

    Function fn_general_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return typ_area_list
        Pipelined
    Is
        tab_area_list_ko     typ_area_list;
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        Open cur_area_list_for_ko(Null, Null, Null, p_row_number, p_page_length);
        Loop
            Fetch cur_area_list_for_ko Bulk Collect Into tab_area_list_ko Limit 50;
            For i In 1..tab_area_list_ko.count
            Loop
                Pipe Row(tab_area_list_ko(i));

            End Loop;
            Exit When cur_area_list_for_ko%notfound;
        End Loop;
        Close cur_area_list_for_ko;
        Return;

    End fn_general_area_list;

End iot_swp_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_EXTRAHOURS
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_EXTRAHOURS" As

    Procedure sp_create_claim(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        p_yyyymm                Varchar2,
        p_lead_approver         Varchar2,
        p_selected_compoff_days typ_tab_string,
        p_weekend_totals        typ_tab_string,
        p_sum_compoff_hrs       Number,
        p_sum_weekday_extra_hrs Number,
        p_sum_holiday_extra_hrs Number,
        p_message_type Out      Varchar2,
        p_message_text Out      Varchar2
    ) As
        v_app_no                Varchar2(13);
        v_empno                 Varchar2(5);
        e_employee_not_found    Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_yyyymm_date           Date;
        v_app_mm                Varchar2(2);
        v_app_yyyy              Varchar2(4);
        v_lead_apprl            Number;
        v_lead_apprd_ot         Number;
        v_lead_apprd_hhot       Number;
        v_lead_apprd_co         Number;
        v_lead_apprl_empno      Varchar2(5);
        v_day_date              Date;
        v_co_day                Number;
        v_pos                   Number;
        v_prev_pos              Number;
        v_week_claim_co         Number;
        v_week_claim_othh       Number;
        v_week_claim_otwrk      Number;
        v_week_applicable_otwrk Number;
        v_week_applicable_othh  Number;

    Begin
        v_empno            := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;
        v_yyyymm_date      := to_date(p_yyyymm, 'yyyymm');
        v_app_mm           := substr(p_yyyymm, 5, 2);
        v_app_yyyy         := substr(p_yyyymm, 1, 4);
        v_app_no           := v_empno || '_' || v_app_mm || '_' || v_app_yyyy;
        If nvl(p_sum_compoff_hrs, 0) = 0 And nvl(p_sum_weekday_extra_hrs, 0) = 0 And nvl(p_sum_holiday_extra_hrs, 0) = 0 Then
            p_message_type := 'KO';
            p_message_text := 'CompOff/Extrahours not claimed. Cannot create claim.';
            Return;
        End If;
        v_lead_apprl_empno := upper(trim(p_lead_approver));
        If v_lead_apprl_empno = 'NONE' Then
            v_lead_apprl      := 4;
            v_lead_apprd_ot   := nvl(p_sum_weekday_extra_hrs, 0);
            v_lead_apprd_hhot := nvl(p_sum_holiday_extra_hrs, 0);
            v_lead_apprd_co   := nvl(p_sum_compoff_hrs, 0);
        End If;
        Insert Into ss_otmaster (
            app_no,
            app_date,
            empno,
            mon,
            yyyy,
            month,
            ot,
            hhot,
            co,
            lead_apprl_empno,
            lead_apprl,
            lead_apprd_ot,
            lead_apprd_hhot,
            lead_apprd_co,
            hod_apprl,
            hrd_apprl
        )
        Values(
            v_app_no,
            sysdate,
            v_empno,
            v_app_mm,
            v_app_yyyy,
            to_char(v_yyyymm_date, 'Mon'),
            p_sum_weekday_extra_hrs,
            p_sum_holiday_extra_hrs,
            p_sum_compoff_hrs,
            v_lead_apprl_empno,
            v_lead_apprl,
            v_lead_apprd_ot,
            v_lead_apprd_hhot,
            v_lead_apprd_co,
            0,
            0
        );

        Insert Into ss_otdetail(
            empno,
            mon,
            yyyy,
            day,
            d_details,
            w_details,
            of_mon,
            app_no,
            wk_of_year,
            day_yyyy
        )
        Select
            v_empno,
            v_app_mm,
            v_app_yyyy,
            dd,
            to_char(punch_date, 'dd-Mon-yyyy') || ';' ||
            ddd || ';' ||
            shift_code || ';' ||
            first_punch || ';' ||
            last_punch || ';' ||
            to_hrs(wrk_hrs) || ';' ||
            to_hrs(delta_hrs) || ';' ||
            to_hrs(extra_hrs) || ';' ||
            remarks || ';' ||
            get_holiday(trunc(punch_date)) || ';' d_details,
            Case
                When is_sunday = 2 Then
                    wk_sum_work_hrs || ';' || wk_bfwd_delta_hrs || ';' || wk_cfwd_delta_hrs || ';' || wk_penalty_leave_hrs ||
                    ';' || wk_sum_delta_hrs || ';'
                Else
                    ''
            End                                   w_details,
            to_char(punch_date, 'mm'),
            v_app_no,
            wk_of_year,
            to_char(punch_date, 'yyyy')
        From
            Table(iot_punch_details.fn_punch_details_4_self(
                    p_person_id => p_person_id,
                    p_meta_id   => Null,
                    p_empno     => v_empno,
                    p_yyyymm    => p_yyyymm,
                    p_for_ot    => 'OK')
            );
        --p_message_type     := 'OK';
        --Return;
        For i In 1..p_selected_compoff_days.count

        Loop
            With
                csv As (
                    Select
                        p_selected_compoff_days(i) str
                    From
                        dual
                )
            Select
                to_date(regexp_substr(str, '[^,]+', 1, 1), 'dd-Mon-yyyy') c1,
                to_number(regexp_substr(str, '[^,]+', 1, 2))              c2
            Into
                v_day_date, v_pos
            From
                csv;
            Update
                ss_otdetail
            Set
                co_bool = 1
            Where
                app_no       = v_app_no
                And day_yyyy = to_char(v_day_date, 'yyyy')
                And of_mon   = to_char(v_day_date, 'mm')
                And day      = to_number(to_char(v_day_date, 'dd'));

        End Loop;
        /*
                p_message_type     := 'OK';
                Return;
        */
        For i In 1..p_weekend_totals.count
        Loop
            With
                csv As (
                    Select
                        p_weekend_totals(i) str
                    From
                        dual
                )
            Select
                to_date(regexp_substr(str, '[^,]+', 1, 1), 'dd-Mon-yyyy') c1,
                to_number(regexp_substr(str, '[^,]+', 1, 2))              c2,
                to_number(regexp_substr(str, '[^,]+', 1, 3))              c3,
                to_number(regexp_substr(str, '[^,]+', 1, 4))              c4,
                to_number(regexp_substr(str, '[^,]+', 1, 5))              c5,
                to_number(regexp_substr(str, '[^,]+', 1, 6))              c6
            Into
                v_day_date,
                v_week_claim_co,
                v_week_applicable_othh,
                v_week_claim_othh,
                v_week_applicable_otwrk,
                v_week_claim_otwrk
            From
                csv;
            Update
                ss_otdetail
            Set
                w_co = v_week_claim_co,
                w_ot_max = v_week_applicable_otwrk,
                w_ot_claim = v_week_claim_otwrk,
                w_hhot_max = v_week_applicable_othh,
                w_hhot_claim = v_week_claim_othh
            Where
                app_no       = v_app_no
                And day_yyyy = to_char(v_day_date, 'yyyy')
                And of_mon   = to_char(v_day_date, 'mm')
                And day      = to_number(to_char(v_day_date, 'dd'));
        End Loop;

        p_message_type     := 'OK';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_create_claim;

    Procedure sp_delete_claim(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_claim_no         Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin

        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;
        Delete
            From ss_otdetail
        Where
            app_no = p_claim_no;
        Delete
            From ss_otmaster
        Where
            app_no = p_claim_no;
        Commit;
        p_message_type := 'OK';
        p_message_text := 'Claim deleted successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_claim;

    Procedure sp_extra_hrs_adjst_details(
        p_application_id         Varchar2,
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_emp_name           Out Varchar2,
        p_claim_no           Out Varchar2,

        p_claimed_ot         Out Varchar2,
        p_claimed_hhot       Out Varchar2,
        p_claimed_co         Out Varchar2,

        p_lead_approved_ot   Out Varchar2,
        p_lead_approved_hhot Out Varchar2,
        p_lead_approved_co   Out Varchar2,

        p_hod_approved_ot    Out Varchar2,
        p_hod_approved_hhot  Out Varchar2,
        p_hod_approved_co    Out Varchar2,

        p_hr_approved_ot     Out Varchar2,
        p_hr_approved_hhot   Out Varchar2,
        p_hr_approved_co     Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
    ) As

        v_onduty_app ss_ondutyapp%rowtype;
        v_depu       ss_depu%rowtype;
        v_empno      Varchar2(5);
        v_count      Number;

    Begin

        Select
            Count(*)
        Into
            v_count
        From
            ss_otmaster
        Where
            Trim(app_no) = Trim(p_application_id);

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;

        Select
            e.empno || ' - ' || e.name,
            a.app_no,
            nvl(a.ot / 60, 0),
            nvl(a.hhot / 60, 0),
            nvl(a.co / 60, 0),
            nvl(a.lead_apprd_ot / 60, 0),
            nvl(a.lead_apprd_hhot, 0),
            nvl(a.lead_apprd_co, 0),
            nvl(a.hod_apprd_ot, 0),
            nvl(a.hod_apprd_hhot, 0),
            nvl(a.hod_apprd_co, 0),
            Case
                When nvl(a.hrd_apprd_ot, 0) = 0 Then
                    Null
                Else
                    a.hrd_apprd_ot
            End,
            Case
                When nvl(a.hrd_apprd_hhot, 0) = 0 Then
                    Null
                Else
                    a.hrd_apprd_hhot
            End,
            Case
                When nvl(a.hrd_apprd_co, 0) = 0 Then
                    Null
                Else
                    a.hrd_apprd_co
            End
        Into
            p_emp_name,
            p_claim_no,
            p_claimed_ot,
            p_claimed_hhot,
            p_claimed_co,
            p_lead_approved_ot,
            p_lead_approved_hhot,
            p_lead_approved_co,
            p_hod_approved_ot,
            p_hod_approved_hhot,
            p_hod_approved_co,
            p_hr_approved_ot,
            p_hr_approved_hhot,
            p_hr_approved_co
        From
            ss_otmaster a,
            ss_emplmast e
        Where
            a.empno      = e.empno
            And a.app_no = p_application_id;

        p_message_type := 'OK';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_extra_hrs_adjst_details;

    Procedure sp_claim_approval(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_approvals  typ_tab_string,
        p_approver_profile Number,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_app_no         Varchar2(70);
        v_approval       Number;
        v_remarks        Varchar2(70);
        v_count          Number;
        v_rec_count      Number;
        sqlpart1         Varchar2(60) := 'Update SS_OTMaster ';
        sqlpart2         Varchar2(500);
        sqlpart3         Varchar2(500);
        strsql           Varchar2(1000);
        v_otmaster_rec   ss_otmaster%rowtype;
        v_approver_empno Varchar2(5);
        v_user_tcp_ip    Varchar2(30);
        v_msg_type       Number;
        v_msg_text       Varchar2(1000);
    Begin

        v_approver_empno := get_empno_from_meta_id(p_meta_id);
        If v_approver_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        sqlpart3         := ' ';
        sqlpart2         := ' set ApproverProfile_APPRL = :Approval, ApproverProfile_Code = :Approver_EmpNo, ApproverProfile_APPRL_DT = Sysdate,
                    ApproverProfile_TCP_IP = :User_TCP_IP , ApproverProfile_Remarks = :Remarks ';
        If p_approver_profile = user_profile.type_hod Or p_approver_profile = user_profile.type_sec Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HOD');

            sqlpart3 := sqlpart3 || ', HOD_Apprd_OT = Lead_Apprd_OT, ';
            sqlpart3 := sqlpart3 || 'HOD_Apprd_HHOT = Lead_Apprd_HHOT, ';
            sqlpart3 := sqlpart3 || 'HOD_Apprd_CO = Lead_Apprd_CO ';
        Elsif p_approver_profile = user_profile.type_hrd Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HRD');

            sqlpart3 := sqlpart3 || ', HRD_Apprd_OT = HOD_Apprd_OT, ';
            sqlpart3 := sqlpart3 || 'HRD_Apprd_HHOT = HOD_Apprd_HHOT, ';
            sqlpart3 := sqlpart3 || 'HRD_Apprd_CO = HOD_Apprd_CO ';
        Elsif p_approver_profile = user_profile.type_lead Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'LEAD');

            sqlpart3 := sqlpart3 || ', Lead_Apprd_OT = OT, ';
            sqlpart3 := sqlpart3 || 'Lead_Apprd_HHOT = HHOT, ';
            sqlpart3 := sqlpart3 || 'Lead_Apprd_CO = CO ';
        End If;

        For i In 1..p_claim_approvals.count
        Loop

            With
                csv As (
                    Select
                        p_claim_approvals(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1))            app_no,
                to_number(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) approval
            Into
                v_app_no, v_approval
            From
                csv;

            /*
            p_message_type := 'OK';
            p_message_text := 'Debug 1 - ' || p_leave_approvals(i);
            Return;
            */
            strsql := sqlpart1 || ' ' || sqlpart2;

            If v_approval = ss.approved Then
                strsql := strsql || ' ' || sqlpart3;
            End If;
            strsql := strsql || '  Where App_No = :p_app_no';
            /*
            p_message_type := 'OK';
            p_message_text := 'Debug - ' || v_approval || ' - ' || strsql;
            Return;
            */
            Execute Immediate strsql
                Using v_approval, v_approver_empno, v_user_tcp_ip, v_remarks, trim(v_app_no);

            If p_approver_profile = user_profile.type_hrd And v_approval = ss.approved Then
                Select
                    *
                Into
                    v_otmaster_rec
                From
                    ss_otmaster
                Where
                    app_no = v_app_no;

                If nvl(v_otmaster_rec.hrd_apprd_co, 0) > 0 Then
                    Insert Into ss_leaveledg(
                        app_no,
                        app_date,
                        leavetype,
                        description,
                        empno,
                        leaveperiod,
                        db_cr,
                        bdate,
                        adj_type
                    )
                    Values(
                        v_app_no,
                        sysdate,
                        'CO',
                        'Compensatory Off Credit',
                        v_otmaster_rec.empno,
                        v_otmaster_rec.hrd_apprd_co / 60,
                        'C',
                        to_date(v_otmaster_rec.yyyy || v_otmaster_rec.mon, 'yyyymm'),
                        'CO'

                    );

                End If;
            End If;

        End Loop;

        Commit;
        p_message_type   := 'OK';
        p_message_text   := 'Procedure executed successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_claim_approval;

    Procedure sp_claim_approval_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin

        sp_claim_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_claim_approvals  => p_claim_approvals,
            p_approver_profile => user_profile.type_lead,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End sp_claim_approval_lead;

    Procedure sp_claim_approval_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_claim_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_claim_approvals  => p_claim_approvals,
            p_approver_profile => user_profile.type_hod,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End sp_claim_approval_hod;

    Procedure sp_claim_approval_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_claim_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_claim_approvals  => p_claim_approvals,
            p_approver_profile => user_profile.type_hrd,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End sp_claim_approval_hr;

    Procedure sp_claim_adjustment(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_no         Varchar2,
        p_approved_ot      Number,
        p_approved_hhot    Number,
        p_approved_co      Number,
        p_approver_profile Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_app_no         Varchar2(70);
        v_approval       Number;
        v_remarks        Varchar2(70);
        v_count          Number;
        v_rec_count      Number;
        sqlpart1         Varchar2(60) := 'Update SS_OTMaster ';
        sqlpart2         Varchar2(500);
        sqlpart3         Varchar2(500);
        strsql           Varchar2(1000);
        v_otmaster_rec   ss_otmaster%rowtype;
        v_approver_empno Varchar2(5);
        v_user_tcp_ip    Varchar2(30);
        v_msg_type       Number;
        v_msg_text       Varchar2(1000);
    Begin
        v_approver_empno := get_empno_from_meta_id(p_meta_id);
        If v_approver_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        v_app_no         := trim(p_claim_no);
        v_approval       := ss.approved;
        sqlpart2         := ' set ApproverProfile_APPRL = :Approval, ApproverProfile_Code = :Approver_EmpNo, ApproverProfile_APPRL_DT = Sysdate,
                    ApproverProfile_TCP_IP = :User_TCP_IP , ApproverProfile_Remarks = :Remarks ';
        sqlpart3         := ', ';
        sqlpart3         := sqlpart3 || ' ApproverProfile_Apprd_OT = :Apprd_OT, ';
        sqlpart3         := sqlpart3 || ' ApproverProfile_Apprd_HHOT = :Apprd_HHOT, ';
        sqlpart3         := sqlpart3 || ' ApproverProfile_Apprd_CO = :Apprd_CO ';

        strsql           := sqlpart1 || sqlpart2 || sqlpart3 || '  Where trim(App_No) = trim(:p_app_no)';

        If p_approver_profile = user_profile.type_hod Or p_approver_profile = user_profile.type_sec Then
            strsql := replace(strsql, 'ApproverProfile', 'HOD');

        Elsif p_approver_profile = user_profile.type_hrd Then
            strsql := replace(strsql, 'ApproverProfile', 'HRD');

        Elsif p_approver_profile = user_profile.type_lead Then
            strsql := replace(strsql, 'ApproverProfile', 'LEAD');

        End If;
        /*
        p_message_type   := 'OK';
        p_message_text   := strsql;
        return;
        */
        Execute Immediate strsql
            Using v_approval, v_approver_empno, v_user_tcp_ip, v_remarks, p_approved_ot, p_approved_hhot, p_approved_co, trim(
            v_app_no);
        If p_approver_profile = user_profile.type_hrd And v_approval = ss.approved Then
            Select
                *
            Into
                v_otmaster_rec
            From
                ss_otmaster
            Where
                app_no = v_app_no;

            If nvl(v_otmaster_rec.hrd_apprd_co, 0) > 0 Then
                Insert Into ss_leaveledg(
                    app_no,
                    app_date,
                    leavetype,
                    description,
                    empno,
                    leaveperiod,
                    db_cr,
                    bdate,
                    adj_type
                )
                Values(
                    v_app_no,
                    sysdate,
                    'CO',
                    'Compensatory Off Credit',
                    v_otmaster_rec.empno,
                    v_otmaster_rec.hrd_apprd_co / 60,
                    'C',
                    to_date(v_otmaster_rec.yyyy || v_otmaster_rec.mon, 'yyyymm'),
                    'CO'

                );

            End If;
        End If;

        Commit;
        p_message_type   := 'OK';
        p_message_text   := 'Procedure executed successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_claim_adjustment_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_no         Varchar2,
        p_approved_ot      Number,
        p_approved_hhot    Number,
        p_approved_co      Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_claim_adjustment(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_claim_no         => p_claim_no,
            p_approved_ot      => p_approved_ot,
            p_approved_hhot    => p_approved_hhot,
            p_approved_co      => p_approved_co,
            p_approver_profile => user_profile.type_lead,

            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_claim_adjustment_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_no         Varchar2,
        p_approved_ot      Number,
        p_approved_hhot    Number,
        p_approved_co      Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_claim_adjustment(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_claim_no         => p_claim_no,
            p_approved_ot      => p_approved_ot,
            p_approved_hhot    => p_approved_hhot,
            p_approved_co      => p_approved_co,
            p_approver_profile => user_profile.type_hod,

            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_claim_adjustment_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_claim_no         Varchar2,
        p_approved_ot      Number,
        p_approved_hhot    Number,
        p_approved_co      Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_claim_adjustment(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_claim_no         => p_claim_no,
            p_approved_ot      => p_approved_ot,
            p_approved_hhot    => p_approved_hhot,
            p_approved_co      => p_approved_co,
            p_approver_profile => user_profile.type_hrd,

            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_check_claim_exists(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_yyyymm           Varchar2,
        p_claim_exists Out Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_count              Number;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_otmaster
        Where
            empno    = v_empno
            And mon  = substr(p_yyyymm, 5, 2)
            And yyyy = substr(p_yyyymm, 1, 4);
        If v_count > 0 Then
            p_claim_exists := 'OK';
        Else
            p_claim_exists := 'KO';
        End If;
        p_message_type := 'OK';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_check_claim_exists;
End iot_extrahours;
/
---------------------------
--Changed PACKAGE BODY
--PKG_ABSENT_TS
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."PKG_ABSENT_TS" As

    Function get_payslip_month Return Varchar2 Is
        v_payslip_month_rec ss_absent_payslip_period%rowtype;
        v_ret_val           Varchar2(7);
    Begin
        Select
            *
        Into
            v_payslip_month_rec
        From
            ss_absent_payslip_period
        Where
            is_open = 'OK';

        Return v_payslip_month_rec.period;
    Exception
        When Others Then
            Return 'ERR';
    End;

    Procedure check_payslip_month_isopen(
        param_payslip_yyyymm Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
        v_open_payslip_yyyymm Varchar2(10);
    Begin
        v_open_payslip_yyyymm := get_payslip_month;
        If v_open_payslip_yyyymm <> param_payslip_yyyymm Then
            param_success := 'KO';
            param_message := 'Err - Payslip month "' || param_payslip_yyyymm || '" is not open in the system';
            Return;
        Else
            param_success := 'OK';
        End If;

    End;

    Procedure generate_list(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_empno          Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        v_key_id      Varchar2(8);
        v_first_day   Date;
        v_last_day    Date;
        v_requester   Varchar2(5);
        v_param_empno Varchar2(10);
    Begin
        v_first_day   := to_date(param_absent_yyyymm || '01', 'yyyymmdd');
        If param_absent_yyyymm = '202003' Then
            v_last_day := To_Date('20-Mar-2020', 'dd-Mon-yyyy');
        Else
            v_last_day := last_day(v_first_day);
        End If;

        v_key_id      := dbms_random.string('X', 8);
        v_requester   := ss.get_empno(param_requester);
        If param_empno = 'ALL' Then
            v_param_empno := '%';
        Else
            v_param_empno := param_empno || '%';
        End If;

        Delete
            From ss_absent_ts_detail
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm
            And empno Like v_param_empno;
        --commit;
        --param_success   := 'OK';
        --return;
        If param_empno = 'ALL' Then
            Delete
                From ss_absent_ts_master
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm;

            Insert Into ss_absent_ts_master (
                absent_yyyymm,
                payslip_yyyymm,
                modified_on,
                modified_by,
                key_id
            )
            Values (
                param_absent_yyyymm,
                param_payslip_yyyymm,
                sysdate,
                v_requester,
                v_key_id
            );

        Else
            Select
                key_id
            Into
                v_key_id
            From
                ss_absent_ts_master
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm;

        End If;

        Commit;
        Insert Into ss_absent_ts_detail (
            key_id,
            absent_yyyymm,
            payslip_yyyymm,
            empno,
            absent_days,
            cl_bal,
            sl_bal,
            pl_bal,
            co_bal
        )
        Select
            v_key_id,
            param_absent_yyyymm,
            param_payslip_yyyymm,
            empno,
            absent_days,
            closingclbal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) cl_bal,
            closingslbal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) sl_bal,
            closingplbal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) pl_bal,
            closingcobal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) co_bal
        From
            (
                Select
                    empno,
                    Listagg(dy, ', ') Within
                        Group (Order By dy) As absent_days
                From
                    (
                        Select
                            a.empno,
                            b.day_no                        dy,
                            is_emp_absent(a.empno, b.tdate) is_emp_absent
                        From
                            ss_emplmast        a,
                            ss_absent_ts_leave b
                        Where
                            b.yyyymm     = Trim(Trim(param_absent_yyyymm))
                            And a.empno  = b.empno
                            And a.status = 1
                            And a.parent Not In (
                                Select
                                    parent
                                From
                                    ss_dept_not_4_absent
                            )
                            And a.emptype In (
                                'R', 'F'
                            )
                            And a.empno Like v_param_empno
                            And b.leave_hrs > 0
                    )
                Where
                    is_emp_absent = 1
                Group By empno
            );

        Commit;
        param_success := 'OK';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End generate_list;

    Procedure generate_nu_list_4_all_emp(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Delete
            From ss_absent_as_lop
        Where
            payslip_yyyymm                    = param_payslip_yyyymm
            And to_char(lop_4_date, 'yyyymm') = param_absent_yyyymm;

        pop_timesheet_leave_data(
            param_yyyymm  => param_absent_yyyymm,
            param_success => param_success,
            param_message => param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        generate_list(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            'ALL',
            param_requester,
            param_success,
            param_message
        );
    End generate_nu_list_4_all_emp;

    Procedure pop_timesheet_leave_data(
        param_yyyymm      Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) As
    Begin
        Delete
            From ss_absent_ts_leave
        Where
            yyyymm = param_yyyymm;

        Insert Into ss_absent_ts_leave (
            yyyymm,
            empno,
            projno,
            wpcode,
            activity,
            day_no,
            tdate,
            leave_hrs
        )
        Select
            yymm,
            empno,
            projno,
            wpcode,
            activity,
            day_no,
            t_date,
            Sum(colvalue)
        From
            (
                Select
                    yymm,
                    empno,
                    projno,
                    wpcode,
                    activity,
                    day_no,
                    to_date(yymm || '-' || day_no, 'yyyymm-dd') t_date,
                    colvalue
                From
                    (
                        With
                            t As (
                                Select
                                    yymm,
                                    empno,
                                    parent,
                                    assign,
                                    a.projno,
                                    wpcode,
                                    activity,
                                    d1,
                                    d2,
                                    d3,
                                    d4,
                                    d5,
                                    d6,
                                    d7,
                                    d8,
                                    d9,
                                    d10,
                                    d11,
                                    d12,
                                    d13,
                                    d14,
                                    d15,
                                    d16,
                                    d17,
                                    d18,
                                    d19,
                                    d20,
                                    d21,
                                    d22,
                                    d23,
                                    d24,
                                    d25,
                                    d26,
                                    d27,
                                    d28,
                                    d29,
                                    d30,
                                    d31
                                From
                                    timecurr.time_daily a,
                                    timecurr.tm_leave   b
                                Where
                                    substr(a.projno, 1, 5) = b.projno
                                    And a.wpcode <> 4
                                    And yymm               = param_yyyymm
                            )
                        Select
                            yymm,
                            empno,
                            parent,
                            assign,
                            projno,
                            wpcode,
                            activity,
                            to_number(replace(col, 'D', '')) day_no,
                            colvalue
                        From
                            t Unpivot (colvalue
                            For col
                            In (d1,
                            d2,
                            d3,
                            d4,
                            d5,
                            d6,
                            d7,
                            d8,
                            d9,
                            d10,
                            d11,
                            d12,
                            d13,
                            d14,
                            d15,
                            d16,
                            d17,
                            d18,
                            d19,
                            d20,
                            d21,
                            d22,
                            d23,
                            d24,
                            d25,
                            d26,
                            d27,
                            d28,
                            d29,
                            d30,
                            d31))
                    )
                Where
                    day_no <= to_number(to_char(last_day(to_date(param_yyyymm, 'yyyymm')), 'dd'))
            )
        --Where
        --colvalue > 0
        Group By
            yymm,
            empno,
            projno,
            wpcode,
            activity,
            day_no,
            t_date;

        Commit;
        param_success := 'OK';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure update_no_mail_list(
        param_absent_yyyymm      Varchar2,
        param_payslip_yyyymm     Varchar2,
        param_emp_list_4_no_mail Varchar2,
        param_requester          Varchar2,
        param_success Out        Varchar2,
        param_message Out        Varchar2
    ) As
    Begin
        Null;
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        If Trim(param_emp_list_4_no_mail) Is Null Then
            param_success := 'KO';
            param_message := 'Err - Employee List for NO-MAIL is blank.';
            Return;
        End If;

        Update
            ss_absent_ts_detail
        Set
            no_mail = Null
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm;

        Commit;
        Update
            ss_absent_ts_detail
        Set
            no_mail = 'OK'
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm
            And empno In (
                Select
                    column_value empno
                From
                    Table (ss.csv_to_table(param_emp_list_4_no_mail))
            );

        Commit;
        param_success := 'OK';
        param_message := 'Employee List for NO-MAIL successfully updated';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            Rollback;
    End;

    Function get_lop(
        param_empno Varchar2,
        param_pdate Date
    ) Return Number Is
        v_lop Number;
    Begin
        Select
            half_full
        Into
            v_lop
        From
            ss_absent_ts_lop
        Where
            empno          = param_empno
            And lop_4_date = param_pdate;

        Return v_lop;
    Exception
        When Others Then
            Return 0;
    End;

    Procedure set_lop_4_emp(
        param_empno          Varchar2,
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_lop_val        Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        Cursor c1 Is
            Select
                column_value
            From
                Table (ss.csv_to_table(param_lop_val));

        Type typ_tab Is
            Table Of c1%rowtype Index By Binary_Integer;
        v_tab  typ_tab;
        v_day  Varchar2(5);
        v_lop  Varchar2(5);
        v_cntr Number;
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        param_success := 'KO';
        v_cntr        := 0;
        For c2 In c1
        Loop
            v_cntr := v_cntr + 1;
            v_day  := lpad(substr(c2.column_value, 1, instr(c2.column_value, '-') - 1), 2, '0');

            v_lop  := substr(c2.column_value, instr(c2.column_value, '-') + 1);

            Insert Into ss_absent_ts_lop (
                empno,
                lop_4_date,
                payslip_yyyymm,
                half_full,
                entry_date
            )
            Values (
                param_empno,
                to_date(param_absent_yyyymm || v_day, 'yyyymmdd'),
                param_payslip_yyyymm,
                v_lop,
                sysdate
            );

        End Loop;

        If v_cntr > 0 Then
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                param_empno,
                param_requester,
                param_success,
                param_message
            );
        Else
            param_success := 'KO';
            param_message := 'Err - Zero rows updated.';
        End If;

    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            Rollback;
    End;

    Procedure regenerate_list_4_one_emp(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_empno          Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        generate_list(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            param_empno,
            param_requester,
            param_success,
            param_message
        );
    End;

    Procedure reset_emp_lop(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_empno          Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Delete
            From ss_absent_ts_lop
        Where
            payslip_yyyymm                    = param_payslip_yyyymm
            And to_char(lop_4_date, 'yyyymm') = param_absent_yyyymm
            And empno                         = param_empno;

        Commit;
        regenerate_list_4_one_emp(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            param_empno,
            param_requester,
            param_success,
            param_message
        );
    End;

    Procedure delete_user_lop(
        param_empno          Varchar2,
        param_payslip_yyyymm Varchar2,
        param_absent_yyyymm  Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        Delete
            From ss_absent_ts_lop
        Where
            empno                             = param_empno
            And payslip_yyyymm                = param_payslip_yyyymm
            And to_char(lop_4_date, 'yyyymm') = param_absent_yyyymm;

        Commit;
        regenerate_list_4_one_emp(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            param_empno,
            param_requester,
            param_success,
            param_message
        );
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure refresh_absent_list(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        v_count            Number;
        v_absent_list_date Date;
        Cursor cur_onduty Is
            With
                absent_list As (
                    Select
                        empno
                    From
                        ss_absent_ts_detail
                    Where
                        absent_yyyymm      = param_absent_yyyymm
                        And payslip_yyyymm = param_payslip_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_absent_ts_lop
                    Where
                        payslip_yyyymm = param_payslip_yyyymm
                )
            Select
            Distinct
                empno
            From
                (
                    Select
                        empno
                    From
                        ss_ondutyapp
                    Where
                        app_date >= trunc(v_absent_list_date)
                        And type In ('OD', 'IO')
                        And nvl(lead_apprl, 0) <> 2
                        And nvl(hod_apprl, 0) <> 2
                        And nvl(hrd_apprl, 0) <> 2
                        And to_char(pdate, 'yyyymm') = param_absent_yyyymm
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                    Union
                    Select
                        empno
                    From
                        ss_ondutyapp_deleted
                    Where
                        deleted_on >= trunc(v_absent_list_date)
                        And type In ('OD', 'IO')
                        And to_char(pdate, 'yyyymm') = param_absent_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_ondutyapp_rejected
                    Where
                        rejected_on >= trunc(v_absent_list_date)
                        And type In ('OD', 'IO')
                        And to_char(pdate, 'yyyymm') = param_absent_yyyymm
                );

        Cursor cur_depu Is
            With
                absent_list As (
                    Select
                        empno
                    From
                        ss_absent_ts_detail
                    Where
                        absent_yyyymm      = param_absent_yyyymm
                        And payslip_yyyymm = param_payslip_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_absent_ts_lop
                    Where
                        payslip_yyyymm = param_payslip_yyyymm
                )
            Select
            Distinct
                empno
            From
                (
                    Select
                        empno
                    From
                        ss_depu
                    Where
                        (app_date >= trunc(v_absent_list_date)
                            Or chg_date >= trunc(v_absent_list_date))
                        And type In ('OT', 'DP')
                        And nvl(hod_apprl, 0) <> 2
                        And nvl(hrd_apprl, 0) <> 2
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                    Union
                    Select
                        empno
                    From
                        ss_depu_deleted
                    Where
                        deleted_on >= trunc(v_absent_list_date)
                        And type In ('OT', 'DP')
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_depu_rejected
                    Where
                        rejected_on >= trunc(v_absent_list_date)
                        And type In ('OT', 'DP')
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_depu_hist
                    Where
                        empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                        And type In ('OT', 'DP')
                        And chg_date >= trunc(v_absent_list_date)
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                );

        Cursor cur_leave Is
            With
                absent_list As (
                    Select
                        empno
                    From
                        ss_absent_ts_detail
                    Where
                        absent_yyyymm      = param_absent_yyyymm
                        And payslip_yyyymm = param_payslip_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_absent_ts_lop
                    Where
                        payslip_yyyymm = param_payslip_yyyymm
                )
            Select
            Distinct
                empno
            From
                (
                    Select
                        empno
                    From
                        ss_leaveapp
                    Where
                        (app_date >= trunc(v_absent_list_date))
                        And nvl(lead_apprl, 0) <> 2
                        And nvl(hod_apprl, 0) <> 2
                        And nvl(hrd_apprl, 0) <> 2
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                    Union
                    Select
                        empno
                    From
                        ss_leave_adj
                    Where
                        (adj_dt >= trunc(v_absent_list_date))
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_leaveapp_deleted
                    Where
                        deleted_on >= trunc(v_absent_list_date)
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_leaveapp_rejected
                    Where
                        rejected_on >= trunc(v_absent_list_date)
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                );
        v_sysdate          Date := sysdate;
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Begin
            Select
                nvl(refreshed_on, modified_on)
            Into
                v_absent_list_date
            From
                ss_absent_ts_master
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm;

        Exception
            When Others Then
                param_success := 'KO';
                param_message := 'Absent list not yet generated for the said period.';
                Return;
        End;

        For c_empno In cur_onduty
        Loop
            Null;
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                c_empno.empno,
                param_requester,
                param_success,
                param_message
            );
        End Loop;

        For c_empno In cur_depu
        Loop
            Null;
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                c_empno.empno,
                param_requester,
                param_success,
                param_message
            );
        End Loop;

        For c_empno In cur_leave
        Loop
            Null;
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                c_empno.empno,
                param_requester,
                param_success,
                param_message
            );
        End Loop;
        Update
            ss_absent_ts_master
        Set
            refreshed_on = v_sysdate
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm;

        Commit;
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Function is_emp_absent(
        param_empno In Varchar2,
        param_date  In Date
    ) Return Number As

        v_count           Number;
        c_is_absent       Constant Number := 1;
        c_not_absent      Constant Number := 0;
        c_leave_depu_tour Constant Number := 2;
        v_on_ldt          Number;
        v_ldt_appl        Number;
    Begin
        v_on_ldt   := isleavedeputour(param_date, param_empno);
        If v_on_ldt = 1 Then
            Return c_not_absent;
        End If;
        v_ldt_appl := isldt_appl(param_empno, param_date);
        If v_ldt_appl > 0 Then
            Return c_not_absent;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_absent_ts_lop
        Where
            empno          = param_empno
            And lop_4_date = param_date;

        If v_count > 0 Then
            Return c_not_absent;
        End If;
        Return c_is_absent;
    End is_emp_absent;

    Procedure reverse_lop_4_emp(
        param_empno          Varchar2,
        param_payslip_yyyymm Varchar2,
        param_lop_val        Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        Cursor c1 Is
            Select
                column_value
            From
                Table (ss.csv_to_table(param_lop_val));

        Type typ_tab Is
            Table Of c1%rowtype Index By Binary_Integer;
        v_tab  typ_tab;
        v_day  Varchar2(8);
        v_lop  Varchar2(5);
        v_cntr Number;
        v_date Date;
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Begin
            v_date := to_date(param_payslip_yyyymm, 'yyyymm');
        Exception
            When Others Then
                param_success := 'KO';
                param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
                Return;
        End;

        param_success := 'KO';
        v_cntr        := 0;
        For c2 In c1
        Loop
            v_cntr := v_cntr + 1;
            v_day  := substr(c2.column_value, 1, instr(c2.column_value, '-') - 1);

            v_lop  := substr(c2.column_value, instr(c2.column_value, '-') + 1);

            Insert Into ss_absent_ts_lop_reverse (
                empno,
                lop_4_date,
                payslip_yyyymm,
                half_full,
                entry_date
            )
            Values (
                param_empno,
                to_date(v_day, 'yyyymmdd'),
                to_char(v_date, 'yyyymm'),
                v_lop,
                sysdate
            );

        End Loop;

        If v_cntr = 0 Then
            param_success := 'KO';
            param_message := 'Err - Zero rows updated.';
        Else
            param_success := 'OK';
        End If;

    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            Rollback;
    End;

End pkg_absent_ts;
/
---------------------------
--Changed PACKAGE BODY
--IOT_EXTRAHOURS_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_EXTRAHOURS_QRY" As

    Function fn_extra_hrs_claims(
        p_empno        Varchar2,
        p_req_for_self Varchar2,
        p_start_date   Date Default Null,
        p_row_number   Number,
        p_page_length  Number
    ) Return Sys_Refcursor As
        v_request_for_self Varchar2(20);
        c                  Sys_Refcursor;
    Begin
        Open c For

            Select
                claims.*
            From
                (

                    Select
                        a.app_date                                 As claim_date,
                        a.app_no                                   As claim_no,
                        month || '-' || yyyy                       As claim_period,
                        get_emp_name(nvl(a.lead_apprl_empno, ''))  lead_name,
                        ot                                         As claimed_ot,
                        hhot                                       As claimed_hhot,
                        co                                         As claimed_co,
                        ss.approval_text(nvl(a.lead_apprl, 0))     lead_approval_desc,
                        ss.approval_text(nvl(a.hod_apprl, 0))      hod_approval_desc,
                        ss.approval_text(nvl(a.hrd_apprl, 0))      hrd_approval_desc,
                        a.lead_remarks,
                        a.hod_remarks,
                        a.hrd_remarks,
                        nvl(a.lead_apprd_ot, 0)                    As lead_approved_ot,
                        nvl(a.lead_apprd_hhot, 0)                  As lead_approved_hhot,
                        nvl(a.lead_apprd_co, 0)                    As lead_approved_co,
                        nvl(a.hod_apprd_ot, 0)                     As hod_approved_ot,
                        nvl(a.hod_apprd_hhot, 0)                   As hod_approved_hhot,
                        nvl(a.hod_apprd_co, 0)                     As hod_approved_co,
                        Case
                            When nvl(a.hrd_apprd_ot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_ot
                        End                                        As hrd_approved_ot,
                        Case
                            When nvl(a.hrd_apprd_hhot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_hhot
                        End                                        As hrd_approved_hhot,
                        Case
                            When nvl(a.hrd_apprd_co, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_co
                        End                                        As hrd_approved_co,
                        Case
                            When p_req_for_self                  = 'OK'
                                And nvl(a.lead_apprl, ss.pending) In (ss.pending, ss.apprl_none)
                                And nvl(a.hod_apprl, ss.pending) = ss.pending
                            Then
                                1
                            Else
                                0
                        End                                        can_delete_claim,
                        Row_Number() Over (Order By app_date Desc) row_number,
                        Count(*) Over ()                           total_row

                    From
                        ss_otmaster a
                    Where
                        a.empno             = p_empno
                        And to_number(a.yyyy || a.mon) >= to_number(to_char(add_months(sysdate, - 24), 'YYYYMM'))
                        And a.yyyy || a.mon = Case
                            When p_start_date Is Null Then
                                a.yyyy || a.mon
                            Else
                                to_char(p_start_date, 'yyyymm')
                        End
                    Order By a.app_date Desc
                ) claims
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_extra_hrs_claims;

    Function fn_extra_hrs_claims_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date Default Null,
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
        c       := fn_extra_hrs_claims(
                       p_empno        => v_empno,
                       p_req_for_self => 'OK',
                       p_start_date   => p_start_date,
                       p_row_number   => p_row_number,
                       p_page_length  => p_page_length
                   );
        Return c;
    End fn_extra_hrs_claims_4_self;

    Function fn_extra_hrs_claims_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_start_date  Date Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        v_count              Number;
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = p_empno;
        If v_count = 0 Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        c := fn_extra_hrs_claims(
                 p_empno        => p_empno,
                 p_req_for_self => 'KO',
                 p_start_date   => p_start_date,
                 p_row_number   => p_row_number,
                 p_page_length  => p_page_length
             );
        Return c;
    End fn_extra_hrs_claims_4_other;

    Function fn_extra_hrs_claim_detail(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_claim_no  Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                ot_detail.*,
                to_hrs(nvl(get_time_sheet_work_hrs(empno, pdate), 0) * 60)  As ts_work_hrs,
                to_hrs(nvl(get_time_sheet_extra_hrs(empno, pdate), 0) * 60) As ts_extra_hrs
            From
                (
                    Select
                        empno,
                        yyyy || '-' || mon                                             As claim_period,
                        app_no                                                         As claim_no,
                        d_details                                                      As day_detail,
                        w_details                                                      As week_detail,
                        w_ot_max                                                       As week_extrahours_applicable,
                        w_ot_claim                                                     As week_extrahours_claim,
                        w_co                                                           As week_claimed_co,
                        w_hhot_claim                                                   As week_holiday_ot_claim,
                        w_hhot_max                                                     As week_holiday_ot_applicable,
                        to_date(day_yyyy || '-' || of_mon || '-' || day, 'yyyy-mm-dd') As pdate
                    From
                        ss_otdetail
                    Where
                        app_no = p_claim_no
                ) ot_detail
            Order By
                pdate;
        Return c;
    End fn_extra_hrs_claim_detail;

    Function fn_pending_lead_approval(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        e_employee_not_found Exception;
        v_empno              Varchar2(5);
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                *
            From
                (

                    Select
                        e.empno || ' - ' || e.name                                               As employee,
                        a.app_date                                                               As claim_date,
                        a.app_no                                                                 As claim_no,
                        month || '-' || yyyy                                                     As claim_period,
                        a.lead_apprl_empno || ' - ' || get_emp_name(nvl(a.lead_apprl_empno, '')) lead_name,
                        ot                                                                       As claimed_ot,
                        hhot                                                                     As claimed_hhot,
                        co                                                                       As claimed_co,
                        ss.approval_text(nvl(a.lead_apprl, 0))                                   lead_approval_desc,
                        ss.approval_text(nvl(a.hod_apprl, 0))                                    hod_approval_desc,
                        ss.approval_text(nvl(a.hrd_apprl, 0))                                    hrd_approval_desc,
                        a.lead_remarks,
                        a.hod_remarks,
                        a.hrd_remarks,
                        nvl(a.lead_apprd_ot, 0)                                                  As lead_approved_ot,
                        nvl(a.lead_apprd_hhot, 0)                                                As lead_approved_hhot,
                        nvl(a.lead_apprd_co, 0)                                                  As lead_approved_co,
                        nvl(a.hod_apprd_ot, 0)                                                   As hod_approved_ot,
                        nvl(a.hod_apprd_hhot, 0)                                                 As hod_approved_hhot,
                        nvl(a.hod_apprd_co, 0)                                                   As hod_approved_co,
                        Case
                            When nvl(a.hrd_apprd_ot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_ot
                        End                                                                      As hrd_approved_ot,
                        Case
                            When nvl(a.hrd_apprd_hhot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_hhot
                        End                                                                      As hrd_approved_hhot,
                        Case
                            When nvl(a.hrd_apprd_co, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_co
                        End                                                                      As hrd_approved_co,
                        Case
                            When nvl(a.lead_apprl, ss.pending) In (ss.pending, ss.apprl_none)
                                And nvl(a.hod_apprl, ss.pending) = ss.pending
                            Then
                                1
                            Else
                                0
                        End                                                                      can_delete_claim,
                        Row_Number() Over (Order By app_date Desc)                               row_number,
                        Count(*) Over ()                                                         total_row

                    From
                        ss_otmaster a,
                        ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0)    = 0)
                        And e.empno            = a.empno
                        And a.lead_apprl_empno = v_empno
                        And a.app_no           = nvl(p_application_id, a.app_no)
                        And to_number(a.yyyy || a.mon) >= to_number(to_char(add_months(sysdate, - 24), 'YYYYMM'))
                    Order By a.app_date Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_pending_lead_approval;

    Function fn_pending_hod_approval(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        e_employee_not_found Exception;
        v_empno              Varchar2(5);
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                *
            From
                (

                    Select
                        e.empno || ' - ' || e.name                 As employee,
                        a.app_date                                 As claim_date,
                        a.app_no                                   As claim_no,
                        month || '-' || yyyy                       As claim_period,
                        get_emp_name(nvl(a.lead_apprl_empno, ''))  lead_name,
                        ot                                         As claimed_ot,
                        hhot                                       As claimed_hhot,
                        co                                         As claimed_co,
                        ss.approval_text(nvl(a.lead_apprl, 0))     lead_approval_desc,
                        ss.approval_text(nvl(a.hod_apprl, 0))      hod_approval_desc,
                        ss.approval_text(nvl(a.hrd_apprl, 0))      hrd_approval_desc,
                        a.lead_remarks,
                        a.hod_remarks,
                        a.hrd_remarks,
                        nvl(a.lead_apprd_ot, 0)                    As lead_approved_ot,
                        nvl(a.lead_apprd_hhot, 0)                  As lead_approved_hhot,
                        nvl(a.lead_apprd_co, 0)                    As lead_approved_co,
                        nvl(a.hod_apprd_ot, 0)                     As hod_approved_ot,
                        nvl(a.hod_apprd_hhot, 0)                   As hod_approved_hhot,
                        nvl(a.hod_apprd_co, 0)                     As hod_approved_co,
                        Case
                            When nvl(a.hrd_apprd_ot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_ot
                        End                                        As hrd_approved_ot,
                        Case
                            When nvl(a.hrd_apprd_hhot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_hhot
                        End                                        As hrd_approved_hhot,
                        Case
                            When nvl(a.hrd_apprd_co, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_co
                        End                                        As hrd_approved_co,
                        Case
                            When nvl(a.lead_apprl, ss.pending) In (ss.pending, ss.apprl_none)
                                And nvl(a.hod_apprl, ss.pending) = ss.pending
                            Then
                                1
                            Else
                                0
                        End                                        can_delete_claim,
                        Row_Number() Over (Order By app_date Desc) row_number,
                        Count(*) Over ()                           total_row

                    From
                        ss_otmaster a,
                        ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0) In (1, 4))
                        And (nvl(hod_apprl, 0) = 0)
                        And a.empno            = e.empno
                        And a.app_no           = nvl(p_application_id, a.app_no)
                        And e.mngr             = Trim(v_empno)
                        And to_number(a.yyyy || a.mon) >= to_number(to_char(add_months(sysdate, - 24), 'YYYYMM'))
                    Order By a.app_date Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End fn_pending_hod_approval;

    Function fn_pending_onbehalf_approval(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        e_employee_not_found Exception;
        v_empno              Varchar2(5);
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                *
            From
                (

                    Select
                        e.empno || ' - ' || e.name                 As employee,
                        a.app_date                                 As claim_date,
                        a.app_no                                   As claim_no,
                        month || '-' || yyyy                       As claim_period,
                        get_emp_name(nvl(a.lead_apprl_empno, ''))  lead_name,
                        ot                                         As claimed_ot,
                        hhot                                       As claimed_hhot,
                        co                                         As claimed_co,
                        ss.approval_text(nvl(a.lead_apprl, 0))     lead_approval_desc,
                        ss.approval_text(nvl(a.hod_apprl, 0))      hod_approval_desc,
                        ss.approval_text(nvl(a.hrd_apprl, 0))      hrd_approval_desc,
                        a.lead_remarks,
                        a.hod_remarks,
                        a.hrd_remarks,
                        nvl(a.lead_apprd_ot, 0)                    As lead_approved_ot,
                        nvl(a.lead_apprd_hhot, 0)                  As lead_approved_hhot,
                        nvl(a.lead_apprd_co, 0)                    As lead_approved_co,
                        nvl(a.hod_apprd_ot, 0)                     As hod_approved_ot,
                        nvl(a.hod_apprd_hhot, 0)                   As hod_approved_hhot,
                        nvl(a.hod_apprd_co, 0)                     As hod_approved_co,
                        Case
                            When nvl(a.hrd_apprd_ot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_ot
                        End                                        As hrd_approved_ot,
                        Case
                            When nvl(a.hrd_apprd_hhot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_hhot
                        End                                        As hrd_approved_hhot,
                        Case
                            When nvl(a.hrd_apprd_co, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_co
                        End                                        As hrd_approved_co,
                        Case
                            When nvl(a.lead_apprl, ss.pending) In (ss.pending, ss.apprl_none)
                                And nvl(a.hod_apprl, ss.pending) = ss.pending
                            Then
                                1
                            Else
                                0
                        End                                        can_delete_claim,
                        Row_Number() Over (Order By app_date Desc) row_number,
                        Count(*) Over ()                           total_row

                    From
                        ss_otmaster a,
                        ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0) In (1, 4))
                        And (nvl(hod_apprl, 0) = 0)
                        And a.empno            = e.empno
                        And a.app_no           = nvl(p_application_id, a.app_no)
                        And to_number(a.yyyy || a.mon) >= to_number(to_char(add_months(sysdate, - 24), 'YYYYMM'))
                        And e.mngr In (
                            Select
                                mngr
                            From
                                ss_delegate
                            Where
                                empno = v_empno
                        )
                    Order By a.app_date Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

        Return c;
    End fn_pending_onbehalf_approval;

    Function fn_pending_hr_approval(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        e_employee_not_found Exception;
        v_empno              Varchar2(5);
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        e.empno || ' - ' || e.name                        As employee,
                        a.app_date                                        As claim_date,
                        a.app_no                                          As claim_no,
                        month || '-' || yyyy                              As claim_period,
                        get_emp_name(nvl(a.lead_apprl_empno, ''))         As lead_name,
                        ot                                                As claimed_ot,
                        hhot                                              As claimed_hhot,
                        co                                                As claimed_co,
                        ss.approval_text(nvl(a.lead_apprl, 0))            As lead_approval_desc,
                        ss.approval_text(nvl(a.hod_apprl, 0))             As hod_approval_desc,
                        ss.approval_text(nvl(a.hrd_apprl, 0))             As hrd_approval_desc,
                        a.lead_remarks,
                        a.hod_remarks,
                        a.hrd_remarks,
                        nvl(a.lead_apprd_ot, 0)                           As lead_approved_ot,
                        nvl(a.lead_apprd_hhot, 0)                         As lead_approved_hhot,
                        nvl(a.lead_apprd_co, 0)                           As lead_approved_co,
                        nvl(a.hod_apprd_ot, 0)                            As hod_approved_ot,
                        nvl(a.hod_apprd_hhot, 0)                          As hod_approved_hhot,
                        nvl(a.hod_apprd_co, 0)                            As hod_approved_co,
                        Case
                            When nvl(a.hrd_apprd_ot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_ot
                        End                                               As hrd_approved_ot,
                        Case
                            When nvl(a.hrd_apprd_hhot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_hhot
                        End                                               As hrd_approved_hhot,
                        Case
                            When nvl(a.hrd_apprd_co, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_co
                        End                                               As hrd_approved_co,
                        Case
                            When nvl(a.lead_apprl, ss.pending) In (ss.pending, ss.apprl_none)
                                And nvl(a.hod_apprl, ss.pending) = ss.pending
                            Then
                                1
                            Else
                                0
                        End                                               As can_delete_claim,
                        e.parent                                          As parent,
                        get_emp_pen_lve_4_month(a.empno, a.yyyy || a.mon) As penalty_hrs,
                        Row_Number() Over (Order By e.parent, e.empno)    As row_number,
                        Count(*) Over ()                                  As total_row
                    From
                        ss_otmaster a,
                        ss_emplmast e
                    Where
                        (nvl(hod_apprl, 0)     = 1)
                        And (nvl(hrd_apprl, 0) = 0)
                        And e.empno            = a.empno
                        And a.app_no           = nvl(p_application_id, a.app_no)
                        And to_number(a.yyyy || a.mon) >= to_number(to_char(add_months(sysdate, - 24), 'YYYYMM'))
                    Order By e.parent, a.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_pending_hr_approval;

End iot_extrahours_qry;
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
                        DM_VU_EMP_DESK_MAP_SWP_PLAN
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
                        DM_VU_EMP_DESK_MAP_SWP_PLAN dmst
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
                And assign Not In (
                    Select
                        assign
                    From
                        swp_exclude_assign
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
                And costcode Not In (
                    Select
                        assign
                    From
                        swp_exclude_assign
                )
                And noofemps > 0
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
                projno                  data_value_field,
                projno || ' - ' || name data_text_field
            From
                ss_projmast
            Where
                active = 1
            Order By
                projno,
                name;

        Return c;
    End;

End iot_swp_select_list_qry;
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
--IMPORT_PUNCH
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IMPORT_PUNCH" As

    Procedure proc_normalize_async (
        param_key_id Varchar2
    ) As
        v_job_name   Varchar2(30);
        v_job_no     Varchar2(5);
    Begin
        v_job_no     := dbms_random.string(
            'X',
            5
        );
        v_job_name   := 'NORMALIZE_PUNCH_' || v_job_no;
        dbms_scheduler.create_job(
            job_name              => v_job_name,
            job_type              => 'STORED_PROCEDURE',
            job_action            => 'import_punch.normalize_blob_into_punch_data',
            number_of_arguments   => 1,
            enabled               => false,
            job_class             => 'TCMPL_JOB_CLASS',
            comments              => 'To Normalize Punch Data'
        );

        dbms_scheduler.set_job_argument_value(
            job_name            => v_job_name,
            argument_position   => 1,
            argument_value      => param_key_id
        );

        dbms_scheduler.enable(v_job_name);
    End;

    Procedure upload_blob (
        param_blob        Blob,
        param_file_name   Varchar2,
        param_success     Out               Varchar2,
        param_message     Out               Varchar2
    ) Is

        v_key_id   Varchar2(5);
        v_count    Number;
        ex_custom Exception;
        Pragma exception_init ( ex_custom, -20001 );
    Begin
        v_key_id        := dbms_random.string(
            'X',
            5
        );
        param_success   := 'OK';
        Select
            Count(*)
        Into v_count
        From
            ss_punch_upload_blob
        Where
            Trim(process_status) = 'WP';

        If v_count > 0 Then
            raise_application_error(
                -20001,
                'Previous file upload process not completed. Try after sometime.'
            );
            return;
        End If;
        Delete From ss_punch_upload_blob;

        Commit;
        Insert Into ss_punch_upload_blob (
            key_id,
            modified_on,
            file_blob,
            file_type,
            process_status,
            file_name
        ) Values (
            v_key_id,
            Sysdate,
            param_blob,
            'PUNCH_DATA',
            'UP',
            param_file_name
        );

        Commit;
        proc_normalize_async(v_key_id);
        param_success   := 'OK';
        param_message   := 'Punch Upload & Normalization has been scheduled.';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;

    Procedure insert_into_punch_all Is
        Cursor cur_4all_punch Is
        Select
            *
        From
            ss_ipformat;

        Type typ_tab_punch Is
            Table Of cur_4all_punch%rowtype;
        tab_punch typ_tab_punch;
    Begin
        Open cur_4all_punch;
        Loop
            Fetch cur_4all_punch Bulk Collect Into tab_punch Limit 100;
            For i In 1..tab_punch.count Loop Begin
                Insert Into ss_punch_all (
                    empno,
                    hh,
                    mm,
                    ss,
                    pdate,
                    falseflag,
                    dd,
                    mon,
                    yyyy,
                    mach
                ) Values (
                    tab_punch(i).empno,
                    tab_punch(i).hh,
                    tab_punch(i).mm,
                    tab_punch(i).ss,
                    tab_punch(i).pdate,
                    1,
                    tab_punch(i).dd,
                    tab_punch(i).mon,
                    tab_punch(i).yyyy,
                    tab_punch(i).mach
                );

                Commit;
            Exception
                When Others Then
                    Null;
            End;
            End Loop;

            Exit When cur_4all_punch%notfound;
        End Loop;

        Null;
    End;

    Procedure insert_into_punch Is

        Cursor cur_punch Is
        Select
            *
        From
            ss_ipformat
        Where
            mach In (
                Select
                    mach_name
                From
                    ss_swipe_mach_mast
                Where
                    valid_4_in_out = 1
            );

        Type typ_tab_punch Is
            Table Of cur_punch%rowtype;
        tab_punch typ_tab_punch;
    Begin
        Open cur_punch;
        Loop
            Fetch cur_punch Bulk Collect Into tab_punch Limit 100;
            For i In 1..tab_punch.count Loop Begin
                Insert Into ss_punch (
                    empno,
                    hh,
                    mm,
                    ss,
                    pdate,
                    falseflag,
                    dd,
                    mon,
                    yyyy,
                    mach
                ) Values (
                    tab_punch(i).empno,
                    tab_punch(i).hh,
                    tab_punch(i).mm,
                    tab_punch(i).ss,
                    tab_punch(i).pdate,
                    1,
                    tab_punch(i).dd,
                    tab_punch(i).mon,
                    tab_punch(i).yyyy,
                    tab_punch(i).mach
                );

                Commit;
            Exception
                When Others Then
                    Null;
            End;
            End Loop;

            Exit When cur_punch%notfound;
        End Loop;

        Commit;
    End;

    Procedure replace_sr_no_with_empno As
    Begin
        Update ss_importpunch a
        Set
            empno = (
                Select
                    empno
                From
                    ss_vu_contmast
                Where
                    punchno = a.empno
            )
        Where
            empno In (
                Select
                    punchno
                From
                    ss_vu_contmast
            );

        Commit;
    End replace_sr_no_with_empno;

    Procedure insert_punch_2_prod_tab Is
    Begin
        -- Insert into Punch All Table
        insert_into_punch_all;
        --

        --Delete unwanted Punch
        Delete From ss_importpunch
        Where
            mach Not In (
                Select
                    mach_name
                From
                    ss_swipe_mach_mast
                Where
                    valid_4_in_out = 1
            );

        Commit;
        --Delete unwanted Punch

        --Replace Serial Number with EmpNo
        replace_sr_no_with_empno;
        --Replace Serial Number with Empno

        --Insert into Punch Table
        insert_into_punch;
        --
        Declare
            Cursor cur_uploaded_punch_data Is
            Select Distinct
                empno,
                pdate
            From
                ss_ipformat;

            v_status   Varchar2(10);
            v_msg      Varchar2(1000);
        Begin
            For c1 In cur_uploaded_punch_data Loop
                generate_auto_punch(
                    c1.empno,
                    c1.pdate
                );
                wfh_attendance.rem_wfh_n_keep_card_swipe(
                    param_empno   => c1.empno,
                    param_pdate   => c1.pdate
                );

                itinv_stk.attend_plan.create_attend_act_punch(
                    p_punch_date   => Trunc(c1.pdate),
                    p_empno        => c1.empno,
                    p_status       => v_status,
                    p_msg          => v_msg
                );

            End Loop;
        End;
        --

    End;

    Procedure insert_2_temp_tab (
        param_text Varchar2
    ) As

        v_mach    Varchar2(4);
        v_hh      Varchar2(2);
        v_mn      Varchar2(2);
        v_ss      Varchar2(2);
        v_dd      Varchar2(2);
        v_mon     Varchar2(2);
        v_yyyy    Varchar2(4);
        v_empno   Varchar2(5);
    Begin
        v_mach    := Substr(param_text, 1, 4);
        v_hh      := Substr(param_text, 5, 2);
        v_mn      := Substr(param_text, 7, 2);
        v_ss      := Substr(param_text, 9, 2);
        v_dd      := Substr(param_text, 11, 2);
        v_mon     := Substr(param_text, 13, 2);
        v_yyyy    := Substr(param_text, 15, 4);
        v_empno   := Substr(Trim(Substr(param_text, 19, 8)), -5);

        Insert Into ss_importpunch (
            empno,
            hh,
            mm,
            ss,
            dd,
            mon,
            yyyy,
            mach
        ) Values (
            v_empno,
            v_hh,
            v_mn,
            v_ss,
            v_dd,
            v_mon,
            v_yyyy,
            v_mach
        );

        Commit;
    End;

    Procedure update_status (
        param_key_id    Varchar2,
        param_success   Varchar2,
        param_message   Varchar2
    ) As
    Begin
        Update ss_punch_upload_blob
        Set
            process_status = param_success,
            process_message = param_message
        Where
            key_id = param_key_id;

        Commit;
    End;

    Procedure normalize_blob_2_rows (
        param_key_id    Varchar2,
        param_success   Out             Varchar2,
        param_message   Out             Varchar2
    ) As

        l_str1        Varchar2(4000);
        l_str2        Varchar2(4000);
        l_leftover    Varchar2(4000);
        l_chunksize   Number := 3000;
        l_offset      Number := 1;
        l_linebreak   Varchar2(2) := Chr(13) || Chr(10);
        l_length      Number;
        v_blob        Blob;
        l_row         Varchar2(200);
    Begin
        --empty import_punch tble
        Delete From ss_importpunch;
        --

        Select
            file_blob
        Into v_blob
        From
            ss_punch_upload_blob
        Where
            key_id = param_key_id;

        l_length        := dbms_lob.getlength(v_blob);
        dbms_output.put_line(l_length);
        While l_offset < l_length Loop
            l_str1       := l_leftover || utl_raw.cast_to_varchar2(dbms_lob.Substr(
                v_blob,
                l_chunksize,
                l_offset
            ));

            l_leftover   := Null;
            l_str2       := l_str1;
            While l_str2 Is Not Null Loop If Instr(l_str2, l_linebreak) <= 0 Then
                l_leftover   := l_str2;
                l_str2       := Null;
            Else
                l_row    := ( Substr(l_str2, 1, Instr(l_str2, l_linebreak) - 1) );

                --Insert into table

                --Pipe Row ( l_row );

                insert_2_temp_tab(l_row);
                --
                l_str2   := Substr(l_str2, Instr(l_str2, l_linebreak) + 2);
            End If;
            End Loop;

            l_offset     := l_offset + l_chunksize;
        End Loop;

        If l_leftover Is Not Null Then
            l_row := Substr(l_leftover, 1, 200);
                           --Insert into table
            insert_2_temp_tab(l_row);
                --

            --Pipe Row ( l_row );
            --dbms_output.put_line(l_leftover);
        End If;

        param_success   := 'OK';
        param_message   := 'Blob normalized to rows';
        return;
    End;

    Procedure normalize_blob_into_punch_data (
        param_key_id    Varchar2,
        param_success   Out             Varchar2,
        param_message   Out             Varchar2
    ) As
    Begin
        Update ss_punch_upload_blob
        Set
            process_status = 'WP'
        Where
            key_id = param_key_id;

        Commit;

        --*****--
        normalize_blob_2_rows(
            param_key_id,
            param_success,
            param_message
        );
        update_status(
            param_key_id,
                Case param_success
                    When 'OK' Then
                        'WP'
                    Else param_success
                End,
            param_message
        );

        --*****--
        If param_success = 'KO' Then
            return;
        End If;

        --*****--
        insert_punch_2_prod_tab;

        --*****--
        param_success   := 'OK';
        param_message   := 'Data successfully uploaded to Database';
        update_status(
            param_key_id,
            param_success,
            param_message
        );
        Commit;
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
            update_status(
                param_key_id,
                param_success,
                param_message
            );
            Commit;
    End;

    Procedure normalize_blob_into_punch_data (
        param_key_id Varchar2
    ) As
        v_success   Varchar2(10);
        v_message   Varchar2(2000);
    Begin
        normalize_blob_into_punch_data(
            param_key_id,
            v_success,
            v_message
        );
    End;

End import_punch;
/
---------------------------
--Changed PACKAGE BODY
--PKG_ABSENT
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."PKG_ABSENT" As

    Function get_emp_absent_update_date(
        param_empno                Varchar2,
        param_period_keyid         Varchar2,
        param_absent_list_gen_date Date
    ) Return Date Is
        v_ret_date Date;
    Begin
        Select
            trunc(modified_on)
        Into
            v_ret_date
        From
            ss_absent_detail
        Where
            empno      = param_empno
            And key_id = param_period_keyid;

        Return (v_ret_date);
    Exception
        When Others Then
            Return (param_absent_list_gen_date);
    End;

    Procedure check_payslip_month_isopen(
        param_payslip_yyyymm Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
        v_open_payslip_yyyymm Varchar2(10);
    Begin
        v_open_payslip_yyyymm := get_payslip_month;
        If v_open_payslip_yyyymm <> param_payslip_yyyymm Then
            param_success := 'KO';
            param_message := 'Err - Payslip month "' || param_payslip_yyyymm || '" is not open in the system';
            Return;
        Else
            param_success := 'OK';
        End If;

    End;

    Procedure generate_list(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_empno          Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        v_key_id      Varchar2(8);
        v_first_date  Date;
        v_last_day    Date;
        --v_empno       varchar2(5);
        v_requester   Varchar2(5);
        v_param_empno Varchar2(10);
    Begin
        /*
            check_payslip_month_isopen(param_payslip_yyyymm,param_success,param_message);
            if param_success = 'KO' then
                return;
            end if;
            */
        If param_absent_yyyymm = '202106' Then
            v_first_date := to_date(param_absent_yyyymm || '07', 'yyyymmdd');
        Else
            v_first_date := to_date(param_absent_yyyymm || '01', 'yyyymmdd');
        End If;

        If param_absent_yyyymm = '202003' Then
            v_last_day := To_Date('20-Mar-2020', 'dd-Mon-yyyy');
        Else
            v_last_day := last_day(v_first_date);
        End If;

        v_key_id      := dbms_random.string('X', 8);
        v_requester   := ss.get_empno(param_requester);
        If param_empno = 'ALL' Then
            v_param_empno := '%';
        Else
            v_param_empno := param_empno || '%';
        End If;

        Delete
            From ss_absent_detail
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm
            And empno Like v_param_empno;

        If param_empno = 'ALL' Then
            Delete
                From ss_absent_master
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm;

            Insert Into ss_absent_master (
                absent_yyyymm,
                payslip_yyyymm,
                modified_on,
                modified_by,
                key_id
            )
            Values (
                param_absent_yyyymm,
                param_payslip_yyyymm,
                sysdate,
                v_requester,
                v_key_id
            );

        Else
            Select
                key_id
            Into
                v_key_id
            From
                ss_absent_master
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm;

        End If;

        Commit;
        Insert Into ss_absent_detail (
            key_id,
            absent_yyyymm,
            payslip_yyyymm,
            empno,
            absent_days,
            cl_bal,
            sl_bal,
            pl_bal,
            co_bal
        )
        Select
            v_key_id,
            param_absent_yyyymm,
            param_payslip_yyyymm,
            empno,
            absent_days,
            closingclbal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) cl_bal,
            closingslbal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) sl_bal,
            closingplbal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) pl_bal,
            closingcobal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) co_bal
        From
            (
                Select
                    empno,
                    Listagg(dy, ', ') Within
                        Group (Order By dy) As absent_days
                From
                    (
                        With
                            days_tab As (
                                Select
                                    to_date(param_absent_yyyymm || to_char(days, 'FM00'), 'yyyymmdd') pdate,
                                    days                                                              dy
                                From
                                    ss_days
                                Where
                                    --days <= to_number(to_char(last_day(to_date(param_absent_yyyymm, 'yyyymm')), 'dd'))
                                    days <= to_number(to_char(v_last_day, 'dd'))
                                    And days >= to_number(to_char(v_first_date, 'dd'))
                            )
                        Select
                            a.empno,
                            dy,
                            pkg_absent.is_emp_absent(
                                a.empno, pdate, substr(s_mrk, ((dy - 1) * 2) + 1, 2), a.doj
                            ) is_absent
                        From
                            ss_emplmast a,
                            days_tab    b,
                            ss_muster   c
                        Where
                            mnth         = Trim(Trim(param_absent_yyyymm))
                            And a.empno  = c.empno
                            And a.status = 1
                            And a.parent Not In (
                                Select
                                    parent
                                From
                                    ss_dept_not_4_absent
                            )
                            And emptype In (
                                'R', 'F'
                            )
                            And a.empno Like v_param_empno
                    )
                Where
                    is_absent = 1
                Group By empno
            );

        Commit;
        param_success := 'OK';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End generate_list;

    Procedure generate_nu_list_4_all_emp(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Delete
            From ss_absent_lop
        Where
            payslip_yyyymm                    = param_payslip_yyyymm
            And to_char(lop_4_date, 'yyyymm') = param_absent_yyyymm;

        generate_list(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            'ALL',
            param_requester,
            param_success,
            param_message
        );
    End;

    Procedure regenerate_list_4_one_emp(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_empno          Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        generate_list(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            param_empno,
            param_requester,
            param_success,
            param_message
        );
    End;

    Procedure reset_emp_lop(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_empno          Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Delete
            From ss_absent_lop
        Where
            payslip_yyyymm                    = param_payslip_yyyymm
            And to_char(lop_4_date, 'yyyymm') = param_absent_yyyymm
            And empno                         = param_empno;

        Commit;
        regenerate_list_4_one_emp(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            param_empno,
            param_requester,
            param_success,
            param_message
        );
    End;

    Function is_emp_absent(
        param_empno      In Varchar2,
        param_date       In Date,
        param_shift_code In Varchar2,
        param_doj        In Date
    ) Return Varchar2 As

        v_holiday         Number;
        v_count           Number;
        c_is_absent       Constant Number := 1;
        c_not_absent      Constant Number := 0;
        c_leave_depu_tour Constant Number := 2;
        v_on_ldt          Number;
        v_ldt_appl        Number;
    Begin
        v_holiday  := get_holiday(param_date);
        If v_holiday > 0 Or nvl(param_shift_code, 'ABCD') In (
                'HH', 'OO'
            )
        Then
            --return -1;
            Return c_not_absent;
        End If;

        --Check DOJ & DOL

        If param_date < nvl(param_doj, param_date) Then
            --return -5;
            Return c_not_absent;
        End If;
        v_on_ldt   := isleavedeputour(param_date, param_empno);
        If v_on_ldt = 1 Then
            --return -2;
            --return c_leave_depu_tour;
            Return c_not_absent;
        End If;
        Select
            Count(empno)
        Into
            v_count
        From
            ss_integratedpunch
        Where
            empno     = Trim(param_empno)
            And pdate = param_date;

        If v_count > 0 Then
            --return -3;
            Return c_not_absent;
        End If;
        v_ldt_appl := isldt_appl(param_empno, param_date);
        If v_ldt_appl > 0 Then
            --return -6;
            Return c_not_absent;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_absent_lop
        Where
            empno          = param_empno
            And lop_4_date = param_date;

        If v_count > 0 Then
            Return c_not_absent;
        End If;
        --return -4;
        Return c_is_absent;
    End is_emp_absent;

    Procedure set_lop_4_emp(
        param_empno          Varchar2,
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_lop_val        Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        Cursor c1 Is
            Select
                column_value
            From
                Table (ss.csv_to_table(param_lop_val));

        Type typ_tab Is
            Table Of c1%rowtype Index By Binary_Integer;
        v_tab  typ_tab;
        v_day  Varchar2(5);
        v_lop  Varchar2(5);
        v_cntr Number;
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        param_success := 'KO';
        v_cntr        := 0;
        For c2 In c1
        Loop
            v_cntr := v_cntr + 1;
            v_day  := lpad(substr(c2.column_value, 1, instr(c2.column_value, '-') - 1), 2, '0');

            v_lop  := substr(c2.column_value, instr(c2.column_value, '-') + 1);

            Insert Into ss_absent_lop (
                empno,
                lop_4_date,
                payslip_yyyymm,
                half_full,
                entry_date
            )
            Values (
                param_empno,
                to_date(param_absent_yyyymm || v_day, 'yyyymmdd'),
                param_payslip_yyyymm,
                v_lop,
                sysdate
            );

        End Loop;

        If v_cntr > 0 Then
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                param_empno,
                param_requester,
                param_success,
                param_message
            );
        Else
            param_success := 'KO';
            param_message := 'Err - Zero rows updated.';
        End If;

    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            Rollback;
    End;

    Function get_lop(
        param_empno Varchar2,
        param_pdate Date
    ) Return Number Is
        v_lop Number;
    Begin
        Select
            half_full
        Into
            v_lop
        From
            ss_absent_lop
        Where
            empno          = param_empno
            And lop_4_date = param_pdate;

        Return v_lop;
    Exception
        When Others Then
            Return 0;
    End;

    Procedure update_no_mail_list(
        param_absent_yyyymm       Varchar2,
        param_payslip_yyyymm      Varchar2,
        param_emp_list_4_no_mail  Varchar2,
        param_emp_list_4_yes_mail Varchar2,
        param_requester           Varchar2,
        param_success Out         Varchar2,
        param_message Out         Varchar2
    ) As
    Begin
        Null;
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        /*
        If Trim(param_emp_list_4_no_mail) Is Null Then
            param_success   := 'KO';
            param_message   := 'Err - Employee List for NO-MAIL is blank.';
            return;
        End If;
        */
        Update
            ss_absent_detail
        Set
            no_mail = Null
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm
            And empno In (
                Select
                    column_value empno
                From
                    Table (ss.csv_to_table(param_emp_list_4_yes_mail))
            );

        Commit;
        Update
            ss_absent_detail
        Set
            no_mail = 'OK'
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm
            And empno In (
                Select
                    column_value empno
                From
                    Table (ss.csv_to_table(param_emp_list_4_no_mail))
            );

        Commit;
        param_success := 'OK';
        param_message := 'Employee List for NO-MAIL successfully updated';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            Rollback;
    End;

    Procedure add_payslip_period(
        param_period      Varchar2,
        param_open        Varchar2,
        param_by_win_uid  Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) As
        v_count    Number;
        v_date     Date;
        v_by_empno Varchar2(5);
    Begin
        Begin
            v_date := to_date(param_period, 'Mon-yyyy');
        Exception
            When Others Then
                param_success := 'KO';
                param_message := 'Err - Invalid date format';
                Return;
        End;

        v_by_empno    := pkg_09794.get_empno(param_by_win_uid);
        If v_by_empno Is Null Then
            param_success := 'KO';
            param_message := 'Err - Data Entry by EmpNo not found.';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_absent_payslip_period
        Where
            period = to_char(v_date, 'yyyymm');

        If v_count <> 0 Then
            param_success := 'KO';
            param_message := 'Err - Period already exists.';
            Return;
        End If;

        Insert Into ss_absent_payslip_period (
            period,
            is_open,
            modified_on,
            modified_by
        )
        Values (
            to_char(v_date, 'yyyymm'),
            param_open,
            sysdate,
            v_by_empno
        );

        If param_open = 'OK' Then
            Update
                ss_absent_payslip_period
            Set
                is_open = 'KO'
            Where
                period != to_char(v_date, 'yyyymm')
                And is_open = 'OK';

        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Period successfully added.';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure edit_payslip_period(
        param_period      Varchar2,
        param_open        Varchar2,
        param_by_win_uid  Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) As
        v_count    Number;
        v_date     Date;
        v_by_empno Varchar2(5);
    Begin
        Begin
            v_date := to_date(param_period, 'Mon-yyyy');
        Exception
            When Others Then
                param_success := 'KO';
                param_message := 'Err - Invalid date format';
                Return;
        End;

        v_by_empno    := pkg_09794.get_empno(param_by_win_uid);
        If v_by_empno Is Null Then
            param_success := 'KO';
            param_message := 'Err - Data Entry by EmpNo not found.';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_absent_payslip_period
        Where
            period = to_char(v_date, 'yyyymm');

        If v_count <> 1 Then
            param_success := 'KO';
            param_message := 'Err - Period not found in database.';
            Return;
        End If;

        Update
            ss_absent_payslip_period
        Set
            is_open = param_open
        Where
            period = to_char(v_date, 'yyyymm');

        If param_open = 'OK' Then
            Update
                ss_absent_payslip_period
            Set
                is_open = 'KO'
            Where
                period != to_char(v_date, 'yyyymm')
                And is_open = 'OK';

        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Period successfully updated.';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure refresh_absent_list(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        v_count             Number;
        v_absent_list_date  Date;
        v_absent_list_keyid Varchar2(8);
        Cursor cur_onduty(
            pc_list_keyid Varchar2,
            pc_list_date  Date
        ) Is
            With
                absent_list As (
                    Select
                        empno
                    From
                        ss_absent_detail
                    Where
                        absent_yyyymm      = param_absent_yyyymm
                        And payslip_yyyymm = param_payslip_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_absent_lop
                    Where
                        payslip_yyyymm = param_payslip_yyyymm
                )
            Select
            Distinct
                empno
            From
                (
                    Select
                        empno
                    From
                        ss_ondutyapp
                    Where
                        app_date >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And type In ('OD', 'IO')
                        And nvl(lead_apprl, 0) <> 2
                        And nvl(hod_apprl, 0) <> 2
                        And nvl(hrd_apprl, 0) <> 2
                        And to_char(pdate, 'yyyymm') = param_absent_yyyymm
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                    Union
                    Select
                        empno
                    From
                        ss_ondutyapp_deleted
                    Where
                        deleted_on >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And to_char(pdate, 'yyyymm') = param_absent_yyyymm
                        And type In ('OD', 'IO')
                    Union
                    Select
                        empno
                    From
                        ss_ondutyapp_rejected
                    Where
                        rejected_on >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And to_char(pdate, 'yyyymm') = param_absent_yyyymm
                        And type In ('OD', 'IO')
                );

        Cursor cur_depu(
            pc_list_keyid Varchar2,
            pc_list_date  Date
        ) Is
            With
                absent_list As (
                    Select
                        empno
                    From
                        ss_absent_detail
                    Where
                        absent_yyyymm      = param_absent_yyyymm
                        And payslip_yyyymm = param_payslip_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_absent_lop
                    Where
                        payslip_yyyymm = param_payslip_yyyymm
                )
            Select
            Distinct
                empno
            From
                (
                    Select
                        empno
                    From
                        ss_depu
                    Where
                        (app_date >= get_emp_absent_update_date(
                                empno, pc_list_keyid, pc_list_date
                            )
                            Or chg_date >= get_emp_absent_update_date(
                                empno, pc_list_keyid, pc_list_date
                            ))
                        And type In ('TR', 'DP')
                        And nvl(hod_apprl, 0) <> 2
                        And nvl(hrd_apprl, 0) <> 2
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                    Union
                    Select
                        empno
                    From
                        ss_depu_deleted
                    Where
                        deleted_on >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And type In ('TR', 'DP')
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_depu_rejected
                    Where
                        rejected_on >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And type In ('TR', 'DP')
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_depu_hist
                    Where
                        empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                        And type In ('TR', 'DP')
                        And chg_date >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                );

        Cursor cur_leave(
            pc_list_keyid Varchar2,
            pc_list_date  Date
        ) Is
            With
                absent_list As (
                    Select
                        empno
                    From
                        ss_absent_detail
                    Where
                        absent_yyyymm      = param_absent_yyyymm
                        And payslip_yyyymm = param_payslip_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_absent_lop
                    Where
                        payslip_yyyymm = param_payslip_yyyymm
                )
            Select
            Distinct
                empno
            From
                (
                    Select
                        empno
                    From
                        ss_leaveapp
                    Where
                        (app_date >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        ))
                        And nvl(lead_apprl, 0) <> 2
                        And nvl(hod_apprl, 0) <> 2
                        And nvl(hrd_apprl, 0) <> 2
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                    Union
                    /*
                    Select
                        empno
                    From
                        ss_leave_adj
                    Where
                        (adj_dt >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        ))
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    */
                    Select
                        empno
                    From
                        ss_leaveapp_deleted
                    Where
                        deleted_on >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_leaveapp_rejected
                    Where
                        rejected_on >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                );
        v_sysdate           Date := sysdate;
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Begin
            Select
                trunc(nvl(refreshed_on, modified_on)),
                key_id
            Into
                v_absent_list_date,
                v_absent_list_keyid
            From
                ss_absent_master
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm;

        Exception
            When Others Then
                param_success := 'KO';
                param_message := 'Absent list not yet generated for the said period.';
                Return;
        End;

        For c_empno In cur_onduty(v_absent_list_keyid, v_absent_list_date)
        Loop
            Null;
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                c_empno.empno,
                param_requester,
                param_success,
                param_message
            );
        End Loop;

        For c_empno In cur_depu(v_absent_list_keyid, v_absent_list_date)
        Loop
            Null;
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                c_empno.empno,
                param_requester,
                param_success,
                param_message
            );
        End Loop;

        For c_empno In cur_leave(v_absent_list_keyid, v_absent_list_date)
        Loop
            Null;
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                c_empno.empno,
                param_requester,
                param_success,
                param_message
            );
        End Loop;

        Update
            ss_absent_master
        Set
            refreshed_on = v_sysdate
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm;

        Commit;
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure reverse_lop_4_emp(
        param_empno          Varchar2,
        param_payslip_yyyymm Varchar2,
        param_lop_val        Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        Cursor c1 Is
            Select
                column_value
            From
                Table (ss.csv_to_table(param_lop_val));

        Type typ_tab Is
            Table Of c1%rowtype Index By Binary_Integer;
        v_tab  typ_tab;
        v_day  Varchar2(8);
        v_lop  Varchar2(5);
        v_cntr Number;
        v_date Date;
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Begin
            v_date := to_date(param_payslip_yyyymm, 'yyyymm');
        Exception
            When Others Then
                param_success := 'KO';
                param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
                Return;
        End;

        param_success := 'KO';
        v_cntr        := 0;
        For c2 In c1
        Loop
            v_cntr := v_cntr + 1;
            v_day  := substr(c2.column_value, 1, instr(c2.column_value, '-') - 1);

            v_lop  := substr(c2.column_value, instr(c2.column_value, '-') + 1);

            Insert Into ss_absent_lop_reverse (
                empno,
                lop_4_date,
                payslip_yyyymm,
                half_full,
                entry_date
            )
            Values (
                param_empno,
                to_date(v_day, 'yyyymmdd'),
                to_char(v_date, 'yyyymm'),
                v_lop,
                sysdate
            );

        End Loop;

        If v_cntr = 0 Then
            param_success := 'KO';
            param_message := 'Err - Zero rows updated.';
        Else
            param_success := 'OK';
        End If;

    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            Rollback;
    End;

    Function get_payslip_month Return Varchar2 Is
        v_payslip_month_rec ss_absent_payslip_period%rowtype;
        v_ret_val           Varchar2(7);
    Begin
        Select
            *
        Into
            v_payslip_month_rec
        From
            ss_absent_payslip_period
        Where
            is_open = 'OK';
        --v_ret_val := substr(v_payslip_month_rec.period,1,4) || '-' || substr(v_payslip_month_rec.period,5,2);

        Return v_payslip_month_rec.period;
    Exception
        When Others Then
            Return 'ERR';
    End;

    Procedure delete_user_lop(
        param_empno          Varchar2,
        param_payslip_yyyymm Varchar2,
        param_absent_yyyymm  Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        Delete
            From ss_absent_lop
        Where
            empno                             = param_empno
            And payslip_yyyymm                = param_payslip_yyyymm
            And to_char(lop_4_date, 'yyyymm') = param_absent_yyyymm;

        Commit;
        regenerate_list_4_one_emp(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            param_empno,
            param_requester,
            param_success,
            param_message
        );
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Function get_pending_app_4_month(
        param_yyyymm Varchar2
    ) Return typ_tab_pending_app
        Pipelined
    As

        Cursor cur_pending_apps Is
            Select
                empno                        empno,
                emp_name                     emp_name,
                parent                       parent,
                app_no                       app_no,
                bdate                        bdate,
                edate                        edate,
                leavetype                    leavetype,
                ss.approval_text(hrd_apprl)  hrd_apprl_txt,
                ss.approval_text(hod_apprl)  hod_apprl_txt,
                ss.approval_text(lead_apprl) lead_apprl_txt
            From
                (
                    With
                        emp_list As (
                            Select
                                empno As emp_num,
                                name  As emp_name,
                                parent
                            From
                                ss_emplmast
                            Where
                                status = 1
                                And emptype In (
                                    'R', 'F'
                                )
                        ), dates As (
                            Select
                                to_date(param_yyyymm, 'yyyymm')           As first_day,
                                last_day(to_date(param_yyyymm, 'yyyymm')) As last_day
                            From
                                dual
                        )
                    Select
                        empno,
                        emp_name,
                        parent,
                        app_no,
                        bdate,
                        edate,
                        leavetype,
                        hrd_apprl,
                        hod_apprl,
                        lead_apprl
                    From
                        ss_leaveapp a,
                        emp_list    b,
                        dates       c
                    Where
                        a.empno = b.emp_num
                        And nvl(lead_apprl, ss.pending) In (
                            ss.pending, ss.approved, ss.apprl_none
                        )
                        And nvl(hod_apprl, ss.pending) In (
                            ss.pending, ss.approved
                        )
                        And nvl(hrd_apprl, ss.pending) In (
                            ss.pending
                        )
                        And (bdate Between first_day And last_day
                            Or nvl(bdate, edate) Between first_day And last_day
                            Or first_day Between bdate And nvl(bdate, edate))
                    Union
                    Select
                        empno,
                        emp_name,
                        parent,
                        app_no,
                        pdate,
                        Null,
                        type As od_type,
                        hrd_apprl,
                        hod_apprl,
                        lead_apprl
                    From
                        ss_ondutyapp a,
                        emp_list     b,
                        dates
                    Where
                        a.empno = b.emp_num
                        And type In (
                            'IO', 'OD'
                        )
                        And nvl(lead_apprl, ss.pending) In (
                            ss.pending, ss.approved, ss.apprl_none
                        )
                        And nvl(hod_apprl, ss.pending) In (
                            ss.pending, ss.approved
                        )
                        And nvl(hrd_apprl, ss.pending) In (
                            ss.pending
                        )
                        And (pdate Between first_day And last_day)
                    Union
                    Select
                        empno,
                        emp_name,
                        parent,
                        app_no,
                        bdate,
                        edate,
                        type As depu_type,
                        hrd_apprl,
                        hod_apprl,
                        lead_apprl
                    From
                        ss_depu  a,
                        emp_list b,
                        dates
                    Where
                        a.empno = b.emp_num
                        And type In (
                            'HT', 'VS', 'TR', 'DP'
                        )
                        And nvl(lead_apprl, ss.pending) In (
                            ss.pending, ss.approved, ss.apprl_none
                        )
                        And nvl(hod_apprl, ss.pending) In (
                            ss.pending, ss.approved
                        )
                        And nvl(hrd_apprl, ss.pending) In (
                            ss.pending
                        )
                        And (bdate Between first_day And last_day
                            Or nvl(bdate, edate) Between first_day And last_day
                            Or first_day Between bdate And nvl(bdate, edate))
                /*union
                select
                    empno,
                    emp_name,
                    parent,
                    app_no,
                    bdate,
                    edate,
                    type,
                    hrd_apprl,
                    hod_apprl,
                    lead_apprl
                from
                    ss_depu a,
                    emp_list b,
                    dates
                where
                    a.empno = b.emp_num
                    and type in (
                        'HT',
                        'VS',
                        'TR',
                        'DP'
                    )
                    and nvl(lead_apprl,ss.pending) in (
                        ss.pending,
                        ss.approved,
                        ss.apprl_none
                    )
                    and nvl(hod_apprl,ss.pending) in (
                        ss.pending,
                        ss.approved
                    )
                    and nvl(hrd_apprl,ss.pending) in (
                        ss.pending
                    )
                    and ( bdate between first_day and last_day
                          or nvl(bdate,edate) between first_day and last_day
                          or first_day between bdate and nvl(bdate,edate) )*/
                );

        v_rec      typ_rec_pending_app;
        v_tab      typ_tab_pending_app;
        v_tab_null typ_tab_pending_app;
    Begin
        Open cur_pending_apps;
        Loop
            Fetch cur_pending_apps Bulk Collect Into v_tab Limit 50;
            For i In 1..v_tab.count
            Loop
                Pipe Row (v_tab(i));
            End Loop;

            v_tab := v_tab_null;
            Exit When cur_pending_apps%notfound;
        End Loop;
        --pipe row ( v_rec );

    End;

End pkg_absent;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_PRIMARY_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_PRIMARY_WORKSPACE" As


    Procedure del_emp_future_planning(
        p_empno               Varchar2,
        p_planning_start_date Date
    ) As
        v_ows_desk_id Varchar2(10);
    Begin

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
        v_ows_desk_id         Varchar2(10);
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
                --If no change then continue
                If tab_primary_workspace(1).primary_workspace = v_workspace_code Then
                    Continue;
                End If;

                --Delete existing SWP DESK ASSIGNMENT planning
                del_emp_future_planning(
                    p_empno               => v_empno,
                    p_planning_start_date => trunc(rec_config_week.start_date)
                );
                --
                v_ows_desk_id := iot_swp_common.get_desk_from_dms(v_empno);
                --Remove user desk association in DMS
                If Trim(v_ows_desk_id) Is Not Null Then
                    iot_swp_dms.sp_remove_desk_user(
                        p_person_id => p_person_id,
                        p_meta_id   => p_meta_id,

                        p_empno     => v_empno,
                        p_deskid    => v_ows_desk_id
                    );
                End If;

                --If furture planning is reverted to old planning then continue
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

        p_emp_perc_office_workspace  Out Number,
        p_emp_perc_smart_workspace   Out Number,

        p_message_type               Out Varchar2,
        p_message_text               Out Varchar2
    ) As
        v_empno              Varchar2(5);
        v_total              Number;
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
        v_friday_date               := iot_swp_common.get_friday_date(nvl(p_start_date, sysdate));
        v_empno                     := get_empno_from_meta_id(p_meta_id);
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
        p_total_emp_count           := nvl(p_emp_count_office_workspace, 0) + nvl(p_emp_count_smart_workspace, 0) + nvl(p_emp_count_not_in_ho, 0);
        v_total                     := (nvl(p_total_emp_count, 0) - nvl(p_emp_count_not_in_ho, 0));
        p_emp_perc_office_workspace := round(((nvl(p_emp_count_office_workspace, 0) / v_total) * 100), 1);
        p_emp_perc_smart_workspace  := round(((nvl(p_emp_count_smart_workspace, 0) / v_total) * 100), 1);

        p_message_type              := 'OK';
        p_message_text              := 'Procedure executed successfully.';
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

        p_emp_perc_office_workspace  Out Number,
        p_emp_perc_smart_workspace   Out Number,

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

            p_emp_perc_office_workspace  => p_emp_perc_office_workspace,
            p_emp_perc_smart_workspace   => p_emp_perc_smart_workspace,

            p_message_type               => p_message_type,
            p_message_text               => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;


End iot_swp_primary_workspace;
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
--Changed PACKAGE BODY
--IOT_EMPLMAST
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_EMPLMAST" As

    Procedure employee_list_dept(p_dept             Varchar2,
                                 p_out_emp_list Out Sys_Refcursor) As
    Begin

        Open p_out_emp_list For
            Select
                empno, name, parent, assign
            From
                ss_emplmast
            Where
                status     = 1
                And parent = p_dept;
    End employee_list_dept;

    Procedure employee_details(p_empno        Varchar2,
                               p_name     Out Varchar2,
                               p_parent   Out Varchar2,
                               p_metaid   Out Varchar2,
                               p_personid Out Varchar2,
                               p_success  Out Varchar2,
                               p_message  Out Varchar2
    ) As
    Begin
        Select
            name, parent, metaid, personid
        Into
            p_name, p_parent, p_metaid, p_personid
        From
            ss_emplmast
        Where
            empno = p_empno;
        p_success := 'OK';
        p_message := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End employee_details;

    Procedure employee_details_ref_cur(p_empno               Varchar2,
                                       p_out_emp_details Out Sys_Refcursor) As
    Begin
        Open p_out_emp_details For
            Select
                name, parent, metaid, personid
            From
                ss_emplmast
            Where
                empno = p_empno;
    End;
    /*
        Function fn_employee_details_ref(p_empno         Varchar2,
                                         p_rownum In Out Number) Return Sys_Refcursor
        As
            c Sys_Refcursor;
        Begin
            Open c For
                Select
                    name, parent, metaid, personid, p_rownum
                From
                    ss_emplmast
                Where
                    empno = p_empno;
            p_rownum := -1;
            Return c;
        End;
    */
    Function fn_employee_details(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2 Default Null
    ) Return Sys_Refcursor
    As
        c                    Sys_Refcursor;
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_empno              Varchar2(5);
    Begin

        If p_empno Is Not Null Then
            v_empno := p_empno;
        Else
            v_empno := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return Null;
            End If;

        End If;
        Open c For
           /* Select
                empno, name, parent, metaid, personid
            From
                ss_emplmast
            Where
                empno = v_empno;
        */

        Select 
            a.empno           ,
            a.name            ,
            a.metaid          ,
            a.personid        ,
            a.grade           AS emp_grade,
            a.email           AS emp_email,
            a.emptype         ,        
            iot_swp_common.get_emp_work_area(p_person_id,p_meta_id,a.empno) As work_area,
            a.parent         As parent_code,
            a.assign         As assign_code,
            ( Select Distinct c.name From ss_costmast c Where c.costcode = a.parent ) As parent_desc,
            ( Select Distinct c.name From ss_costmast c Where c.costcode = a.assign ) As assign_desc     
                From
                    ss_emplmast a
                Where
                    empno = v_empno;
        Return c;
    End;

    Function fn_employee_list_ref(p_dept Varchar2) Return Sys_Refcursor
    As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                empno, name, parent, metaid, personid
            From
                ss_emplmast
            Where
                status = 1;
        --parent     = p_dept
        --And status = 1;
        --p_rownum := -1;
        Return c;
    End;
End iot_emplmast;
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
--IOT_SWP_DMS
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_DMS" As

    /*  p_unqid := 'SWPF'  -- fixed desk
        p_unqid := 'SWPV'  -- variable desk     */

    c_empno_swpv       Constant Varchar2(4)  := 'SWPV';
    c_blockdesk_4_swpv Constant Number(1)    := 7;
    c_unqid_swpv       Constant Varchar2(20) := 'Desk block SWPV';

    Procedure sp_add_desk_user(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_deskid           Varchar2,
        p_parent           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists Number;
    Begin
        Select
            Count(du.empno)
        Into
            v_exists
        From
            dms.dm_usermaster_swp_plan du
        Where
            du.empno        = p_empno
            And du.deskid   = p_deskid
            And du.costcode = p_parent;

        If v_exists = 0 Then
            Insert Into dms.dm_usermaster_swp_plan(empno, deskid, costcode, dep_flag)
            Values
                (p_empno, p_deskid, p_parent, 0);
        Else
            p_message_type := 'KO';
            p_message_text := 'Err : User already assigned desk in DMS';
            Return;
        End If;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_desk_user;

    Procedure sp_remove_desk_user(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_empno     Varchar2,
        p_deskid    Varchar2
    ) As
        v_pk              Varchar2(20);
        v_create_by_empno Varchar2(5);
    Begin
        v_create_by_empno := get_empno_from_meta_id(p_meta_id);

        Delete
            From dms.dm_usermaster_swp_plan du
        Where
            du.empno      = p_empno
            And du.deskid = p_deskid;
        /*
        If p_unqid = 'SWPV' Then
            --send assets to orphan table

            v_pk := dbms_random.string('X', 20);

            Insert Into dms.dm_orphan_asset(unqid, empno, deskid, assetid, createdon, createdby, confirmed)
            Select
                v_pk,
                p_empno,
                deskid,
                assetid,
                sysdate,
                v_create_by_empno,
                0
            From
                dms.dm_deskallocation
            Where
                deskid = p_deskid;

            -- release assets of desk from dm_deskallocation table 

            Delete
                From dms.dm_deskallocation
            Where
                deskid = p_deskid;
        End If;
        */
    End sp_remove_desk_user;

    Procedure sp_lock_desk(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_deskid    Varchar2
    ) As
        v_exists Number;
    Begin
        Select
            Count(dl.empno)
        Into
            v_exists
        From
            dms.dm_desklock_swp_plan dl
        Where
            dl.empno      = c_empno_swpv
            And dl.deskid = p_deskid;

        If v_exists = 0 Then
            Insert Into dms.dm_desklock_swp_plan(unqid, empno, deskid, targetdesk, blockflag, blockreason)
            Values
                (c_unqid_swpv, c_empno_swpv, p_deskid, 0, 1, c_blockdesk_4_swpv);
        Else
            Update
                dms.dm_desklock_swp_plan
            Set
                unqid = c_unqid_swpv,
                targetdesk = 0,
                blockflag = 1,
                blockreason = c_blockdesk_4_swpv
            Where
                empno      = c_empno_swpv
                And deskid = p_deskid;
        End If;
    End sp_lock_desk;

    Procedure sp_unlock_desk(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_deskid      Varchar2,
        p_week_key_id Varchar2
    ) As
        v_count Number;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            swp_smart_attendance_plan
        Where
            Trim(deskid)    = Trim(p_deskid)
            And week_key_id = p_week_key_id;

        --
        If v_count > 0 Then
            Return;
        End If;
        Delete
            From dms.dm_desklock_swp_plan dl
        Where
            Trim(dl.empno)      = Trim(c_empno_swpv)
            And Trim(dl.deskid) = Trim(p_deskid)
            And Trim(dl.unqid)  = Trim(c_unqid_swpv);
    End sp_unlock_desk;

    Procedure sp_clear_desk(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_deskid    Varchar2
    ) As
        v_pk              Varchar2(20);
        v_create_by_empno Varchar2(5);
    Begin
        v_create_by_empno := get_empno_from_meta_id(p_meta_id);

        /* send assets to orphan table */

        v_pk              := dbms_random.string('X', 20);

        Insert Into dms.dm_orphan_asset(unqid, empno, deskid, assetid, createdon, createdby, confirmed)
        Select
            v_pk,
            '',
            deskid,
            assetid,
            sysdate,
            v_create_by_empno,
            0
        From
            dms.dm_deskallocation_swp_plan
        Where
            deskid = p_deskid;

        /* release assets of desk from dm_deskallocation table */

        Delete
            From dms.dm_deskallocation_swp_plan
        Where
            deskid = p_deskid;

    End sp_clear_desk;

End iot_swp_dms;
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
   Select a.KYE_ID, a.DESKID, a.AREA_KEY_ID ,
      b.AREA_KEY_ID, b.AREA_DESC, b.AREA_CATG_CODE, b.AREA_INFO
   From SWP_DESK_AREA_MAPPING a , DMS.DM_DESK_AREAS b
   where a.AREA_KEY_ID = b.AREA_KEY_ID(+);
   */
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
---------------------------
--New PACKAGE BODY
--IOT_SWP_CONFIG_WEEK
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_CONFIG_WEEK" As
    c_plan_close_code  Constant Number := 0;
    c_plan_open_code   Constant Number := 1;
    c_past_plan_code   Constant Number := 0;
    c_cur_plan_code    Constant Number := 1;
    c_future_plan_code Constant Number := 2;

    --

    Procedure sp_update_primary_workspace
    As
    Begin
        Insert Into swp_primary_workspace (key_id, empno, primary_workspace, start_date, modified_on, modified_by, active_code,
        assign_code)
        Select
            dbms_random.string('X', 10), empno, 1, trunc(sysdate), sysdate, 'Sys', 2, assign
        From
            ss_emplmast
        Where
            status = 1
            And emptype In (
                Select
                    emptype
                From
                    swp_include_emptype
            )
            And assign Not In (
                Select
                    assign
                From
                    swp_exclude_assign
            )
            And empno Not In (
                Select
                    empno
                From
                    swp_primary_workspace
            );
    End sp_update_primary_workspace;

    Procedure init_configuration(p_sysdate Date) As
        v_cur_week_mon        Date;
        v_cur_week_fri        Date;
        v_next_week_key_id    Varchar2(8);
        v_current_week_key_id Varchar2(8);
        v_count               Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            swp_config_weeks;
        If v_count > 0 Then
            Return;
        End If;
        v_cur_week_mon        := iot_swp_common.get_monday_date(p_sysdate);
        v_cur_week_fri        := iot_swp_common.get_friday_date(p_sysdate);
        v_current_week_key_id := dbms_random.string('X', 8);
        --Insert New Plan dates
        Insert Into swp_config_weeks(
            key_id,
            start_date,
            end_date,
            planning_flag,
            planning_open
        )
        Values(
            v_current_week_key_id,
            v_cur_week_mon,
            v_cur_week_fri,
            c_cur_plan_code,
            c_plan_close_code
        );

    End;

    --
    Procedure close_planning As
    Begin
        Update
            swp_config_weeks
        Set
            planning_open = c_plan_close_code
        Where
            planning_open = c_plan_open_code;
    End close_planning;
    --

    Procedure do_dms_data_to_plan(p_week_key_id Varchar2) As
    Begin
        Delete
            From dms.dm_usermaster_swp_plan;
        Delete
            From dms.dm_deskallocation_swp_plan;
        Delete
            From dms.dm_desklock_swp_plan;
        Commit;

        Insert Into dms.dm_usermaster_swp_plan(
            fk_week_key_id,
            empno,
            deskid,
            costcode,
            dep_flag
        )
        Select
            p_week_key_id,
            empno,
            deskid,
            costcode,
            dep_flag
        From
            dms.dm_usermaster;

        Insert Into dms.dm_deskallocation_swp_plan(
            fk_week_key_id,
            deskid,
            assetid
        )
        Select
            p_week_key_id,
            deskid,
            assetid
        From
            dms.dm_deskallocation;

        Insert Into dms.dm_desklock_swp_plan(
            fk_week_key_id,
            unqid,
            empno,
            deskid,
            targetdesk,
            blockflag,
            blockreason
        )
        Select
            p_week_key_id,
            unqid,
            empno,
            deskid,
            targetdesk,
            blockflag,
            blockreason
        From
            dms.dm_desklock;
    End;

    Procedure do_dms_snapshot(p_sysdate Date) As

    Begin
        Delete
            From dms.dm_deskallocation_snapshot;

        Insert Into dms.dm_deskallocation_snapshot(
            snapshot_date,
            deskid,
            assetid
        )
        Select
            p_sysdate,
            deskid,
            assetid
        From
            dms.dm_deskallocation;

        Delete
            From dms.dm_usermaster_snapshot;

        Insert Into dms.dm_usermaster_snapshot(
            snapshot_date,
            empno,
            deskid,
            costcode,
            dep_flag
        )
        Select
            p_sysdate,
            empno,
            deskid,
            costcode,
            dep_flag
        From
            dms.dm_usermaster;

        Delete
            From dms.dm_desklock_snapshot;

        Insert Into dms.dm_desklock_snapshot(
            snapshot_date,
            unqid,
            empno,
            deskid,
            targetdesk,
            blockflag,
            blockreason
        )
        Select
            p_sysdate,
            unqid,
            empno,
            deskid,
            targetdesk,
            blockflag,
            blockreason
        From
            dms.dm_desklock;

        Commit;

    End;
    --
    Procedure toggle_plan_future_to_curr As
    Begin
        --Close Planning
        close_planning;
        --toggle CURRENT to PAST
        Update
            swp_config_weeks
        Set
            planning_flag = c_past_plan_code
        Where
            planning_flag = c_cur_plan_code;
        --toggle FUTURE to CURRENT 
        Update
            swp_config_weeks
        Set
            planning_flag = c_cur_plan_code
        Where
            planning_flag = c_future_plan_code;

        --Toggle WorkSpace planning FUTURE to CURRENT
        Update
            swp_primary_workspace
        Set
            active_code = c_past_plan_code
        Where
            active_code = c_cur_plan_code
            And empno In (
                Select
                    empno
                From
                    swp_primary_workspace
                Where
                    active_code = c_future_plan_code
            );

        Update
            swp_primary_workspace
        Set
            active_code = c_cur_plan_code
        Where
            active_code = c_future_plan_code;

    End toggle_plan_future_to_curr;
    --
    Procedure rollover_n_open_planning(p_sysdate Date) As
        v_next_week_mon       Date;
        v_next_week_fri       Date;
        v_next_week_key_id    Varchar2(8);

        rec_config_week       swp_config_weeks%rowtype;
    Begin
        --Close and toggle existing planning
        toggle_plan_future_to_curr;

        v_next_week_mon    := iot_swp_common.get_monday_date(p_sysdate + 6);
        v_next_week_fri    := iot_swp_common.get_friday_date(p_sysdate + 6);
        v_next_week_key_id := dbms_random.string('X', 8);
        --Insert New Plan dates
        Insert Into swp_config_weeks(
            key_id,
            start_date,
            end_date,
            planning_flag,
            planning_open
        )
        Values(
            v_next_week_key_id,
            v_next_week_mon,
            v_next_week_fri,
            c_future_plan_code,
            c_plan_open_code
        );

        --Get current week key id
        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            key_id In (
                Select
                    key_id
                From
                    (
                        Select
                            key_id
                        From
                            swp_config_weeks
                        Where
                            key_id <> v_next_week_key_id
                        Order By start_date Desc
                    )
                Where
                    Rownum = 1
            );

        Insert Into swp_smart_attendance_plan(
            key_id,
            ws_key_id,
            empno,
            attendance_date,
            modified_on,
            modified_by,
            deskid,
            week_key_id
        )
        Select
            dbms_random.string('X', 10),
            a.ws_key_id,
            a.empno,
            trunc(a.attendance_date) + 7,
            p_sysdate,
            'Sys',
            a.deskid,
            v_next_week_key_id
        From
            swp_smart_attendance_plan a
        Where
            week_key_id = rec_config_week.key_id;
        --
        --do snapshot of DESK+USER & DESK+ASSET & Also DESKLOCK mapping
        do_dms_snapshot(trunc(p_sysdate));
        ---

        do_dms_data_to_plan(v_next_week_key_id);
    End rollover_n_open_planning;
    --
    Procedure sp_cofiguration Is
        v_secondlast_workdate Date;
        v_sysdate             Date;
        v_fri_date            Date;
        Type rec Is Record(
                work_date     Date,
                work_day_desc Varchar2(100),
                rec_num       Number
            );

        Type typ_tab_work_day Is Table Of rec;
        tab_work_day          typ_tab_work_day;
    Begin
        sp_update_primary_workspace;
        v_sysdate  := trunc(sysdate);
        v_fri_date := iot_swp_common.get_friday_date(trunc(v_sysdate));
        --
        init_configuration(v_sysdate);
        --
        Select
            d_date As work_date,
            Case Rownum
                When 1 Then
                    'LAST'
                When 2 Then
                    'SECOND_LAST'
                Else
                    Null
            End    work_day_desc,
            Rownum As rec_num
        Bulk Collect
        Into
            tab_work_day
        From
            (
                Select
                    *
                From
                    ss_days_details
                Where
                    d_date <= v_fri_date
                    And d_date >= trunc(v_sysdate)
                    And d_date Not In
                    (
                        Select
                            trunc(holiday)
                        From
                            ss_holidays
                        Where
                            (holiday <= v_fri_date
                                And holiday >= trunc(v_sysdate))
                    )
                Order By d_date Desc
            )
        Where
            Rownum In(1, 2);

        If tab_work_day.count = 2 Then
            --v_sysdate EQUAL SECOND_LAST working day "THURSDAY"
            If v_sysdate = tab_work_day(2).work_date Then --SECOND_LAST working day
                rollover_n_open_planning(v_sysdate);
                --v_sysdate EQUAL LAST working day "FRIDAY"
                --        ElsIf V_SYSDATE = tab_work_day(1).work_date Then --LAST working day
            Else
                toggle_plan_future_to_curr;

            End If;
        End If;
    End sp_cofiguration;

End iot_swp_config_week;
/
---------------------------
--Changed PACKAGE BODY
--IOT_DESK_DETAILS
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_DESK_DETAILS" As
    Procedure employee_desk_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_desk_id         Out Varchar2,
        p_comp_name       Out Varchar2,
        p_computer        Out Varchar2,
        p_pc_model        Out Varchar2,
        p_monitor1        Out Varchar2,
        p_monitor1_model  Out Varchar2,
        p_monitor2        Out Varchar2,
        p_monitor2_model  Out Varchar2,
        p_telephone       Out Varchar2,
        p_telephone_model Out Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;
        Select
            a.deskid,
            a.compname,
            a.computer,
            a.pcmodel,
            a.monitor1,
            a.monmodel1,
            a.monitor2,
            a.monmodel2,
            a.telephone,
            a.telmodel
        Into
            p_desk_id,
            p_comp_name,
            p_computer,
            p_pc_model,
            p_monitor1,
            p_monitor1_model,
            p_monitor2,
            p_monitor2_model,
            p_telephone,
            p_telephone_model
        From
            dms.desmas_allocation_all a
        Where
            a.empno1 = v_empno;
        p_message_type := 'OK';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;
End;
/
---------------------------
--Changed PACKAGE BODY
--IOT_HOLIDAY_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_HOLIDAY_QRY" As

   Function get_holiday_attendance(
      p_empno       Varchar2,
      p_start_date  Date,
      p_end_date    Date,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor As
      c Sys_Refcursor;
   Begin
      Open c For
         Select *
           From (
                   Select to_char(app_date, 'dd-Mon-yyyy') As applied_on,
                          a.app_no As app_no,
                          a.description As description,
                          get_emp_name(lead_apprl_empno) As lead_name,
                          a.lead_apprldesc As lead_approval,
                          a.hod_apprldesc As hod_approval,
                          a.hrd_apprldesc As hr_approval,
                          a.lead_reason As lead_remarks,
                          a.pdate As holiday_attendance_date,
                          Case
                             When (a.pdate < sysdate)
                                Or (a.hod_apprl > 0)
                             Then
                                1
                             Else
                                0
                          End delete_allowed,
                          Row_Number() Over (Order By app_date Desc) row_number,
                          Count(*) Over () total_row
                     From ss_ha_app_stat a
                    Where empno = p_empno
                      And a.app_date >= nvl(p_start_date, add_months(sysdate, - 3))
                      And trunc(a.app_date) <= nvl(p_end_date, trunc(a.app_date))
                    -- empno = p_empno And a.app_date >= add_months(sysdate, - 3)
                    Order By pdate Desc
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

      Return c;

   End;

   Function fn_holiday_attendance(
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
      c       := get_holiday_attendance(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
      Return c;
   End fn_holiday_attendance;

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
         Select *
           From (
                   Select to_char(app_date, 'dd-Mon-yyyy') As Application_Date,
                          a.app_no As Application_Id,
                          A.empno As Empno,
                          B.Name As Emp_Name,
                          A.PROJNO As Project,
                          GetEmpName(A.Lead_Apprl_EmpNo) As Lead_Name,
                          to_char(A.Pdate, 'dd-Mon-yyyy') ||'  '||A.START_HH
                          || ':'
                          || A.START_MM
                          || ' To '
                          || A.END_HH
                          || ':'
                          || A.END_MM As Attendance_Date,
                          A.location As office,
                          A.LEAD_REASON As Lead_remarks,
                          B.Parent As Parent,
                          Row_Number() Over (Order By a.app_date) As row_number,
                          Count(*) Over () As total_row
                     From SS_Holiday_Attendance A, SS_EmplMast B
                    Where A.EmpNo = B.EmpNo
                      And (nvl(Lead_apprl, 0) = 0)
                      And (nvl(Hrd_apprl, 0) = 0)
                      And (nvl(Hod_apprl, 0) = 0)
                      And Lead_Apprl_EmpNo = Trim(v_lead_empno)
                    Order By Parent, A.empno
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
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
         Select *
           From (
                   Select to_char(app_date, 'dd-Mon-yyyy') As Application_Date,
                          a.app_no As Application_Id,
                          A.empno As Empno,
                          B.Name As Emp_Name,
                          A.PROJNO As Project,
                          GetEmpName(A.Lead_Apprl_EmpNo) As Lead_Name,
                          to_char(A.Pdate, 'dd-Mon-yyyy') ||'  '||A.START_HH
                          || ':'
                          || A.START_MM
                          || ' To '
                          || A.END_HH
                          || ':'
                          || A.END_MM As Attendance_Date,
                          A.location As office,
                          A.HODREASON As hod_remarks,
                          B.Parent As Parent,
                          Row_Number() Over (Order By a.app_date) As row_number,
                          Count(*) Over () As total_row
                     From SS_Holiday_Attendance A, SS_EmplMast B
                    Where (nvl(Lead_apprl, 0) In (1, 4))
                      And (nvl(Hrd_apprl, 0) = 0)
                      And (nvl(Hod_apprl, 0) = 0)
                      And A.EmpNo = B.EmpNo
                      And A.EmpNo In (Select empno From SS_EmplMast Where Mngr = Trim(v_hod_empno))
                    Order By Parent, A.empno
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
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
         Select *
           From (
                   Select to_char(app_date, 'dd-Mon-yyyy') As Application_Date,
                          a.app_no As Application_Id,
                          A.empno As Empno,
                          B.Name As Emp_Name,
                          A.PROJNO As Project,
                          GetEmpName(A.Lead_Apprl_EmpNo) As Lead_Name,
                          to_char(A.Pdate, 'dd-Mon-yyyy') ||'  '||A.START_HH
                          || ':'
                          || A.START_MM
                          || ' To '
                          || A.END_HH
                          || ':'
                          || A.END_MM As Attendance_Date,
                          A.location As office,
                          A.HODREASON As hod_remarks,
                          B.Parent As Parent,
                          Row_Number() Over (Order By a.app_date) As row_number,
                          Count(*) Over () As total_row
                     From SS_Holiday_Attendance A, SS_EmplMast B
                    Where (NVL(Lead_apprl, 0) In (1, 4))
                      And (NVL(Hrd_apprl, 0) = 0)
                      And (NVL(Hod_apprl, 0) = 0)
                      And A.EmpNo = B.EmpNo
                      And A.EmpNo In
                          (
                             Select empno
                               From SS_EmplMast
                              Where Mngr In
                                    (Select Mngr From SS_Delegate Where empno = Trim(v_hod_empno)
                                    )
                          )
                    Order By Parent, A.empno
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
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
         Select *
           From (
                  Select to_char(app_date, 'dd-Mon-yyyy') As Application_Date,
                          a.app_no As Application_Id,
                          A.empno As Empno,
                          B.Name As Emp_Name,
                          A.PROJNO As Project,
                          GetEmpName(A.Lead_Apprl_EmpNo) As Lead_Name,
                          to_char(A.Pdate, 'dd-Mon-yyyy') ||'  '||A.START_HH
                          || ':'
                          || A.START_MM
                          || ' To '
                          || A.END_HH
                          || ':'
                          || A.END_MM As Attendance_Date,
                          A.location As office,
                          A.HRDREASON As Hr_remarks,
                          B.Parent As Parent,
                          Row_Number() Over (Order By a.app_date) As row_number,
                          Count(*) Over () As total_row
                     From SS_Holiday_Attendance A, SS_EmplMast B
                    Where (nvl(Lead_apprl, 0) In (1, 4))
                      And (nvl(Hod_apprl, 0) = 1)
                      And A.EmpNo = B.EmpNo
                      And (nvl(Hrd_apprl, 0) = 0)
                    Order By Parent, A.empno

                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
      Return c;
   End fn_pending_hr_approval;

Procedure sp_holiday_details(
          p_person_id            Varchar2,
          p_meta_id              Varchar2,

          p_Application_Id       Varchar2,

          P_Employee            Out Varchar2,
          P_PROJNO           Out Varchar2,
          P_Lead_Name        Out Varchar2,
          P_Attendance_Date  Out Varchar2,
          P_Punch_In_Time    Out Varchar2,
          P_Punch_Out_Time   Out Varchar2,
          P_REMARKS          Out Varchar2,
          P_Office           Out Varchar2,
          P_LEAD_APPRL       Out Varchar2,
          P_LEAD_APPRL_DATE  Out Varchar2,
          P_LEAD_APPRL_EMPNO Out Varchar2,
          P_HOD_APPRL        Out Varchar2,
          P_HOD_APPRL_DATE   Out Varchar2,
          P_HR_APPRL         Out Varchar2,
          P_HR_APPRL_DATE    Out Varchar2,
          P_DESCRIPTION      Out Varchar2,
          P_Application_Date Out Varchar2,
          P_HOD_Remarks      Out Varchar2,
          P_Hr_Remarks       Out Varchar2,
          P_Lead_Remarks     Out Varchar2,

          p_message_type     Out Varchar2,
          p_message_text     Out Varchar2
   ) As
   v_empno        Varchar2(5);
   v_user_tcp_ip  Varchar2(5) := 'NA';
   v_message_type Number      := 0;
Begin
   v_empno        := get_empno_from_meta_id(p_meta_id);

   If v_empno = 'ERRRR' Then
      p_message_type := 'KO';
      p_message_text := 'Invalid employee number';
      Return;
   End If;

   Select A.EMPNO ||' - ' ||GetEmpName(A.EMPNO) As Employee,
          A.PROJNO As PROJNO,
          GetEmpName(A.Lead_Apprl_EmpNo) As Lead_Name,
          to_char(A.PDATE, 'dd-Mon-yyyy') As Attendance_Date,
          to_char(A.START_HH)
          || ':'
          || to_char(A.START_MM) As Punch_In_Time,
          to_char(A.END_HH)
          || ':'
          || to_char(A.END_MM) As Punch_Out_Time,
          A.REMARKS As,
          A.LOCATION As office,
          Case A.LEAD_APPRL 
               when 0 then 'Pending'
               when 1 then 'Approved'
               when 2 then 'Rejected'
               Else '' end  As Lead_Apprl,
          to_char(A.LEAD_APPRL_DATE, 'dd-Mon-yyyy') As LEAD_APPRL_DATE,
          A.LEAD_APPRL_EMPNO As LEAD_APPRL_EMPNO,
          Case A.HOD_APPRL 
               when 0 then 'Pending'
               when 1 then 'Approved'
               when 2 then 'Rejected'
               Else '' end As HOD_APPRL,
          to_char(A.HOD_APPRL_DATE, 'dd-Mon-yyyy') As HOD_APPRL_DATE,
          Case A.HRD_APPRL 
               when 0 then 'Pending'
               when 1 then 'Approved'
               when 2 then 'Rejected'
               Else '' end  As HR_APPRL,
          to_char(A.HRD_APPRL_DATE, 'dd-Mon-yyyy') As HR_APPRL_DATE,
          A.DESCRIPTION As DESCRIPTION,
          to_char(A.app_date, 'dd-Mon-yyyy') As Application_Date,
          A.HODREASON As HOD_Remarks,
          A.HRDREASON As Hr_Remarks,
          A.LEAD_REASON As Lead_Remarks
     Into P_Employee,
          P_PROJNO,
          P_Lead_Name,
          P_Attendance_Date,
          P_Punch_In_Time,
          P_Punch_Out_Time,
          P_REMARKS,
          P_Office,
          P_LEAD_APPRL,
          P_LEAD_APPRL_DATE,
          P_LEAD_APPRL_EMPNO,
          P_HOD_APPRL,
          P_HOD_APPRL_DATE,
          P_HR_APPRL,
          P_HR_APPRL_DATE,
          P_DESCRIPTION,
          P_Application_Date,
          P_HOD_Remarks,
          P_Hr_Remarks,
          P_Lead_Remarks
     From SS_HOLIDAY_ATTENDANCE A
    Where A.APP_NO = P_Application_Id;

   p_message_type := 'OK';
   p_message_text := 'Procedure executed successfully.';

   Exception
   When Others Then
      p_message_type := 'KO';
      p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

End sp_holiday_details;

   --  GRANT EXECUTE ON "IOT_HOLIDAY_QRY" TO "TCMPL_APP_CONFIG";

End iot_holiday_qry;
/
---------------------------
--New PACKAGE BODY
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
--New PACKAGE BODY
--IOT_SWP_OFFICE_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_OFFICE_WORKSPACE" As

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
                v_empno, v_attendance_date, v_desk, v_ststue
            From
                csv;

            Delete
                From swp_smart_attendance_plan
            Where
                empno               = v_empno
                And attendance_date = v_attendance_date;

            If v_ststue = '1' Then

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
        v_ststue          Varchar2(5);
        v_mod_by_empno    Varchar2(5);
        v_pk              Varchar2(10);
        v_fk              Varchar2(10);
        v_empno           Varchar2(5);
        v_attendance_date Date;
        v_desk            Varchar2(20);
        v_parent          Varchar2(4);
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
        Select
            parent
        Into
            v_parent
        From
            ss_emplmast
        Where
            empno = p_empno;
        /*
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
        */
        iot_swp_dms.sp_add_desk_user(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_empno        => p_empno,
            p_deskid       => p_deskid,
            p_parent       => v_parent,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

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

        p_emp_perc_office_workspace  Out Number,
        p_emp_perc_smart_workspace   Out Number,

        p_message_type               Out Varchar2,
        p_message_text               Out Varchar2
    ) As
        v_empno              Varchar2(5);
        v_total              Number;
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
        v_friday_date               := iot_swp_common.get_friday_date(nvl(p_start_date, sysdate));
        v_empno                     := get_empno_from_meta_id(p_meta_id);
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
        p_total_emp_count           := nvl(p_emp_count_office_workspace, 0) + nvl(p_emp_count_smart_workspace, 0) + nvl(p_emp_count_not_in_ho, 0);
        v_total                     := (nvl(p_total_emp_count, 0) - nvl(p_emp_count_not_in_ho, 0));
        p_emp_perc_office_workspace := round(((nvl(p_emp_count_office_workspace, 0) / v_total) * 100), 1);
        p_emp_perc_smart_workspace  := round(((nvl(p_emp_count_smart_workspace, 0) / v_total) * 100), 1);

        p_message_type              := 'OK';
        p_message_text              := 'Procedure executed successfully.';
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

        p_emp_perc_office_workspace  Out Number,
        p_emp_perc_smart_workspace   Out Number,

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

            p_emp_perc_office_workspace  => p_emp_perc_office_workspace,
            p_emp_perc_smart_workspace   => p_emp_perc_smart_workspace,

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
        v_start_date   := iot_swp_common.get_monday_date(p_date);
        v_end_date     := iot_swp_common.get_friday_date(p_date);
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

End IOT_SWP_OFFICE_WORKSPACE;
/
