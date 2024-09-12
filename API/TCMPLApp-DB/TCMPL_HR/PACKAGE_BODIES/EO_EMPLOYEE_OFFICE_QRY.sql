Create Or Replace Package Body tcmpl_hr.eo_employee_office_qry As

    Function fn_employee_office_list(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_generic_search       Varchar2 Default Null,
        p_office_location_code Varchar2 Default Null,
        p_parent               Varchar2 Default Null,
        p_grade                Varchar2 Default Null,
        p_emptype              Varchar2 Default Null,

        p_row_number           Number,
        p_page_length          Number

    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_generic_search     Varchar2(100);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        If Trim(p_generic_search) Is Null Then
            v_generic_search := '%';
        Else
            v_generic_search := '%' || upper(trim(p_generic_search)) || '%';

        End If;
        Open c For
            Select
                *
            From
                (
                    Select
                        qry.*,
                        Row_Number() Over (Order By qry.empno) row_number,
                        Count(*) Over ()                       total_row

                    From
                        (
                            With
                                emp_list As (
                                    Select
                                        empno,
                                        name,
                                        parent,
                                        assign,
                                        grade,
                                        emptype
                                    From
                                        vu_emplmast
                                    Where
                                        status      = 1
                                        And parent  = nvl(p_parent, parent)
                                        And grade   = nvl(p_grade, grade)
                                        And emptype = nvl(p_emptype, emptype)
                                        And (empno Like v_generic_search Or name Like v_generic_search || '%')
                                ),
                                emp_office As(
                                    Select
                                        empno,
                                            Max(office_location_code) Keep (Dense_Rank Last Order By start_date) emp_office,
                                            Max(modified_on) Keep (Dense_Rank Last Order By modified_on)          modified_on
                                    From
                                        eo_employee_office_map
                                    Where
                                        empno In (
                                            Select
                                                empno
                                            From
                                                emp_list
                                        )
                                    Group By empno
                                )
                            Select
                                a.empno,
                                a.name,
                                a.parent,
                                a.assign,
                                a.grade,
                                a.emptype,
                                b.emp_office                                                                  emp_office_location_code,
                                b.emp_office || ' - ' || pkg_common.fn_get_office_location_desc(b.emp_office) emp_office_location,
                                b.modified_on
                            From
                                emp_list   a,
                                emp_office b
                            Where
                                a.empno = b.empno(+)
                        ) qry

                    Where
                        nvl(emp_office_location_code, 'X') = nvl(p_office_location_code, nvl(emp_office_location_code, 'X'))
                )

            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End;

    Function fn_employee_office_hist_list(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_empno                Varchar2,
        p_office_location_code Varchar2 Default Null,
        p_parent               Varchar2 Default Null,

        p_row_number           Number,
        p_page_length          Number

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
                        a.key_id,
                        a.empno,
                        a.start_date,
                        a.office_location_code || ' - ' || b.office_location_desc                emp_office_location,
                        a.modified_on,
                        a.modified_by || ' - ' || pkg_common.fn_get_employee_name(a.modified_by) modified_by,
                        Row_Number() Over (Order By a.empno)                                     row_number,
                        Count(*) Over ()                                                         total_row
                    From
                        eo_employee_office_map   a,
                        mis_mast_office_location b
                    Where
                        a.empno                    = p_empno
                        And a.office_location_code = b.office_location_code
                        order by a.start_date desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End;

    Function fn_employee_office_list_4xl(
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
            With
                emp_list As (
                    Select
                        empno,
                        name,
                        parent,
                        assign,
                        grade,
                        emptype,
                        email,
                        personid,
                        metaid
                    From
                        vu_emplmast
                    Where
                        status = 1
                ),
                emp_office As(
                    Select
                        empno,
                            Max(office_location_code) Keep (Dense_Rank Last Order By
                            start_date) emp_office,
                            Max(start_date) Keep (Dense_Rank Last Order By
                            start_date) from_date,
                            Max(modified_on) Keep (Dense_Rank Last Order By
                            modified_on) modified_on
                    From
                        eo_employee_office_map
                    Where
                        empno In (
                            Select
                                empno
                            From
                                emp_list
                        )
                    Group By
                        empno
                )
            Select
                a.empno,
                a.name,
                a.parent,
                a.assign,
                a.grade,
                a.emptype,
                a.email,
                a.personid,
                a.metaid,
                b.emp_office || ' - ' || pkg_common.fn_get_office_location_desc(b.emp_office) emp_office_location,
                b.from_date,
                b.modified_on
            From
                emp_list   a,
                emp_office b
            Where
                a.empno = b.empno(+);

        Return c;

    End;

End;