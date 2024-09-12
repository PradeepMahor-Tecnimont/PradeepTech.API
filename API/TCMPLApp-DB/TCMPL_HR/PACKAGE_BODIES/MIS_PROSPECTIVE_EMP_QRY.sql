Create Or Replace Package Body tcmpl_hr.mis_prospective_emp_qry As

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
                        p.key_id,
                        p.costcode || ' - ' || pkg_common.fn_get_dept_name(p.costcode) dept,
                        p.emp_name,
                        p.office_location_code || ' - ' || l.office_location_desc      office_location,
                        p.proposed_doj,
                        p.revised_doj,
                        p.join_status_code || ' - ' || s.join_status_desc              join_status,
                        Case p.empno
                            When Null Then
                                Null
                            Else

                                p.empno || ' - ' || pkg_common.fn_get_employee_name(empno)
                        End                                                            As tcmpl_emp,
                        Row_Number() Over (Order By empno)                             row_number,
                        Count(*) Over ()                                               total_row
                    From
                        mis_prospective_emp      p,
                        mis_mast_joining_status  s,
                        mis_mast_office_location l
                    Where
                        p.office_location_code = l.office_location_code
                        And p.join_status_code = s.join_status_code
                        And p.emp_name Like upper(nvl(Trim(p_generic_search), '')) || '%'

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
                        costcode,
                        emp_name,
                        office_location_code,
                        proposed_doj,
                        revised_doj,
                        join_status_code,
                        empno,
                        Row_Number() Over (Order By empno) row_number,
                        Count(*) Over ()                   total_row
                    From
                        mis_prospective_emp
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End;

    Function fn_joinees_hr_xl(
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
                e.empno,
                e.personid,
                e.name                                As employee_name,
                e.grade,
                e.sex,
                e.doj,
                e.parent                              As dept,
                pkg_common.fn_get_dept_name(e.parent) As dept_name,
                d.desg                                As designation

            From
                vu_emplmast e,
                vu_desgmast d
            Where
                e.desgcode = d.desgcode
                And emptype In ('R', 'S', 'C', 'F', 'O')
                And e.doj Between p_start_date And p_end_date;
        Return c;
    End;

    Function fn_relieved_hr_xl(
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
                e.empno,
                e.personid,
                e.name                                As employee_name,
                e.grade,
                e.sex,
                e.dol                                 relieved_on,
                e.parent                              As dept,
                pkg_common.fn_get_dept_name(e.parent) As dept_name,
                d.desg                                As designation

            From
                vu_emplmast e,
                vu_desgmast d
            Where
                e.desgcode = d.desgcode
                And emptype In ('R', 'S', 'C', 'F', 'O')
                And e.dol Between p_start_date And p_end_date;
        Return c;
    End;

    Function fn_prospective_joinees_hr_xl(
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
                pe.emp_name                                    employee_name,
                pe.costcode                                    dept,
                pkg_common.fn_get_dept_name(pe.costcode)       dept_name,
                nvl(pe.revised_doj, pe.proposed_doj)           proposed_doj,
                ol.office_location_desc                        joining_office,
                js.join_status_desc                            joining_status,
                pe.empno || ' - ' || e.name                    joined_as,
                e.doj,
                e.grade,
                e.emptype,
                pkg_common.fn_get_designation_name(e.desgcode) As desgination
            From
                mis_prospective_emp      pe,
                mis_mast_office_location ol,
                mis_mast_joining_status  js,
                vu_emplmast              e
            Where
                pe.office_location_code = ol.office_location_code
                And pe.join_status_code = js.join_status_code
                And pe.empno            = e.empno(+)
                And nvl(revised_doj, proposed_doj) Between p_start_date And p_end_date;
        Return c;
    End;
End;