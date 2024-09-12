Create Or Replace Package Body timecurr.pkg_ts_emp_timesheet_qry As

    Function fn_employee_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_costcode       Varchar2,
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
                       Select empno                                    As empno,
                              name                                     As employee_name,
                              assign                                   As assign,
                              getcostname(assign)                      As assign_name,
                              Row_Number() Over (Order By projno Desc) row_number,
                              Count(*) Over ()                         total_row
                         From emplmast
                        Where assign = p_costcode
                          And (
                              upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                           Or upper(name) Like '%' || upper(Trim(p_generic_search)) || '%'
                              )
                          And status = 1
                   )
             Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
             Order By empno;
        Return c;
    End fn_employee_list;

End pkg_ts_emp_timesheet_qry;
