Create Or Replace Package Body tcmpl_app_config.pkg_app_user_master_qry As

    Function fn_app_user_master_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
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
                        empno                                             As empno,
                        get_emp_name(empno)                               As name,
                        (
                        Case
                            When status = 1 Then
                                'Active'
                            Else
                                'DeActive'
                        End
                        )                                                 As status,
                        (
                        Case
                            When empno = v_empno Then
                                not_ok
                            Else
                                ok
                        End
                        )                                                 As checkbox_flag,
                        modified_on                                       As modified_on,
                        modified_by || ' - ' || get_emp_name(modified_by) As modified_by,
                        Row_Number() Over(Order By empno Asc)             row_number,
                        Count(*) Over()                                   total_row
                    From
                        app_user_master
                    Where
                        (empno Like '%' || upper(Trim(p_generic_search)) || '%')
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_app_user_master_list;

End pkg_app_user_master_qry;