Create Or Replace Package Body "SELFSERVICE"."PKG_DESKBOOKING_QRY" As

    Function fn_emp_desk_book_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor Is
        c                    Sys_Refcursor;
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_next_work_date     Date;
    Begin
        v_empno          := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        v_next_work_date := iot_swp_common.fn_get_next_work_date(sysdate + 1);

        Open c For
            Select
                *
            From
                (
                    Select
                        a.key_id,
                        a.empno,
                        get_emp_name(a.empno)                           emp_name,
                        nvl(a.deskid, 'N.A.') as deskid,
                        --a.attendance_date,
                        to_char(b.d_date, 'dd-Mon-yyyy')                attendance_date,
                        to_char(b.d_date, 'Dy')                         day_of_week,
                        a.start_time,
                        a.end_time,
                        a.modified_on,
                        a.modified_by || ' - ' || get_emp_name(a.empno) modified_by_emp_name,
                        a.shiftcode,
                        a.office,
                        (Case
                             When trunc(a.attendance_date) Is Null Then
                                 'QB'
                             When a.attendance_date = trunc(sysdate) Then
                                 'NA'
                             Else
                                 'DL'
                         End)                                           As action_type,
                        Row_Number() Over(Order By a.attendance_date)   As row_number,
                        Count(*) Over()                                 As total_row
                    From
                        ss_days_details                  b
                        Left Outer Join db_desk_bookings a
                        On b.d_date = a.attendance_date
                        And a.empno = v_empno
                    Where
                        b.d_date Between trunc(sysdate) And v_next_work_date
                    Order By b.d_date
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_emp_desk_book_list;

    Function fn_emp_desk_book_log_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor Is
        c                    Sys_Refcursor;
        v_count              Number;
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
                        get_emp_name(a.empno)                           emp_name,
                        a.deskid,
                        --a.attendance_date,
                        to_char(a.attendance_date, 'dd-Mon-yyyy')       attendance_date,
                        to_char(a.attendance_date, 'Dy')                day_of_week,
                        a.start_time,
                        a.end_time,
                        a.modified_on,
                        a.modified_by || ' - ' || get_emp_name(a.empno) modified_by_emp_name,
                        a.shiftcode,
                        a.office,
                        (Case
                             When trunc(a.attendance_date) = trunc(sysdate) Then
                                 'KO'
                             Else
                                 'OK'
                         End)                                           As is_delete,
                        Row_Number() Over(Order By a.attendance_date)   As row_number,
                        Count(*) Over()                                 As total_row
                    From
                        db_desk_bookings_log a
                    Where
                        a.empno = v_empno
                        And (upper(a.empno) Like '%' || upper(Trim(p_generic_search)) || '%')
                    Order By trunc(a.attendance_date)

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_emp_desk_book_log_list;

End pkg_deskbooking_qry;