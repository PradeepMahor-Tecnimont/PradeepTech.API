Create Or Replace Package Body tcmpl_hr.pkg_emp_select_list_qry As

    Function fn_emp_relation_code_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For

            Select
                to_char(code)                        data_value_field,
                description || ' (' || gender || ')' data_text_field
            From
                emp_relation_mast
            Order By
                description;
        Return c;
    End;

    Function fn_emp_relation_text_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For

            Select
                Trim(description)                    data_value_field,
                description || ' (' || gender || ')' data_text_field
            From
                emp_relation_mast
            Order By
                description;
        Return c;
    End;

    Function fn_emp_occupation_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                to_char(code) data_value_field,
                description   data_text_field
            From
                emp_occupation
            Order By
                description;
        Return c;
    End;

    Function fn_bus_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                to_char(code) data_value_field,
                description   data_text_field
            From
                emp_bus_master
            Order By
                description;
        Return c;
    End;

    Function fn_emp_blood_group_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                to_char(code) data_value_field,
                description   data_text_field
            From
                emp_blood_group_type
            Order By
                description;
        Return c;
    End;

    Function fn_emp_country_list_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                country_name                          data_value_field,
                country_code || ' - ' || country_name data_text_field
            From
                emp_country_list
            Order By
                country_code;
        Return c;
    End;

    Function fn_emp_relatives_relations_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                key_id        data_value_field,
                relation_desc data_text_field
            From
                emp_relatives_relations
            Order By
                key_id;
        Return c;
    End;

    Function fn_emp_relatives_loa_status_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                status_code data_value_field,
                status_desc data_text_field
            From
                emp_relatives_loa_status_mast
            Order By
                status_code;
        Return c;
    End;

    Function fn_all_active_employees(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_generic_search varchar2(100);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        if p_generic_search is not null then
        v_generic_search := '%' || upper(trim(p_generic_search)) || '%';
        else
        v_generic_search:= '%';
        end if;
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
                        vu_emplmast
                    Where
                        status = 1
                        and (empno like v_generic_search or name like v_generic_search)
                )
            Where

                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End;

End;
/