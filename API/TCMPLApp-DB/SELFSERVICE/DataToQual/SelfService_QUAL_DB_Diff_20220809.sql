--------------------------------------------------------
--  DDL for Table SWP_DEPT_WORKSPACE_SUMMARY
--------------------------------------------------------
/*
  CREATE TABLE "SELFSERVICE"."SWP_DEPT_WORKSPACE_SUMMARY" 
   (	"WEEK_KEY_ID" VARCHAR2(8 BYTE), 
	"ASSIGN" CHAR(4 BYTE), 
	"OWS_EMP_COUNT" NUMBER(4,0), 
	"SWS_EMP_COUNT" NUMBER(4,0), 
	"DWS_EMP_COUNT" NUMBER(4,0), 
	"MODIFIED_ON" DATE
   ) ;
--------------------------------------------------------
--  DDL for Index SWP_DEPT_WORKSPACE_SUMMARY_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "SELFSERVICE"."SWP_DEPT_WORKSPACE_SUMMARY_PK" ON "SELFSERVICE"."SWP_DEPT_WORKSPACE_SUMMARY" ("WEEK_KEY_ID", "ASSIGN") ;
--------------------------------------------------------
--  Constraints for Table SWP_DEPT_WORKSPACE_SUMMARY
--------------------------------------------------------

  ALTER TABLE "SELFSERVICE"."SWP_DEPT_WORKSPACE_SUMMARY" ADD CONSTRAINT "SWP_DEPT_WORKSPACE_SUMMARY_PK" PRIMARY KEY ("WEEK_KEY_ID", "ASSIGN");
  ALTER TABLE "SELFSERVICE"."SWP_DEPT_WORKSPACE_SUMMARY" MODIFY ("MODIFIED_ON" NOT NULL ENABLE);
  ALTER TABLE "SELFSERVICE"."SWP_DEPT_WORKSPACE_SUMMARY" MODIFY ("DWS_EMP_COUNT" NOT NULL ENABLE);
  ALTER TABLE "SELFSERVICE"."SWP_DEPT_WORKSPACE_SUMMARY" MODIFY ("SWS_EMP_COUNT" NOT NULL ENABLE);
  ALTER TABLE "SELFSERVICE"."SWP_DEPT_WORKSPACE_SUMMARY" MODIFY ("OWS_EMP_COUNT" NOT NULL ENABLE);
  ALTER TABLE "SELFSERVICE"."SWP_DEPT_WORKSPACE_SUMMARY" MODIFY ("ASSIGN" NOT NULL ENABLE);
  ALTER TABLE "SELFSERVICE"."SWP_DEPT_WORKSPACE_SUMMARY" MODIFY ("WEEK_KEY_ID" NOT NULL ENABLE);
*/

--------------------------------------------------------
--  File created - Tuesday-August-09-2022   
--------------------------------------------------------
---------------------------
--Changed PACKAGE
--IOT_SWP_SMART_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_SMART_WORKSPACE" As
    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;
    c_office_workspace Constant Number := 1;
    c_smart_workspace Constant Number := 2;
    c_not_in_mum_office Constant Number := 3;

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

    Procedure sp_sys_assign_sws_desk(
        p_empno            Varchar2,
        p_attendance_date  Date,
        p_deskid           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_delete_weekly_attendance(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_date             Date,
        p_deskid           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );
    Procedure sp_add_weekly_attendance(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_date             Date,
        p_deskid           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );
End iot_swp_smart_workspace;
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

    Function fn_emp_list4plan_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_costcode_list_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_dept_list4plan_4_hod_sec(
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

    Function fn_costcode_list_4_admin(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_emp_list4desk_plan(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_emp_list4wp_details(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_swp_type_list(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_exclude_sws_type Varchar2 Default Null
    ) Return Sys_Refcursor;

    Function fn_emp_list_4_admin(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_swp_type_list_4_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_empno            Varchar2,
        p_exclude_sws_type Varchar2 Default Null
    ) Return Sys_Refcursor;

End iot_swp_select_list_qry;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_PRIMARY_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_PRIMARY_WORKSPACE" As

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;
    c_office_workspace Constant Number := 1;
    c_smart_workspace Constant Number := 2;
    c_not_in_mum_office Constant Number := 3;

    Procedure sp_add_office_ws_desk(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_deskid           Varchar2,
        p_empno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_hod_assign_work_space(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_emp_workspace_array typ_tab_string,
        p_message_type Out    Varchar2,
        p_message_text Out    Varchar2
    );

    Procedure sp_hr_assign_work_space(
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

        p_emp_perc_office_workspace  Out Number,
        p_emp_perc_smart_workspace   Out Number,

        p_message_type               Out Varchar2,
        p_message_text               Out Varchar2
    );

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
    );

    Procedure sp_admin_assign_work_space(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_workspace_code   Number,
        p_start_date       Date,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_admin_delete_work_space(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,
        p_start_date       Date,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );
    Function fn_dept_ows_quota_exists(
        p_assign           Varchar2,
        p_week_key_id      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) Return Varchar2;
End iot_swp_primary_workspace;
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
                            iot_swp_common.get_swp_planned_desk(e.empno)                                    As deskid
                        From
                            ss_emplmast e,
                            primary_ws  pws,
                            params
                        Where
                            e.status     = 1
                            And e.empno  = pws.empno

                            And e.assign = params.p_assign_code
                            
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
--IOT_SWP_EMPLOYEES_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_EMPLOYEES_QRY" As

    Function fn_swp_employees(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor;
End iot_swp_employees_qry;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_COMMON
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_COMMON" As

    Function fn_get_pws_text(
        p_pws_type_code Number
    ) Return Varchar2;

    Function fn_get_dept_group(
        p_costcode Varchar2
    ) Return Varchar2;

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

    Function get_swp_planned_desk(
        p_empno In Varchar2
    ) Return Varchar2;

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

    Function get_default_dept4plan_hod_sec(
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

    Function fn_get_emp_pws(
        p_empno Varchar2,
        p_date  Date Default Null
    ) Return Number;

    Function fn_get_emp_pws_planning(
        p_empno Varchar2 Default Null
    ) Return Varchar2;

    Function is_desk_in_general_area(
        p_deskid Varchar2
    ) Return Boolean;

    Function fn_can_do_desk_plan_4_emp(
        p_empno Varchar2
    ) Return Boolean;

    Function fn_can_work_smartly(
        p_empno Varchar2
    ) Return Number;

    Function fn_is_present_4_swp(
        p_empno Varchar2,
        p_date  Date
    ) Return Number;

    Function get_emp_is_eligible_4swp(
        p_empno Varchar2 Default Null
    ) Return Varchar2;

    Function is_emp_dualmonitor_user(
        p_empno Varchar2 Default Null
    ) Return Number;

    Function get_emp_projno_desc(
        p_empno Varchar2
    ) Return Varchar2;

    Function fn_get_attendance_status(
        p_empno Varchar2,
        p_date  Date
    ) Return Varchar2;

    Function fn_get_attendance_status(
        p_empno Varchar2,
        p_date  Date,
        p_pws   Number
    ) Return Varchar2;

    Function fn_is_attendance_required(
        p_empno Varchar2,
        p_date  Date,
        p_pws   Number
    ) Return Varchar2;

    Function fn_get_prev_work_date(
        p_prev_date Date Default Null
    ) Return Date;    
    -----------------------
    Procedure get_planning_week_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_plan_start_date Out Date,
        p_plan_end_date   Out Date,
        p_curr_start_date Out Date,
        p_curr_end_date   Out Date,
        p_planning_exists Out Varchar2,
        p_pws_open        Out Varchar2,
        p_sws_open        Out Varchar2,
        p_ows_open        Out Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2

    );

    Procedure sp_primary_workspace(
        p_person_id                   Varchar2,
        p_meta_id                     Varchar2,
        p_empno                       Varchar2 Default Null,

        p_current_workspace_text  Out Varchar2,
        p_current_workspace_val   Out Varchar2,
        p_current_workspace_date  Out Varchar2,

        p_planning_workspace_text Out Varchar2,
        p_planning_workspace_val  Out Varchar2,
        p_planning_workspace_date Out Varchar2,

        p_message_type            Out Varchar2,
        p_message_text            Out Varchar2

    );

    Procedure sp_emp_office_workspace(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,

        p_office       Out Varchar2,
        p_floor        Out Varchar2,
        p_wing         Out Varchar2,
        p_desk         Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_get_emp_workspace_details(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        p_empno                 Varchar2,
        p_current_pws       Out Number,
        p_planning_pws      Out Number,
        p_current_pws_text  Out Varchar2,
        p_planning_pws_text Out Varchar2,
        p_curr_desk_id      Out Varchar2,
        p_curr_office       Out Varchar2,
        p_curr_floor        Out Varchar2,
        p_curr_wing         Out Varchar2,
        p_curr_bay          Out Varchar2,
        p_plan_desk_id      Out Varchar2,
        p_plan_office       Out Varchar2,
        p_plan_floor        Out Varchar2,
        p_plan_wing         Out Varchar2,
        p_plan_bay          Out Varchar2,
        p_message_type      Out Varchar2,
        p_message_text      Out Varchar2
    );

    Procedure get_dept_planning_weekdetails(
        p_person_id                 Varchar2,
        p_meta_id                   Varchar2,
        p_assign_code               Varchar2 Default Null,
        p_plan_start_date       Out Date,
        p_plan_end_date         Out Date,
        p_curr_start_date       Out Date,
        p_curr_end_date         Out Date,
        p_planning_exists       Out Varchar2,
        p_pws_open              Out Varchar2,
        p_sws_open              Out Varchar2,
        p_ows_open              Out Varchar2,
        p_dept_ows_quota_exists Out Varchar2,
        p_dept_ows_quota        Out Number,
        p_message_type          Out Varchar2,
        p_message_text          Out Varchar2
    );
End iot_swp_common;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_ATTENDANCE_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_ATTENDANCE_QRY" As

    Function fn_attendance_for_period(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_start_date              Date,
        p_end_date                Date,

        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor;

    Function fn_attendance_for_day(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_start_date              Date,

        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor;

    Function fn_attendance_for_prev_day(
        p_person_id Varchar2,
        p_meta_id   Varchar2

    ) Return Sys_Refcursor;

    Function fn_date_list(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,

        p_start_date Date,
        p_end_date   Date

    ) Return Sys_Refcursor;

    Function fn_attendance_for_month(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_yyyymm                  Varchar2,

        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor;

    --
    Function fn_week_number_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_yyyymm    Varchar2

    ) Return Sys_Refcursor;
End iot_swp_attendance_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_SMART_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_SMART_WORKSPACE" As
    c_planning_future  Constant Number(1) := 2;
    c_planning_current Constant Number(1) := 1;
    c_planning_is_open Constant Number(1) := 1;
    Procedure del_emp_sws_atend_plan(
        p_empno            Varchar2,
        p_date             Date,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
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
        If Not iot_swp_common.fn_can_do_desk_plan_4_emp(p_empno) Then
            Return;
        End If;

        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = c_planning_future
            And sws_open  = c_planning_is_open;

        Select
            Count(*)
        Into
            v_count
        From
            swp_smart_attendance_plan
        Where
            empno           = p_empno
            And week_key_id = rec_config_week.key_id;
        If v_count < 2 Then
            p_message_type := 'KO';
            p_message_text := 'Only one attendance day availabe. Hence cannot delete.';
            Return;
        End If;
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
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

        If Not iot_swp_common.is_desk_in_general_area(rec_smart_attendance_plan.deskid) Then
            Return;
        End If;
        --

        iot_swp_dms.sp_unlock_desk(
            p_person_id   => Null,
            p_meta_id     => Null,

            p_deskid      => rec_smart_attendance_plan.deskid,
            p_week_key_id => rec_config_week.key_id
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_add_weekly_atnd(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_weekly_attendance typ_tab_string,
        p_empno             Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        strsql                    Varchar2(600);
        v_count                   Number;
        v_status                  Varchar2(5);
        v_mod_by_empno            Varchar2(5);
        v_pk                      Varchar2(10);
        v_fk                      Varchar2(10);
        v_empno                   Varchar2(5);
        v_attendance_date         Date;
        v_desk                    Varchar2(20);
        rec_config_week           swp_config_weeks%rowtype;
        rec_smart_attendance_plan swp_smart_attendance_plan%rowtype;
    Begin

        v_mod_by_empno := get_empno_from_meta_id(p_meta_id);

        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        If Not iot_swp_common.fn_can_do_desk_plan_4_emp(p_empno) Then
            p_message_type := 'KO';
            p_message_text := 'Planning not allowed for employee assign code.';
            Return;
        End If;

        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = c_planning_future
            And sws_open  = c_planning_is_open;

        ---    
        Select
            Count(*)
        Into
            v_count
        From
            swp_primary_workspace a
        Where
            Trim(a.empno)                 = Trim(p_empno)
            And Trim(a.primary_workspace) = 2
            And trunc(a.start_date)       = (
                      Select
                          Max(trunc(start_date))
                      From
                          swp_primary_workspace b
                      Where
                          b.empno = a.empno
                          And b.start_date <= rec_config_week.end_date
                  );

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
                To_Date(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) attendance_date,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3))          desk,
                Trim(regexp_substr(str, '[^~!~]+', 1, 4))          status
            Into
                v_empno, v_attendance_date, v_desk, v_status
            From
                csv;

            If v_status = 0 Then
                del_emp_sws_atend_plan(
                    p_empno        => v_empno,
                    p_date         => trunc(v_attendance_date),
                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
                Return;
            End If;
            Begin
                Select
                    *
                Into
                    rec_smart_attendance_plan
                From
                    swp_smart_attendance_plan
                Where
                    empno               = v_empno
                    And attendance_date = v_attendance_date;
            Exception
                When Others Then
                    Null;
            End;
            If v_status = '1' Then
                If rec_smart_attendance_plan.empno Is Null Then
                    v_pk := dbms_random.string('X', 10);

                    ---    
                    Select
                        key_id
                    Into
                        v_fk
                    From
                        swp_primary_workspace a
                    Where
                        Trim(a.empno)                 = Trim(p_empno)
                        And Trim(a.primary_workspace) = 2
                        And trunc(a.start_date)       = (
                                  Select
                                      Max(trunc(start_date))
                                  From
                                      swp_primary_workspace b
                                  Where
                                      b.empno = a.empno
                                      And b.start_date <= rec_config_week.end_date
                              );

                    --Check attendance date is holiday
                    Select
                        Count(*)
                    Into
                        v_count
                    From
                        ss_holidays
                    Where
                        holiday = v_attendance_date;
                    If v_count > 0 Then
                        p_message_type := 'KO';
                        p_message_text := 'Cannot assign holiday as attendance day.';
                        Continue;
                    End If;

                    --Insert into Attendance Plan
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
                Else
                    Update
                        swp_smart_attendance_plan
                    Set
                        deskid = v_desk, modified_on = sysdate, modified_by = v_mod_by_empno
                    Where
                        key_id = rec_smart_attendance_plan.key_id;
                End If;
                If iot_swp_common.is_desk_in_general_area(v_desk) Then
                    /*
                    iot_swp_dms.sp_clear_desk(
                        p_person_id => Null,
                        p_meta_id   => p_meta_id,

                        p_deskid    => v_desk

                    );
                    */
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
        When dup_val_on_index Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || v_desk || ' is not available. It has be assigned to other Employee.';

        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_weekly_atnd;

    Procedure sp_delete_weekly_attendance(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_empno             Varchar2,
        p_date              Date,
        p_deskid            Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
    Begin
        del_emp_sws_atend_plan(
            p_empno        => p_empno,
            p_date         => p_date,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
    End;

    Procedure sp_add_weekly_attendance(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_empno             Varchar2,
        p_date              Date,
        p_deskid            Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        strsql                    Varchar2(600);
        v_count                   Number;
        v_status                  Varchar2(5);
        v_mod_by_empno            Varchar2(5);
        v_pk                      Varchar2(10);
        v_fk                      Varchar2(10);
        v_empno                   Varchar2(5);
        v_attendance_date         Date;
        v_desk                    Varchar2(20);
        rec_config_week           swp_config_weeks%rowtype;
        rec_smart_attendance_plan swp_smart_attendance_plan%rowtype;
    Begin

        v_mod_by_empno    := get_empno_from_meta_id(p_meta_id);

        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        If Not iot_swp_common.fn_can_do_desk_plan_4_emp(p_empno) Then
            p_message_type := 'KO';
            p_message_text := 'Planning not allowed for employee assign code.';
            Return;
        End If;

        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = c_planning_future
            And sws_open  = c_planning_is_open;

        ---    
        Select
            Count(*)
        Into
            v_count
        From
            swp_primary_workspace a
        Where
            Trim(a.empno)                 = Trim(p_empno)
            And Trim(a.primary_workspace) = 2
            And trunc(a.start_date)       = (
                      Select
                          Max(trunc(start_date))
                      From
                          swp_primary_workspace b
                      Where
                          b.empno = a.empno
                          And b.start_date <= rec_config_week.end_date
                  );

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number ' || p_empno;
            Return;
        End If;
        /*
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
                        To_Date(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) attendance_date,
                        Trim(regexp_substr(str, '[^~!~]+', 1, 3))          desk,
                        Trim(regexp_substr(str, '[^~!~]+', 1, 4))          status
                    Into
                        v_empno, v_attendance_date, v_desk, v_status
                    From
                        csv;
                        del_emp_sws_atend_plan(
                            p_empno        => v_empno,
                            p_date         => trunc(v_attendance_date),
                            p_message_type => p_message_type,
                            p_message_text => p_message_text
                        );
                        Return;
                        */
        v_attendance_date := p_date;
        v_empno           := p_empno;
        v_desk            := p_deskid;
        Begin
            Select
                *
            Into
                rec_smart_attendance_plan
            From
                swp_smart_attendance_plan
            Where
                empno               = v_empno
                And attendance_date = v_attendance_date;
        Exception
            When Others Then
                Null;
        End;

        If rec_smart_attendance_plan.empno Is Null Then
            v_pk := dbms_random.string('X', 10);

            ---    
            Select
                key_id
            Into
                v_fk
            From
                swp_primary_workspace a
            Where
                Trim(a.empno)                 = Trim(p_empno)
                And Trim(a.primary_workspace) = 2
                And trunc(a.start_date)       = (
                          Select
                              Max(trunc(start_date))
                          From
                              swp_primary_workspace b
                          Where
                              b.empno = a.empno
                              And b.start_date <= rec_config_week.end_date
                      );

            --Check attendance date is holiday
            Select
                Count(*)
            Into
                v_count
            From
                ss_holidays
            Where
                holiday = v_attendance_date;
            If v_count > 0 Then
                p_message_type := 'KO';
                p_message_text := 'Cannot assign holiday as attendance day.';
                Return;
            End If;

            --Insert into Attendance Plan
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
        Else
            Update
                swp_smart_attendance_plan
            Set
                deskid = v_desk, modified_on = sysdate, modified_by = v_mod_by_empno
            Where
                key_id = rec_smart_attendance_plan.key_id;
        End If;
        If iot_swp_common.is_desk_in_general_area(v_desk) Then
            /*
            iot_swp_dms.sp_clear_desk(
                p_person_id => Null,
                p_meta_id   => p_meta_id,

                p_deskid    => v_desk

            );
            */
            iot_swp_dms.sp_lock_desk(
                p_person_id => Null,
                p_meta_id   => Null,

                p_deskid    => v_desk
            );
        End If;
        --          End If;

        --        End Loop;
        Commit;

        p_message_type    := 'OK';
        p_message_text    := 'Procedure executed successfully.';
    Exception
        When dup_val_on_index Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || v_desk || ' is not available. It has be assigned to other Employee.';

        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_weekly_attendance;

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

        For c1 In cur_summary(trunc(v_start_date), trunc(v_end_date))
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

    Procedure sp_sys_assign_sws_desk(
        p_empno            Varchar2,
        p_attendance_date  Date,
        p_deskid           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count         Number;
        v_pk            Varchar2(10);
        v_fk            Varchar2(10);
        rec_config_week swp_config_weeks%rowtype;
    Begin

        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = c_planning_future;

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

        --Check attendance date is holidy
        Select
            Count(*)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = p_attendance_date;
        If v_count > 0 Then
            p_message_type := 'KO';
            p_message_text := 'Cannot assign holiday as attendance day.';
            Return;
        End If;

        v_pk           := dbms_random.string('X', 10);

        Select
            key_id
        Into
            v_fk
        From
            swp_primary_workspace pws
        Where
            Trim(pws.empno)           = Trim(p_empno)
            And pws.primary_workspace = 2
            And trunc(pws.start_date) = (
                Select
                    Max(trunc(start_date))
                From
                    swp_primary_workspace b
                Where
                    b.empno = pws.empno
                    And b.start_date <= rec_config_week.end_date
            );

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
            p_empno,
            p_attendance_date,
            p_deskid,
            sysdate,
            'Sys',
            rec_config_week.key_id
        );
        If iot_swp_common.is_desk_in_general_area(p_deskid) Then

            iot_swp_dms.sp_lock_desk(
                p_person_id => Null,
                p_meta_id   => Null,

                p_deskid    => p_deskid
            );
        End If;
        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_sys_assign_sws_desk;

End iot_swp_smart_workspace;
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
                        dm_vu_emp_desk_map_swp_plan
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
                        dm_vu_emp_desk_map_swp_plan dmst
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

    Function fn_emp_list4plan_4_hod_sec(
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
                        ss_user_dept_rights                                   a, swp_include_assign_4_seat_plan b
                    Where
                        empno        = v_empno
                        And a.parent = b.assign
                    Union
                    Select
                        costcode
                    From
                        ss_costmast                                   a, swp_include_assign_4_seat_plan b
                    Where
                        hod            = v_empno
                        And a.costcode = b.assign
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
                        ss_user_dept_rights a
                    Where
                        empno = v_empno
                    Union
                    Select
                        costcode
                    From
                        ss_costmast a
                    Where
                        hod = v_empno
                )
                And costcode Not In (
                    Select
                        assign
                    From
                        swp_exclude_assign
                )
            --And noofemps > 0
            Order By
                costcode;

        Return c;
    End;

    Function fn_dept_list4plan_4_hod_sec(
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
                        ss_user_dept_rights            a,
                        swp_include_assign_4_seat_plan b
                    Where
                        empno        = v_empno
                        And a.parent = b.assign
                    Union
                    Select
                        costcode
                    From
                        ss_costmast                    a,
                        swp_include_assign_4_seat_plan b
                    Where
                        hod            = v_empno
                        And a.costcode = b.assign
                )
                And costcode Not In (
                    Select
                        assign
                    From
                        swp_exclude_assign
                )
            --And noofemps > 0
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
            Distinct
                proj_no                  data_value_field,
                proj_no || ' - ' || name data_text_field
            From
                ss_projmast
            Where
                active = 1
            Order By
                proj_no;

        Return c;
    End;

    Function fn_costcode_list_4_admin(
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
                costcode Not In (
                    Select
                        assign
                    From
                        swp_exclude_assign
                )
            --And noofemps > 0
            Order By
                costcode;
        Return c;
    End;

    Function fn_emp_list4desk_plan(
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
                status = 1
                And emptype In(
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
                And assign In (
                    Select
                        assign
                    From
                        swp_include_assign_4_seat_plan
                );
        Return c;
    End;

    Function fn_emp_list4wp_details(
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
                status = 1
                And assign In (
                    Select
                        assign
                    From
                        swp_include_assign_4_seat_plan
                )
            Order By
                empno;
        Return c;
    End;

    Function fn_swp_type_list(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_exclude_sws_type Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                  Sys_Refcursor;
        v_exclude_swp_type Number;
    Begin
        If p_exclude_sws_type = 'OK' Then
            v_exclude_swp_type := 2;
        Else
            v_exclude_swp_type := -1;
        End If;
        Open c For
            Select
                to_char(type_code) data_value_field,
                type_desc          data_text_field
            From
                swp_primary_workspace_types
            Where
                type_code <> v_exclude_swp_type;
        Return c;
    End;

    Function fn_emp_list_4_admin(
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
                status = 1
            Order By
                empno;
        Return c;
    End;

    Function fn_swp_type_list_4_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_empno            Varchar2,
        p_exclude_sws_type Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                  Sys_Refcursor;
        v_exclude_swp_type Number;
    Begin

        If p_exclude_sws_type = 'OK' Then
            v_exclude_swp_type := 2;
        Else
            v_exclude_swp_type := -1;
        End If;

        Open c For
            Select
                to_char(type_code) data_value_field,
                type_desc          data_text_field
            From
                swp_primary_workspace_types
            Where
                type_code <> 3
                And type_code <> v_exclude_swp_type;
        Return c;
    End;

End iot_swp_select_list_qry;
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

    Function fn_dept_ows_quota_exists(
        p_assign           Varchar2,
        p_week_key_id      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) Return Varchar2 As
        v_swp_dept_ws_sum  swp_dept_workspace_summary%rowtype;
        c_office_workspace Constant Number := 1;

        v_config_week_row  swp_config_weeks%rowtype;
        v_dept_ows_count   Number;
    Begin

        --Get department workspace summary
        Select
            *
        Into
            v_swp_dept_ws_sum
        From
            swp_dept_workspace_summary
        Where
            assign          = p_assign
            And week_key_id = p_week_key_id;

        --Get config week row.
        Select
            *
        Into
            v_config_week_row
        From
            swp_config_weeks
        Where
            key_id = p_week_key_id;

        --Get department Office Workspace emp count 
        Select
            Count(*)
        Into
            v_dept_ows_count
        From
            swp_primary_workspace pws,
            ss_emplmast           e
        Where
            pws.empno                 = e.empno
            And e.status              = 1
            And e.emptype In (
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
            And start_date            = (
                           Select
                               Max(start_date)
                           From
                               swp_primary_workspace pws_sub
                           Where
                               pws_sub.empno = pws.empno
                               And pws_sub.start_date <= v_config_week_row.end_date
                       )
            And pws.primary_workspace = c_office_workspace;

        --Compare workspace assignment and quota for the department
        If v_dept_ows_count < v_swp_dept_ws_sum.ows_emp_count Then
            Return 'OK';
        Else
            Return 'KO';
        End If;
    Exception
        When Others Then
            Return 'ER';
    End;

    Procedure sp_assign_work_space(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_is_admin_call       Number Default 0,
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

        If nvl(p_is_admin_call, 0) != 1 Then
            Begin

                Select
                    *
                Into
                    rec_config_week
                From
                    swp_config_weeks
                Where
                    planning_flag = c_planning_future
                    And pws_open  = c_planning_is_open;
            Exception
                When Others Then
                    p_message_type := 'KO';
                    p_message_text := 'Err - SWP Planning is not open. Cannot proceed.';
                    Return;
            End;
        Elsif nvl(p_is_admin_call, 0) = 1 Then

            Begin

                Select
                    *
                Into
                    rec_config_week
                From
                    swp_config_weeks
                Where
                    planning_flag = c_planning_future;
            Exception
                When Others Then
                    p_message_type := 'KO';
                    p_message_text := 'Err - SWP Planning is not open. Cannot proceed.';
                    Return;
            End;

        End If;

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
                /*If same FUTURE record exists in database then continue*/
                /*If no change then continue*/
                If tab_primary_workspace(1).primary_workspace = v_workspace_code Then
                    Continue;
                End If;

                /*Delete existing SWP DESK ASSIGNMENT planning*/
                del_emp_future_planning(
                    p_empno               => v_empno,
                    p_planning_start_date => trunc(rec_config_week.start_date)
                );
                /**/
                v_ows_desk_id := iot_swp_common.get_swp_planned_desk(v_empno);
                /*Remove user desk association in DMS*/
                If Trim(v_ows_desk_id) Is Not Null Then
                    iot_swp_dms.sp_remove_desk_user(
                        p_person_id => p_person_id,
                        p_meta_id   => p_meta_id,

                        p_empno     => v_empno,
                        p_deskid    => v_ows_desk_id
                    );
                End If;

                /*If furture planning is reverted to old planning then continue*/
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

    /*
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
                    planning_flag = c_planning_future
                    And pws_open  = c_planning_is_open;
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
                    v_ows_desk_id := iot_swp_common.get_swp_planned_desk(v_empno);
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
    */
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
        If Not iot_swp_common.fn_can_do_desk_plan_4_emp(p_empno) Then
            p_message_type := 'KO';
            p_message_text := 'Planning not allowed for employee assign code.';
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
        /*,modified_on,*/
        /*modified_by*/
        )
        Values (
            p_empno,
            p_deskid
        /*,sysdate,*/
        /*v_mod_by_empno*/
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

    Procedure sp_hod_assign_work_space(
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

        sp_assign_work_space(
            p_person_id           => p_person_id,
            p_meta_id             => p_meta_id,

            p_emp_workspace_array => p_emp_workspace_array,
            p_message_type        => p_message_type,
            p_message_text        => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_hr_assign_work_space(
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

        sp_assign_work_space(
            p_person_id           => p_person_id,
            p_meta_id             => p_meta_id,
            p_is_admin_call       => 1,
            p_emp_workspace_array => p_emp_workspace_array,
            p_message_type        => p_message_type,
            p_message_text        => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;

    /* By Pradeep only for information*/

    Procedure sp_admin_assign_work_space(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_workspace_code   Number,
        p_start_date       Date,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_mod_by_empno Varchar2(5);
        v_key          Varchar2(10);
        c_active_code  Constant Number(1) := 0;
    Begin
        v_mod_by_empno := get_empno_from_meta_id(p_meta_id);
        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        v_key          := dbms_random.string('X', 10);

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
            p_empno,
            p_workspace_code,
            p_start_date,
            sysdate,
            v_mod_by_empno,
            c_active_code
        );

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_admin_delete_work_space(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,
        p_start_date       Date,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count             Number;
        v_mod_by            Varchar2(5);
        v_tab_from          Varchar2(2);

        v_empno             Varchar2(5);
        v_primary_workspace Number;
        v_start_date        Date;
        v_modified_on       Date;
        v_modified_by       Varchar2(5);

    Begin
        v_count        := 0;
        v_mod_by       := get_empno_from_meta_id(p_meta_id);

        If v_mod_by = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            empno, primary_workspace, start_date, modified_on, modified_by
        Into
            v_empno, v_primary_workspace, v_start_date, v_modified_on, v_modified_by
        From
            swp_primary_workspace
        Where
            key_id = p_application_id
            And start_date >= p_start_date;

        Insert Into swp_primary_workspace_det
        (key_id, empno, primary_workspace, start_date,
            source_modifiedon, source_modifiedby, deleted_on, deleted_by)
        Values
        (p_application_id, v_empno, v_primary_workspace, v_start_date,
            v_modified_on, v_modified_by, sysdate, v_mod_by);

        If (Sql%rowcount > 0) Then
            Delete
                From swp_primary_workspace
            Where
                key_id = p_application_id
                And start_date >= p_start_date;
            Commit;
        Else
            p_message_type := 'KO';
            p_message_text := 'Faild to insert record into delete table ';
            Return;
            Rollback;
        End If;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_admin_delete_work_space;

    /* End*/

End iot_swp_primary_workspace;
/
---------------------------
--New PACKAGE BODY
--IOT_SWP_EMPLOYEES_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_EMPLOYEES_QRY" As

    Function fn_swp_employees(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_exclude_grade      Varchar2(2);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_is_exclude_x1_employees = 1 Then
            v_exclude_grade := 'X1';
        Else
            v_exclude_grade := '!!';
        End If;

        Open c For
            Select
                empno, name As employee_name, emptype, grade, parent, assign
            From
                ss_emplmast e
            Where
                (
                e.status = 1

                )
                And e.emptype In (
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
                And e.grade <> v_exclude_grade;
        Return c;
    End fn_swp_employees;

End iot_swp_employees_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_CONFIG_WEEK
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_CONFIG_WEEK" As
    c_plan_close_code   Constant Number      := 0;
    c_plan_open_code    Constant Number      := 1;
    c_past_plan_code    Constant Number      := 0;
    c_cur_plan_code     Constant Number      := 1;
    c_future_plan_code  Constant Number      := 2;

    c_pws               Constant Number      := 100;

    c_ows               Constant Number      := 1;
    c_sws               Constant Number      := 2;
    c_dws               Constant Number      := 3;

    c_general_area_catg Constant Varchar2(4) := 'A002';

    Procedure sp_generate_workspace_summary(
        p_sysdate          Date,
        p_next_week_key_id Varchar2
    )
    As
        v_config_week_row swp_config_weeks%rowtype;
    Begin

        Select
            *
        Into
            v_config_week_row
        From
            swp_config_weeks
        Where
            key_id = p_next_week_key_id;
        --Delete existing records for the week
        Delete
            From swp_dept_workspace_summary
        Where
            week_key_id = p_next_week_key_id;

        --Insert data for the week
        --
        Insert Into swp_dept_workspace_summary(
            week_key_id,
            assign,
            ows_emp_count,
            sws_emp_count,
            dws_emp_count,
            modified_on
        )
        Select
            p_next_week_key_id,
            assign,
            Sum(pws) sum_pws,
            Sum(sws) sum_sws,
            Sum(ows) sum_ows,
            p_sysdate
        From
            (
                Select
                    pws.empno,
                    e.assign,
                    pws.start_date,
                    Case primary_workspace
                        When 1 Then
                            1
                        Else
                            0
                    End As pws,
                    Case primary_workspace
                        When 2 Then
                            1
                        Else
                            0
                    End As sws,
                    Case primary_workspace
                        When 3 Then
                            1
                        Else
                            0
                    End As ows

                From
                    swp_primary_workspace pws,
                    ss_emplmast           e
                Where
                    pws.empno      = e.empno
                    And e.status   = 1
                    And e.emptype In (
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
                    And start_date = (
                        Select
                            Max(start_date)
                        From
                            swp_primary_workspace pws_sub
                        Where
                            pws_sub.empno = pws.empno
                            And pws_sub.start_date <= v_config_week_row.end_date
                    )
            )
        Group By
            assign;
    End;

    Procedure remove_temp_desks(p_sysdate Date) As
    Begin

        --remove left employees
        Delete
            From swp_temp_desk_allocation
        Where
            empno Not In (
                Select
                    empno
                From
                    ss_emplmast
                Where
                    status = 1
            );

        --remove employees already allocated desk in DMS
        Delete
            From swp_temp_desk_allocation
        Where
            empno In (
                Select
                    empno
                From
                    dms.dm_usermaster
                Where
                    deskid Not Like 'H%'
            )
            And (start_date Is Null Or start_date <= p_sysdate);

        --remove employees whose desk has been already allocated to other users
        Delete
            From swp_temp_desk_allocation
        Where
            deskid In (
                Select
                    deskid
                From
                    dms.dm_usermaster
            )
            And (start_date Is Null Or start_date <= p_sysdate);

    End;

    Procedure sp_set_plan_status(
        p_plan_type        Number,
        p_plan_status_code Number
    ) As
        row_config_week swp_config_weeks%rowtype;
    Begin
        Select
            *
        Into
            row_config_week
        From
            swp_config_weeks
        Where
            planning_flag = 2;
        If p_plan_type = c_pws Then
            Update
                swp_config_weeks
            Set
                pws_open = p_plan_status_code
            Where
                key_id = row_config_week.key_id;
        End If;
        If p_plan_type = c_sws Then
            Update
                swp_config_weeks
            Set
                sws_open = p_plan_status_code
            Where
                key_id = row_config_week.key_id;
        End If;

    End;

    Procedure send_mail_planning_open(
        p_plan_type Number
    )
    As

        Cursor cur_hod_sec Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        empno,
                        name                                           employee_name,
                        replace(email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By empno)) / 50) group_id
                    From
                        (
                            Select
                                e.empno,
                                e.name,
                                e.email
                            From
                                ss_emplmast e
                            Where
                                status = 1
                                And e.email Is Not Null
                                And e.empno Not In ('04132', '04600', '04484')
                                And e.empno In (
                                    Select
                                        hod
                                    From
                                        ss_costmast
                                    Union
                                    Select
                                        empno
                                    From
                                        ss_user_dept_rights
                                )
                        )
                    Order By empno
                )
            Group By
                group_id;
        --
        Type typ_tab_hod_sec Is
            Table Of cur_hod_sec%rowtype;
        tab_hod_sec     typ_tab_hod_sec;

        v_count         Number;
        v_mail_csv      Varchar2(2000);
        v_subject       Varchar2(1000);
        v_msg_body      Varchar2(2000);
        v_success       Varchar2(1000);
        v_message       Varchar2(500);
        row_config_week swp_config_weeks%rowtype;
    Begin
        Select
            *
        Into
            row_config_week
        From
            swp_config_weeks
        Where
            planning_flag = 2;
        If p_plan_type = c_pws Then
            v_msg_body := v_mail_body_pws_open;
            v_msg_body := replace(v_msg_body, '!PLAN_STARTDATE!', to_char(row_config_week.start_date, 'dd-Mon-yyyy'));
            v_subject  := 'SWP : Primary work space planning enabled for change';

        Elsif p_plan_type = c_sws Then
            v_msg_body := v_mail_body_sws_open;
            v_msg_body := replace(v_msg_body, '!PLAN_STARTDATE!', to_char(row_config_week.start_date, 'dd-Mon-yyyy'));
            v_subject  := 'SWP : Activation of Smart Workspace employees weekly planning';
        Else
            Return;
        End If;

        For email_csv_row In cur_hod_sec
        Loop
            v_mail_csv := email_csv_row.email_csv_list;

            tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
                p_person_id    => Null,
                p_meta_id      => Null,
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body1   => v_msg_body,
                p_mail_body2   => Null,
                p_mail_type    => 'HTML',
                p_mail_from    => 'SWP',
                p_message_type => v_success,
                p_message_text => v_message
            );

            /*
            send_mail_from_api(
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body    => v_msg_body,
                p_mail_profile => 'SELFSERVICE',
                --(example --> SQSI, OSD, ALHR, etc...)
                p_mail_format  => 'HTML',
                p_success      => v_success,
                p_message      => v_message
            );
            */
        End Loop;

    End;

    Procedure sp_plan_visible_to_emp(
        p_show_plan Boolean
    )
    As
        v_flag_value                 Varchar2(2);
        show_future_plan_to_emp_flag Varchar2(4) := 'F004';
    Begin
        If p_show_plan Then
            v_flag_value := 'OK';
        Else
            v_flag_value := 'KO';

        End If;
        Update
            swp_flags
        Set
            flag_value = v_flag_value
        Where
            flag_id = show_future_plan_to_emp_flag;

    End;

    Function fn_is_second_last_day_of_week(p_sysdate Date) Return Boolean As
        v_secondlast_workdate Date;
        v_fri_date            Date;
        Type rec Is Record(
                work_date     Date,
                work_day_desc Varchar2(100),
                rec_num       Number
            );

        Type typ_tab_work_day Is Table Of rec;
        tab_work_day          typ_tab_work_day;
    Begin
        v_fri_date := iot_swp_common.get_friday_date(trunc(p_sysdate));
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
                    And d_date >= trunc(p_sysdate)
                    And d_date Not In
                    (
                        Select
                            trunc(holiday)
                        From
                            ss_holidays
                        Where
                            (holiday <= v_fri_date
                                And holiday >= trunc(p_sysdate))
                    )
                Order By d_date Desc
            )
        Where
            Rownum In(1, 2);
        If tab_work_day.count = 2 Then
            --v_sysdate EQUAL SECOND_LAST working day "THURSDAY"
            If p_sysdate = tab_work_day(2).work_date Then --SECOND_LAST working day
                Return true;
            End If;
        End If;
        Return false;
    Exception
        When Others Then
            Return false;
    End;

    Function fn_is_action_day_4_flag(
        p_action_flag Varchar2,
        p_sysdate     Date
    ) Return Boolean As

        v_no_of_days_before_fri Number;
        v_date                  Date;
        v_fri_date              Date;
        v_count                 Number;

    Begin
        v_fri_date := iot_swp_common.get_friday_date(trunc(p_sysdate));
        Select
            flag_value_number
        Into
            v_no_of_days_before_fri
        From
            swp_flags
        Where
            flag_id = p_action_flag;

        --            

        Select
            d_date
        Into
            v_date
        From
            (
                Select
                    d_date, Rownum row_num
                From
                    (
                        Select
                            d_date
                        From
                            ss_days_details
                        Where
                            d_date Between To_Date(v_fri_date) - 5 And To_Date(v_fri_date)
                            And d_date Not In (
                                Select
                                    holiday
                                From
                                    ss_holidays
                                Where
                                    holiday Between To_Date(v_fri_date) - 5 And To_Date(v_fri_date)
                            )
                        Order By d_date Desc
                    )
            )
        Where
            row_num = v_no_of_days_before_fri + 1;

        If v_date = p_sysdate Then
            Return true;
        Else
            Return false;
        End If;
    Exception
        When Others Then
            Return false;
    End;

    Function fn_is_close_day_4_flag(
        p_action_flag   Varchar2,
        p_duration_flag Varchar2,
        p_sysdate       Date
    ) Return Boolean As

        v_no_of_days_before_fri Number;
        v_date                  Date;
        v_fri_date              Date;
        v_count                 Number;
        v_duration              Number;
    Begin
        v_fri_date := iot_swp_common.get_friday_date(trunc(p_sysdate));
        Select
            flag_value_number
        Into
            v_no_of_days_before_fri
        From
            swp_flags
        Where
            flag_id = p_action_flag;

        Select
            flag_value_number
        Into
            v_duration
        From
            swp_flags
        Where
            flag_id = p_duration_flag;

        --            

        Select
            d_date
        Into
            v_date
        From
            (
                Select
                    d_date, Rownum row_num
                From
                    (
                        Select
                            d_date
                        From
                            ss_days_details
                        Where
                            d_date Between To_Date(v_fri_date) - 5 And To_Date(v_fri_date)
                            And d_date Not In (
                                Select
                                    holiday
                                From
                                    ss_holidays
                                Where
                                    holiday Between To_Date(v_fri_date) - 5 And To_Date(v_fri_date)
                            )
                        Order By d_date Desc
                    )
            )
        Where
            row_num = v_no_of_days_before_fri + 1 - v_duration;

        If v_date = p_sysdate Then
            Return true;
        Else
            Return false;
        End If;
    Exception
        When Others Then
            Return false;
    End;

    Procedure sp_del_dms_desk_for_sws_users As
        Cursor cur_desk_plan_dept Is
            Select
                *
            From
                swp_include_assign_4_seat_plan;
        c1      Sys_Refcursor;

        --
        Cursor cur_sws Is
            Select
                a.empno,
                a.primary_workspace,
                a.start_date,
                iot_swp_common.get_swp_planned_desk(
                    p_empno => a.empno
                ) swp_desk_id
            From
                swp_primary_workspace a,
                ss_emplmast           e
            Where
                a.empno                 = e.empno
                And e.status            = 1
                And a.primary_workspace = 2
                And trunc(a.start_date) = (
                    Select
                        Max(trunc(start_date))
                    From
                        swp_primary_workspace b
                    Where
                        b.empno = a.empno
                        And b.start_date <= sysdate
                )
                And e.assign In (
                    Select
                        assign
                    From
                        swp_include_assign_4_seat_plan
                );
        Type typ_tab_sws Is Table Of cur_sws%rowtype Index By Binary_Integer;
        tab_sws typ_tab_sws;
    Begin
        Open cur_sws;
        Loop
            Fetch cur_sws Bulk Collect Into tab_sws Limit 50;
            For i In 1..tab_sws.count
            Loop
                iot_swp_dms.sp_remove_desk_user(
                    p_person_id => Null,
                    p_meta_id   => Null,
                    p_empno     => tab_sws(i).empno,
                    p_deskid    => tab_sws(i).swp_desk_id
                );
            End Loop;
            Exit When cur_sws%notfound;
        End Loop;
    End;

    --

    Procedure sp_mail_sws_plan_to_emp
    As
        cur_dept_rows      Sys_Refcursor;
        cur_emp_week_plan  Sys_Refcursor;
        row_config_week    swp_config_weeks%rowtype;
        v_mail_body        Varchar2(4000);
        v_day_row          Varchar2(1000);
        v_emp_mail         Varchar2(100);
        v_msg_type         Varchar2(15);
        v_msg_text         Varchar2(1000);
        v_emp_desk         Varchar2(10);
        Cursor cur_sws_emp_list(cp_monday_date Date,
                                cp_friday_date Date) Is
            Select
                a.empno,
                e.name As employee_name,
                a.primary_workspace,
                a.start_date
            From
                swp_primary_workspace a,
                ss_emplmast           e
            Where
                e.status                = 1
                And a.empno             = e.empno
                And a.primary_workspace = 2
                And emptype In (
                    Select
                        emptype
                    From
                        swp_include_emptype
                )
                And assign Not In(
                    Select
                        assign
                    From
                        swp_exclude_assign
                )
                And trunc(a.start_date) = (
                    Select
                        Max(trunc(start_date))
                    From
                        swp_primary_workspace b
                    Where
                        b.empno = a.empno
                        And b.start_date <= cp_friday_date
                )
                And e.empno Not In(
                    Select
                        empno
                    From
                        swp_exclude_emp
                    Where
                        empno = e.empno
                        And (cp_monday_date Between start_date And end_date
                            Or cp_friday_date Between start_date And end_date)
                    Minus

                    Select
                        empno
                    From
                        swp_exclude_emp
                    Where
                        empno = e.empno
                        And (start_date Between cp_monday_date And cp_friday_date
                            Or end_date Between cp_monday_date And cp_friday_date)
                )
                And grade <> 'X1';
        Type typ_tab_sws_emp_list Is Table Of cur_sws_emp_list%rowtype;
        tab_sws_emp_list   typ_tab_sws_emp_list;

        Cursor cur_emp_smart_attend_plan(cp_empno      Varchar2,
                                         cp_start_date Date,
                                         cp_end_date   Date) Is
            With
                atnd_days As (
                    Select
                        w.empno,
                        Trim(w.attendance_date) As attendance_date,
                        Trim(w.deskid)          As deskid,
                        1                       As planned,
                        dm.office               As office,
                        dm.floor                As floor,
                        dm.wing                 As wing,
                        dm.bay                  As bay
                    From
                        swp_smart_attendance_plan w,
                        dms.dm_deskmaster         dm
                    Where
                        w.empno      = cp_empno
                        And w.deskid = dm.deskid(+)
                        And attendance_date Between cp_start_date And cp_end_date
                )
            Select
                e.empno                   As empno,
                dd.d_day,
                dd.d_date,
                nvl(atnd_days.planned, 0) As planned,
                atnd_days.deskid          As deskid,
                atnd_days.office          As office,
                atnd_days.floor           As floor,
                atnd_days.wing            As wing,
                atnd_days.bay             As bay
            From
                ss_emplmast     e,
                ss_days_details dd,
                atnd_days
            Where
                e.empno       = Trim(cp_empno)

                And dd.d_date = atnd_days.attendance_date
                And d_date Between cp_start_date And cp_end_date
            Order By
                dd.d_date;
        Type typ_tab_emp_smart_plan Is Table Of cur_emp_smart_attend_plan%rowtype;
        tab_emp_smart_plan typ_tab_emp_smart_plan;
    Begin

        Select
            *
        Into
            row_config_week
        From
            swp_config_weeks
        Where
            planning_flag = 2;

        Open cur_sws_emp_list(trunc(row_config_week.start_date), trunc(row_config_week.end_date));
        Loop
            Fetch cur_sws_emp_list Bulk Collect Into tab_sws_emp_list Limit 50;
            For i In 1..tab_sws_emp_list.count
            Loop
                Begin
                    Select
                        email
                    Into
                        v_emp_mail
                    From
                        ss_emplmast
                    Where
                        empno      = tab_sws_emp_list(i).empno
                        And status = 1;
                    If v_emp_mail Is Null Then
                        Continue;
                    End If;
                Exception
                    When Others Then
                        Continue;
                End;

                --PRIMARY WORK SPACE
                If tab_sws_emp_list(i).primary_workspace = 1 Then
                    v_mail_body := v_ows_mail_body;
                    v_mail_body := replace(v_mail_body, '!@User@!', tab_sws_emp_list(i).employee_name);
                    v_mail_body := replace(v_mail_body, '!@StartDate@!', to_char(row_config_week.start_date, 'dd-Mon-yyyy'));
                    v_mail_body := replace(v_mail_body, '!@EndDate@!', to_char(row_config_week.end_date, 'dd-Mon-yyyy'));

                    /*
                    v_emp_desk := get_swp_planned_desk(
                            p_empno => emp_row.empno
                    );
                    */
                    --SMART WORK SPACE
                Elsif tab_sws_emp_list(i).primary_workspace = 2 Then
                    If cur_emp_smart_attend_plan%isopen Then
                        Close cur_emp_smart_attend_plan;
                    End If;
                    Open cur_emp_smart_attend_plan(tab_sws_emp_list(i).empno, row_config_week.start_date, row_config_week.
                    end_date);
                    Fetch cur_emp_smart_attend_plan Bulk Collect Into tab_emp_smart_plan Limit 5;
                    For i In 1..tab_emp_smart_plan.count
                    Loop

                        v_day_row := nvl(v_day_row, '') || v_sws_empty_day_row;
                        v_day_row := replace(v_day_row, 'DESKID', tab_emp_smart_plan(i).deskid);
                        v_day_row := replace(v_day_row, 'DATE', to_char(tab_emp_smart_plan(i).d_date, 'dd-Mon-yyyy'));
                        v_day_row := replace(v_day_row, 'DAY', tab_emp_smart_plan(i).d_day);
                        v_day_row := replace(v_day_row, 'OFFICE', tab_emp_smart_plan(i).office);
                        v_day_row := replace(v_day_row, 'FLOOR', tab_emp_smart_plan(i).floor);
                        v_day_row := replace(v_day_row, 'WING', tab_emp_smart_plan(i).wing);

                    End Loop;

                    If v_day_row = v_sws_empty_day_row Or v_day_row Is Null Then
                        Continue;
                    End If;
                    v_mail_body := v_sws_mail_body;
                    v_mail_body := replace(v_mail_body, '!@StartDate@!', to_char(row_config_week.start_date, 'dd-Mon-yyyy'));
                    v_mail_body := replace(v_mail_body, '!@EndDate@!', to_char(row_config_week.end_date, 'dd-Mon-yyyy'));
                    v_mail_body := replace(v_mail_body, '!@User@!', tab_sws_emp_list(i).employee_name);
                    v_mail_body := replace(v_mail_body, '!@WEEKLYPLANNING@!', v_day_row);

                End If;
                tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
                    p_person_id    => Null,
                    p_meta_id      => Null,
                    p_mail_to      => v_emp_mail,
                    p_mail_cc      => Null,
                    p_mail_bcc     => Null,
                    p_mail_subject => 'SWP : Attendance schedule for Smart Workspace',
                    p_mail_body1   => v_mail_body,
                    p_mail_body2   => Null,
                    p_mail_type    => 'HTML',
                    p_mail_from    => 'SELFSERVICE',
                    p_message_type => v_msg_type,
                    p_message_text => v_msg_text
                );
                Commit;
                v_day_row   := Null;
                v_mail_body := Null;
                v_msg_type  := Null;
                v_msg_text  := Null;
            End Loop;
            Exit When cur_sws_emp_list%notfound;

        End Loop;

    End;

    Procedure sp_mail_ows_plan_to_emp
    As
        cur_dept_rows     Sys_Refcursor;
        cur_emp_week_plan Sys_Refcursor;
        row_config_week   swp_config_weeks%rowtype;
        v_mail_body       Varchar2(4000);
        v_day_row         Varchar2(1000);
        v_emp_mail        Varchar2(100);
        v_msg_type        Varchar2(15);
        v_msg_text        Varchar2(1000);
        v_emp_desk        Varchar2(10);
        Cursor cur_ows_emp_list(cp_monday_date Date,
                                cp_friday_date Date) Is

            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        a.empno,
                        e.name                                           As employee_name,
                        replace(e.email, ',', '.')                       user_email,
                        a.primary_workspace,
                        a.start_date,
                        ceil((Row_Number() Over(Order By e.empno)) / 50) group_id
                    From
                        swp_primary_workspace a,
                        ss_emplmast           e
                    Where
                        e.status                = 1
                        And a.empno             = e.empno
                        And a.primary_workspace = 1
                        And e.emptype In (
                            Select
                                emptype
                            From
                                swp_include_emptype
                        )
                        And e.assign Not In(
                            Select
                                assign
                            From
                                swp_exclude_assign
                        )
                        And trunc(a.start_date) = (
                            Select
                                Max(trunc(start_date))
                            From
                                swp_primary_workspace b
                            Where
                                b.empno = a.empno
                                And b.start_date <= cp_friday_date
                        )
                        And e.empno Not In(
                            Select
                                empno
                            From
                                swp_exclude_emp
                            Where
                                empno = e.empno
                                And (cp_monday_date Between start_date And end_date
                                    Or cp_friday_date Between start_date And end_date)
                        )
                        And e.grade <> 'X1'
                        And e.email Is Not Null
                        And e.empno Not In ('04484')
                ) data
            Group By
                group_id;

        Type typ_tab_ows_emp_list Is Table Of cur_ows_emp_list%rowtype;
        tab_ows_emp_list  typ_tab_ows_emp_list;

    Begin

        Select
            *
        Into
            row_config_week
        From
            swp_config_weeks
        Where
            planning_flag = 2;

        v_mail_body := v_ows_mail_body;
        v_mail_body := replace(v_mail_body, '!@StartDate@!', to_char(row_config_week.start_date, 'dd-Mon-yyyy'));
        v_mail_body := replace(v_mail_body, '!@EndDate@!', to_char(row_config_week.end_date, 'dd-Mon-yyyy'));

        Open cur_ows_emp_list(trunc(row_config_week.start_date), trunc(row_config_week.end_date));
        Loop
            Fetch cur_ows_emp_list Bulk Collect Into tab_ows_emp_list Limit 50;
            For i In 1..tab_ows_emp_list.count
            Loop

                tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
                    p_person_id    => Null,
                    p_meta_id      => Null,
                    p_mail_to      => Null,
                    p_mail_cc      => Null,
                    p_mail_bcc     => tab_ows_emp_list(i).email_csv_list,
                    p_mail_subject => 'SWP : Attendance schedule for Office Workspace',
                    p_mail_body1   => v_mail_body,
                    p_mail_body2   => Null,
                    p_mail_type    => 'HTML',
                    p_mail_from    => 'SELFSERVICE',
                    p_message_type => v_msg_type,
                    p_message_text => v_msg_text
                );
                Commit;
                v_day_row  := Null;

                v_msg_type := Null;
                v_msg_text := Null;
            End Loop;
            Exit When cur_ows_emp_list%notfound;

        End Loop;

    End;

    --

    Procedure sp_add_new_joinees_to_pws
    As
        v_config_week_row swp_config_weeks%rowtype;
        v_count           Number;

    Begin
        Insert Into swp_primary_workspace (key_id, empno, primary_workspace, start_date, modified_on, modified_by, active_code,
            assign_code)
        Select
            dbms_random.string('X', 10),
            empno,
            1 As pws,
            greatest(doj, To_Date('31-Jan-2022')),
            sysdate,
            'Sys',
            2,
            e.assign
        From
            ss_emplmast                e,
            swp_deputation_departments dd
        Where
            e.status     = 1
            And e.assign = dd.assign(+)
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
            And empno Not In (
                Select
                    empno
                From
                    swp_primary_workspace
            );

        --Add new joinees to Dept Quota
        Select
            Count(*)
        Into
            v_count
        From
            swp_config_weeks
        Where
            planning_flag = 2;

        --Iff planning not exists then RETURN
        If v_count = 0 Then
            Return;
        End If;
        Select
            *
        Into
            v_config_week_row
        From
            swp_config_weeks
        Where
            planning_flag = 2;
        sp_generate_workspace_summary(
            p_sysdate          => sysdate,
            p_next_week_key_id => v_config_week_row.key_id
        );
        --************----
    End sp_add_new_joinees_to_pws;

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
            pws_open,
            ows_open,
            sws_open
        )
        Values(
            v_current_week_key_id,
            v_cur_week_mon,
            v_cur_week_fri,
            c_cur_plan_code,
            c_plan_close_code,
            c_plan_close_code,
            c_plan_close_code
        );

    End;

    --
    Procedure close_planning As
        b_update_planning_flag Boolean := false;
    Begin
        Update
            swp_config_weeks
        Set
            pws_open = c_plan_close_code,
            ows_open = c_plan_close_code,
            sws_open = c_plan_close_code
        Where
            pws_open    = c_plan_open_code
            Or ows_open = c_plan_open_code
            Or sws_open = c_plan_open_code;
        If b_update_planning_flag Then
            Update
                swp_config_weeks
            Set
                planning_flag = c_past_plan_code
            Where
                planning_flag = c_cur_plan_code;

            Update
                swp_config_weeks
            Set
                planning_flag = c_cur_plan_code
            Where
                planning_flag = c_future_plan_code;

        End If;
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
    Procedure toggle_plan_future_to_curr(
        p_sysdate Date
    ) As
        rec_config_week swp_config_weeks%rowtype;
        v_sysdate       Date;

    Begin
        v_sysdate := trunc(p_sysdate);

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
                        Order By start_date Desc
                    )
                Where
                    Rownum = 1
            );
        /*
                If rec_config_week.start_date != v_sysdate Then
                    Return;
                End If;
                --
        */
        sp_plan_visible_to_emp(p_show_plan => false);
        --------------        
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
            active_code != c_past_plan_code;

        Update
            swp_primary_workspace pws
        Set
            active_code = c_cur_plan_code
        Where
            pws.empno In (
                Select
                    empno
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
            )
            And start_date = (
                Select
                    Max(start_date)
                From
                    swp_primary_workspace
                Where
                    empno = pws.empno
            );

    End toggle_plan_future_to_curr;
    --
    Procedure rollover_n_open_planning(p_sysdate Date) As
        v_next_week_mon    Date;
        v_next_week_fri    Date;
        v_next_week_key_id Varchar2(8);

        rec_config_week    swp_config_weeks%rowtype;
    Begin
        v_next_week_mon    := iot_swp_common.get_monday_date(p_sysdate + 6);
        v_next_week_fri    := iot_swp_common.get_friday_date(p_sysdate + 6);

        v_next_week_mon    := trunc(v_next_week_mon);
        v_next_week_fri    := trunc(v_next_week_fri);

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
                        Order By start_date Desc
                    )
                Where
                    Rownum = 1
            );
        --Check planning for next week already open
        If rec_config_week.start_date >= v_next_week_mon Then
            Return;
        End If;

        --Close and toggle existing planning
        If rec_config_week.planning_flag = c_future_plan_code Then
            toggle_plan_future_to_curr(p_sysdate);
        End If;

        v_next_week_key_id := dbms_random.string('X', 8);
        --Insert New Plan dates
        Insert Into swp_config_weeks(
            key_id,
            start_date,
            end_date,
            planning_flag,
            pws_open,
            ows_open,
            sws_open
        )
        Values(
            v_next_week_key_id,
            v_next_week_mon,
            v_next_week_fri,
            c_future_plan_code,
            c_plan_close_code,
            c_plan_close_code,
            c_plan_close_code
        );

        --
        --Roll-over SMART Attendance Plan
        --

        --if exists, Delete smart attendance plan for next week 
        Delete
            From swp_smart_attendance_plan
        Where
            attendance_date Between v_next_week_mon And v_next_week_fri;

        --Rollover current weeks plan to next week
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
        --
        --Delete planning of ex-employees
        Delete
            From swp_smart_attendance_plan
        Where
            empno Not In (
                Select
                    empno
                From
                    ss_emplmast
                Where
                    status = 1
            )
            And week_key_id = v_next_week_key_id;
        --
        --
        --Delete planning for holidays during next week
        Delete
            From swp_smart_attendance_plan
        Where
            attendance_date In (
                Select
                    trunc(holiday)
                From
                    ss_holidays
                Where
                    holiday Between v_next_week_mon And v_next_week_fri
            )
            And week_key_id = v_next_week_key_id;

        --
        --
        --Delete planning where desk has been already assigned by TEAM DMS
        Delete
            From swp_smart_attendance_plan
        Where
            deskid In (
                Select
                    deskid
                From
                    dms.dm_usermaster
                Where
                    deskid Not Like 'H%'
            )
            And week_key_id = v_next_week_key_id;

        --
        --
        --delete from smart attendance plan if desk is a GENERAL Catg desk
        Delete
            From swp_smart_attendance_plan
        Where
            deskid In (
                Select
                    deskid
                From
                    dms.dm_deskmaster
                Where
                    work_area In (
                        Select
                            area_key_id
                        From
                            dms.dm_desk_areas
                        Where
                            area_catg_code = c_general_area_catg
                    )

            )
            And week_key_id = v_next_week_key_id;
        --
        --
        --Generate DEPT-Wise workspace summary for Quota purpose
        sp_generate_workspace_summary(
            p_sysdate          => p_sysdate,
            p_next_week_key_id => v_next_week_key_id
        );
        --
        --
        --do snapshot of DESK+USER & DESK+ASSET & Also DESKLOCK mapping
        do_dms_snapshot(trunc(p_sysdate));
        ---

        do_dms_data_to_plan(v_next_week_key_id);

    End rollover_n_open_planning;

    --
    Procedure sp_configuration Is
        v_secondlast_workdate Date;
        v_sysdate             Date;
        v_fri_date            Date;
        v_is_second_last_day  Boolean;
        Type rec Is Record(
                work_date     Date,
                work_day_desc Varchar2(100),
                rec_num       Number
            );

        Type typ_tab_work_day Is Table Of rec;
        tab_work_day          typ_tab_work_day;
        v_flag_open_pws_plan  Varchar2(4)  := 'F005';
        v_flag_open_sws_plan  Varchar2(4)  := 'F006';

        v_flag_close_pws_plan Varchar2(4)  := 'F007';
        v_flag_close_sws_plan Varchar2(4)  := 'F008';

        v_open_pws            Boolean;
        v_open_sws            Boolean;

        v_close_pws           Boolean;
        v_close_sws           Boolean;
        v_cur_env             Varchar2(60);
        c_dev_env             Varchar2(60) := 'tpldev11g.ticb.comp';

    Begin

        Select
            sys_context('userenv', 'service_name')
        Into
            v_cur_env
        From
            dual;

        sp_add_new_joinees_to_pws;

        v_sysdate            := trunc(sysdate);
        v_fri_date           := iot_swp_common.get_friday_date(trunc(v_sysdate));

        --Hard-Code date for DEV env
        If lower(v_cur_env) = c_dev_env Then
            v_sysdate := To_Date('9-Aug-2022');
        End If;
        --

        remove_temp_desks(v_sysdate);

        --

        init_configuration(v_sysdate);

        v_is_second_last_day := fn_is_second_last_day_of_week(v_sysdate);

        v_open_pws           := fn_is_action_day_4_flag(
                                    p_action_flag => v_flag_open_pws_plan,
                                    p_sysdate     => v_sysdate
                                );
        v_close_pws          := fn_is_close_day_4_flag(
                                    p_action_flag   => v_flag_open_pws_plan,
                                    p_duration_flag => v_flag_close_pws_plan,
                                    p_sysdate       => v_sysdate
                                );

        v_open_sws           := fn_is_action_day_4_flag(
                                    p_action_flag => v_flag_open_sws_plan,
                                    p_sysdate     => v_sysdate
                                );

        v_close_sws          := fn_is_close_day_4_flag(
                                    p_action_flag   => v_flag_open_sws_plan,
                                    p_duration_flag => v_flag_close_sws_plan,
                                    p_sysdate       => v_sysdate
                                );

        -- blocking pws forcefully (but not in dev env)
        If lower(v_cur_env) != c_dev_env Then
            v_open_pws := false;
        End If;
        --
        If v_open_pws Or v_open_sws Then
            rollover_n_open_planning(v_sysdate);
        End If;

        If v_open_pws Then
            sp_set_plan_status(
                p_plan_type        => c_pws,
                p_plan_status_code => c_plan_open_code
            );
            sp_plan_visible_to_emp(p_show_plan => false);
            send_mail_planning_open(
                p_plan_type => c_pws
            );
        End If;

        If v_close_pws Then
            sp_set_plan_status(
                p_plan_type        => c_pws,
                p_plan_status_code => c_plan_close_code
            );
        End If;

        If v_open_sws Then
            sp_set_plan_status(
                p_plan_type        => c_sws,
                p_plan_status_code => c_plan_open_code
            );
            sp_plan_visible_to_emp(
                p_show_plan => false
            );
            send_mail_planning_open(
                p_plan_type => c_sws
            );
        End If;

        If v_close_sws Then
            sp_set_plan_status(
                p_plan_type        => c_sws,
                p_plan_status_code => c_plan_close_code
            );
        End If;

        If v_sysdate = v_fri_date Then
            --Auto generate SMART attendance plan
            iot_swp_auto_assign_desk.sp_auto_generate_plan;

            close_planning;
            sp_plan_visible_to_emp(
                p_show_plan => true
            );
            sp_mail_sws_plan_to_emp;
            sp_mail_ows_plan_to_emp;
        Elsif to_char(v_sysdate, 'Dy') = 'Mon' Then
            toggle_plan_future_to_curr(v_sysdate);
        Else
            Null;
            --ToBeDecided
        End If;
    End sp_configuration;

End iot_swp_config_week;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_COMMON
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_COMMON" As

    Function fn_get_pws_text(
        p_pws_type_code Number
    ) Return Varchar2 As
        v_ret_val Varchar2(100);
    Begin
        If p_pws_type_code Is Null Or p_pws_type_code = -1 Then
            Return Null;
        End If;
        Select
            type_desc
        Into
            v_ret_val
        From
            swp_primary_workspace_types
        Where
            type_code = p_pws_type_code;
        Return v_ret_val;
    Exception
        When Others Then
            Return Null;
    End;

    Function fn_get_dept_group(
        p_costcode Varchar2
    ) Return Varchar2 As
        v_retval Varchar2(100);
    Begin
        Select
            group_name
        Into
            v_retval
        From
            ss_dept_grouping
        Where
            parent = p_costcode;
        Return v_retval;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_emp_work_area(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2
    ) Return Varchar2 As
        v_count  Number;
        v_projno Varchar2(5);
        v_area   Varchar2(60);
    Begin

        Select
            Count(dapm.office || ' - ' || ep.projno || ' - ' || da.area_desc)
        Into
            v_count
        From
            swp_emp_proj_mapping      ep,
            dms.dm_desk_area_proj_map dapm,
            dms.dm_desk_areas         da
        Where
            ep.projno          = dapm.projno
            And dapm.area_code = da.area_key_id
            And ep.empno       = p_empno;

        If (v_count > 0) Then

            Select
                dapm.office || ' - ' || ep.projno || ' - ' || da.area_desc
            Into
                v_area
            From
                swp_emp_proj_mapping      ep,
                dms.dm_desk_area_proj_map dapm,
                dms.dm_desk_areas         da
            Where
                ep.projno          = dapm.projno
                And dapm.area_code = da.area_key_id
                And ep.empno       = p_empno
                And Rownum         = 1;

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
        v_retval Varchar(50);
        v_count  Number;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_usermaster
        Where
            empno = Trim(p_empno)
            And deskid Not Like 'H%';

        If v_count > 0 Then
            Select
                deskid
            Into
                v_retval
            From
                dms.dm_usermaster
            Where
                empno = Trim(p_empno)
                And deskid Not Like 'H%';
            Return v_retval;
        End If;
        --Return v_retval;
        Select
            Count(*)
        Into
            v_count
        From
            swp_temp_desk_allocation
        Where
            empno = p_empno;

        If v_count > 0 Then
            Select
                deskid
            Into
                v_retval
            From
                swp_temp_desk_allocation
            Where
                empno = Trim(p_empno);
            Return '*!-' || v_retval;
        End If;

        Return v_retval;
    Exception
        When Others Then
            Return Null;
    End get_desk_from_dms;

    Function get_swp_planned_desk(
        p_empno In Varchar2
    ) Return Varchar2 As
        v_retval Varchar(50) := 'NA';
    Begin

        Select
        Distinct deskid As desk
        Into
            v_retval
        From
            dms.dm_usermaster_swp_plan dmst
        Where
            dmst.empno = Trim(p_empno)
            And dmst.deskid Not Like 'H%';

        Return v_retval;
    Exception
        When Others Then
            Return Null;
    End get_swp_planned_desk;

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
                        dm_vu_emp_desk_map_swp_plan c
                )
            );
        Return v_count;
    End;

    Function get_monday_date(p_date Date) Return Date As
        v_day_num Number;
    Begin
        v_day_num := To_Number(to_char(p_date, 'd'));
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

    Function get_default_dept4plan_hod_sec(
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
                            parent As assign
                        From
                            ss_user_dept_rights                                   a, swp_include_assign_4_seat_plan b
                        Where
                            empno        = v_hod_sec_empno
                            And a.parent = b.assign
                        Union
                        Select
                            costcode As assign
                        From
                            ss_costmast                                   a, swp_include_assign_4_seat_plan b
                        Where
                            hod            = v_hod_sec_empno
                            And a.costcode = b.assign
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

    Function fn_get_emp_pws(
        p_empno Varchar2,
        p_date  Date Default Null
    ) Return Number As
        v_emp_pws      Number;
        v_friday_date  Date;
        v_pws_for_date Date;
    Begin
        v_pws_for_date := trunc(nvl(p_date, sysdate));
        Begin
            Select
                a.primary_workspace
            Into
                v_emp_pws
            From
                swp_primary_workspace a
            Where
                a.empno             = p_empno
                And
                trunc(a.start_date) = (
                    Select
                        Max(trunc(start_date))
                    From
                        swp_primary_workspace b
                    Where
                        b.empno = a.empno
                        And b.start_date <= v_pws_for_date
                );
            Return v_emp_pws;
        Exception
            When Others Then
                Return Null;
        End;
    End;

    Function fn_get_emp_pws_planning(
        p_empno Varchar2 Default Null
    ) Return Varchar2 As
        v_emp_pws        Number;
        v_pws_for_date   Date;
        row_config_weeks swp_config_weeks%rowtype;
    Begin
        If p_empno Is Null Then
            Return Null;
        End If;
        Begin
            Select
                *
            Into
                row_config_weeks
            From
                swp_config_weeks
            Where
                planning_flag = 2;
            v_pws_for_date := row_config_weeks.end_date;
        Exception
            When Others Then
                Null;
        End;
        v_emp_pws := fn_get_emp_pws(p_empno, v_pws_for_date);
        v_emp_pws := nvl(v_emp_pws, -1);
        Return fn_get_pws_text(v_emp_pws);
    Exception
        When Others Then
            Return Null;
    End;

    Function fn_can_do_desk_plan_4_emp(p_empno Varchar2) Return Boolean As
        v_count Number;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast                    e,
            swp_include_assign_4_seat_plan sp
        Where
            empno        = p_empno
            And e.assign = sp.assign;
        Return v_count > 0;
    End;

    Function fn_can_work_smartly(
        p_empno Varchar2
    ) Return Number As
        v_is_swp_eligible Varchar2(2);
        v_is_dual_monitor Number(1);
        v_is_laptop_user  Number(1);
    Begin

        v_is_laptop_user  := is_emp_laptop_user(p_empno);
        v_is_dual_monitor := is_emp_dualmonitor_user(p_empno);
        v_is_swp_eligible := get_emp_is_eligible_4swp(p_empno);

        If v_is_laptop_user = 1 And v_is_swp_eligible = 'OK' And v_is_dual_monitor = 0 Then
            Return 1;
        Else
            Return 0;
        End If;
    Exception
        When Others Then
            Return Null;
    End;

    Function fn_is_present_4_swp(
        p_empno Varchar2,
        p_date  Date
    ) Return Number
    As
        v_count Number;
    Begin

        --Punch Count
        Select
            Count(*)
        Into
            v_count
        From
            ss_punch
        Where
            empno     = p_empno
            And pdate = p_date;
        If v_count > 0 Then
            Return 1;
        End If;

        --Approved Leave
        Select
            Count(*)
        Into
            v_count
        From
            ss_leaveledg
        Where
            empno           = p_empno
            And bdate <= p_date
            And nvl(edate, bdate) >= p_date
            And (adj_type   = 'LA'
                Or adj_type = 'LC');
        If v_count > 0 Then
            Return 1;
        End If;

        --Forgot Punch
        Select
            Count(*)
        Into
            v_count
        From
            ss_ondutyapp
        Where
            empno     = p_empno
            And pdate = p_date
            And type  = 'IO';
        If v_count > 0 Then
            Return 1;
        End If;

        --OnTour / Deputation / Remote Work
        Select
            Count(*)
        Into
            v_count
        From
            ss_depu
        Where
            empno         = Trim(p_empno)
            And bdate <= p_date
            And nvl(edate, bdate) >= p_date

            And hrd_apprl = 1;

        If v_count > 0 Then
            Return 1;
        End If;

        --Exception
        Select
            Count(*)
        Into
            v_count
        From
            swp_exclude_emp
        Where
            empno         = Trim(p_empno)
            And p_date Between start_date And end_date
            And is_active = 1;
        If v_count > 0 Then
            Return 1;
        End If;
        Return 0;
    End;

    Function get_emp_is_eligible_4swp(
        p_empno Varchar2 Default Null
    ) Return Varchar2 As
    Begin
        If Trim(p_empno) Is Null Then
            Return Null;
        End If;
        Return is_emp_eligible_for_swp(p_empno);
    End;

    Function is_emp_dualmonitor_user(
        p_empno Varchar2 Default Null
    ) Return Number As
        v_count Number;
    Begin
        Select
            Count(da.assetid)
        Into
            v_count
        From
            dms.dm_deskallocation da,
            dms.dm_usermaster     um,
            dms.dm_assetcode      ac
        Where
            um.deskid             = da.deskid
            And um.empno          = p_empno
            And ac.sub_asset_type = 'IT0MO'
            And da.assetid        = ac.barcode
            And um.deskid Not Like 'H%';
        If v_count >= 2 Then
            Return 1;
        Else
            Return 0;

        End If;

        --
        Select
            Count(da.assetid)
        Into
            v_count
        From
            dms.dm_deskallocation da,
            dms.dm_usermaster     um,
            dms.dm_assetcode      ac
        Where
            um.deskid             = da.deskid
            And um.empno          = p_empno
            And ac.sub_asset_type = 'IT0MO'
            And da.assetid        = ac.barcode
            And um.deskid Like 'H%';
        If v_count >= 2 Then
            Return 1;
        Else
            Return 0;

        End If;

    Exception
        When Others Then
            Return 0;
    End;

    Function get_emp_projno_desc(
        p_empno Varchar2
    ) Return Varchar2 As
        v_projno    Varchar2(5);
        v_proj_name ss_projmast.name%Type;
    Begin
        Select
            projno
        Into
            v_projno
        From
            swp_emp_proj_mapping
        Where
            empno = p_empno;
        Select
        Distinct name
        Into
            v_proj_name
        From
            ss_projmast
        Where
            proj_no = v_projno;
        Return v_projno || ' - ' || v_proj_name;
    Exception
        When Others Then
            Return '';
    End;

    Function fn_get_attendance_status(
        p_empno Varchar2,
        p_date  Date
    ) Return Varchar2 As
        v_count             Number;
        v_punch_exists      Boolean;
        row_depu_tour       ss_depu%rowtype;
        row_onduty          ss_ondutyapp%rowtype;
        row_leave           ss_leaveapp%rowtype;
        row_leaveledg       ss_leaveledg%rowtype;
        row_exclude_emp     swp_exclude_emp%rowtype;
        row_absent_lop      ss_absent_lop%rowtype;
        row_absent_ts_lop   ss_absent_ts_lop%rowtype;
        v_default_return    Varchar2(15);
        e_general_exception Exception;
        Pragma exception_init(e_general_exception, -20002);
    Begin
        v_default_return := 'Absent';
        Select
            Count(*)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = trunc(p_date);
        If v_count > 0 Then
            v_default_return := '';

        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_integratedpunch

        Where
            empno     = p_empno
            And pdate = p_date
            And mach <> 'WFH0';

        If v_count > 0 Then
            Return 'Present';
        End If;

        --Check Exception
        Begin
            Select
                *
            Into
                row_exclude_emp
            From
                swp_exclude_emp
            Where
                p_date Between start_date And end_date
                And empno = p_empno;

        Exception
            When Others Then
                Null;
        End;

        --Check Leave app
        Begin
            Declare
                v_leave_desc Varchar2(100);
            Begin
                Select
                    Count(*)
                Into
                    v_count
                From
                    ss_leaveapp
                Where
                    empno = p_empno
                    And p_date Between bdate And nvl(edate, bdate);
                If v_count > 0 Then
                    v_leave_desc := 'Leave applied';
                Else
                    Raise e_general_exception;
                End If;
                Select
                    *
                Into
                    row_leave
                From
                    ss_leaveapp
                Where
                    empno = p_empno
                    And p_date Between bdate And nvl(edate, bdate);

                If row_leave.hrd_apprl = 1 Then
                    v_leave_desc := 'Leave';
                Else
                    v_leave_desc := 'Leave applied';
                End If;
                If nvl(row_exclude_emp.is_active, 0) = 1 Then
                    Return v_leave_desc || ' + Exception';
                Else
                    Return v_leave_desc;
                End If;

            Exception
                When Others Then
                    If Trim(v_leave_desc) Is Not Null Then
                        Return v_leave_desc;
                    End If;
            End;

            -- Check Loss of pay PUNCH DETAILS...
            Begin
                Select
                    *
                Into
                    row_absent_lop
                From
                    ss_absent_lop
                Where
                    empno          = p_empno
                    And lop_4_date = p_date;

                Return 'LWP-PunchDetails';
            Exception
                When Others Then
                    Null;
            End;

            -- Check Loss of pay TIMESHEET...
            Begin
                Select
                    *
                Into
                    row_absent_ts_lop
                From
                    ss_absent_ts_lop
                Where
                    empno          = p_empno
                    And lop_4_date = p_date;

                Return 'LWP-Timesheet';
            Exception
                When Others Then
                    Null;
            End;

            --Check Leave LEDG for Leave Claim & Smart Work Leave deduction
            Declare
                v_leave_desc Varchar2(100);
            Begin
                Select
                    *
                Into
                    row_leaveledg
                From
                    ss_leaveledg
                Where
                    empno     = p_empno
                    And p_date Between bdate And nvl(edate, bdate)
                    And adj_type In ('LC', 'SW')
                    And db_cr = 'D';
                If row_leaveledg.adj_type = 'SW' Then
                    v_leave_desc := 'SWP-Leave';
                Else
                    v_leave_desc := 'Leave';
                End If;
                If nvl(row_exclude_emp.is_active, 0) = 1 Then
                    Return v_leave_desc || ' + Exception';
                Else
                    Return v_leave_desc;
                End If;
            Exception
                When Others Then
                    Null;
            End;

            --Check deputation / tour / remote work
            Begin
                Select
                    Count(*)
                Into
                    v_count
                From
                    ss_depu
                Where
                    type In ('TR', 'DP', 'RW')
                    And empno = p_empno
                    And p_date Between bdate And edate;

                If v_count > 1 Then
                    Return 'Tour-Deputation-err';
                End If;

                Select
                    *
                Into
                    row_depu_tour
                From
                    ss_depu
                Where
                    type In ('TR', 'DP', 'RW')
                    And empno = p_empno
                    And p_date Between bdate And edate;

                If row_depu_tour.hrd_apprl = 1 Then
                    If row_depu_tour.type = 'RW' Then
                        Return 'Smart Work Applied';
                    End If;
                    Return 'Tour-Deputation';
                Else
                    Return 'Tour-Deputation applied';
                End If;
            Exception
                When Others Then
                    Null;
            End;
            --Check Missed / In-Out punch onduty
            Begin
                Select
                    *
                Into
                    row_onduty
                From
                    ss_ondutyapp
                Where
                    type In (
                        'IO', 'OD'
                    )
                    And empno = p_empno
                    And pdate = trunc(p_date);
                If row_onduty.hrd_apprl = 1 Then
                    Return 'Onduty MP/IO';
                Else
                    Return 'Onduty MP/IO applied';

                End If;
            Exception
                When Others Then
                    Null;
            End;

            If row_exclude_emp.is_active = 1 Then
                Return 'Exception';
            End If;

            Return v_default_return;
        Exception
            When Others Then
                Return 'ERR';
        End;
    End;

    Function fn_get_attendance_status(
        p_empno Varchar2,
        p_date  Date,
        p_pws   Number
    ) Return Varchar2 As
        v_count          Number;
        v_ret_val        Varchar2(100);
        v_fri_date       Date;
        v_swp_start_date Date;
    Begin
        If p_empno Is Null Or p_date Is Null Or p_pws Is Null Then
            Return Null;
        End If;
        v_swp_start_date := To_Date('18-Apr-2022');
        Select
            Count(*)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = trunc(p_date);
        If v_count > 0 Then
            --Return '';
            Null;
        End If;
        v_ret_val        := fn_get_attendance_status(
                                p_empno => p_empno,
                                p_date  => p_date
                            );
        If p_pws Not In (2, 3) Then --Office workspace
            Return v_ret_val;
        End If;
        If p_pws = 3 Then -- Deputation workspace
            If v_ret_val = 'Absent' Then
                Return 'OnSite';
            Else
                Return v_ret_val;
            End If;
        End If;

        v_fri_date       := get_friday_date(sysdate);

        --Smart workspace
        If trunc(p_date) <= v_fri_date And trunc(p_date) >= v_swp_start_date Then
            Select
                Count(*)
            Into
                v_count
            From
                swp_smart_attendance_plan
            Where
                empno               = p_empno
                And attendance_date = p_date;
            If v_count = 0 Then
                If v_ret_val = 'Present' Then
                    Return 'OutOfTurn Present';
                Elsif v_ret_val = 'Absent' Then
                    Return 'Smartly Present';
                End If;
            End If;
        End If;
        Return v_ret_val;
    End;

    Function fn_is_attendance_required(
        p_empno Varchar2,
        p_date  Date,
        p_pws   Number
    ) Return Varchar2 As
        v_count   Number;
        v_ret_val Varchar2(100);
    Begin
        If p_date > (sysdate) Then
            Return 'No';
        End If;
        If p_pws = 1 Then
            Return 'Yes';
        End If;
        If p_pws = 3 Then
            Return 'No';
        End If;
        If p_pws = 2 Then
            Select
                Count(*)
            Into
                v_count
            From
                swp_smart_attendance_plan
            Where
                empno               = p_empno
                And attendance_date = p_date;
            If v_count > 0 Then
                Return 'Yes';
            Else
                Return 'No';
            End If;
        End If;
        Return '--';
    End;
    --

    Function fn_get_prev_work_date(
        p_prev_date Date Default Null
    ) Return Date
    As
        v_prev_date Date;
        v_count     Number;
    Begin
        v_prev_date := trunc(nvl(p_prev_date, sysdate));
        Select
            Count(*)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = v_prev_date;
        If v_count = 0 Then
            Return v_prev_date;
        Else
            Return fn_get_prev_work_date(v_prev_date - 1);
        End If;

    End;

    Procedure sp_get_emp_workspace_details(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        p_empno                 Varchar2,
        p_current_pws       Out Number,
        p_planning_pws      Out Number,
        p_current_pws_text  Out Varchar2,
        p_planning_pws_text Out Varchar2,
        p_curr_desk_id      Out Varchar2,
        p_curr_office       Out Varchar2,
        p_curr_floor        Out Varchar2,
        p_curr_wing         Out Varchar2,
        p_curr_bay          Out Varchar2,
        p_plan_desk_id      Out Varchar2,
        p_plan_office       Out Varchar2,
        p_plan_floor        Out Varchar2,
        p_plan_wing         Out Varchar2,
        p_plan_bay          Out Varchar2,
        p_message_type      Out Varchar2,
        p_message_text      Out Varchar2
    ) As
        v_current_pws     Number;
        v_planning_pws    Number;
        v_plan_start_date Date;
        v_plan_end_date   Date;
        v_curr_start_date Date;
        v_curr_end_date   Date;
        v_planning_exists Varchar2(2);
        v_pws_open        Varchar2(2);
        v_sws_open        Varchar2(2);
        v_ows_open        Varchar2(2);
        v_msg_type        Varchar2(10);
        v_msg_text        Varchar2(1000);
        v_emp_pws         Number;
        v_friday_date     Date;
    Begin
        get_planning_week_details(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,
            p_plan_start_date => v_plan_start_date,
            p_plan_end_date   => v_plan_end_date,
            p_curr_start_date => v_curr_start_date,
            p_curr_end_date   => v_curr_end_date,
            p_planning_exists => v_planning_exists,
            p_pws_open        => v_pws_open,
            p_sws_open        => v_sws_open,
            p_ows_open        => v_ows_open,
            p_message_type    => v_msg_type,
            p_message_text    => v_msg_text

        );

        p_current_pws       := fn_get_emp_pws(
                                   p_empno => p_empno,
                                   p_date  => trunc(sysdate)
                               );
        If v_plan_end_date Is Not Null Then
            p_planning_pws := fn_get_emp_pws(
                                  p_empno => p_empno,
                                  p_date  => v_plan_end_date
                              );
        End If;
        p_current_pws_text  := fn_get_pws_text(p_current_pws);
        p_planning_pws_text := fn_get_pws_text(p_planning_pws);
        If p_current_pws = 1 Then --Office
            Begin
                p_curr_desk_id := get_desk_from_dms(p_empno);
                Select
                    dm.office,
                    dm.floor,
                    dm.wing,
                    dm.bay
                Into
                    p_curr_office,
                    p_curr_floor,
                    p_curr_wing,
                    p_curr_bay
                From
                    dms.dm_deskmaster dm
                Where
                    dm.deskid = p_curr_desk_id;
            Exception
                When Others Then
                    Null;
            End;
        End If;

        If p_planning_pws = 1 Then --Office
            Begin
                p_plan_desk_id := get_desk_from_dms(p_empno);
                Select
                    dm.office,
                    dm.floor,
                    dm.wing,
                    dm.bay
                Into
                    p_plan_office,
                    p_plan_floor,
                    p_plan_wing,
                    p_plan_bay
                From
                    dms.dm_deskmaster dm
                Where
                    dm.deskid = p_plan_desk_id;
            Exception
                When Others Then
                    Null;
            End;
            /*
        Elsif p_planning_pws = 2 Then --SMART
            p_plan_sws := iot_swp_smart_workspace_qry.fn_emp_week_attend_planning(
                              p_person_id => p_person_id,
                              p_meta_id   => p_meta_id,
                              p_empno     => p_empno,
                              p_date      => v_plan_start_date
                          );
*/
        End If;
    End;

    Procedure sp_emp_office_workspace(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,

        p_office       Out Varchar2,
        p_floor        Out Varchar2,
        p_wing         Out Varchar2,
        p_desk         Out Varchar2,

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
        End If;

        Select
        Distinct
            'P_Office' As p_office,
            'P_Floor'  As p_floor,
            'P_Desk'   As p_desk,
            'P_Wing'   As p_wing
        Into
            p_office,
            p_floor,
            p_wing,
            p_desk
        From
            dual;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_emp_office_workspace;

    Procedure sp_primary_workspace(
        p_person_id                   Varchar2,
        p_meta_id                     Varchar2,
        p_empno                       Varchar2 Default Null,

        p_current_workspace_text  Out Varchar2,
        p_current_workspace_val   Out Varchar2,
        p_current_workspace_date  Out Varchar2,

        p_planning_workspace_text Out Varchar2,
        p_planning_workspace_val  Out Varchar2,
        p_planning_workspace_date Out Varchar2,

        p_message_type            Out Varchar2,
        p_message_text            Out Varchar2

    ) As
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        If p_empno Is Not Null Then
            v_empno := p_empno;
        Else
            v_empno := get_empno_from_meta_id(p_meta_id);
        End If;

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
        End If;
        Begin
            Select
            Distinct
                a.primary_workspace As p_primary_workspace_val,
                b.type_desc         As p_primary_workspace_text,
                a.start_date        As p_primary_workspace_date
            Into
                p_current_workspace_val,
                p_current_workspace_text,
                p_current_workspace_date
            From
                swp_primary_workspace       a,
                swp_primary_workspace_types b
            Where
                a.primary_workspace = b.type_code
                And a.empno         = v_empno
                And a.active_code   = 1;
        Exception
            When Others Then
                p_current_workspace_text := 'NA';
        End;

        Begin
            Select
            Distinct
                a.primary_workspace As p_primary_workspace_val,
                b.type_desc         As p_primary_workspace_text,
                a.start_date        As p_primary_workspace_date
            Into
                p_planning_workspace_val,
                p_planning_workspace_text,
                p_planning_workspace_date
            From
                swp_primary_workspace       a,
                swp_primary_workspace_types b
            Where
                a.primary_workspace = b.type_code
                And a.empno         = v_empno
                And a.active_code   = 2;
        Exception
            When Others Then
                p_planning_workspace_text := 'NA';
        End;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_primary_workspace;

    Procedure get_planning_week_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_plan_start_date Out Date,
        p_plan_end_date   Out Date,
        p_curr_start_date Out Date,
        p_curr_end_date   Out Date,
        p_planning_exists Out Varchar2,
        p_pws_open        Out Varchar2,
        p_sws_open        Out Varchar2,
        p_ows_open        Out Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2

    ) As
        v_count         Number;
        v_rec_plan_week swp_config_weeks%rowtype;
        v_rec_curr_week swp_config_weeks%rowtype;
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
            p_pws_open        := 'KO';
            p_sws_open        := 'KO';
            p_ows_open        := 'KO';
            p_planning_exists := 'KO';
        Else
            Select
                *
            Into
                v_rec_plan_week
            From
                swp_config_weeks
            Where
                planning_flag = 2;

            p_plan_start_date := v_rec_plan_week.start_date;
            p_plan_end_date   := v_rec_plan_week.end_date;
            p_planning_exists := 'OK';
            p_pws_open        := Case
                                     When nvl(v_rec_plan_week.pws_open, 0) = 1 Then
                                         'OK'
                                     Else
                                         'KO'
                                 End;
            p_sws_open        := Case
                                     When nvl(v_rec_plan_week.sws_open, 0) = 1 Then
                                         'OK'
                                     Else
                                         'KO'
                                 End;
            p_ows_open        := Case
                                     When nvl(v_rec_plan_week.ows_open, 0) = 1 Then
                                         'OK'
                                     Else
                                         'KO'
                                 End;
        End If;
        Select
            *
        Into
            v_rec_curr_week
        From
            (
                Select
                    *
                From
                    swp_config_weeks
                Where
                    planning_flag <> 2
                Order By start_date Desc
            )
        Where
            Rownum = 1;

        p_curr_start_date := v_rec_curr_week.start_date;
        p_curr_end_date   := v_rec_curr_week.end_date;

        p_message_type    := 'OK';
        p_message_text    := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End get_planning_week_details;

    Procedure get_dept_planning_weekdetails(
        p_person_id                 Varchar2,
        p_meta_id                   Varchar2,
        p_assign_code               Varchar2 Default Null,
        p_plan_start_date       Out Date,
        p_plan_end_date         Out Date,
        p_curr_start_date       Out Date,
        p_curr_end_date         Out Date,
        p_planning_exists       Out Varchar2,
        p_pws_open              Out Varchar2,
        p_sws_open              Out Varchar2,
        p_ows_open              Out Varchar2,
        p_dept_ows_quota_exists Out Varchar2,
        p_dept_ows_quota        Out Number,
        p_message_type          Out Varchar2,
        p_message_text          Out Varchar2
    ) As
        v_by_empno           Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_assign_code        Varchar2(4);
        v_rec_plan_week      swp_config_weeks%rowtype;
        v_dept_quota         swp_dept_workspace_summary%rowtype;
    Begin

        v_by_empno     := get_empno_from_meta_id(p_meta_id);

        If v_by_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;

        get_planning_week_details(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,
            p_plan_start_date => p_plan_start_date,
            p_plan_end_date   => p_plan_end_date,
            p_curr_start_date => p_curr_start_date,
            p_curr_end_date   => p_curr_end_date,
            p_planning_exists => p_planning_exists,
            p_pws_open        => p_pws_open,
            p_sws_open        => p_sws_open,
            p_ows_open        => p_ows_open,
            p_message_type    => p_message_type,
            p_message_text    => p_message_text

        );
        If p_message_type = 'KO' Then
            Return;
        End If;
        v_assign_code  := p_assign_code;
        If v_assign_code Is Null Then
            v_assign_code := iot_swp_common.get_default_costcode_hod_sec(
                                 p_hod_sec_empno => v_by_empno,
                                 p_assign_code   => p_assign_code
                             );

        End If;
        If p_planning_exists = 'OK' Then
            Select
                *
            Into
                v_rec_plan_week
            From
                swp_config_weeks
            Where
                planning_flag = 2;
            p_dept_ows_quota_exists := iot_swp_primary_workspace.fn_dept_ows_quota_exists(
                                           p_assign       => v_assign_code,
                                           p_week_key_id  => v_rec_plan_week.key_id,
                                           p_message_type => p_message_type,
                                           p_message_text => p_message_text
                                       );
            Select
                *
            Into
                v_dept_quota
            From
                swp_dept_workspace_summary
            Where
                week_key_id = v_rec_plan_week.key_id
                And assign  = v_assign_code;
            p_dept_ows_quota        := v_dept_quota.ows_emp_count;

        Else
            p_dept_ows_quota_exists := 'KO';
            p_dept_ows_quota := 0;
        End If;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_dept_ows_quota_exists := 'KO';
            p_message_type          := 'KO';
            p_message_text          := 'Err ' || sqlcode || ' - ' || sqlerrm;

    End;

End iot_swp_common;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_ATTENDANCE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_ATTENDANCE_QRY" As

    Function fn_attendance_for_period(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_start_date              Date,
        p_end_date                Date,
        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_exclude_grade      Varchar2(2);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_is_exclude_x1_employees = 1 Then
            v_exclude_grade := 'X1';
        Else
            v_exclude_grade := '!!';
        End If;

        Open c For
            Select
                data.*,
                iot_swp_common.fn_get_pws_text(data.n_pws)                                    c_pws,
                iot_swp_common.fn_get_attendance_status(data.empno, data.d_date, data.n_pws)  attend_status,
                iot_swp_common.fn_is_attendance_required(data.empno, data.d_date, data.n_pws) attend_required
            From
                (
                    Select
                        *
                    From
                        (
                            With
                                work_days As (
                                    Select
                                        *
                                    From
                                        ss_days_details d
                                    Where
                                        d.d_date Between p_start_date And nvl(p_end_date, sysdate)
                                        And d.d_date Not In (
                                            Select
                                                holiday
                                            From
                                                ss_holidays
                                            Where
                                                holiday Between p_start_date And nvl(p_end_date, sysdate)
                                        )
                                )
                            Select
                                e.empno                                                    As empno,
                                e.name                                                     As employee_name,
                                e.email                                                    As email,
                                e.parent                                                   As parent,
                                e.assign                                                   As assign,
                                e.emptype                                                  As emp_type,
                                e.grade                                                    As grade,
                                e.doj                                                      As doj,
                                p_end_date                                                 As dol,
                                wd.d_date                                                  As d_date,
                                to_char(e.status)                                          As status,
                                to_char(iot_swp_common.fn_get_emp_pws(e.empno, wd.d_date)) n_pws
                            From
                                ss_emplmast e,
                                work_days   wd
                            Where
                                (
                                e.status = 1

                                )
                                And e.emptype In (
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
                                And e.grade <> v_exclude_grade
                        )
                    Where
                        d_date >= doj

                ) data;

        Return c;

    End;

    Function fn_attendance_for_day(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_start_date              Date,

        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        e_date_is_holiday    Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        Pragma exception_init(e_date_is_holiday, -20002);
        c                    Sys_Refcursor;
        v_exclude_grade      Varchar2(2);
        v_count              Number;
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_is_exclude_x1_employees = 1 Then
            v_exclude_grade := 'X1';
        Else
            v_exclude_grade := '!!';
        End If;

        If p_start_date Is Null Then
            raise_application_error(-20003, 'Invalid date provided.');

            Return Null;
        End If;

        Select
            Count(holiday)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = p_start_date;
        If v_count > 0 Then
            raise_application_error(-20002, 'Date provided is a holiday');
            Return Null;
        End If;
        Open c For
            Select
                data.*,
                iot_swp_common.fn_get_pws_text(data.n_pws)                                    c_pws,
                iot_swp_common.fn_get_attendance_status(data.empno, data.d_date, data.n_pws)  attend_status,
                iot_swp_common.fn_is_attendance_required(data.empno, data.d_date, data.n_pws) attend_required

            From
                (
                    Select
                        *
                    From
                        (
                            Select
                                e.empno                                                       As empno,
                                e.name                                                        As employee_name,
                                e.email                                                       As email,
                                e.parent                                                      As parent,
                                e.assign                                                      As assign,
                                e.emptype                                                     As emp_type,
                                e.grade                                                       As grade,
                                e.doj                                                         As doj,
                                trunc(p_start_date)                                           As d_date,
                                to_char(e.status)                                             As status,
                                to_char(iot_swp_common.fn_get_emp_pws(e.empno, p_start_date)) n_pws,
                                Case iot_swp_common.fn_can_work_smartly(empno)
                                    When 1 Then
                                        'Yes'
                                    Else
                                        'No'
                                End                                                           As can_work_smartly
                            From
                                ss_emplmast e
                            Where
                                status = 1
                                And emptype In (
                                    Select
                                        emptype
                                    From
                                        swp_include_emptype
                                )
                                And assign Not In(
                                    Select
                                        assign
                                    From
                                        swp_exclude_assign
                                )
                                And grade <> v_exclude_grade
                                And doj <= p_start_date
                        )
                ) data;

        Return c;

    End;

    Function fn_attendance_for_prev_day(
        p_person_id Varchar2,
        p_meta_id   Varchar2

    ) Return Sys_Refcursor As
        v_prev_date Date;
    Begin
        v_prev_date := iot_swp_common.fn_get_prev_work_date(trunc(sysdate) - 1);

        Return fn_attendance_for_day(
                p_person_id               => p_person_id,
                p_meta_id                 => p_meta_id,

                p_start_date              => v_prev_date,

                p_is_exclude_x1_employees => 0

            );
    End;

    Function fn_date_list(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,

        p_start_date Date,
        p_end_date   Date

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

        Open c For
            Select
                *
            From
                (
                    Select
                        dd.d_day As d_days, dd.d_date d_date_list
                    From
                        ss_days_details dd
                    Where
                        d_date Between p_start_date And p_end_date
                        And dd.d_date Not In (
                            Select
                                holiday
                            From
                                ss_holidays
                            Where
                                ss_holidays.holiday Between p_start_date And p_end_date
                        )
                )
            Order By
                d_date_list;
        Return c;

    End;

    Function fn_week_number_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_yyyymm    Varchar2

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_temp_date          Date;
        v_mm                 Varchar2(2);
        v_yyyy               Varchar2(4);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_yyyymm Is Null Then
            raise_application_error(-20003, 'Invalid month provided.');

            Return Null;
        End If;
        --
        --Check p_yyyymm is valid
        Begin
            v_temp_date := To_Date(p_yyyymm, 'yyyymm');
            v_mm        := substr(p_yyyymm, 5, 2);
            v_yyyy      := substr(p_yyyymm, 1, 4);
        Exception
            When Others Then
                raise_application_error(-20002, 'Invalid yyyymm.');
                Return Null;
        End;
        --

        Open c For
            With
                params As (
                    Select
                        n_getstartdate(v_mm, v_yyyy) As start_date,
                        n_getenddate(v_mm, v_yyyy)   As end_date
                    From
                        dual
                )
            Select
                d_date,
                'Week_' || to_char(trunc((Rownum - 1) / 7) + 1) As week_name
            From
                ss_days_details dd, params
            Where
                d_date Between params.start_date And params.end_date
                And dd.d_date Not In (
                    Select
                        holiday
                    From
                        ss_holidays, params
                    Where
                        ss_holidays.holiday Between params.start_date And params.end_date
                );
        Return c;

    End;

    Function fn_swp_day_attendance_list(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_start_date              Date,
        p_end_date                Date,
        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_exclude_grade      Varchar2(2);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_is_exclude_x1_employees = 1 Then
            v_exclude_grade := 'X1';
        Else
            v_exclude_grade := '!!';
        End If;

        Open c For
            Select
                data.*,
                iot_swp_common.fn_get_pws_text(data.n_pws)                                    c_pws,
                iot_swp_common.fn_get_attendance_status(data.empno, data.d_date, data.n_pws)  attend_status,
                iot_swp_common.fn_is_attendance_required(data.empno, data.d_date, data.n_pws) attend_required
            From
                (
                    Select
                        *
                    From
                        (
                            With
                                work_days As (
                                    Select
                                        *
                                    From
                                        ss_days_details d
                                    Where
                                        d.d_date Between p_start_date And nvl(p_end_date, sysdate)
                                        And d.d_date Not In (
                                            Select
                                                holiday
                                            From
                                                ss_holidays
                                            Where
                                                holiday Between p_start_date And nvl(p_end_date, sysdate)
                                        )
                                )
                            Select
                                e.empno                                                    As empno,
                                e.name                                                     As employee_name,
                                e.email                                                    As email,
                                e.parent                                                   As parent,
                                e.assign                                                   As assign,
                                e.emptype                                                  As emp_type,
                                e.grade                                                    As grade,
                                e.doj                                                      As doj,
                                p_end_date                                                 As dol,
                                wd.d_date                                                  As d_date,
                                to_char(e.status)                                          As status,
                                to_char(iot_swp_common.fn_get_emp_pws(e.empno, wd.d_date)) n_pws
                            From
                                ss_emplmast e,
                                work_days   wd
                            Where
                                (
                                e.status = 1

                                )
                                And e.emptype In (
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
                                And e.grade <> v_exclude_grade
                        )
                    Where
                        d_date >= doj

                ) data;

        Return c;

    End;

    Function fn_attendance_for_month(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_yyyymm                  Varchar2,

        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        e_date_is_holiday    Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        Pragma exception_init(e_date_is_holiday, -20002);
        c                    Sys_Refcursor;
        v_exclude_grade      Varchar2(2);
        v_count              Number;
        v_temp_date          Date;
        v_mm                 Varchar2(2);
        v_yyyy               Varchar2(4);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_is_exclude_x1_employees = 1 Then
            v_exclude_grade := 'X1';
        Else
            v_exclude_grade := '!!';
        End If;

        If p_yyyymm Is Null Then
            raise_application_error(-20003, 'Invalid month provided.');

            Return Null;
        End If;
        --
        --Check p_yyyymm is valid
        Begin
            v_temp_date := To_Date(p_yyyymm, 'yyyymm');
            v_mm        := substr(p_yyyymm, 5, 2);
            v_yyyy      := substr(p_yyyymm, 1, 4);
        Exception
            When Others Then
                raise_application_error(-20002, 'Invalid yyyymm.');
                Return Null;
        End;
        --
        Open c For
            Select
                data.*,
                iot_swp_common.fn_get_pws_text(data.n_pws)                                    c_pws,
                iot_swp_common.fn_get_attendance_status(data.empno, data.d_date, data.n_pws)  attend_status,
                iot_swp_common.fn_is_attendance_required(data.empno, data.d_date, data.n_pws) attend_required
            From
                (
                    Select
                        *
                    From
                        (

                            With
                                params As (
                                    Select
                                        n_getstartdate(v_mm, v_yyyy) As start_date,
                                        n_getenddate(v_mm, v_yyyy)  As end_date
                                    From
                                        dual
                                ),
                                days_details As (
                                    Select
                                        d_date,
                                        'Week_' || to_char(trunc((Rownum - 1) / 7) + 1) As week_num
                                    From
                                        ss_days_details, params
                                    Where
                                        d_date Between params.start_date And params.end_date
                                ),
                                work_days As (
                                    Select
                                        *
                                    From
                                        days_details d, params
                                    Where
                                        d.d_date Between params.start_date And nvl(params.end_date, sysdate)
                                        And d.d_date Not In (
                                            Select
                                                holiday
                                            From
                                                ss_holidays, params
                                            Where
                                                holiday Between params.start_date And nvl(params.end_date, sysdate)
                                        )
                                )
                            Select
                                e.empno                                                    As empno,
                                e.name                                                     As employee_name,
                                e.email                                                    As email,
                                e.parent                                                   As parent,
                                e.assign                                                   As assign,
                                e.emptype                                                  As emp_type,
                                e.grade                                                    As grade,
                                e.doj                                                      As doj,
                                params.end_date                                            As dol,
                                wd.d_date                                                  As d_date,
                                to_char(e.status)                                          As status,
                                to_char(iot_swp_common.fn_get_emp_pws(e.empno, wd.d_date)) As n_pws,
                                wd.week_num                                                As week_num
                            From
                                ss_emplmast e,
                                work_days   wd,
                                params
                            Where
                                (
                                e.status = 1

                                )
                                And e.emptype In (
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
                                And e.grade <> v_exclude_grade
                        )
                    Where
                        d_date >= doj

                ) data;
        Return c;

    End;

End iot_swp_attendance_qry;
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
                        to_char(a.app_date, 'dd-Mon-yyyy')             As application_date,
                        a.app_no                                       As application_id,
                        a.pdate                                        As application_for_date,
                        a.start_date                                   As start_date,
                        description,
                        a.type                                         As onduty_type,
                        get_emp_name(a.lead_apprl_empno)               As lead_name,
                        a.lead_apprldesc                               As lead_approval,
                        hod_apprldesc                                  As hod_approval,
                        hrd_apprldesc                                  As hr_approval,
                        Case
                            When p_req_for_self = 'OK' Then
                                a.can_delete_app
                            Else
                                0
                        End                                            As can_delete_app,
                        Row_Number() Over (Order By a.start_date Desc) As row_number,
                        Count(*) Over ()                               As total_row
                    From
                        ss_vu_od_depu a
                    Where
                        a.empno    = p_empno
                        And a.pdate >= add_months(sysdate, -24)
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
            empno = p_empno;
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
