Create Or Replace Package Body tcmpl_hr.mis_transfers_qry As

    Function fn_all_emp_list_hr(
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
                        key_id,
                        mit.empno || ' - ' || e.name                                         employee_name,
                        transfer_date,
                        from_costcode || ' - ' || pkg_common.fn_get_dept_name(from_costcode) from_dept,
                        to_costcode || ' - ' || pkg_common.fn_get_dept_name(to_costcode)     to_dept,
                        Row_Number() Over (Order By e.empno)                                 row_number,
                        Count(*) Over ()                                                     total_row
                    From
                        mis_internal_transfers mit,
                        vu_emplmast            e
                    Where
                        e.empno      = mit.empno
                        And e.status = 1
                        And (
                            e.empno Like upper(nvl(Trim(p_generic_search), '')) || '%'
                            Or
                            e.name Like upper(nvl(Trim(p_generic_search), '')) || '%'
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End;

    Function fn_emp_list_dept(
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
                        key_id,
                        mit.empno || ' - ' || e.name,
                        transfer_date,
                        from_costcode || pkg_common.fn_get_dept_name(from_costcode) from_dept,
                        to_costcode || pkg_common.fn_get_dept_name(to_costcode)     to_dept,
                        Row_Number() Over (Order By e.empno)                        row_number,
                        Count(*) Over ()                                            total_row
                    From
                        mis_internal_transfers mit,
                        vu_emplmast            e
                    Where
                        e.empno      = mit.empno
                        And e.status = 1
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End;

    Function fn_transfers_hr_xl(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,

        p_start_date Date,
        p_end_date   Date

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        e_invalid_date_range Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        Pragma exception_init(e_invalid_date_range, -20002);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_start_date Is Null Or p_end_date Is Null Then
            raise_application_error(-20002, 'Invalid date range');
            Return Null;
        End If;
        If p_start_date > p_end_date Then
            raise_application_error(-20002, 'Invalid date range');
            Return Null;
        End If;

        Open c For
            Select
                e.empno || ' - ' || e.name                   As employee_name,
                e.grade,
                e.emptype,
                e.sex,
                e.doj,
                trunc(months_between(sysdate, e.dob) / 12)   As age,
                d.desg                                       As designation,
                t.from_costcode                              As from_dept,
                pkg_common.fn_get_dept_name(t.from_costcode) As from_dept_name,
                t.to_costcode                                As to_dept,
                pkg_common.fn_get_dept_name(t.to_costcode)   As to_dept_name,
                t.transfer_date
            From
                vu_emplmast            e,
                mis_internal_transfers t,
                vu_desgmast            d
            Where
                e.empno        = t.empno
                And e.desgcode = d.desgcode
                And t.transfer_date Between p_start_date And p_end_date;
        Return c;
    End;

End;