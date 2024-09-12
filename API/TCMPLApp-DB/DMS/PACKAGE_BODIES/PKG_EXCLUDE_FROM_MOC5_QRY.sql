Create Or Replace Package Body dms.pkg_exclude_from_moc5_qry As

    Function fn_exclude_emp_list(
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
            Select *
              From (
                       Select empno                                             As empno,
                              get_emp_name(empno)                               As empname,
                              modified_by || ' - ' || get_emp_name(modified_by) As modified_by,
                              modified_on                                       As modified_on,

                              Row_Number() Over(Order By empno)                 row_number,
                              Count(*) Over()                                   total_row
                         From emp_exclude_from_moc5
                        Where upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'

                   )
             Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_exclude_emp_list;

End pkg_exclude_from_moc5_qry;
/
  Grant Execute On dms.pkg_exclude_from_moc5_qry To tcmpl_app_config;