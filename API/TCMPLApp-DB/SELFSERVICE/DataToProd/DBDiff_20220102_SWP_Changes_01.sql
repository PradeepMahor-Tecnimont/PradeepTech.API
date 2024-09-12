--------------------------------------------------------
--  File created - Sunday-January-02-2022   
--------------------------------------------------------
---------------------------
--New TABLE
--SWP_MAP_EMP_TASKFORCE
---------------------------
  CREATE TABLE "SELFSERVICE"."SWP_MAP_EMP_TASKFORCE" 
   (	"EMPNO" CHAR(5) NOT NULL ENABLE,
	"PROJNO" VARCHAR2(5) NOT NULL ENABLE,
	"TASKFORCE_DOJ" DATE,
	"MODIFIED_ON" DATE,
	"MODIFIED_BY" VARCHAR2(5),
	CONSTRAINT "SWP_EMP_TASKFORCE_MAP_PK" PRIMARY KEY ("EMPNO","PROJNO") ENABLE
   );
---------------------------
--New TABLE
--SS_ROLES
---------------------------
  CREATE TABLE "SELFSERVICE"."SS_ROLES" 
   (	"ROLE_ID" CHAR(5) NOT NULL ENABLE,
	"ROLE_DESC" VARCHAR2(100),
	CONSTRAINT "SS_ROLES_PK" PRIMARY KEY ("ROLE_ID") ENABLE
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
--New TABLE
--SWP_EXCLUDE_ASSIGN
---------------------------
  CREATE TABLE "SELFSERVICE"."SWP_EXCLUDE_ASSIGN" 
   (	"ASSIGN" VARCHAR2(4)
   );
---------------------------
--New TABLE
--SS_USER_ROLES
---------------------------
  CREATE TABLE "SELFSERVICE"."SS_USER_ROLES" 
   (	"EMPNO" CHAR(5) NOT NULL ENABLE,
	"ROLE_ID" CHAR(5) NOT NULL ENABLE,
	"IS_ACTIVE" NUMBER NOT NULL ENABLE,
	CONSTRAINT "TABLE1_PK" PRIMARY KEY ("EMPNO","ROLE_ID") ENABLE
   );
---------------------------
--New TABLE
--SWP_INCLUDE_EMPTYPE
---------------------------
  CREATE TABLE "SELFSERVICE"."SWP_INCLUDE_EMPTYPE" 
   (	"EMPTYPE" VARCHAR2(1)
   );
---------------------------
--New TABLE
--SWP_MAP_EMP_PROJECT
---------------------------
  CREATE TABLE "SELFSERVICE"."SWP_MAP_EMP_PROJECT" 
   (	"EMPNO" CHAR(5),
	"PROJNO" VARCHAR2(5)
   );
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
	CONSTRAINT "SWP_WFH_WEEKATND_PK" PRIMARY KEY ("KEY_ID") ENABLE
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
	"ACTIVE_CODE" NUMBER(1,0)
   );
  COMMENT ON COLUMN "SELFSERVICE"."SWP_PRIMARY_WORKSPACE"."ACTIVE_CODE" IS '2(Current/Future), 1(Current), 0(Past)';
  COMMENT ON COLUMN "SELFSERVICE"."SWP_PRIMARY_WORKSPACE"."PRIMARY_WORKSPACE" IS '1(Office),2(SmartWork),3(Not in mumbai office)';
---------------------------
--New TABLE
--SWP_EMP_PRIMARY_WORKSPACE_HIST
---------------------------
  CREATE TABLE "SELFSERVICE"."SWP_EMP_PRIMARY_WORKSPACE_HIST" 
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
--Changed VIEW
--TCMPL_APP_CONFIG
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."TCMPL_APP_CONFIG" 
 ( ""
  )  AS 
  Select
        ur.module_id,
        m.module_name,
        ur.role_id,
        r.role_name,
        ur.empno,
        ur.person_id,
        ra.action_id
    From
        sec_module_user_roles   ur,
        sec_modules             m,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        ur.module_id              = m.module_id
        And ur.role_id            = r.role_id
        And ur.module_role_key_id = ra.module_role_key_id(+)
    Union
    Select
        mr.module_id,
        Null module_name,
        mr.role_id,
        r.role_desc,
        hod  empno,
        Null person_id,
        ra.action_id
    From
        vu_costmast             c,
        sec_module_roles        mr,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        mr.role_id       = app_constants.role_id_hod
        And mr.role_id   = r.role_id
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.action_id(+)
    Union
    Select
        mr.module_id,
        Null      module_name,
        mr.role_id,
        r.role_desc,
        mngr.mngr empno,
        Null      person_id,
        ra.action_id
    From
        (
            Select
            Distinct mngr
            From
                vu_emplmast
            Where
                status = 1
                And mngr Is Not Null
        )                       mngr,
        sec_module_roles        mr,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        mr.role_id       = app_constants.role_id_mngr_hod
        And mr.role_id   = r.role_id
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.action_id(+)
        And mr.module_id = 'M04'
    Union
    Select
        mr.module_id,
        Null    module_name,
        mr.role_id,
        r.role_desc,
        d.empno empno,
        Null    person_id,
        ra.action_id
    From
        selfservice.ss_delegate d,
        sec_module_roles        mr,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        mr.role_id       = app_constants.role_id_mngr_hod_onbehalf
        And mr.role_id   = r.role_id
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.action_id(+)
        And mr.module_id = 'M04'
    Union
    Select
        mr.module_id,
        Null          module_name,
        mr.role_id,
        r.role_desc,
        lead.empno,
        lead.personid person_id,
        ra.action_id
    From
        (
            Select
                empno, personid
            From
                vu_emplmast
            Where
                status = 1
                And empno In (
                    Select
                        empno
                    From
                        selfservice.ss_lead_approver
                )
        )                       lead,
        sec_module_roles        mr,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        mr.role_id       = app_constants.role_id_lead
        And mr.role_id   = r.role_id
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.action_id(+)
        And mr.module_id = 'M04'
    Union
    Select
        mr.module_id,
        Null          module_name,
        mr.role_id,
        r.role_desc,
        lead.empno,
        lead.personid person_id,
        ra.action_id
    From
        (
            Select
                empno, personid
            From
                vu_emplmast
            Where
                status = 1
                And empno In (
                    Select
                        empno
                    From
                        selfservice.ss_user_dept_rights
                )
        )                       lead,
        sec_module_roles        mr,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        mr.role_id       = app_constants.role_id_lead
        And mr.role_id   = r.role_id
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.action_id(+)
        And mr.module_id = 'M04';
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
--New VIEW
--DM_VU_EMP_DM_TYPE_MAP
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_VU_EMP_DM_TYPE_MAP" 
 ( "EMPNO", "EMP_DM_TYPE", "DM_TYPE_DESC"
  )  AS 
  SELECT 
    "EMPNO","EMP_DM_TYPE","DM_TYPE_DESC"
FROM 
    
dms.dm_vu_emp_dm_type_map;
---------------------------
--New VIEW
--DM_VU_DESK_AREAS
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_VU_DESK_AREAS" 
 ( "AREA_KEY_ID", "AREA_DESC", "IS_SHARED_AREA"
  )  AS 
  SELECT 
    "AREA_KEY_ID","AREA_DESC","IS_SHARED_AREA"
FROM 
    
dms.dm_desk_areas;
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
--DM_VU_EMP_DESK_MAP
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_VU_EMP_DESK_MAP" 
 ( "EMPNO", "DESKID", "MODIFIED_ON", "MODIFIED_BY"
  )  AS 
  SELECT 
    "EMPNO","DESKID","MODIFIED_ON","MODIFIED_BY"
FROM 
    
dms.dm_vu_emp_desk_map;
---------------------------
--New VIEW
--SS_VU_JOBMASTER
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_JOBMASTER" 
 ( "PROJNO", "PHASE", "SHORT_DESC", "TASKFORCE"
  )  AS 
  select projno,phase,short_desc,taskforce from TIMECURR.jobmaster ;
---------------------------
--New INDEX
--SWP_EMP_TASKFORCE_MAP_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SWP_EMP_TASKFORCE_MAP_PK" ON "SELFSERVICE"."SWP_MAP_EMP_TASKFORCE" ("EMPNO","PROJNO");
---------------------------
--New INDEX
--SWP_WFH_WEEKATND_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SWP_WFH_WEEKATND_PK" ON "SELFSERVICE"."SWP_SMART_ATTENDANCE_PLAN" ("KEY_ID");
---------------------------
--New INDEX
--SS_HSESUGG_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_HSESUGG_PK" ON "SELFSERVICE"."SS_HSESUGG" ("SUGGNO");
---------------------------
--New INDEX
--SS_ABSENT_TS_LEAVE_PK1
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_ABSENT_TS_LEAVE_PK1" ON "SELFSERVICE"."SS_ABSENT_TS_LEAVE" ("EMPNO","TDATE","PROJNO","ACTIVITY");
---------------------------
--New PACKAGE
--IOT_SWP_COMMON
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_COMMON" As

    Function get_emp_work_area(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2
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

    Function is_emp_laptop_user(
        p_empno Varchar2
    ) Return Number;

End iot_swp_common;
/
---------------------------
--New PACKAGE
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


   Cursor cur_reserved_area_list(p_date        Date,
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

             )
       Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

   Cursor cur_general_area_list(p_office      Varchar2,
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
             )
       Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

 Cursor cur_restricted_area_list(p_date        Date,
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
                 Where a.AREA_CATG_CODE = 'A003'
                 Order By a.area_desc, a.office, a.floor

             )
       Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

   Type typ_area_list Is Table Of cur_general_area_list%rowtype;

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

   Function fn_work_area_desk(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,

      p_date        Date,
      p_work_area   Varchar2,
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

End IOT_SWP_SMART_WORKSPACE_QRY;
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

   Cursor cur_general_area_list(p_office      Varchar2,
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

   Type typ_area_list Is Table Of cur_general_area_list%rowtype;

   Function fn_office_planning(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_date        Date,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

   Function fn_general_area_list(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_date        Date Default Null,

      p_row_number  Number,
      p_page_length Number
   ) Return typ_area_list
      Pipelined;

   Function fn_work_area_desk(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,

      p_date        Date,
      p_work_area   Varchar2,
      p_wing        Varchar2 Default Null,

      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

End IOT_SWP_OFFICE_WORKSPACE_QRY;
/
---------------------------
--New PACKAGE
--IOT_SWP_OFFICE_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_OFFICE_WORKSPACE" As

   Procedure sp_add_office_ws_desk(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_deskid           Varchar2,
      p_empno            Varchar2,
      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   );

End IOT_SWP_OFFICE_WORKSPACE;
/
---------------------------
--New PACKAGE
--IOT_SWP_PRIMARY_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_PRIMARY_WORKSPACE_QRY" As

    --**--
    Function fn_emp_primary_ws_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_assign_code Varchar2 Default Null,
        p_start_date  Date     Default Null,

        p_empno       Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_emp_primary_ws_plan_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_assign_code Varchar2 Default Null,

        p_empno       Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

End iot_swp_primary_workspace_qry;
/
---------------------------
--New PACKAGE
--IOT_SWP_ACTION
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_ACTION" As

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;


    Procedure sp_add_atnd(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_weekly_attendance typ_tab_string,
        p_empno             Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    );

End iot_swp_action;
/
---------------------------
--New PACKAGE
--IOT_SWP_PRIMARY_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_PRIMARY_WORKSPACE" As

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;

    Procedure sp_add_weekly_atnd(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_weekly_attendance typ_tab_string,
        p_empno             Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    );

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
End iot_swp_primary_workspace;
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
--New PACKAGE
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

/*    Function fn_employee_list_4_sec_hod(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;
*/
    Function fn_costcode_list_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

End iot_swp_select_list_qry;
/
---------------------------
--New PACKAGE
--IOT_SWP_CONFIG_WEEK
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_CONFIG_WEEK" As

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;

    Procedure do_cofiguration;

End iot_swp_config_week;
/
---------------------------
--New PACKAGE BODY
--IOT_SWP_OFFICE_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_OFFICE_WORKSPACE_QRY" As

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
      v_start_date         Date := (IOT_SWP_COMMON.get_monday_date(p_date) - 1);
      v_end_date           Date := (IOT_SWP_COMMON.get_friday_date(p_date));
      Cursor cur_days Is
         Select to_char(d_date, 'yyyymmdd') yymmdd, to_char(d_date, 'DY') dday
           From ss_days_details
          Where d_date Between v_start_date And v_end_date;
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

      Open cur_general_area_list(Null, Null, Null, p_row_number, p_page_length);
      Loop
         Fetch cur_general_area_list Bulk Collect Into tab_area_list_ko Limit 50;
         For i In 1..tab_area_list_ko.count
         Loop
            Pipe Row(tab_area_list_ko(i));

         End Loop;
         Exit When cur_general_area_list%notfound;
      End Loop;
      Close cur_general_area_list;
      Return;

   End fn_general_area_list;

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
         Select *
           From (
                   Select mast.deskid As deskid,
                          mast.office As office,
                          mast.floor As floor,
                          mast.seatno As seat_no,
                          mast.wing As wing,
                          mast.assetcode As asset_code,
                          mast.bay As bay,
                          Row_Number() Over (Order By deskid Desc) row_number,
                          Count(*) Over () total_row
                     From dms.dm_deskmaster mast
                    Where mast.work_area = Trim(p_work_area)
                      And (p_wing Is Null Or mast.wing = p_wing)
                      And mast.deskid
                          Not In(
                             Select Distinct swptbl.deskid
                               From swp_smart_attendance_plan swptbl
                             --where (trunc(ATTENDANCE_DATE) = TRUNC(p_date) or p_date is null)
                             Union
                             Select Distinct c.deskid
                               From dm_vu_emp_desk_map c
                          )
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
          Order By deskid,
                seat_no;
      Return c;
   End fn_work_area_desk;

End IOT_SWP_OFFICE_WORKSPACE_QRY;
/
---------------------------
--New PACKAGE BODY
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
--New PACKAGE BODY
--IOT_SWP_SMART_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_SMART_WORKSPACE_QRY" As

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
         v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        Open cur_reserved_area_list(p_date,Null, Null, Null, p_row_number, p_page_length);
        Loop
            Fetch cur_reserved_area_list Bulk Collect Into tab_area_list_ok Limit 50;
            For i In 1..tab_area_list_ok.count
            Loop
                Pipe Row(tab_area_list_ok(i));

            End Loop;
            Exit When cur_reserved_area_list%notfound;
        End Loop;
        Close cur_reserved_area_list;
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

      Open cur_general_area_list(Null, Null, Null, p_row_number, p_page_length);
      Loop
         Fetch cur_general_area_list Bulk Collect Into tab_area_list_ko Limit 50;
         For i In 1..tab_area_list_ko.count
         Loop
            Pipe Row(tab_area_list_ko(i));

         End Loop;
         Exit When cur_general_area_list%notfound;
      End Loop;
      Close cur_general_area_list;
      Return;

   End fn_general_area_list;

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
         Select *
           From (
                   Select mast.deskid As deskid,
                          mast.office As office,
                          mast.floor As floor,
                          mast.seatno As seat_no,
                          mast.wing As wing,
                          mast.assetcode As asset_code,
                          mast.bay As bay,
                          Row_Number() Over (Order By deskid Desc) row_number,
                          Count(*) Over () total_row
                     From dms.dm_deskmaster mast
                    Where mast.work_area = Trim(p_work_area)
                      And (p_wing Is Null Or mast.wing = p_wing)
                      And mast.deskid
                          Not In(
                             Select Distinct swptbl.deskid
                               From swp_smart_attendance_plan swptbl
                              Where (trunc(ATTENDANCE_DATE) = TRUNC(p_date) Or p_date Is Null)
                             Union
                             Select Distinct c.deskid
                               From dm_vu_emp_desk_map c
                          )
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
          Order By deskid,
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

        Open cur_restricted_area_list(p_date,Null, Null, Null, p_row_number, p_page_length);
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
        v_start_date         Date := IOT_SWP_COMMON.get_monday_date(trunc(p_date));
        v_end_date           Date := IOT_SWP_COMMON.get_friday_date(trunc(p_date));
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
        v_start_date         Date := IOT_SWP_COMMON.get_monday_date(p_date) - 1;
        v_end_date           Date := IOT_SWP_COMMON.get_friday_date(p_date);
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

End IOT_SWP_SMART_WORKSPACE_QRY;
/
---------------------------
--New PACKAGE BODY
--IOT_SWP_CONFIG_WEEK
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_CONFIG_WEEK" As
    c_plan_close  Constant Number := 0;
    c_plan_open   Constant Number := 1;
    c_past_plan   Constant Number := 0;
    c_cur_plan    Constant Number := 1;
    c_future_plan Constant Number := 2;

    --
    Procedure init_configuration(p_sysdate Date) As
        v_next_week_mon       Date;
        v_next_week_fri       Date;
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
        v_next_week_mon       := iot_swp_qry.get_monday_date(p_sysdate + 6);
        v_next_week_fri       := iot_swp_qry.get_friday_date(p_sysdate + 6);
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
            v_next_week_mon,
            v_next_week_fri,
            c_future_plan,
            c_plan_close
        );

    End;

    --
    Procedure close_planning As
    Begin
        Update
            swp_config_weeks
        Set
            planning_open = c_plan_close
        Where
            planning_open = c_plan_open;
    End close_planning;
    --

    Procedure toggle_plan_future_to_curr As
    Begin
        --Close Planning
        close_planning;
        --toggle CURRENT to PAST
        Update
            swp_config_weeks
        Set
            planning_flag = c_past_plan
        Where
            planning_flag = c_cur_plan;
        --toggle FUTURE to CURRENT 
        Update
            swp_config_weeks
        Set
            planning_flag = c_cur_plan
        Where
            planning_flag = c_future_plan;

        --Toggle WorkSpace planning FUTURE to CURRENT
        Update
            swp_primary_workspace
        Set
            active_code = c_past_plan
        Where
            active_code = c_cur_plan
            And empno In (
                Select
                    empno
                From
                    swp_primary_workspace
                Where
                    active_code = c_future_plan
            );

        Update
            swp_primary_workspace
        Set
            active_code = c_cur_plan
        Where
            active_code = c_future_plan;

    End toggle_plan_future_to_curr;
    --
    Procedure rollover_n_open_planning(p_sysdate Date) As
        v_next_week_mon       Date;
        v_next_week_fri       Date;
        v_next_week_key_id    Varchar2(8);
        v_current_week_key_id Varchar2(8);
    Begin
        --Close and toggle existing planning
        toggle_plan_future_to_curr;

        v_next_week_mon    := iot_swp_qry.get_monday_date(p_sysdate + 6);
        v_next_week_fri    := iot_swp_qry.get_friday_date(p_sysdate + 6);
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
            c_future_plan,
            c_plan_open
        );

        --Get current week key id
        Select
            key_id
        Into
            v_current_week_key_id
        From
            swp_config_weeks
        Where
            planning_flag = c_cur_plan;

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
            week_key_id = v_current_week_key_id;

    End rollover_n_open_planning;
    --
    Procedure do_cofiguration Is
        v_secondlast_workdate Date;
        v_sysdate             Date;
        Type rec Is Record(
                work_date     Date,
                work_day_desc Varchar2(100),
                rec_num       Number
            );

        Type typ_tab_work_day Is Table Of rec;
        tab_work_day          typ_tab_work_day;
    Begin

        v_sysdate := trunc(sysdate);
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
                    d_date < (selfservice.iot_swp_qry.get_friday_date(trunc(sysdate)))
                    And d_date >= trunc(sysdate)
                    And d_date Not In
                    (
                        Select
                            trunc(holiday)
                        From
                            ss_holidays
                        Where
                            (holiday < (selfservice.iot_swp_qry.get_friday_date(trunc(sysdate)))
                                And holiday >= trunc(sysdate))
                    )
                Order By d_date Desc
            )
        Where
            Rownum In(1, 2);

        --sysdate EQUAL SECOND_LAST working day "THURSDAY"
        If v_sysdate = tab_work_day(2).work_date Then --SECOND_LAST working day
            rollover_n_open_planning(v_sysdate);
            --sysdate EQUAL LAST working day "FRIDAY"
            --        ElsIf v_sysdate = tab_work_day(1).work_date Then --LAST working day
        Else
            toggle_plan_future_to_curr;

        End If;

    End do_cofiguration;

End iot_swp_config_week;
/
---------------------------
--New PACKAGE BODY
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
--New PACKAGE BODY
--IOT_SWP_PRIMARY_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_PRIMARY_WORKSPACE_QRY" As

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
        v_hod_sec_empno       Varchar2(5);
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_friday_date         Date;
        v_hod_sec_assign_code Varchar2(4);
    Begin
        v_friday_date         := iot_swp_common.get_friday_date(nvl(p_start_date, sysdate));

        v_hod_sec_empno       := get_empno_from_meta_id(p_meta_id);

        If v_hod_sec_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        v_hod_sec_assign_code := iot_swp_common.get_default_costcode_hod_sec(
                                     p_hod_sec_empno => v_hod_sec_empno,
                                     p_assign_code   => p_assign_code
                                 );
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
                        Row_Number() Over(Order By a.empno)                               As row_number,
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
                        And a.assign = v_hod_sec_assign_code
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

    End fn_emp_primary_ws_list;

    Function fn_emp_primary_ws_plan_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_assign_code Varchar2 Default Null,

        p_empno       Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
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
            p_person_id   => p_person_id,
            p_meta_id     => p_meta_id,

            p_assign_code => p_assign_code,
            p_start_date  => v_plan_friday_date,

            p_empno       => p_empno,

            p_row_number  => p_row_number,
            p_page_length => p_page_length
        );

    End fn_emp_primary_ws_plan_list;

End iot_swp_primary_workspace_qry;
/
---------------------------
--New PACKAGE BODY
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

            Select
                abbr
            Into
                v_area
            From
                ss_costmast
            Where
                costcode In(
                    Select
                        assign
                    From
                        ss_emplmast
                    Where
                        empno = p_empno
                );
        End If;

        Return v_area;
    Exception
        When Others Then
            Return Null;
    End get_emp_work_area;

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
            dm_vu_emp_desk_map                         dmst, dms.dm_deskmaster dms
        Where
            dmst.deskid    = dms.deskid
            And dmst.empno = Trim(p_empno);

        Return v_retval;
    End get_desk_from_dms;
/*
    Function get_emp_dms_type_desc(
        p_empno In Varchar2
    ) Return Varchar2 As
        v_emp_dm_type_desc Varchar2(100);
    Begin
        Select
            dm_type_desc
        Into
            v_emp_dm_type_desc
        From
            dm_vu_emp_dm_type_map
        Where
            empno = p_empno;
        Return v_emp_dm_type_desc;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_emp_dms_type_code(
        p_empno In Varchar2
    ) Return Number As
        v_emp_dm_type_code Number;
    Begin
        Select
            emp_dm_type
        Into
            v_emp_dm_type_code
        From
            dm_vu_emp_dm_type_map
        Where
            empno = p_empno;
        Return v_emp_dm_type_code;
    Exception
        When Others Then
            Return -1;
    End;
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
            mast.work_area        = p_work_area
            And area.area_key_id  = mast.work_area
            And Trim(mast.office) = Trim(p_office)
            And Trim(mast.floor)  = Trim(p_floor)
            And (mast.wing        = p_wing Or p_wing Is Null);

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
                        dm_vu_emp_desk_map c
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

    Function is_emp_laptop_user(
        p_empno Varchar2
    ) Return Number
    As
    Begin
        Return itinv_stk.dist.is_laptop_user(p_empno);
    End;
End iot_swp_common;
/
---------------------------
--New PACKAGE BODY
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
        c_permanent_desk constant number := 1;
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
        c_permanent_desk constant number := 1;
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


/*
    Function fn_employee_list_4_sec_hod(
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
                And parent In (
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
*/
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

End iot_swp_select_list_qry;
/
---------------------------
--New PACKAGE BODY
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

End iot_swp_primary_workspace;
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
