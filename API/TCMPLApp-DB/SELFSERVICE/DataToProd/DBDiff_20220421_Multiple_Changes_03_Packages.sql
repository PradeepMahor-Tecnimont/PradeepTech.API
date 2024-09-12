--------------------------------------------------------
--  File created - Thursday-April-21-2022   
--------------------------------------------------------
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
    ) Return Varchar2 ;

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

    Function fn_get_emp_pws(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_is_planning Boolean
    ) Return Number;

    Function fn_get_emp_pws_planning(
        p_empno Varchar2 Default Null
    ) Return Varchar2;

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

    Function is_desk_in_general_area(p_deskid Varchar2) Return Boolean;

    Function fn_can_do_desk_plan_4_emp(p_empno Varchar2) Return Boolean;

    Function fn_is_present_4_swp(
        p_empno Varchar2,
        p_date  Date
    ) Return Number;

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
    Function get_emp_is_eligible_4swp(
        p_empno Varchar2 Default Null
    ) Return Varchar2;

    Function is_emp_dualmonitor_user(
        p_empno Varchar2 Default Null
    ) Return Number;

    Function get_emp_projno_desc(
        p_empno Varchar2
    ) Return Varchar2;

End iot_swp_common;
/
---------------------------
--Changed PACKAGE
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

        p_is_admin_call         Boolean  Default false,

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

    Function fn_emp_pws_admin_list(
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


    query_pws Varchar2(4500) := '
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
            iot_swp_common.fn_get_dept_group(a.assign)             As assign_dept_group,
            a.office,
            a.emptype,
            a.email                                               As email,

            iot_swp_common.get_desk_from_dms(a.empno)             As deskid,
            iot_swp_common.get_emp_work_area(Null, Null, a.empno) As work_area,
            iot_swp_common.is_emp_dualmonitor_user(a.empno)       As is_dual_monitor_user,
            iot_swp_common.is_emp_laptop_user(a.empno)            As is_laptop_user,
            Case iot_swp_common.is_emp_laptop_user(a.empno)
                When 1 Then
                    ''Yes''
                Else
                    ''No''
            End                                                   As is_laptop_user_text,
            a.grade                                               As emp_grade,
            nvl(b.primary_workspace, 0)                           As primary_workspace,
            iot_swp_common.fn_get_pws_text(b.primary_workspace) as primary_workspace_text,
            iot_swp_common.is_emp_eligible_for_swp(a.empno)       As is_swp_eligible,
            Case iot_swp_common.is_emp_eligible_for_swp(a.empno)
                When ''OK'' Then
                    ''Yes''
                Else
                    ''No''
            End                                                   As is_swp_eligible_desc,
            Row_Number() Over(Order By a.name)                    As row_number,
            Count(*) Over()                                       As total_row
        From
            ss_emplmast        a,
            primary_work_space b,
            swp_include_emptype c,
            params
        Where
            a.empno      = b.empno(+)
            !ASSIGN_WHERE_CLAUSE!
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
        Order By a.assign, a.name
    ) data, params
Where
    row_number Between (nvl(params.p_row_number, 0) + 1) And (nvl(params.p_row_number, 0) + params.p_page_length)
 ';

    sub_qry_assign_where_clause Varchar2(70) := ' And a.assign = params.p_assign_code ';

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
    sub_qry_pws_csv Varchar2(500) := ' 
and
nvl(b.primary_workspace,0) in ( Select
    regexp_substr(params.p_pws_csv, ''[^,]+'', 1, level) emptype
From
    dual, params
Connect By
    level <=
    length(params.p_pws_csv) - length(replace(params.p_pws_csv, '','')) + 1)';

    where_clause_laptop_user Varchar2(200) := ' and iot_swp_common.is_emp_laptop_user(a.empno) = params.p_laptop_user ';

    where_clause_swp_eligible Varchar2(200) := ' and iot_swp_common.is_emp_eligible_for_swp(a.empno) = params.p_swp_eligibility ';

    where_clause_generic_search Varchar2(200) := ' and (a.name like params.p_generic_search or a.empno like params.p_generic_search ) ';

End iot_swp_primary_workspace_qry;
/
---------------------------
--Changed PACKAGE
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
            :p_assign_csv     As p_assign_csv,
            :p_emptype_csv    As p_emptype_csv,
            :p_grades_csv     As p_grades_csv,
            :p_generic_search As p_generic_search,
            :p_desk_assignment_status as p_desk_assignment_status
        From
            dual
    ),
    attend_plan As (
        Select
            empno, attendance_date,deskid
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
                    status = 1
                    !CE_ASSIGN!
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
                        iot_swp_common.fn_get_dept_group(a.assign)             As assign_dept_group,
                        case when a.empno is null then 0 else 1 end planned,
                        a.deskid as deskid,
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
                        !E_ASSIGN!
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
                    !PIVOT_FOR!
                    For d_days In (!MON! As mon, !TUE! As tue, !WED! As wed, !THU! As thu,
                    !FRI! As fri)
                    )

            ) data
    ) full_data, params
Where
    row_number Between (nvl(params.p_row_number, 0) + 1) And (nvl(params.p_row_number, 0) + params.p_page_length)';

    where_clause_generic_search Varchar2(200) := ' and (e.name like params.p_generic_search or e.empno like params.p_generic_search ) ';
    where_clause_e_assign_code Varchar2(100) := ' And e.assign = params.p_assign_code ';
    where_clause_ce_assign_code Varchar2(100) := ' And ce.assign = params.p_assign_code ';

    sub_qry_ce_assign_csv Varchar2(400) := ' And ce.assign in (
                    Select
                        regexp_substr(params.p_assign_csv, ''[^,]+'', 1, level) assign
                    From
                        dual
                    Connect By
                        level <=
                        length(params.p_assign_csv) - length(replace(params.p_assign_csv, '','')) + 1
                )';

    sub_qry_e_assign_csv Varchar2(400) := ' And e.assign in (
                    Select
                        regexp_substr(params.p_assign_csv, ''[^,]+'', 1, level) assign
                    From
                        dual
                    Connect By
                        level <=
                        length(params.p_assign_csv) - length(replace(params.p_assign_csv, '','')) + 1
                )';

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

    sub_desk_pivot Varchar2(100) := ' max(deskid)  ';
    sub_days_pivot Varchar2(100) := ' Count(d_days) ';

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
    Function fn_general_area_restrictedlist(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2 Default Null,
        p_date        Date     Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

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
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_date                   Date     Default sysdate,

        p_assign_code            Varchar2 Default Null,

        p_emptype_csv            Varchar2 Default Null,
        p_grade_csv              Varchar2 Default Null,
        p_generic_search         Varchar2 Default Null,
        p_desk_assignment_status Varchar2 Default Null,
        p_desk_pivot             Number   Default 0,

        p_row_number             Number,
        p_page_length            Number
    ) Return Sys_Refcursor;

    Function fn_current_planning_xl(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_assign_code Varchar2 Default Null
    ) Return Sys_Refcursor;

    Function fn_future_planning_xl(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_assign_code Varchar2 Default Null
    ) Return Sys_Refcursor;

    Function fn_week_attend_planning_all(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_date                   Date     Default sysdate,

        p_assign_csv             Varchar2 Default Null,

        p_emptype_csv            Varchar2 Default Null,
        p_grade_csv              Varchar2 Default Null,
        p_generic_search         Varchar2 Default Null,
        p_desk_assignment_status Varchar2 Default Null,
        p_desk_pivot             Number   Default 0,

        p_row_number             Number,
        p_page_length            Number
    ) Return Sys_Refcursor;

    Function fn_all_current_planning_xl(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date

    ) Return Sys_Refcursor;

End iot_swp_smart_workspace_qry;
/
---------------------------
--Changed PACKAGE BODY
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
                        dm_vu_emp_desk_map_swp_plan
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
                                desk_list                   d,
                                dm_vu_emp_desk_map_swp_plan ed
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

    Function fn_general_area_restrictedlist(
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
                        And da.area_catg_code = c_restricted_area_catg
                        And da.area_key_id    = v_emp_area_code

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
                                desk_list                   d,
                                dm_vu_emp_desk_map_swp_plan ed
                            Where
                                d.deskid = ed.deskid(+)
                            Group By office, wing, floor, work_area, area_desc, area_catg_code
                            Order By area_desc, office, wing, floor
                        ) a
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_general_area_restrictedlist;

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
                                dm_vu_emp_desk_map_swp_plan c
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
                        1                       As planned,
                        dm.office               As office,
                        dm.floor                As floor,
                        dm.wing                 As wing,
                        dm.bay                  As bay
                    From
                        swp_smart_attendance_plan w,
                        dms.dm_deskmaster         dm
                    Where
                        w.empno      = p_empno
                        And w.deskid = dm.deskid(+)
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
                nvl(hh.is_holiday, 0)     As is_holiday,
                atnd_days.office          As office,
                atnd_days.floor           As floor,
                atnd_days.wing            As wing,
                atnd_days.bay             As bay
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
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_date                   Date     Default sysdate,

        p_assign_code            Varchar2 Default Null,

        p_emptype_csv            Varchar2 Default Null,
        p_grade_csv              Varchar2 Default Null,
        p_generic_search         Varchar2 Default Null,
        p_desk_assignment_status Varchar2 Default Null,
        p_desk_pivot             Number   Default 0,

        p_row_number             Number,
        p_page_length            Number
    ) Return Sys_Refcursor As
        c                     Sys_Refcursor;
        v_hod_sec_empno       Varchar2(5);
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_query               Varchar2(7000);
        v_start_date          Date := iot_swp_common.get_monday_date(p_date) - 1;
        v_end_date            Date := iot_swp_common.get_friday_date(p_date);
        v_hod_sec_assign_code Varchar2(4);
        Cursor cur_days Is
            Select
                to_char(d_date, 'yyyymmdd') yymmdd, to_char(d_date, 'DY') dday
            From
                ss_days_details
            Where
                d_date Between v_start_date And v_end_date;
        v_assign_csv          Varchar2(100);
    Begin
        --v_start_date := get_monday_date(p_date);
        --v_end_date   := get_friday_date(p_date);

        v_query               := c_qry_attendance_planning;
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

        v_hod_sec_assign_code := iot_swp_common.get_default_dept4plan_hod_sec(
                                     p_hod_sec_empno => v_hod_sec_empno,
                                     p_assign_code   => p_assign_code
                                 );

        v_query               := replace(v_query, '!E_ASSIGN!', where_clause_e_assign_code);
        v_query               := replace(v_query, '!CE_ASSIGN!', where_clause_ce_assign_code);

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

        If nvl(p_desk_pivot, 0) = 1 Then
            v_query := replace(v_query, '!PIVOT_FOR!', sub_desk_pivot);
        Else
            v_query := replace(v_query, '!PIVOT_FOR!', sub_days_pivot);
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
            v_assign_csv,
            p_emptype_csv,
            p_grade_csv,
            '%' || upper(trim(p_generic_search)) || '%',
            p_desk_assignment_status;

        Return c;

    End;

    Function fn_current_planning_xl(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_assign_code Varchar2 Default Null
    ) Return Sys_Refcursor As
        c Sys_Refcursor;

    Begin
        c := fn_week_attend_planning(
                 p_person_id              => p_person_id,
                 p_meta_id                => p_meta_id,
                 p_date                   => sysdate,

                 p_assign_code            => p_assign_code,

                 p_emptype_csv            => Null,
                 p_grade_csv              => Null,
                 p_generic_search         => Null,
                 p_desk_assignment_status => Null,
                 p_desk_pivot             => 1,

                 p_row_number             => 0,
                 p_page_length            => 100000
             );
        Return c;
    End;

    Function fn_future_planning_xl(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_assign_code Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                Sys_Refcursor;
        rec_config_weeks swp_config_weeks%rowtype;
    Begin
        Begin
            Select
                *
            Into
                rec_config_weeks
            From
                swp_config_weeks
            Where
                planning_flag = 2;
        Exception
            When Others Then
                Return Null;
        End;
        c := fn_week_attend_planning(
                 p_person_id              => p_person_id,
                 p_meta_id                => p_meta_id,
                 p_date                   => rec_config_weeks.start_date,

                 p_assign_code            => p_assign_code,

                 p_emptype_csv            => Null,
                 p_grade_csv              => Null,
                 p_generic_search         => Null,
                 p_desk_assignment_status => Null,
                 p_desk_pivot             => 1,

                 p_row_number             => 0,
                 p_page_length            => 100000
             );
        Return c;
    End;

    Function fn_week_attend_planning_all(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_date                   Date     Default sysdate,

        p_assign_csv             Varchar2 Default Null,

        p_emptype_csv            Varchar2 Default Null,
        p_grade_csv              Varchar2 Default Null,
        p_generic_search         Varchar2 Default Null,
        p_desk_assignment_status Varchar2 Default Null,
        p_desk_pivot             Number   Default 0,

        p_row_number             Number,
        p_page_length            Number
    ) Return Sys_Refcursor As
        c                     Sys_Refcursor;
        v_hod_sec_empno       Varchar2(5);
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_query               Varchar2(7000);
        v_start_date          Date := iot_swp_common.get_monday_date(p_date) - 1;
        v_end_date            Date := iot_swp_common.get_friday_date(p_date);
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

        /*
        v_hod_sec_empno       := get_empno_from_meta_id(p_meta_id);
        If v_hod_sec_empno = 'ERRRR' Then
            Raise e_employee_not_found;
        End If;

        v_hod_sec_assign_code := iot_swp_common.get_default_dept4plan_hod_sec(
                                     p_hod_sec_empno => v_hod_sec_empno,
                                     p_assign_code   => p_assign_code
                                 );
        */
        If p_assign_csv Is Not Null Then
            v_query := replace(v_query, '!E_ASSIGN!', sub_qry_e_assign_csv);
            v_query := replace(v_query, '!CE_ASSIGN!', sub_qry_ce_assign_csv);
        Else
            v_query := replace(v_query, '!E_ASSIGN!', '');
            v_query := replace(v_query, '!CE_ASSIGN!', '');
        End If;

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

        If nvl(p_desk_pivot, 0) = 1 Then
            v_query := replace(v_query, '!PIVOT_FOR!', sub_desk_pivot);
        Else
            v_query := replace(v_query, '!PIVOT_FOR!', sub_days_pivot);
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
            p_assign_csv,
            p_emptype_csv,
            p_grade_csv,
            '%' || upper(trim(p_generic_search)) || '%',
            p_desk_assignment_status;

        Return c;

    End;

    Function fn_all_current_planning_xl(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date

    ) Return Sys_Refcursor As
        c Sys_Refcursor;

    Begin
        c := fn_week_attend_planning_all(
                 p_person_id              => p_person_id,
                 p_meta_id                => p_meta_id,
                 p_date                   => p_date,

                 p_emptype_csv            => Null,
                 p_grade_csv              => Null,
                 p_generic_search         => Null,
                 p_desk_assignment_status => Null,
                 p_desk_pivot             => 1,

                 p_row_number             => 0,
                 p_page_length            => 100000
             );
        Return c;
    End;

End iot_swp_smart_workspace_qry;
/
---------------------------
--Changed PACKAGE BODY
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

        p_is_admin_call         Boolean  Default false,

        p_row_number            Number,
        p_page_length           Number
    ) Return Sys_Refcursor As
        c                     Sys_Refcursor;

        v_hod_sec_empno       Varchar2(5);
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_friday_date         Date;
        v_hod_sec_assign_code Varchar2(4);
        v_query               Varchar2(6500);
    Begin
        v_friday_date   := iot_swp_common.get_friday_date(nvl(p_start_date, sysdate));

        v_hod_sec_empno := get_empno_from_meta_id(p_meta_id);

        If v_hod_sec_empno = 'ERRRR' And p_is_admin_call = false Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        --If EMPNO is not null then set assign code filter as null else validate assign code
        If p_is_admin_call Then
            v_hod_sec_assign_code := p_assign_code;
        Else
            If p_empno Is Null Or p_assign_code Is Not Null Then
                v_hod_sec_assign_code := iot_swp_common.get_default_costcode_hod_sec(
                                             p_hod_sec_empno => v_hod_sec_empno,
                                             p_assign_code   => p_assign_code
                                         );
                If v_hod_sec_assign_code Is Null Then
                    Return Null;
                End If;
            End If;
        End If;

        v_query         := query_pws;

        If v_hod_sec_assign_code Is Not Null Then
            v_query := replace(v_query, '!ASSIGN_WHERE_CLAUSE!', sub_qry_assign_where_clause);
        Else
            v_query := replace(v_query, '!ASSIGN_WHERE_CLAUSE!', '');
        End If;

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
            '%' || upper(trim(p_generic_search)) || '%';

        Return c;

    End;

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

            p_is_admin_call         => false,

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
                        iot_swp_common.fn_get_dept_group(a.assign)             As assign_dept_group,
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
                        Case iot_swp_common.is_emp_dualmonitor_user(a.empno)
                            When 1 Then
                                'Yes'
                            Else
                                'No'
                        End                                                               As is_dual_monitor_user_text,

                        a.grade                                                           As emp_grade,
                        nvl(b.primary_workspace_desc, '')                                 As primary_workspace,
                        Case iot_swp_common.is_emp_eligible_for_swp(a.empno)
                            When 'OK' Then
                                'Yes'
                            Else
                                'No'
                        End                                                               As is_swp_eligible_desc

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

    Function fn_emp_pws_admin_list(
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
        rec_config_week swp_config_weeks%rowtype;
        v_friday_date   Date;
        v_count         Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            swp_config_weeks
        Where
            planning_flag = 2;
        If v_count > 0 Then
            Select
                *
            Into
                rec_config_week
            From
                swp_config_weeks
            Where
                planning_flag = 2;
            v_friday_date := rec_config_week.end_date;
        Else
            v_friday_date := iot_swp_common.get_friday_date(nvl(p_start_date, sysdate));

        End If;

        Return fn_emp_primary_ws_list(
            p_person_id             => p_person_id,
            p_meta_id               => p_meta_id,

            p_assign_code           => p_assign_code,
            p_start_date            => v_friday_date,

            p_empno                 => p_empno,

            p_emptype_csv           => p_emptype_csv,
            p_grade_csv             => p_grade_csv,
            p_primary_workspace_csv => p_primary_workspace_csv,
            p_laptop_user           => p_laptop_user,
            p_eligible_for_swp      => p_eligible_for_swp,
            p_generic_search        => p_generic_search,

            p_is_admin_call         => true,

            p_row_number            => p_row_number,
            p_page_length           => p_page_length
        );

    End;


End iot_swp_primary_workspace_qry;
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
        v_retval Varchar(50) := 'NA';
    Begin

        Select
        Distinct dmst.deskid As desk
        Into
            v_retval
        From
            dm_vu_emp_desk_map dmst
        Where
            dmst.empno = Trim(p_empno)
            And dmst.deskid Not Like 'H%';

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

    Function fn_get_emp_pws(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_is_planning Boolean
    ) Return Number As
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
        If p_is_planning Then
            If v_planning_exists != 'OK' Then
                Return -1;
            End If;
            v_friday_date := v_plan_end_date;
        Else
            v_friday_date := v_curr_end_date;
        End If;
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
                        And b.start_date <= v_friday_date
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
        v_emp_pws Number;
    Begin
        If p_empno Is Null Then
            Return Null;
        End If;
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
            );
        Return fn_get_pws_text(nvl(v_emp_pws, -1));
    Exception
        When Others Then
            Return Null;
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

    Function fn_is_present_4_swp(
        p_empno Varchar2,
        p_date  Date) Return Number
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

        --OnTour Deputation
        Select
            Count(*)
        Into
            v_count
        From
            ss_depu
        Where
            empno             = Trim(p_empno)
            And bdate <= p_date
            And nvl(edate, bdate) >= p_date
            And (hod_apprl    = 1
                And hrd_apprl = 1)
            And type <> 'RW';
        If v_count > 0 Then
            Return 1;
        End If;
        Return 0;
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
                                   p_person_id   => p_person_id,
                                   p_meta_id     => p_meta_id,
                                   p_empno       => p_empno,
                                   p_is_planning => false
                               );
        p_planning_pws      := fn_get_emp_pws(
                                   p_person_id   => p_person_id,
                                   p_meta_id     => p_meta_id,
                                   p_empno       => p_empno,
                                   p_is_planning => true
                               );
        p_current_pws_text  := fn_get_pws_text(p_current_pws);
        p_planning_pws_text := fn_get_pws_text(p_planning_pws);
        If p_current_pws = 1 Then --Office
            Begin
                Select
                    u.deskid,
                    dm.office,
                    dm.floor,
                    dm.wing,
                    dm.bay
                Into
                    p_curr_desk_id,
                    p_curr_office,
                    p_curr_floor,
                    p_curr_wing,
                    p_curr_bay
                From
                    dms.dm_usermaster u,
                    dms.dm_deskmaster dm
                Where
                    u.empno      = p_empno
                    And u.deskid = dm.deskid;
            Exception
                When Others Then
                    Null;
            End;
            /*
        Elsif p_current_pws = 2 Then --SMART
            p_curr_sws := iot_swp_smart_workspace_qry.fn_emp_week_attend_planning(
                              p_person_id => p_person_id,
                              p_meta_id   => p_meta_id,
                              p_empno     => p_empno,
                              p_date      => v_curr_start_date
                          );
*/
        End If;

        If p_planning_pws = 1 Then --Office
            Begin
                Select
                    u.deskid,
                    dm.office,
                    dm.floor,
                    dm.wing,
                    dm.bay
                Into
                    p_plan_desk_id,
                    p_plan_office,
                    p_plan_floor,
                    p_plan_wing,
                    p_plan_bay
                From
                    dms.dm_usermaster_swp_plan u,
                    dms.dm_deskmaster          dm
                Where
                    u.empno      = p_empno
                    And u.deskid = dm.deskid;
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
End iot_swp_common;
/
