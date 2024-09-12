--------------------------------------------------------
--  DDL for Package Body IOT_SWP_ATTENDANCE_QRY
--------------------------------------------------------

Create Or Replace Package Body "SELFSERVICE"."IOT_SWP_ATTENDANCE_QRY" As

    Function get_attendance(

        p_start_date                Date,
        p_end_date                  Date,
        p_is_exclude_x1_employees   Number,
        p_include_employee_location Varchar2,
        p_include_column_01         Varchar2 Default Null

    ) Return Sys_Refcursor As

        c                           Sys_Refcursor;
        v_exclude_grade             Varchar2(2);
        c_location_all              Varchar2(15)  := 'ALL';
        c_location_delhi            Varchar2(15)  := 'GURUGRAM';
        c_location_others           Varchar2(15)  := 'OTHERS';
        --v_loc_sub_query             Varchar2(500);
        c_location_code_gurugram    Varchar2(2)   := '03';
        v_grugram_loc_costcodes_qry Varchar2(500);
        v_query                     Varchar2(3000);
        v_column_01_qry             Varchar2(200) := '';
    Begin

        v_grugram_loc_costcodes_qry := '(select costcode from tcmpl_hr.mis_mast_costcode_location where office_location_code = ''' ||
        c_location_code_gurugram || ''')';

        v_column_01_qry             := ' Case iot_swp_common.fn_can_work_smartly(empno,d_date) When 1 Then ''Yes'' Else ''No'' End As can_work_smartly, ';

        If p_is_exclude_x1_employees = 1 Then
            v_exclude_grade := 'X1';
        Else
            v_exclude_grade := '!!';
        End If;

        If nvl(p_include_column_01, not_ok) = not_ok Then
            v_column_01_qry := ' ';
        End If;

        If upper(trim(p_include_employee_location)) = c_location_all Then
            v_grugram_loc_costcodes_qry := ' ';
        Elsif upper(trim(p_include_employee_location)) = c_location_delhi Then
            v_grugram_loc_costcodes_qry := ' and assign in ' || v_grugram_loc_costcodes_qry;
        Elsif upper(trim(p_include_employee_location)) = c_location_others Then
            v_grugram_loc_costcodes_qry := ' and assign not in ' || v_grugram_loc_costcodes_qry;
        Else
            Return Null;
        End If;

        v_query                     := v_sql_attendance;
        v_query                     := replace(v_query, '!LOCATION_SUB_QUERY!', v_grugram_loc_costcodes_qry);
        v_query                     := replace(v_query, '!ADDITIONAL_COLUMN_01!', v_column_01_qry);

        Open c For v_query Using p_start_date, p_end_date, v_exclude_grade;
        Return c;

    End;

    Function fn_first_monday_of_month(p_yyyymm Varchar2) Return Date As
        v_date    Date;
        v_day_num Number;
    Begin
        v_date    := To_Date(p_yyyymm, 'yyyymm');
        If to_char(v_date, 'd') In (1, 7) Then
            v_date := v_date + 3;
        End If;
        v_day_num := To_Number(to_char(v_date, 'd'));

        Return v_date - v_day_num + 2;

    End;

    Function fn_last_friday_of_month(p_yyyymm Varchar2) Return Date As
        v_date    Date;
        v_day_num Number;
    Begin
        v_date    := last_day(To_Date(p_yyyymm, 'yyyymm'));
        If to_char(v_date, 'd') In (1, 7) Then
            v_date := v_date - 3;
        End If;
        v_day_num := to_char(v_date, 'd');

        Return v_date + (6 - v_day_num);
    End;

    Function fn_attendance_for_period(
        p_person_id                 Varchar2,
        p_meta_id                   Varchar2,

        p_start_date                Date,
        p_end_date                  Date,
        p_is_exclude_x1_employees   Number,
        p_include_employee_location Varchar2

    ) Return Sys_Refcursor As
        v_empno                     Varchar2(5);
        e_employee_not_found        Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                           Sys_Refcursor;
        v_exclude_grade             Varchar2(2);
        c_location_all              Varchar2(15) := 'ALL';
        c_location_delhi            Varchar2(15) := 'GURUGRAM';
        c_location_others           Varchar2(15) := 'OTHERS';
        v_loc_sub_query             Varchar2(500);
        c_location_code_gurugram    Varchar2(2)  := '03';
        v_grugram_loc_costcodes_qry Varchar2(500);
        v_query                     Varchar2(3000);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Return get_attendance(
                p_start_date                => p_start_date,
                p_end_date                  => p_end_date,
                p_is_exclude_x1_employees   => p_is_exclude_x1_employees,
                p_include_employee_location => p_include_employee_location,
                p_include_column_01         => not_ok
            );

        /*
                Open c For
                    Select
                        data.*,
                        iot_swp_common.fn_get_pws_text(data.n_pws)                                    c_pws,
                        iot_swp_common.fn_get_attendance_status(data.empno, data.d_date, data.n_pws)  attend_status,
                        iot_swp_common.fn_is_attendance_required(data.empno, data.d_date, data.n_pws) attend_required
                    From
                        (
                            Select
                                *
                            From
                                (
                                    With
                                        work_days As (
                                            Select
                                                *
                                            From
                                                ss_days_details d
                                            Where
                                                d.d_date Between p_start_date And nvl(p_end_date, sysdate)
                                                And d.d_date Not In (
                                                    Select
                                                        holiday
                                                    From
                                                        ss_holidays
                                                    Where
                                                        holiday Between p_start_date And nvl(p_end_date, sysdate)
                                                )
                                        )
                                    Select
                                        e.empno                                                    As empno,
                                        e.name                                                     As employee_name,
                                        e.email                                                    As email,
                                        e.parent                                                   As parent,
                                        e.assign                                                   As assign,
                                        e.emptype                                                  As emp_type,
                                        e.grade                                                    As grade,
                                        e.doj                                                      As doj,
                                        nvl(e.dol, p_end_date)                                     As dol,
                                        wd.d_date                                                  As d_date,
                                        to_char(e.status)                                          As status,
                                        to_char(iot_swp_common.fn_get_emp_pws(e.empno, wd.d_date)) n_pws,
                                        e.personid                                                 As personid
                                    From
                                        ss_emplmast e,
                                        work_days   wd
                                    Where
                                        (
                                            e.status = 1
                                            Or dol Between p_start_date And p_end_date
                                        )
                                        And e.emptype In (
                                            Select
                                                emptype
                                            From
                                                swp_include_emptype
                                        )
                                        
                                        And e.assign Not In (
                                            Select
                                                assign
                                            From
                                                swp_exclude_assign
                                        )
                                        
                                        And e.grade <> v_exclude_grade
                                )
                            Where
                                d_date Between doj And dol
        
                        ) data;
        
                Return c;
        */
    End;

    Function fn_attendance_for_day(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_start_date              Date,

        p_is_exclude_x1_employees   Number,
        p_include_employee_location Varchar2

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        e_date_is_holiday    Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        Pragma exception_init(e_date_is_holiday, -20002);
        c                    Sys_Refcursor;
        v_exclude_grade      Varchar2(2);
        v_count              Number;
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_is_exclude_x1_employees = 1 Then
            v_exclude_grade := 'X1';
        Else
            v_exclude_grade := '!!';
        End If;

        If p_start_date Is Null Then
            raise_application_error(-20003, 'Invalid date provided.');

            Return Null;
        End If;

        Select
            Count(holiday)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = p_start_date;
        If v_count > 0 Then
            raise_application_error(-20002, 'Date provided is a holiday');
            Return Null;
        End If;

        Return get_attendance(
                p_start_date                => p_start_date,
                p_end_date                  => p_start_date,
                p_is_exclude_x1_employees   => p_is_exclude_x1_employees,
                p_include_employee_location => p_include_employee_location,
                p_include_column_01         => ok
            );

    End;

    Function fn_attendance_for_prev_day(
        p_person_id Varchar2,
        p_meta_id   Varchar2

    ) Return Sys_Refcursor As
        v_prev_date Date;
    Begin
        v_prev_date := iot_swp_common.fn_get_prev_work_date(trunc(sysdate) - 1);

        Return fn_attendance_for_day(
                p_person_id               => p_person_id,
                p_meta_id                 => p_meta_id,

                p_start_date              => v_prev_date,

                p_is_exclude_x1_employees => 0,
        
                p_include_employee_location => not_ok
            );
    End;

    Function fn_attendance_for_month(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_yyyymm                  Varchar2,

        p_is_exclude_x1_employees   Number,
        p_include_employee_location Varchar2

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        e_date_is_holiday    Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        Pragma exception_init(e_date_is_holiday, -20002);
        c                    Sys_Refcursor;
        v_exclude_grade      Varchar2(2);
        v_count              Number;
        v_temp_date          Date;
        v_mm                 Varchar2(2);
        v_yyyy               Varchar2(4);
        v_start_date date;
        v_end_date date;
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_is_exclude_x1_employees = 1 Then
            v_exclude_grade := 'X1';
        Else
            v_exclude_grade := '!!';
        End If;

        If p_yyyymm Is Null Then
            raise_application_error(-20003, 'Invalid month provided.');

            Return Null;
        End If;
        --
        --Check p_yyyymm is valid
        Begin
            v_temp_date := To_Date(p_yyyymm, 'yyyymm');
            v_mm        := substr(p_yyyymm, 5, 2);
            v_yyyy      := substr(p_yyyymm, 1, 4);
        Exception
            When Others Then
                raise_application_error(-20002, 'Invalid yyyymm.');
                Return Null;
        End;
        --
        v_start_date := iot_swp_attendance_qry.fn_first_monday_of_month(p_yyyymm);
        v_end_date := iot_swp_attendance_qry.fn_last_friday_of_month(p_yyyymm);
        Return get_attendance(
                p_start_date                => v_start_date,
                p_end_date                  => v_end_date,
                p_is_exclude_x1_employees   => p_is_exclude_x1_employees,
                p_include_employee_location => p_include_employee_location,
                p_include_column_01         => not_ok
            );

    End;


    Function fn_attendance_for_period_20230507(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_start_date              Date,
        p_end_date                Date,
        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_exclude_grade      Varchar2(2);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_is_exclude_x1_employees = 1 Then
            v_exclude_grade := 'X1';
        Else
            v_exclude_grade := '!!';
        End If;

        Open c For
            Select
                data.*,
                iot_swp_common.fn_get_pws_text(data.n_pws)                                    c_pws,
                iot_swp_common.fn_get_attendance_status(data.empno, data.d_date, data.n_pws)  attend_status,
                iot_swp_common.fn_is_attendance_required(data.empno, data.d_date, data.n_pws) attend_required
            From
                (
                    Select
                        *
                    From
                        (
                            With
                                work_days As (
                                    Select
                                        *
                                    From
                                        ss_days_details d
                                    Where
                                        d.d_date Between p_start_date And nvl(p_end_date, sysdate)
                                        And d.d_date Not In (
                                            Select
                                                holiday
                                            From
                                                ss_holidays
                                            Where
                                                holiday Between p_start_date And nvl(p_end_date, sysdate)
                                        )
                                )
                            Select
                                e.empno                                                    As empno,
                                e.name                                                     As employee_name,
                                e.email                                                    As email,
                                e.parent                                                   As parent,
                                e.assign                                                   As assign,
                                e.emptype                                                  As emp_type,
                                e.grade                                                    As grade,
                                e.doj                                                      As doj,
                                nvl(e.dol, p_end_date)                                     As dol,
                                wd.d_date                                                  As d_date,
                                to_char(e.status)                                          As status,
                                to_char(iot_swp_common.fn_get_emp_pws(e.empno, wd.d_date)) n_pws,
                                e.personid                                                 As personid
                            From
                                ss_emplmast e,
                                work_days   wd
                            Where
                                (
                                    e.status = 1
                                    Or dol Between p_start_date And p_end_date
                                )
                                And e.emptype In (
                                    Select
                                        emptype
                                    From
                                        swp_include_emptype
                                )
                                And e.assign Not In (
                                    Select
                                        assign
                                    From
                                        swp_exclude_assign
                                )
                        --And e.grade <> v_exclude_grade
                        )
                    Where
                        d_date Between doj And dol

                ) data;

        Return c;

    End;

    Function fn_attendance_for_day_20230507(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_start_date              Date,

        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        e_date_is_holiday    Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        Pragma exception_init(e_date_is_holiday, -20002);
        c                    Sys_Refcursor;
        v_exclude_grade      Varchar2(2);
        v_count              Number;
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_is_exclude_x1_employees = 1 Then
            v_exclude_grade := 'X1';
        Else
            v_exclude_grade := '!!';
        End If;

        If p_start_date Is Null Then
            raise_application_error(-20003, 'Invalid date provided.');

            Return Null;
        End If;

        Select
            Count(holiday)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = p_start_date;
        If v_count > 0 Then
            raise_application_error(-20002, 'Date provided is a holiday');
            Return Null;
        End If;

        
        
        Open c For
            Select
                data.*,
                iot_swp_common.fn_get_pws_text(data.n_pws)                                    c_pws,
                iot_swp_common.fn_get_attendance_status(data.empno, data.d_date, data.n_pws)  attend_status,
                iot_swp_common.fn_is_attendance_required(data.empno, data.d_date, data.n_pws) attend_required

            From
                (
                    Select
                        *
                    From
                        (
                            Select
                                e.empno                                                       As empno,
                                e.name                                                        As employee_name,
                                e.email                                                       As email,
                                e.parent                                                      As parent,
                                e.assign                                                      As assign,
                                e.emptype                                                     As emp_type,
                                e.grade                                                       As grade,
                                e.doj                                                         As doj,
                                trunc(p_start_date)                                           As d_date,
                                to_char(e.status)                                             As status,
                                to_char(iot_swp_common.fn_get_emp_pws(e.empno, p_start_date)) n_pws,
                                Case iot_swp_common.fn_can_work_smartly(empno)
                                    When 1 Then
                                        'Yes'
                                    Else
                                        'No'
                                End                                                           As can_work_smartly
                            From
                                ss_emplmast e
                            Where
                                (
                                    status = 1
                                    Or dol >= p_start_date
                                )
                                And emptype In (
                                    Select
                                        emptype
                                    From
                                        swp_include_emptype
                                )
                                And assign Not In(
                                    Select
                                        assign
                                    From
                                        swp_exclude_assign
                                )
                                And grade <> v_exclude_grade
                                And doj <= p_start_date
                        )
                ) data;

        Return c;

    End;

    Function fn_attendance_for_prev_day_20230507(
        p_person_id Varchar2,
        p_meta_id   Varchar2

    ) Return Sys_Refcursor As
        v_prev_date Date;
    Begin
        v_prev_date := iot_swp_common.fn_get_prev_work_date(trunc(sysdate) - 1);

        Return fn_attendance_for_day_20230507(
                p_person_id               => p_person_id,
                p_meta_id                 => p_meta_id,

                p_start_date              => v_prev_date,

                p_is_exclude_x1_employees => 0

            );
    End;

    Function fn_date_list(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,

        p_start_date Date,
        p_end_date   Date

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
                        dd.d_day As d_days, dd.d_date d_date_list
                    From
                        ss_days_details dd
                    Where
                        d_date Between p_start_date And p_end_date
                        And dd.d_date Not In (
                            Select
                                holiday
                            From
                                ss_holidays
                            Where
                                ss_holidays.holiday Between p_start_date And p_end_date
                        )
                )
            Order By
                d_date_list;
        Return c;

    End;

    Function fn_week_number_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_yyyymm    Varchar2

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_temp_date          Date;
        v_mm                 Varchar2(2);
        v_yyyy               Varchar2(4);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_yyyymm Is Null Then
            raise_application_error(-20003, 'Invalid month provided.');

            Return Null;
        End If;
        --
        --Check p_yyyymm is valid
        Begin
            v_temp_date := To_Date(p_yyyymm, 'yyyymm');
            v_mm        := substr(p_yyyymm, 5, 2);
            v_yyyy      := substr(p_yyyymm, 1, 4);
        Exception
            When Others Then
                raise_application_error(-20002, 'Invalid yyyymm.');
                Return Null;
        End;
        --

        Open c For
            With
                params As (
                    Select
                        iot_swp_attendance_qry.fn_first_monday_of_month(p_yyyymm) As start_date,
                        iot_swp_attendance_qry.fn_last_friday_of_month(p_yyyymm)  As end_date
                    From
                        dual
                )

            Select
                'Week_' || wk_no As week_name,
                Min(d_date)      start_date,
                Max(d_date)      end_date
            From
                (

                    Select
                        d_date,
                        to_char(d_date, 'WW') - (to_char(params.start_date, 'WW') - 1) wk_no

                    From
                        ss_days_details dd, params
                    Where
                        d_date Between params.start_date And params.end_date
                        And dd.d_date Not In (
                            Select
                                holiday
                            From
                                ss_holidays, params
                            Where
                                ss_holidays.holiday Between params.start_date And params.end_date
                        )
                )
            Group By
                wk_no
            Order By
                week_name;
        Return c;

    End;

    Function fn_swp_day_attendance_list(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_start_date              Date,
        p_end_date                Date,
        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_exclude_grade      Varchar2(2);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_is_exclude_x1_employees = 1 Then
            v_exclude_grade := 'X1';
        Else
            v_exclude_grade := '!!';
        End If;

        Open c For
            Select
                data.*,
                iot_swp_common.fn_get_pws_text(data.n_pws)                                    c_pws,
                iot_swp_common.fn_get_attendance_status(data.empno, data.d_date, data.n_pws)  attend_status,
                iot_swp_common.fn_is_attendance_required(data.empno, data.d_date, data.n_pws) attend_required
            From
                (
                    Select
                        *
                    From
                        (
                            With
                                work_days As (
                                    Select
                                        *
                                    From
                                        ss_days_details d
                                    Where
                                        d.d_date Between p_start_date And nvl(p_end_date, sysdate)
                                        And d.d_date Not In (
                                            Select
                                                holiday
                                            From
                                                ss_holidays
                                            Where
                                                holiday Between p_start_date And nvl(p_end_date, sysdate)
                                        )
                                )
                            Select
                                e.empno                                                    As empno,
                                e.name                                                     As employee_name,
                                e.email                                                    As email,
                                e.parent                                                   As parent,
                                e.assign                                                   As assign,
                                e.emptype                                                  As emp_type,
                                e.grade                                                    As grade,
                                e.doj                                                      As doj,
                                p_end_date                                                 As dol,
                                wd.d_date                                                  As d_date,
                                to_char(e.status)                                          As status,
                                to_char(iot_swp_common.fn_get_emp_pws(e.empno, wd.d_date)) n_pws
                            From
                                ss_emplmast e,
                                work_days   wd
                            Where
                                (
                                e.status = 1

                                )
                                And e.emptype In (
                                    Select
                                        emptype
                                    From
                                        swp_include_emptype
                                )
                                And e.assign Not In (
                                    Select
                                        assign
                                    From
                                        swp_exclude_assign
                                )
                                And e.grade <> v_exclude_grade
                        )
                    Where
                        d_date >= doj

                ) data;

        Return c;

    End;

    Function fn_attendance_for_month_20230507(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_yyyymm                  Varchar2,

        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        e_date_is_holiday    Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        Pragma exception_init(e_date_is_holiday, -20002);
        c                    Sys_Refcursor;
        v_exclude_grade      Varchar2(2);
        v_count              Number;
        v_temp_date          Date;
        v_mm                 Varchar2(2);
        v_yyyy               Varchar2(4);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_is_exclude_x1_employees = 1 Then
            v_exclude_grade := 'X1';
        Else
            v_exclude_grade := '!!';
        End If;

        If p_yyyymm Is Null Then
            raise_application_error(-20003, 'Invalid month provided.');

            Return Null;
        End If;
        --
        --Check p_yyyymm is valid
        Begin
            v_temp_date := To_Date(p_yyyymm, 'yyyymm');
            v_mm        := substr(p_yyyymm, 5, 2);
            v_yyyy      := substr(p_yyyymm, 1, 4);
        Exception
            When Others Then
                raise_application_error(-20002, 'Invalid yyyymm.');
                Return Null;
        End;
        --
        Open c For
            Select
                data.*,
                iot_swp_common.fn_get_pws_text(data.n_pws)                                    c_pws,
                iot_swp_common.fn_get_attendance_status(data.empno, data.d_date, data.n_pws)  attend_status,
                iot_swp_common.fn_is_attendance_required(data.empno, data.d_date, data.n_pws) attend_required
            From
                (
                    Select
                        *
                    From
                        (

                            With
                                params As (
                                    Select
                                        iot_swp_attendance_qry.fn_first_monday_of_month(p_yyyymm) As start_date,
                                        iot_swp_attendance_qry.fn_last_friday_of_month(p_yyyymm)  As end_date
                                    From
                                        dual
                                ),
                                days_details As (
                                    Select
                                        d_date,
                                        'Week_' || to_char(trunc((Rownum - 1) / 7) + 1) As week_num
                                    From
                                        ss_days_details, params
                                    Where
                                        d_date Between params.start_date And params.end_date
                                ),
                                work_days As (
                                    Select
                                        *
                                    From
                                        days_details d, params
                                    Where
                                        d.d_date Between params.start_date And nvl(params.end_date, sysdate)
                                        And d.d_date Not In (
                                            Select
                                                holiday
                                            From
                                                ss_holidays, params
                                            Where
                                                holiday Between params.start_date And nvl(params.end_date, sysdate)
                                        )
                                )
                            Select
                                e.empno                                                    As empno,
                                e.name                                                     As employee_name,
                                e.email                                                    As email,
                                e.parent                                                   As parent,
                                e.assign                                                   As assign,
                                e.emptype                                                  As emp_type,
                                e.grade                                                    As grade,
                                e.doj                                                      As doj,
                                params.end_date                                            As dol,
                                wd.d_date                                                  As d_date,
                                to_char(e.status)                                          As status,
                                to_char(iot_swp_common.fn_get_emp_pws(e.empno, wd.d_date)) As n_pws,
                                wd.week_num                                                As week_num
                            From
                                ss_emplmast e,
                                work_days   wd,
                                params
                            Where
                                (
                                e.status = 1

                                )
                                And e.emptype In (
                                    Select
                                        emptype
                                    From
                                        swp_include_emptype
                                )
                                And e.emptype <> 'S'
                                And e.assign Not In (
                                    Select
                                        assign
                                    From
                                        swp_exclude_assign
                                )
                                And e.parent Not In(
                                    '0163', '0187', '0232', '0276', '0290'
                                )
                                And e.grade <> v_exclude_grade
                        )
                    Where
                        d_date >= doj

                ) data;
        Return c;

    End;

End iot_swp_attendance_qry;
/

Grant Execute On "SELFSERVICE"."IOT_SWP_ATTENDANCE_QRY" To "TCMPL_APP_CONFIG";