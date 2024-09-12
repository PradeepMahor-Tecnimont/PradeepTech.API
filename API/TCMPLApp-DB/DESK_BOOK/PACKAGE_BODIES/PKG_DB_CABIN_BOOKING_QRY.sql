--------------------------------------------------------
--  DDL for Package Body PKG_DESKBOOKING_QRY
--------------------------------------------------------

Create Or Replace Editionable Package Body desk_book.pkg_db_cabin_booking_qry As
    c_emptype Constant Char(1) := 'G';

    Function fn_cabin_book_calender(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null
    ) Return Sys_Refcursor Is
        c                    Sys_Refcursor;
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_next_work_date     Date;
        v_attendance_date    Date;
        v_column_csv         Varchar2(2000);
        v_query              Varchar2(8000);
        v_start_date         Date;
        v_end_date           Date;
        v_dyddmon            Varchar2(50);
        v_where_clause       Varchar2(500);
    Begin
        v_empno      := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_generic_search Is Not Null Then
            v_where_clause := ' where dr.deskid like %' || trim(p_generic_search) || '%';
        Else
            v_where_clause := ' ';
        End If;
        v_start_date := trunc(sysdate);
        v_end_date   := selfservice.iot_swp_common.fn_get_next_work_date(sysdate + 1);

        With
            params As (
                Select
                    v_start_date p_start_date,
                    v_end_date   p_end_date
                From
                    dual
            )
        Select
            Listagg(booking_day, ',') booking_day_csv
        Into
            v_column_csv
        From
            (
                Select
                    Chr(39) ||
                    to_char(a.d_date, 'Dy_ddMon')
                    || Chr(39) || ' ' || to_char(a.d_date, 'Dy_ddMon') booking_day
                From
                    selfservice.ss_days_details a
                    Cross Join params           p
                Where
                    a.d_date Between p.p_start_date And p.p_end_date
            );
        v_query      := regexp_replace('With
            params As (
                Select
                    :p_start_date p_start_date,
                    :p_end_date   p_end_date
                From
                    dual
            ),
            date_range As (
                Select
                    a.d_date, to_char(a.d_date,dyddmon) booking_day, c.deskid, c.office
                From
                    selfservice.ss_days_details a
                    Cross Join db_cabins        c
                    Cross Join params           p
                Where
                    a.d_date Between p.p_start_date And p.p_end_date
            )
        Select
            *
        From
            (
                Select
                    booking_day,
                    dr.deskid,
                    dr.office,
                    nvl(nvl(cb.empname, guestname), '''') booked_by
                From
                    date_range                        dr
                    Left Outer Join db_cabin_bookings cb
                    On dr.d_date = cb.attendance_date
                    And dr.deskid = cb.deskid 
            ) src
            Pivot(
            Max (booked_by) For booking_day In (
            v_column_csv))', '[[:space:]]+', chr(32));

        v_dyddmon    := chr(39) || 'Dy_ddMon' || chr(39);
        v_query      := replace(v_query, 'v_column_csv', v_column_csv);
        v_query      := replace(v_query, 'dyddmon', v_dyddmon);
        v_query      := replace(v_query, 'v_where_clause', v_where_clause);

        Open c For v_query Using v_start_date, v_end_date;

        Return c;
    End fn_cabin_book_calender;

    Function fn_cabin_booking_list_for_hod(
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
        v_next_work_date     Date;
        v_attendance_date    Date;

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
                        empno,
                        nvl(empname, guestname)                     As name,
                        nvl(deskid, 'N.A.')                         As deskid,
                        attendance_date                             As attendance_date,
                        office,
                        Case emptype
                            When 'E' Then
                                'EMPLOYEE'
                            When 'G' Then
                                'GUEST'
                        End                                         As emptype,
                        modified_on,
                        modified_by || ' - ' || get_emp_name(empno) modified_by,
                        Row_Number() Over(Order By empno)           As row_number,
                        Count(*) Over()                             As total_row
                    From
                        db_cabin_bookings
                    Where
                        empno = v_empno
                        And upper(deskid) Like '%' || upper(Trim(p_generic_search)) || '%'
                    Order By trunc(attendance_date) Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_cabin_booking_list_for_hod;

    Function fn_cabin_booking_list_for_admin(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,
        p_start_date     Date     Default Null,
        p_end_date       Date     Default Null,

        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor Is
        c                    Sys_Refcursor;
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_next_work_date     Date;

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
                        Case
                            When emptype = c_emptype Then
                                'GUEST'
                            Else
                                empno
                        End                                         As empno,
                        nvl(empname, guestname)                     As name,
                        nvl(deskid, 'N.A.')                         As deskid,
                        attendance_date                             As attendance_date,
                        office,
                        Case emptype
                            When 'E' Then
                                'EMPLOYEE'
                            When 'G' Then
                                'GUEST'
                        End                                         As emptype,
                        modified_on,
                        modified_by || ' - ' || get_emp_name(empno) modified_by,
                        Row_Number() Over(Order By empno)           As row_number,
                        Count(*) Over()                             As total_row
                    From
                        db_cabin_bookings
                    Where
                        attendance_date Between nvl(p_start_date, attendance_date) And nvl(p_end_date, attendance_date)
                        And
                        (deskid Like '%' || upper(Trim(p_generic_search)) || '%')
                    Order By deskid Asc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_cabin_booking_list_for_admin;

    Function fn_cabin_booking_list_for_hod_xl(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor Is
        c                    Sys_Refcursor;
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_next_work_date     Date;
        v_attendance_date    Date;

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
                        empno,
                        nvl(empname, guestname)                     As name,
                        nvl(deskid, 'N.A.')                         As deskid,
                        attendance_date                             As attendance_date,
                        office,
                        Case emptype
                            When 'E' Then
                                'EMPLOYEE'
                            When 'G' Then
                                'GUEST'
                        End                                         As emptype,
                        modified_on,
                        modified_by || ' - ' || get_emp_name(empno) modified_by
                    From
                        db_cabin_bookings
                    Where
                        empno = v_empno
                    Order By trunc(attendance_date) Desc
                );
            
        Return c;
    End fn_cabin_booking_list_for_hod_xl;

    Function fn_cabin_booking_list_for_admin_xl(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,

        p_start_date Date Default Null,
        p_end_date   Date Default Null
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
                        key_id,
                        Case
                            When emptype = c_emptype Then
                                'GUEST'
                            Else
                                empno
                        End                                         As empno,
                        nvl(empname, guestname)                     As name,
                        nvl(deskid, 'N.A.')                         As deskid,
                        attendance_date                             As attendance_date,
                        office,
                        Case emptype
                            When 'E' Then
                                'EMPLOYEE'
                            When 'G' Then
                                'GUEST'
                        End                                         As emptype,
                        modified_on,
                        modified_by || ' - ' || get_emp_name(empno) modified_by
                    From
                        db_cabin_bookings
                    Where
                        attendance_date Between nvl(p_start_date, attendance_date) And nvl(p_end_date, attendance_date)
                    Order By deskid Asc
                );
            
        Return c;
    End fn_cabin_booking_list_for_admin_xl;
End pkg_db_cabin_booking_qry;
/