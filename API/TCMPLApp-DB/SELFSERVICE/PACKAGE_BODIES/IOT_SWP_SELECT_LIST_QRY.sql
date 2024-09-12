--------------------------------------------------------
--  DDL for Package Body IOT_SWP_SELECT_LIST_QRY
--------------------------------------------------------

Create Or Replace Package Body "SELFSERVICE"."IOT_SWP_SELECT_LIST_QRY" As

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
        v_is_emp_resigned  Varchar2(2);
    Begin

        If p_exclude_sws_type = 'OK' Then
            v_exclude_swp_type := 2;
        Else
            v_exclude_swp_type := -1;
        End If;
        v_is_emp_resigned := tcmpl_hr.pkg_common.fn_is_emp_resigned(p_empno);
        If v_is_emp_resigned = ok Then
            v_exclude_swp_type := 2;
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

Grant Execute On "SELFSERVICE"."IOT_SWP_SELECT_LIST_QRY" To "TCMPL_APP_CONFIG";