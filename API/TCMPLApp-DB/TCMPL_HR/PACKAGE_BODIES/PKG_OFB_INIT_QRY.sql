Create Or Replace Package Body tcmpl_hr.pkg_ofb_init_qry As

    Function fn_ofb_init_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_generic_search     Varchar2(100);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If Trim(p_generic_search) Is Null Then
            v_generic_search := '%';
        Else
            v_generic_search := '%' || upper(trim(p_generic_search)) || '%';
        End If;
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
                        ee.empno,
                        ee.employee_name,
                        ee.grade,
                        ee.parent,
                        ee.dept_name,
                        ee.end_by_date,
                        ee.initiator_remarks                                remarks,
                        ee.relieving_date,
                        ee.created_by,
                        ee.created_on,
                        Case ee.approval_status
                            When ok Then
                                'Approved'
                            Else
                                'Pending'
                        End                                                 approval_status,
                        fn_is_roll_back_allowed(ee.empno)                   roll_back_allowed,
                        Row_Number() Over (Order By ee.relieving_date Desc) row_number,
                        Count(*) Over ()                                    total_row
                    From
                        tcmpl_hr.ofb_vu_emp_exits ee
                    Where
                        (
                            upper(ee.empno) Like v_generic_search Or
                            upper(ee.employee_name) Like v_generic_search
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                relieving_date Desc;
        Return c;
    End;

    Function fn_is_roll_back_allowed(
        p_empno In Varchar2
    ) Return Number As
        v_retval   Number := 1; --[0 = Allowed / 1 = Not Allowed]
        v_count    Number;
        v_emp_exit ofb_emp_exits%rowtype;
    Begin
        Select
            *
        Into
            v_emp_exit
        From
            ofb_emp_exits
        Where
            empno = p_empno;

        Select
            Count(*)
        Into
            v_count
        From
            ofb_rollback rob
        Where
            rob.empno = p_empno
            And requested_on > v_emp_exit.created_on;

        If v_count = 0 Then
            v_retval := 0;
        Else
            v_retval := 1;
        End If;

        Return v_retval;

    Exception
        When Others Then
            Return 1; --[0 = Allowed / 1 = Not Allowed]
    End fn_is_roll_back_allowed;
End;