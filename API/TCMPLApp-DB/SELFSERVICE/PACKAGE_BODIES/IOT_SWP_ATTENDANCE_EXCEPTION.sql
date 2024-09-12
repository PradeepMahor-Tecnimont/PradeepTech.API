Create Or Replace Package Body selfservice.iot_swp_attendance_exception As
    c_ows_code Constant Number := 1;
    c_sws_code Constant Number := 2;
    Function fn_admin_ows(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date,

        p_row_number  Number,
        p_page_length Number

    ) Return Sys_Refcursor As
        c          Sys_Refcursor;
        v_is_admin Number;
    Begin
        --v_is_admin := nvl(p_is_admin, 0);

        Open c For
            Select
                *
            From
                (
                    Select
                        empno,
                        name                               employee_name,
                        parent,
                        assign,
                        grade,
                        emptype,
                        email,
                        primary_workspace_text,
                        desk_id,
                        Case
                            When is_swp_absent = 0 Then
                                'Yes'
                            Else
                                'No'
                        End                                is_absent,
                        Row_Number() Over (Order By empno) As row_number,
                        Count(*) Over ()                   As total_row
                    From
                        (
                            Select
                                a.empno,
                                e.name,
                                e.parent,
                                e.assign,
                                e.grade,
                                e.emptype,
                                e.email,
                                wt.type_desc                                               primary_workspace_text,
                                iot_swp_common.get_desk_from_dms(a.empno)                  desk_id,
                                iot_swp_common.fn_is_present_4_swp(a.empno, trunc(p_date)) is_swp_absent
                            From
                                swp_primary_workspace       a,
                                ss_emplmast                 e,
                                swp_primary_workspace_types wt,
                                swp_include_emptype         et
                            Where
                                trunc(a.start_date)     = (
                                        Select
                                            Max(trunc(start_date))
                                        From
                                            swp_primary_workspace b
                                        Where
                                            b.empno = a.empno
                                            And b.start_date <= sysdate
                                    )
                                And a.empno             = e.empno
                                And e.emptype           = et.emptype
                                And status              = 1
                                And a.primary_workspace = wt.type_code
                                And a.primary_workspace = c_ows_code
                                and e.empno not in ('04132', '04600')
                        )
                    Where
                        is_swp_absent = 0
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End;

    Function fn_admin_sws(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date,

        p_row_number  Number,
        p_page_length Number

    ) Return Sys_Refcursor As
        c          Sys_Refcursor;
        v_is_admin Number;
    Begin
        --v_is_admin := nvl(p_is_admin, 0);

        Open c For
            Select
                *
            From
                (
                    Select
                        empno,
                        name                               employee_name,
                        parent,
                        assign,
                        grade,
                        emptype,
                        primary_workspace_text,
                        desk_id,
                        Case
                            When is_swp_present = 1 Then
                                'Yes'
                            Else
                                'No'
                        End                                is_present,
                        Row_Number() Over (Order By empno) As row_number,
                        Count(*) Over ()                   As total_row
                    From
                        (
                            Select
                                a.empno,
                                e.name,
                                e.parent,
                                e.assign,
                                e.grade,
                                e.emptype,
                                wt.type_desc                                               primary_workspace_text,
                                iot_swp_common.get_desk_from_dms(a.empno)                  desk_id,
                                iot_swp_common.fn_is_present_4_swp(a.empno, trunc(p_date)) is_swp_present,
                                isldt(p_date,a.empno)                                      is_leave_depu_tour
                            From
                                swp_primary_workspace       a,
                                ss_emplmast                 e,
                                swp_primary_workspace_types wt,
                                swp_include_emptype         et
                            Where
                                trunc(a.start_date)     = (
                                        Select
                                            Max(trunc(start_date))
                                        From
                                            swp_primary_workspace b
                                        Where
                                            b.empno = a.empno
                                            And b.start_date <= sysdate
                                    )
                                And a.empno             = e.empno
                                And e.emptype           = et.emptype
                                And status              = 1
                                And a.primary_workspace = wt.type_code
                                And a.primary_workspace = c_sws_code
                                and e.empno not in ('04132', '04600')
                        )
                    Where
                        is_swp_present = 1
                        and is_leave_depu_tour = 0
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End;

    Function fn_ows(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date,

        p_row_number  Number,
        p_page_length Number

    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_is_admin           Number;
        v_hod_sec_empno      Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_hod_sec_empno := get_empno_from_meta_id(p_meta_id);

        If v_hod_sec_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        empno,
                        name                               employee_name,
                        parent,
                        assign,
                        grade,
                        emptype,
                        primary_workspace_text,
                        desk_id,
                        Case
                            When is_swp_absent = 0 Then
                                'Yes'
                            Else
                                'No'
                        End                                is_absent,
                        Row_Number() Over (Order By empno) As row_number,
                        Count(*) Over ()                   As total_row
                    From
                        (
                            Select
                                a.empno,
                                e.name,
                                e.parent,
                                e.assign,
                                e.grade,
                                e.emptype,
                                wt.type_desc                                               primary_workspace_text,
                                iot_swp_common.get_desk_from_dms(a.empno)                  desk_id,
                                iot_swp_common.fn_is_present_4_swp(a.empno, trunc(p_date)) is_swp_absent
                            From
                                swp_primary_workspace       a,
                                ss_emplmast                 e,
                                swp_primary_workspace_types wt,
                                swp_include_emptype         et
                            Where
                                trunc(a.start_date)     = (
                                        Select
                                            Max(trunc(start_date))
                                        From
                                            swp_primary_workspace b
                                        Where
                                            b.empno = a.empno
                                            And b.start_date <= sysdate
                                    )
                                And a.empno             = e.empno
                                And e.emptype           = et.emptype
                                And status              = 1
                                And a.primary_workspace = wt.type_code
                                And a.primary_workspace = c_ows_code
                                And e.assign In
                                (
                                    Select
                                        parent
                                    From
                                        ss_user_dept_rights a
                                    Where
                                        empno = v_hod_sec_empno
                                    Union
                                    Select
                                        costcode
                                    From
                                        ss_costmast a
                                    Where
                                        hod = v_hod_sec_empno
                                )
                                And e.assign Not In (
                                    Select
                                        assign
                                    From
                                        swp_exclude_assign
                                )
                        )
                    Where
                        is_swp_absent = 0
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End;

    Function fn_sws(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date,

        p_row_number  Number,
        p_page_length Number

    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_is_admin           Number;
        v_hod_sec_empno      Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_hod_sec_empno := get_empno_from_meta_id(p_meta_id);

        If v_hod_sec_empno = 'ERRRR'  Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                *
            From
                (
                    Select
                        empno,
                        name                               employee_name,
                        parent,
                        assign,
                        grade,
                        emptype,
                        primary_workspace_text,
                        desk_id,
                        Case
                            When is_swp_present = 1 Then
                                'Yes'
                            Else
                                'No'
                        End                                is_present,
                        Row_Number() Over (Order By empno) As row_number,
                        Count(*) Over ()                   As total_row
                    From
                        (
                            Select
                                a.empno,
                                e.name,
                                e.parent,
                                e.assign,
                                e.grade,
                                e.emptype,
                                wt.type_desc                                               primary_workspace_text,
                                iot_swp_common.get_desk_from_dms(a.empno)                  desk_id,
                                iot_swp_common.fn_is_present_4_swp(a.empno, trunc(p_date)) is_swp_present,
                                isldt(p_date,a.empno)                                      is_leave_depu_tour
                            From
                                swp_primary_workspace       a,
                                ss_emplmast                 e,
                                swp_primary_workspace_types wt,
                                swp_include_emptype         et
                            Where
                                trunc(a.start_date)     = (
                                        Select
                                            Max(trunc(start_date))
                                        From
                                            swp_primary_workspace b
                                        Where
                                            b.empno = a.empno
                                            And b.start_date <= sysdate
                                    )
                                And a.empno             = e.empno
                                And e.emptype           = et.emptype
                                And status              = 1
                                And a.primary_workspace = wt.type_code
                                And a.primary_workspace = c_sws_code
                                And e.assign In
                                (
                                    Select
                                        parent
                                    From
                                        ss_user_dept_rights a
                                    Where
                                        empno = v_hod_sec_empno
                                    Union
                                    Select
                                        costcode
                                    From
                                        ss_costmast a
                                    Where
                                        hod = v_hod_sec_empno
                                )
                                And e.assign Not In (
                                    Select
                                        assign
                                    From
                                        swp_exclude_assign
                                )
                        )
                    Where
                        is_swp_present = 1
                        and is_leave_depu_tour = 0
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End;

End;