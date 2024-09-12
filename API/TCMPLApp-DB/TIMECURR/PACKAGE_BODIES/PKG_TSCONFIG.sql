Create Or Replace Package Body timecurr.pkg_tsconfig As

    Function fn_tsconfig_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor Is
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
                        schemaname,
                        username,
                        password,
                        pros_month,
                        yearstart01,
                        yearstart04,
                        lockedmnth,
                        yrstdate01,
                        yrstdate04,
                        invoicemonth,
                        yearend01,
                        yearend04,
                        status,
                        repost,
                        Row_Number() Over(Order By schemaname Asc) As row_number,
                        Count(*) Over()                          As total_row
                    From
                        tsconfig
                    Where
                        schemaname Like '%' || upper(Trim(p_generic_search)) || '%'

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_tsconfig_list;

End pkg_tsconfig;
/
Grant Execute On timecurr.pkg_tsconfig To tcmpl_app_config;