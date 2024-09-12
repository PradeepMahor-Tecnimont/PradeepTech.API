--------------------------------------------------------
--  File created - Sunday-April-17-2022   
--------------------------------------------------------
---------------------------
--Changed PACKAGE
--IOT_SWP_FLAGS
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_FLAGS" As
    Procedure get_all_flags(
        p_person_id                        Varchar2,
        p_meta_id                          Varchar2,

        p_restricted_desks_in_sws_plan Out Varchar2,
        p_open_desks_in_sws_plan       Out Varchar2,

        p_message_type                 Out Varchar2,
        p_message_text                 Out Varchar2
    );

     procedure get_flag_details(
        p_person_id             varchar2,
        p_meta_id               varchar2,

        p_flag_id               varchar2,
        p_flag_code         out varchar2,
        p_flag_desc         out varchar2,
        p_flag_value        out varchar2,
        p_flag_value_number out number,
        p_flag_value_date   out date,

        p_message_type      out varchar2,
        p_message_text      out varchar2

    );

End iot_swp_flags;
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
                    !PIVOT_FOR!
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

End iot_swp_smart_workspace_qry;
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

End iot_swp_select_list_qry;
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
                And noofemps > 0
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
                And noofemps > 0
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
                type_desc data_text_field
            From
                swp_primary_workspace_types
            Where
                type_code <> v_exclude_swp_type;
        Return c;
    End;
End iot_swp_select_list_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_FLAGS
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_FLAGS" As
    Procedure get_all_flags(
        p_person_id                        Varchar2,
        p_meta_id                          Varchar2,

        p_restricted_desks_in_sws_plan Out Varchar2,
        p_open_desks_in_sws_plan       Out Varchar2,

        p_message_type                 Out Varchar2,
        p_message_text                 Out Varchar2

    ) As
        Type typ_tab_swp_flags Is Table Of swp_flags%rowtype Index By Pls_Integer;
        tab_swp_flags typ_tab_swp_flags;
    Begin
        Select
            *
        Bulk Collect
        Into
            tab_swp_flags
        From
            swp_flags;
        For i In 1..tab_swp_flags.count
        Loop
            If tab_swp_flags(i).flag_code = 'SWP_RESTRICTED_OPEN_DESK_AREA_FOR_SMART_PLANNING' Then
                p_restricted_desks_in_sws_plan := trim(tab_swp_flags(i).flag_value);
            End If;
            If tab_swp_flags(i).flag_code = 'SWP_OPEN_DESK_AREA_FOR_SMART_PLANNING' Then
                p_open_desks_in_sws_plan := trim(tab_swp_flags(i).flag_value);
            End If;

        End Loop;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;

     procedure get_flag_details(
        p_person_id             varchar2,
        p_meta_id               varchar2,

        p_flag_id               varchar2,
        p_flag_code         out varchar2,
        p_flag_desc         out varchar2,
        p_flag_value        out varchar2,
        p_flag_value_number out number,
        p_flag_value_date   out date,

        p_message_type      out varchar2,
        p_message_text      out varchar2

    ) as
   v_count number;
   begin

      select flag_code, flag_desc, flag_value, flag_value_number, flag_value_date
        into p_flag_code, p_flag_desc, p_flag_value, p_flag_value_number, p_flag_value_date
        from swp_flags
       where flag_id = p_flag_id;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';
       exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   end get_flag_details;


End iot_swp_flags;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_CONFIG_WEEK
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_CONFIG_WEEK" As
    c_plan_close_code  Constant Number := 0;
    c_plan_open_code   Constant Number := 1;
    c_past_plan_code   Constant Number := 0;
    c_cur_plan_code    Constant Number := 1;
    c_future_plan_code Constant Number := 2;

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
            Else
                Return false;
            End If;
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

    Procedure sp_mail_plan_to_emp
    As
        Cursor cur_dept_seat_plan Is
            Select
                *
            From
                swp_include_assign_4_seat_plan;
        cur_dept_rows     Sys_Refcursor;
        cur_emp_week_plan Sys_Refcursor;
        row_config_week   swp_config_weeks%rowtype;
        v_mail_body       Varchar2(4000);
        v_day_row         Varchar2(300);
        v_emp_mail        Varchar2(100);
        v_msg_type        Varchar2(15);
        v_msg_text        Varchar2(1000);
        v_emp_desk        Varchar2(10);
        rec_sws_plan      typ_rec_sws;
        rec_pws_plan      typ_rec_pws;
    Begin
        Select
            *
        Into
            row_config_week
        From
            swp_config_weeks
        Where
            planning_flag = 2;
        For c1 In cur_dept_seat_plan
        Loop
            cur_dept_rows := iot_swp_primary_workspace_qry.fn_emp_primary_ws_list(
                                 p_person_id             => Null,
                                 p_meta_id               => Null,

                                 p_assign_code           => c1.assign,
                                 p_start_date            => row_config_week.start_date,

                                 p_empno                 => Null,

                                 p_emptype_csv           => Null,
                                 p_grade_csv             => Null,
                                 p_primary_workspace_csv => Null,
                                 p_laptop_user           => Null,
                                 p_eligible_for_swp      => Null,
                                 p_generic_search        => Null,

                                 p_is_admin_call         => true,

                                 p_row_number            => 0,
                                 p_page_length           => 10000
                             );

            Loop
                Fetch cur_dept_rows Into rec_pws_plan;
                Exit When cur_dept_rows%notfound;
                Begin
                    Select
                        email
                    Into
                        v_emp_mail
                    From
                        ss_emplmast
                    Where
                        empno      = rec_pws_plan.empno
                        And status = 1;
                    If v_emp_mail Is Null Then
                        Continue;
                    End If;
                Exception
                    When Others Then
                        Continue;
                End;
                --PRIMARY WORK SPACE
                If rec_pws_plan.primary_workspace = 1 Then
                    v_mail_body := v_ows_mail_body;
                    v_mail_body := replace(v_mail_body, '!@User@!', rec_pws_plan.employee_name);
                    v_mail_body := replace(v_mail_body, '!@StartDate@!', to_char(row_config_week.start_date, 'dd-Mon-yyyy'));
                    v_mail_body := replace(v_mail_body, '!@EndDate@!', to_char(row_config_week.start_date, 'dd-Mon-yyyy'));

                    /*
                    v_emp_desk := get_swp_planned_desk(
                            p_empno => emp_row.empno
                    );
                    */
                    --SMART WORK SPACE
                Elsif rec_pws_plan.primary_workspace = 2 Then

                    cur_emp_week_plan := iot_swp_smart_workspace_qry.fn_emp_week_attend_planning(
                                             p_person_id => Null,
                                             p_meta_id   => Null,
                                             p_empno     => rec_pws_plan.empno,
                                             p_date      => row_config_week.start_date
                                         );
                    Loop
                        Fetch cur_emp_week_plan Into rec_sws_plan;
                        Exit When cur_emp_week_plan%notfound;
                        v_day_row := nvl(v_day_row, '') || v_sws_empty_day_row;
                        v_day_row := replace(v_day_row, 'DESKID', rec_sws_plan.deskid);
                        v_day_row := replace(v_day_row, 'DATE', rec_sws_plan.d_date);
                        v_day_row := replace(v_day_row, 'DAY', rec_sws_plan.d_day);
                        v_day_row := replace(v_day_row, 'OFFICE', rec_sws_plan.office);
                        v_day_row := replace(v_day_row, 'FLOOR', rec_sws_plan.floor);
                        v_day_row := replace(v_day_row, 'WING', rec_sws_plan.wing);

                    End Loop;
                    Close cur_emp_week_plan;

                    If v_day_row = v_sws_empty_day_row Or v_day_row Is Null Then
                        Continue;
                    End If;
                    v_mail_body       := v_sws_mail_body;
                    v_mail_body       := replace(v_mail_body, '!@User@!', rec_pws_plan.employee_name);
                    v_mail_body       := replace(v_mail_body, '!@WEEKLYPLANNING@!', v_day_row);

                End If;
                tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
                    p_person_id    => Null,
                    p_meta_id      => Null,
                    p_mail_to      => v_emp_mail,
                    p_mail_cc      => Null,
                    p_mail_bcc     => 'd.bhavsar@tecnimont.in',
                    p_mail_subject => 'Smart work planning',
                    p_mail_body1   => v_mail_body,
                    p_mail_body2   => Null,
                    p_mail_type    => 'HTML',
                    p_mail_from    => 'selfservice.tecnimont.in',
                    p_message_type => v_msg_type,
                    p_message_text => v_msg_text
                );
                v_day_row   := Null;
                v_mail_body := Null;
                v_msg_type  := Null;
                v_msg_text  := Null;
            End Loop;
        End Loop;
    End;
    --
    Procedure sp_add_new_joinees_to_pws
    As
    Begin
        Insert Into swp_primary_workspace (key_id, empno, primary_workspace, start_date, modified_on, modified_by, active_code,
            assign_code)
        Select
            dbms_random.string('X', 10),
            empno,
            case when dd.assign = null then 1 else 2 end pws,
            greatest(doj, to_date('31-Jan-2022')),
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

        If rec_config_week.start_date != v_sysdate Then
            Return;
        End If;
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
        v_next_week_mon    Date;
        v_next_week_fri    Date;
        v_next_week_key_id Varchar2(8);

        rec_config_week    swp_config_weeks%rowtype;
    Begin
        --Close and toggle existing planning
        toggle_plan_future_to_curr(p_sysdate);

        v_next_week_mon    := iot_swp_common.get_monday_date(p_sysdate + 6);
        v_next_week_fri    := iot_swp_common.get_friday_date(p_sysdate + 6);
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
    Begin
        sp_add_new_joinees_to_pws;
        v_sysdate            := trunc(sysdate);
        v_fri_date           := iot_swp_common.get_friday_date(trunc(v_sysdate));
        --
        init_configuration(v_sysdate);

        v_is_second_last_day := fn_is_second_last_day_of_week(v_sysdate);

        If v_is_second_last_day Then --SECOND_LAST working day (THURSDAY)
            rollover_n_open_planning(v_sysdate);
            --v_sysdate EQUAL LAST working day "FRIDAY"
            --        ElsIf V_SYSDATE = tab_work_day(1).work_date Then --LAST working day
        Elsif v_sysdate = v_fri_date Then
            close_planning;
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

End iot_swp_smart_workspace_qry;
/
