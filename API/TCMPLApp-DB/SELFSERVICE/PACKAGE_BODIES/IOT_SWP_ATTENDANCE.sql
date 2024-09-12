Create Or Replace Package Body iot_swp_attendance As

    Function fn_get_sws_attendance(
        p_date           Date,

        p_hod_sec_empno  Varchar2 Default Null,

        p_is_admin       Number   Default Null,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hod_sec_empno      Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_query              Varchar2(6000);

    Begin
        v_query := v_sws_attendance_query;
        If p_is_admin = 1 Then
            v_query := replace(v_query, '!ASSIGN_SUBQUERY!', '');
        Else
            v_query := replace(v_query, '!ASSIGN_SUBQUERY!', v_sub_query_assign);
        End If;
        Open c For v_query Using p_date, p_hod_sec_empno, p_row_number, p_page_length;
        Return c;

    End;

    Function fn_sws_attendance_all(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_date           Date,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hod_sec_empno      Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_query              Varchar2(6000);
    Begin
        v_hod_sec_empno := get_empno_from_meta_id(p_meta_id);

        If v_hod_sec_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Return fn_get_sws_attendance(
            p_date           => trunc(p_date),

            p_hod_sec_empno  => Null,

            p_is_admin       => 1,

            p_generic_search => p_generic_search,

            p_row_number     => p_row_number,
            p_page_length    => p_page_length

        );
    End;

    Function fn_sws_attendance(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_date           Date,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hod_sec_empno      Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_query              Varchar2(6000);
    Begin
        v_hod_sec_empno := get_empno_from_meta_id(p_meta_id);

        If v_hod_sec_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Return fn_get_sws_attendance(
            p_date           => p_date,

            p_hod_sec_empno  => v_hod_sec_empno,

            p_is_admin       => 0,

            p_generic_search => p_generic_search,

            p_row_number     => p_row_number,
            p_page_length    => p_page_length

        );
    End;

End;