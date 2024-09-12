--------------------------------------------------------
--  DDL for Package Body IOT_SELECT_LIST_QRY
--------------------------------------------------------

Create Or Replace Package Body selfservice.iot_select_list_qry As

    Function fn_leave_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c             Sys_Refcursor;
        v_empno       Varchar2(5);
        c_error       Constant Varchar2(5) := 'ERRRR';
        v_count       Number;
        v_emptype     Varchar2(1);
        v_expatriate  Number;
        b_is_sub_cont Boolean              := False;
    Begin

        v_empno := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = c_error Then
            Return Null;
        End If;
        Select
            emptype, expatriate
        Into
            v_emptype, v_expatriate
        From
            ss_emplmast
        Where
            empno = v_empno;

        If v_emptype In ('S', 'C') Then
            Open c For
                Select
                    leavetype   data_value_field,
                    description data_text_field
                From
                    ss_leavetype
                Where
                    leavetype In ('LV');
            --                    
        Elsif v_expatriate = 1 Then
            Open c For
                Select
                    leavetype   data_value_field,
                    description data_text_field
                From
                    ss_leavetype
                Where
                    leavetype In ('LV', 'SL');
                
            --
        Else
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
        End If;
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
        c            Sys_Refcursor;
        v_emp_assign Varchar2(4);
    Begin
        Begin
            Select
                    Max(e.assign) Keep(Dense_Rank Last Order By
                    doj)
            Into
                v_emp_assign
            From
                ss_emplmast e
            Where
                e.metaid   = p_meta_id
                And status = 1
            Group By
                metaid;
        Exception
            When Others Then
                v_emp_assign := Null;
        End;

        Open c For
            Select
                data_value_field,
                data_text_field
            From
                (
                    Select
                        'None'          data_value_field,
                        'Head Of Dept.' data_text_field,
                        1               sort_order
                    From
                        dual
                    Union
                    Select
                    Distinct
                        a.empno data_value_field,
                        b.name  data_text_field,
                        2       sort_order
                    From
                        (
                            Select
                                empno
                            From
                                ss_lead_approver
                            Where
                                parent = v_emp_assign
                            Union
                            Select
                                empno
                            From
                                ss_lead_approver
                            Where
                                parent In(
                                    Select
                                        group_lead_costcode
                                    From
                                        ss_dept_grouping
                                    Where
                                        parent = v_emp_assign
                                )
                        )           a,
                        ss_emplmast b
                    Where
                        a.empno      = b.empno
                        And b.status = 1
                )
            Order By
                sort_order,
                data_value_field;

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

    Function fn_paging_employee_list_4_hr(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_empno          Varchar2 default null,
        p_generic_search Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hr_empno           Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_generic_search     Varchar2(100);
    Begin
        v_hr_empno := get_empno_from_meta_id(p_meta_id);
        If v_hr_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        /*
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
        */

        If p_generic_search Is Not Null Then
            v_generic_search := '%' || upper(trim(p_generic_search)) || '%';
        Else
            v_generic_search := '%';
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        empno                             As data_value_field,
                        empno || ' - ' || name            As data_text_field,
                        Row_Number() Over(Order By empno) As row_number,
                        Count(*) Over()                   As total_row
                    From
                        ss_emplmast
                    Where
                        (status   = 1 Or nvl(dol, sysdate) > sysdate - 730)
                        And (empno Like v_generic_search Or name Like v_generic_search)
                        And empno = nvl(p_empno, empno)
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

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

    Function fn_paging_emplist_4_mngrhod(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_empno          Varchar2 default null,
        p_generic_search Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_mngr_empno         Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_generic_search     Varchar2(100);
    Begin
        v_mngr_empno := get_empno_from_meta_id(p_meta_id);
        If v_mngr_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_generic_search Is Not Null Then
            v_generic_search := '%' || upper(trim(p_generic_search)) || '%';
        Else
            v_generic_search := '%';
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        empno                             As data_value_field,
                        empno || ' - ' || name            As data_text_field,
                        Row_Number() Over(Order By empno) As row_number,
                        Count(*) Over()                   As total_row
                    From
                        ss_emplmast
                    Where
                        status       = 1
                        And (mngr    = v_mngr_empno
                            Or empno = v_mngr_empno)
                        And (empno Like v_generic_search Or name Like v_generic_search)
                        And empno    = nvl(p_empno, empno)
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

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

    Function fn_paging_emplist_4_mngrhod_onbehalf(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_empno          Varchar2 default null,
        p_generic_search Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                     Sys_Refcursor;
        v_mngr_onbehalf_empno Varchar2(5);
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_generic_search      Varchar2(100);
    Begin
        v_mngr_onbehalf_empno := get_empno_from_meta_id(p_meta_id);
        If v_mngr_onbehalf_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_generic_search Is Not Null Then
            v_generic_search := '%' || upper(trim(p_generic_search)) || '%';
        Else
            v_generic_search := '%';
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        empno                             As data_value_field,
                        empno || ' - ' || name            As data_text_field,
                        Row_Number() Over(Order By empno) As row_number,
                        Count(*) Over()                   As total_row
                    From
                        ss_emplmast
                    Where
                        status    = 1
                        And mngr In (
                            Select
                                mngr
                            From
                                ss_delegate
                            Where
                                empno = v_mngr_onbehalf_empno
                        )
                        And (empno Like v_generic_search Or name Like v_generic_search)
                        And empno = nvl(p_empno, empno)
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End;
    
    --
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

    Function fn_paging_emplist_4_secretary(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_empno          Varchar2 default null,
        p_generic_search Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_secretary_empno    Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_generic_search     Varchar2(100);
    Begin
        v_secretary_empno := get_empno_from_meta_id(p_meta_id);
        If v_secretary_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_generic_search Is Not Null Then
            v_generic_search := '%' || upper(trim(p_generic_search)) || '%';
        Else
            v_generic_search := '%';
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        empno                             As data_value_field,
                        empno || ' - ' || name            As data_text_field,
                        Row_Number() Over(Order By empno) As row_number,
                        Count(*) Over()                   As total_row
                    From
                        ss_emplmast
                    Where
                        status    = 1
                        And parent In (
                            Select
                                parent
                            From
                                ss_user_dept_rights
                            Where
                                empno = v_secretary_empno
                        )
                        And (empno Like v_generic_search Or name Like v_generic_search)
                        And empno = nvl(p_empno, empno)
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

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