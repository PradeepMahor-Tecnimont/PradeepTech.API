Create Or Replace Package Body selfservice.iot_swp_config_week As
    c_plan_close_code      Constant Number      := 0;
    c_plan_open_code       Constant Number      := 1;
    c_past_plan_code       Constant Number      := 0;
    c_cur_plan_code        Constant Number      := 1;
    c_future_plan_code     Constant Number      := 2;

    c_cause_curr_week_less Constant Number      := 1;
    c_cause_next_week_less Constant Number      := 2;

    c_pws                  Constant Number      := 100;

    c_ows                  Constant Number      := 1;
    c_sws                  Constant Number      := 2;
    c_dws                  Constant Number      := 3;

    c_general_area_catg    Constant Varchar2(4) := 'A002';

    Procedure sp_sws_to_ows_4non_eligible(
        p_next_week_mon Date
    ) As
        Cursor sws_emp_not_eligible Is
            Select
                *
            From
                (
                    Select
                        empno,
                        dol,
                        grade,
                        iot_swp_common.fn_get_emp_pws(empno)                  pws,
                        tcmpl_hr.pkg_common.fn_is_emp_resigned(empno)         is_emp_resigned,
                        tcmpl_hr.pkg_common.fn_get_emp_office_location(empno) emp_office_loc
                    From
                        ss_emplmast e
                    Where
                        e.status = 1 --and nvl(dol,trunc(sysdate)) >= trunc(sysdate)
                )
            Where
                pws                    = 2
                And (grade             = 'X1'
                    Or is_emp_resigned = ok
                    Or emp_office_loc In(
                        Select
                            office_location_code
                        From
                            swp_exclude_office_loc_4sws
                    ));
        Type typ_tab_sws_noneligible Is Table Of sws_emp_not_eligible%rowtype;
        tab_sws_noneligible typ_tab_sws_noneligible;
        v_key               Varchar2(10);
    Begin
        If p_next_week_mon Is Null Then
            Return;
        End If;
        Open sws_emp_not_eligible;
        Loop
            Fetch sws_emp_not_eligible Bulk Collect Into tab_sws_noneligible Limit 50;
            For i In 1..tab_sws_noneligible.count
            Loop
                Delete
                    From swp_primary_workspace
                Where
                    empno = tab_sws_noneligible(i).empno
                    And start_date >= p_next_week_mon;

                Delete
                    From swp_smart_attendance_plan
                Where
                    empno = tab_sws_noneligible(i).empno
                    And attendance_date >= p_next_week_mon;
                v_key := dbms_random.string('X', 10);

                Insert Into swp_primary_workspace (
                    key_id,
                    empno,
                    primary_workspace,
                    start_date,
                    modified_on,
                    modified_by,
                    active_code
                )
                Values (
                    v_key,
                    tab_sws_noneligible(i).empno,
                    c_ows,
                    p_next_week_mon,
                    sysdate,
                    'Sys',
                    c_future_plan_code
                );

            End Loop;
            Exit When sws_emp_not_eligible%notfound;
        End Loop;
    End;

    Procedure sp_del_invalid_swp_attend_plan(
        p_next_week_key_id Varchar2,
        p_next_week_mon    Varchar2,
        p_next_week_fri    Varchar2
    ) As
    Begin
        --
        --
        --Delete planning of ex-employees
        Delete
            From swp_smart_attendance_plan
        Where
            empno Not In (
                Select
                    empno
                From
                    ss_emplmast
                Where
                    status = 1
            )
            And week_key_id = p_next_week_key_id;

        --
        --
        --Delete planning employees not in Smart workspace
        Delete
            From swp_smart_attendance_plan
        Where
            week_key_id = p_next_week_key_id
            And empno Not In (
                (
                    Select
                        empno
                    From
                        (
                            Select
                                a.empno,
                                    Max(a.primary_workspace) Keep (Dense_Rank Last Order By start_date) primary_workspace,
                                    Max(a.start_date) Keep (Dense_Rank Last Order By start_date)        start_date
                            From
                                swp_primary_workspace a
                            Where
                                a.start_date <= p_next_week_fri
                                And a.empno In (
                                    Select
                                        empno
                                    From
                                        ss_emplmast
                                    Where
                                        status = 1
                                )
                            Group By empno
                        )
                    Where
                        primary_workspace = 2
                )
            );
        --
        --
        --Delete planning for holidays during next week
        Delete
            From swp_smart_attendance_plan
        Where
            attendance_date In (
                Select
                    trunc(holiday)
                From
                    ss_holidays
                Where
                    holiday Between p_next_week_mon And p_next_week_fri
            )
            And week_key_id = p_next_week_key_id;

        --
        --
        --Delete planning where desk has been already assigned by TEAM DMS
        Delete
            From swp_smart_attendance_plan
        Where
            deskid In (
                Select
                    deskid
                From
                    dms.dm_usermaster
                Where
                    deskid Not Like 'H%'
            )
            And week_key_id = p_next_week_key_id;

        --
        --
        --delete from smart attendance plan if desk is a GENERAL Catg desk
        Delete
            From swp_smart_attendance_plan
        Where
            deskid In (
                Select
                    deskid
                From
                    dms.dm_deskmaster
                Where
                    work_area In (
                        Select
                            area_key_id
                        From
                            dms.dm_desk_areas
                        Where
                            area_catg_code = c_general_area_catg
                    )

            )
            And week_key_id = p_next_week_key_id;
        --
    End;

    Function fn_get_work_days_count(
        p_start_date Date,
        p_end_date   Date
    ) Return Number As
        v_count Number;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            ss_days_details d
        Where
            d.d_date Between p_start_date And p_end_date
            And d_date Not In (
                Select
                    holiday
                From
                    ss_holidays
                Where
                    holiday Between p_start_date And p_end_date
                Union
                Select
                    trunc(holiday_leave_date) holiday_lv_date
                From
                    ss_holiday_against_leave
                Where
                    holiday_leave_date Between p_start_date And p_end_date

            );

        Return v_count;
    Exception
        When Others Then
            Return -1;
    End;

    Function fn_get_curr_week_work_days(p_sysdate Date) Return Number
    As
        v_mon_date Date;
        v_fri_date Date;
    Begin
        v_fri_date := iot_swp_common.get_friday_date(trunc(p_sysdate));
        v_mon_date := iot_swp_common.get_monday_date(trunc(p_sysdate));
        Return fn_get_work_days_count(v_mon_date, v_fri_date);
    End;

    Function fn_get_next_week_work_days(p_sysdate Date) Return Number
    As
        v_mon_date Date;
        v_fri_date Date;
    Begin
        v_fri_date := iot_swp_common.get_friday_date(trunc(p_sysdate + 6));
        v_mon_date := iot_swp_common.get_monday_date(trunc(p_sysdate + 6));
        Return fn_get_work_days_count(v_mon_date, v_fri_date);
    End;

    Function fn_get_prev_full_week(
        p_date Date
    ) Return swp_config_weeks%rowtype
    As
        v_count Number;
        Cursor cur_weeks Is
            Select
                *
            From
                swp_config_weeks
            Where
                start_date < p_date
                And start_date > p_date - 30
            Order By
                start_date Desc;
    Begin
        For c_row In cur_weeks
        Loop
            v_count := fn_get_work_days_count(c_row.start_date, c_row.end_date);

            If v_count >= 4 Then
                Return c_row;
            End If;
        End Loop;

    End;

    Function fn_get_prev_week_day_count(
        p_date Date
    ) Return Number As
        v_start_date Date;
        v_end_date   Date;
        v_ret_val    Number;
    Begin
        Select
            start_date, end_date
        Into
            v_start_date, v_end_date
        From
            (
                Select
                    start_date, end_date
                From
                    swp_config_weeks
                Where
                    start_date Between trunc(p_date - 10) And trunc(p_date - 1)
                Order By start_date Desc
            )
        Where
            Rownum = 1;
        v_ret_val := fn_get_work_days_count(v_start_date, v_end_date);
        Return v_ret_val;
    Exception
        When Others Then
            Return 0;
    End;

    Procedure sp_generate_workspace_summary(
        p_sysdate          Date,
        p_next_week_key_id Varchar2
    )
    As
        v_config_week_row swp_config_weeks%rowtype;
    Begin

        Select
            *
        Into
            v_config_week_row
        From
            swp_config_weeks
        Where
            key_id = p_next_week_key_id;
        --Delete existing records for the week
        Delete
            From swp_dept_workspace_summary
        Where
            week_key_id = p_next_week_key_id;

        --Insert data for the week
        --
        Insert Into swp_dept_workspace_summary(
            week_key_id,
            assign,
            ows_emp_count,
            sws_emp_count,
            dws_emp_count,
            modified_on
        )
        Select
            p_next_week_key_id,
            assign,
            Sum(ows) sum_pws,
            Sum(sws) sum_sws,
            Sum(dws) sum_ows,
            p_sysdate
        From
            (
                Select
                    pws.empno,
                    e.assign,
                    pws.start_date,
                    Case primary_workspace
                        When 1 Then
                            1
                        Else
                            0
                    End As ows,
                    Case primary_workspace
                        When 2 Then
                            1
                        Else
                            0
                    End As sws,
                    Case primary_workspace
                        When 3 Then
                            1
                        Else
                            0
                    End As dws

                From
                    swp_primary_workspace pws,
                    ss_emplmast           e
                Where
                    pws.empno      = e.empno
                    And e.status   = 1
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
                    And start_date = (
                        Select
                            Max(start_date)
                        From
                            swp_primary_workspace pws_sub
                        Where
                            pws_sub.empno = pws.empno
                            And pws_sub.start_date <= v_config_week_row.end_date
                    )
            )
        Group By
            assign;
    End;

    Procedure remove_temp_desks(p_sysdate Date) As
    Begin

        --remove left employees
        Delete
            From swp_temp_desk_allocation
        Where
            empno Not In (
                Select
                    empno
                From
                    ss_emplmast
                Where
                    status = 1
            );

        --remove employees already allocated desk in DMS
        Delete
            From swp_temp_desk_allocation
        Where
            empno In (
                Select
                    empno
                From
                    dms.dm_usermaster
                Where
                    deskid Not Like 'H%'
            )
            And (start_date Is Null Or start_date <= p_sysdate);

        --remove employees whose desk has been already allocated to other users
        Delete
            From swp_temp_desk_allocation
        Where
            deskid In (
                Select
                    deskid
                From
                    dms.dm_usermaster
            )
            And (start_date Is Null Or start_date <= p_sysdate);

    End;

    Procedure sp_set_plan_status(
        p_plan_type        Number,
        p_plan_status_code Number
    ) As
        row_config_week swp_config_weeks%rowtype;
    Begin
        Select
            *
        Into
            row_config_week
        From
            swp_config_weeks
        Where
            planning_flag = 2;
        If p_plan_type = c_pws Then
            Update
                swp_config_weeks
            Set
                pws_open = p_plan_status_code
            Where
                key_id = row_config_week.key_id;
        End If;
        If p_plan_type = c_sws Then
            Update
                swp_config_weeks
            Set
                sws_open = p_plan_status_code
            Where
                key_id = row_config_week.key_id;
        End If;

    End;

    Procedure send_mail_planning_open(
        p_plan_type Number
    )
    As

        Cursor cur_hod_sec Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        empno,
                        name                                           employee_name,
                        replace(email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By empno)) / 50) group_id
                    From
                        (
                            Select
                                e.empno,
                                e.name,
                                e.email
                            From
                                ss_emplmast e
                            Where
                                status = 1
                                And e.email Is Not Null
                                And e.empno Not In ('04132', '04600', '04484')
                                And e.empno In (
                                    Select
                                        hod
                                    From
                                        ss_costmast
                                    Union
                                    Select
                                        empno
                                    From
                                        ss_user_dept_rights
                                )
                        )
                    Order By empno
                )
            Group By
                group_id;
        --
        Type typ_tab_hod_sec Is
            Table Of cur_hod_sec%rowtype;
        tab_hod_sec     typ_tab_hod_sec;

        v_count         Number;
        v_mail_csv      Varchar2(2000);
        v_subject       Varchar2(1000);
        v_msg_body      Varchar2(2000);
        v_success       Varchar2(1000);
        v_message       Varchar2(500);
        row_config_week swp_config_weeks%rowtype;
    Begin
        Select
            *
        Into
            row_config_week
        From
            swp_config_weeks
        Where
            planning_flag = 2;
        If p_plan_type = c_pws Then
            v_msg_body := v_mail_body_pws_open;
            v_msg_body := replace(v_msg_body, '!PLAN_STARTDATE!', to_char(row_config_week.start_date, 'dd-Mon-yyyy'));
            v_subject  := 'SWP : Primary work space planning enabled for change';

        Elsif p_plan_type = c_sws Then
            v_msg_body := v_mail_body_sws_open;
            v_msg_body := replace(v_msg_body, '!PLAN_STARTDATE!', to_char(row_config_week.start_date, 'dd-Mon-yyyy'));
            v_subject  := 'SWP : Activation of Smart Workspace employees weekly planning';
        Else
            Return;
        End If;

        For email_csv_row In cur_hod_sec
        Loop
            v_mail_csv := email_csv_row.email_csv_list;

            tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
                p_person_id    => Null,
                p_meta_id      => Null,
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body1   => v_msg_body,
                p_mail_body2   => Null,
                p_mail_type    => 'HTML',
                p_mail_from    => 'SWP',
                p_message_type => v_success,
                p_message_text => v_message
            );

            /*
            send_mail_from_api(
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body    => v_msg_body,
                p_mail_profile => 'SELFSERVICE',
                --(example --> SQSI, OSD, ALHR, etc...)
                p_mail_format  => 'HTML',
                p_success      => v_success,
                p_message      => v_message
            );
            */
        End Loop;

    End;

    Procedure send_mail_planning_not_enable(
        p_cause Number
    ) As

        Cursor cur_hod_sec Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        empno,
                        name                                           employee_name,
                        replace(email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By empno)) / 50) group_id
                    From
                        (
                            Select
                                e.empno,
                                e.name,
                                e.email
                            From
                                ss_emplmast e
                            Where
                                status = 1
                                And e.email Is Not Null
                                And e.empno Not In ('04132', '04600', '04484')
                                And e.empno In (
                                    Select
                                        hod
                                    From
                                        ss_costmast
                                    Union
                                    Select
                                        empno
                                    From
                                        ss_user_dept_rights
                                )
                        )
                    Order By empno
                )
            Group By
                group_id;
        --
        Type typ_tab_hod_sec Is
            Table Of cur_hod_sec%rowtype;
        tab_hod_sec         typ_tab_hod_sec;

        v_count             Number;
        v_mail_csv          Varchar2(2000);
        v_subject           Varchar2(1000);
        v_msg_body          Varchar2(2000);
        v_success           Varchar2(1000);
        v_message           Varchar2(500);
        row_config_week     swp_config_weeks%rowtype;
        c_nextweek_planning Number := 2;
    Begin
        If p_cause = c_cause_next_week_less Then

            v_msg_body := v_mailbody_no_plan_week_next;

        Elsif p_cause = c_cause_curr_week_less Then

            v_msg_body := v_mailbody_no_plan_week_curr;

        Else
            Return;
        End If;
        Select
            *
        Into
            row_config_week
        From
            swp_config_weeks
        Where
            planning_flag = c_nextweek_planning;

        v_msg_body := replace(v_msg_body, '!PLAN_STARTDATE!', to_char(row_config_week.start_date, 'dd-Mon-yyyy'));
        v_subject  := 'SWP : Planning NOT ENABLED';

        For email_csv_row In cur_hod_sec
        Loop
            v_mail_csv := email_csv_row.email_csv_list;

            tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
                p_person_id    => Null,
                p_meta_id      => Null,
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body1   => v_msg_body,
                p_mail_body2   => Null,
                p_mail_type    => 'HTML',
                p_mail_from    => 'SWP',
                p_message_type => v_success,
                p_message_text => v_message
            );

        End Loop;

    End;

    Procedure sp_plan_visible_to_emp(
        p_show_plan Boolean
    )
    As
        v_flag_value                 Varchar2(2);
        show_future_plan_to_emp_flag Varchar2(4) := 'F004';
    Begin
        If p_show_plan Then
            v_flag_value := 'OK';
        Else
            v_flag_value := 'KO';

        End If;
        Update
            swp_flags
        Set
            flag_value = v_flag_value
        Where
            flag_id = show_future_plan_to_emp_flag;

    End;

    Function fn_is_day_num_of_week(
        p_sysdate    Date,
        p_day_number Number
    ) Return Boolean As
        v_mon_date Date;
        v_fri_date Date;
        v_count    Number;
    Begin

        If nvl(p_day_number, 0) = 0 Then
            Return False;
        End If;
        v_mon_date := iot_swp_common.get_monday_date(trunc(p_sysdate));
        v_fri_date := iot_swp_common.get_friday_date(trunc(p_sysdate));
        If p_day_number > 0 Then

            Select
                Count(*)
            Into
                v_count
            From
                ss_days_details
            Where
                d_date >= v_mon_date
                And d_date <= trunc(p_sysdate)
                And d_date Not In
                (
                    Select
                        trunc(holiday)
                    From
                        ss_holidays
                    Where
                        (holiday <= v_fri_date
                            And holiday >= trunc(v_mon_date))
                    Union
                    Select
                        trunc(holiday_leave_date) holiday_lv_date
                    From
                        ss_holiday_against_leave
                    Where
                        (holiday_leave_date <= v_fri_date
                            And holiday_leave_date >= trunc(v_mon_date))

                )
            Order By
                d_date;
        Else

            Select
                Count(*)
            Into
                v_count
            From
                ss_days_details
            Where
                d_date <= v_fri_date
                And d_date >= trunc(p_sysdate)
                And d_date Not In
                (
                    Select
                        trunc(holiday)
                    From
                        ss_holidays
                    Where
                        (holiday <= v_fri_date
                            And holiday >= trunc(v_mon_date))
                    Union
                    Select
                        trunc(holiday_leave_date) holiday_lv_date
                    From
                        ss_holiday_against_leave
                    Where
                        (holiday_leave_date <= v_fri_date
                            And holiday_leave_date >= trunc(v_mon_date))

                )
            Order By
                d_date;
            v_count := v_count * -1;
        End If;
        If v_count = p_day_number Then
            Return True;
        End If;
        Return False;
    Exception
        When Others Then
            Return False;
    End;

    Function fn_is_first_work_day_of_week(
        p_sysdate Date
    ) Return Boolean As
    Begin
        Return fn_is_day_num_of_week(p_sysdate, 1);
    Exception
        When Others Then
            Return False;
    End;

    Function fn_is_last_work_day_of_week(
        p_sysdate Date
    ) Return Boolean As
    Begin
        Return fn_is_day_num_of_week(p_sysdate, -1);
    Exception
        When Others Then
            Return False;
    End;

    Function fn_is_second_last_day_of_week(p_sysdate Date) Return Boolean As
        v_secondlast_workdate Date;
        v_fri_date            Date;
        Type rec Is Record(
                work_date     Date,
                work_day_desc Varchar2(100),
                rec_num       Number
            );

        Type typ_tab_work_day Is Table Of rec;
        tab_work_day          typ_tab_work_day;
    Begin
        v_fri_date := iot_swp_common.get_friday_date(trunc(p_sysdate));
        Select
            d_date As work_date,
            Case Rownum
                When 1 Then
                    'LAST'
                When 2 Then
                    'SECOND_LAST'
                Else
                    Null
            End    work_day_desc,
            Rownum As rec_num
        Bulk Collect
        Into
            tab_work_day
        From
            (
                Select
                    *
                From
                    ss_days_details
                Where
                    d_date <= v_fri_date
                    And d_date >= trunc(p_sysdate)
                    And d_date Not In
                    (
                        Select
                            trunc(holiday)
                        From
                            ss_holidays
                        Where
                            (holiday <= v_fri_date
                                And holiday >= trunc(p_sysdate))
                        Union
                        Select
                            trunc(holiday_leave_date) holiday_lv_date
                        From
                            ss_holiday_against_leave
                        Where
                            (holiday_leave_date <= v_fri_date
                                And holiday_leave_date >= trunc(p_sysdate))

                    )
                Order By d_date Desc
            )
        Where
            Rownum In(1, 2);
        If tab_work_day.count = 2 Then
            --v_sysdate EQUAL SECOND_LAST working day "THURSDAY"
            If p_sysdate = tab_work_day(2).work_date Then --SECOND_LAST working day
                Return True;
            End If;
        End If;
        Return False;
    Exception
        When Others Then
            Return False;
    End;

    Function fn_is_action_day_4_flag(
        p_action_flag Varchar2,
        p_sysdate     Date
    ) Return Boolean As

        v_no_of_days_before_fri Number;
        v_date                  Date;
        v_fri_date              Date;
        v_count                 Number;

    Begin
        v_fri_date := iot_swp_common.get_friday_date(trunc(p_sysdate));
        Select
            flag_value_number
        Into
            v_no_of_days_before_fri
        From
            swp_flags
        Where
            flag_id = p_action_flag;

        --

        Select
            d_date
        Into
            v_date
        From
            (
                Select
                    d_date, Rownum row_num
                From
                    (
                        Select
                            d_date
                        From
                            ss_days_details
                        Where
                            d_date Between To_Date(v_fri_date) - 5 And To_Date(v_fri_date)
                            And d_date Not In (
                                Select
                                    holiday
                                From
                                    ss_holidays
                                Where
                                    holiday Between To_Date(v_fri_date) - 5 And To_Date(v_fri_date)
                                Union
                                Select
                                    trunc(holiday_leave_date) holiday_lv_date
                                From
                                    ss_holiday_against_leave
                                Where
                                    holiday_leave_date Between To_Date(v_fri_date) - 5 And To_Date(v_fri_date)

                            )
                        Order By d_date Desc
                    )
            )
        Where
            row_num = v_no_of_days_before_fri + 1;

        If v_date = p_sysdate Then
            Return True;
        Else
            Return False;
        End If;
    Exception
        When Others Then
            Return False;
    End;

    Function fn_is_close_day_4_flag(
        p_action_flag   Varchar2,
        p_duration_flag Varchar2,
        p_sysdate       Date
    ) Return Boolean As

        v_no_of_days_before_fri Number;
        v_date                  Date;
        v_fri_date              Date;
        v_count                 Number;
        v_duration              Number;
    Begin
        v_fri_date := iot_swp_common.get_friday_date(trunc(p_sysdate));
        Select
            flag_value_number
        Into
            v_no_of_days_before_fri
        From
            swp_flags
        Where
            flag_id = p_action_flag;

        Select
            flag_value_number
        Into
            v_duration
        From
            swp_flags
        Where
            flag_id = p_duration_flag;

        --

        Select
            d_date
        Into
            v_date
        From
            (
                Select
                    d_date, Rownum row_num
                From
                    (
                        Select
                            d_date
                        From
                            ss_days_details
                        Where
                            d_date Between To_Date(v_fri_date) - 5 And To_Date(v_fri_date)
                            And d_date Not In (
                                Select
                                    holiday
                                From
                                    ss_holidays
                                Where
                                    holiday Between To_Date(v_fri_date) - 5 And To_Date(v_fri_date)
                                Union
                                Select
                                    trunc(holiday_leave_date) holiday_lv_date
                                From
                                    ss_holiday_against_leave
                                Where
                                    holiday_leave_date Between To_Date(v_fri_date) - 5 And To_Date(v_fri_date)

                            )
                        Order By d_date Desc
                    )
            )
        Where
            row_num = v_no_of_days_before_fri + 1 - v_duration;

        If v_date = p_sysdate Then
            Return True;
        Else
            Return False;
        End If;
    Exception
        When Others Then
            Return False;
    End;

    Procedure sp_del_dms_desk_for_sws_users As
        Cursor cur_desk_plan_dept Is
            Select
                *
            From
                swp_include_assign_4_seat_plan;
        c1      Sys_Refcursor;

        --
        Cursor cur_sws Is
            Select
                a.empno,
                a.primary_workspace,
                a.start_date,
                iot_swp_common.get_swp_planned_desk(
                    p_empno => a.empno
                ) swp_desk_id
            From
                swp_primary_workspace a,
                ss_emplmast           e
            Where
                a.empno                 = e.empno
                And e.status            = 1
                And a.primary_workspace = 2
                And trunc(a.start_date) = (
                    Select
                        Max(trunc(start_date))
                    From
                        swp_primary_workspace b
                    Where
                        b.empno = a.empno
                        And b.start_date <= sysdate
                )
                And e.assign In (
                    Select
                        assign
                    From
                        swp_include_assign_4_seat_plan
                );
        Type typ_tab_sws Is Table Of cur_sws%rowtype Index By Binary_Integer;
        tab_sws typ_tab_sws;
    Begin
        Open cur_sws;
        Loop
            Fetch cur_sws Bulk Collect Into tab_sws Limit 50;
            For i In 1..tab_sws.count
            Loop
                iot_swp_dms.sp_remove_desk_user(
                    p_person_id => Null,
                    p_meta_id   => Null,
                    p_empno     => tab_sws(i).empno,
                    p_deskid    => tab_sws(i).swp_desk_id
                );
            End Loop;
            Exit When cur_sws%notfound;
        End Loop;
    End;

    --

    Procedure sp_mail_sws_plan_to_emp
    As
        cur_dept_rows      Sys_Refcursor;
        cur_emp_week_plan  Sys_Refcursor;
        row_config_week    swp_config_weeks%rowtype;
        v_mail_body        Varchar2(4000);
        v_day_row          Varchar2(1000);
        v_emp_mail         Varchar2(100);
        v_msg_type         Varchar2(15);
        v_msg_text         Varchar2(1000);
        v_emp_desk         Varchar2(10);
        Cursor cur_sws_emp_list(cp_monday_date Date,
                                cp_friday_date Date) Is
            Select
                a.empno,
                e.name As employee_name,
                a.primary_workspace,
                a.start_date
            From
                swp_primary_workspace a,
                ss_emplmast           e
            Where
                e.status                = 1
                And a.empno             = e.empno
                And a.primary_workspace = 2
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
                And trunc(a.start_date) = (
                    Select
                        Max(trunc(start_date))
                    From
                        swp_primary_workspace b
                    Where
                        b.empno = a.empno
                        And b.start_date <= cp_friday_date
                )
                And e.empno Not In(
                    Select
                        empno
                    From
                        swp_exclude_emp
                    Where
                        empno = e.empno
                        And (cp_monday_date Between start_date And end_date
                            Or cp_friday_date Between start_date And end_date)
                    Minus

                    Select
                        empno
                    From
                        swp_exclude_emp
                    Where
                        empno = e.empno
                        And (start_date Between cp_monday_date And cp_friday_date
                            Or end_date Between cp_monday_date And cp_friday_date)
                )
                And grade <> 'X1';
        Type typ_tab_sws_emp_list Is Table Of cur_sws_emp_list%rowtype;
        tab_sws_emp_list   typ_tab_sws_emp_list;

        Cursor cur_emp_smart_attend_plan(cp_empno      Varchar2,
                                         cp_start_date Date,
                                         cp_end_date   Date) Is
            With
                atnd_days As (
                    Select
                        w.empno,
                        Trim(w.attendance_date) As attendance_date,
                        Trim(w.deskid)          As deskid,
                        1                       As planned,
                        dm.office               As office,
                        dm.floor                As floor,
                        dm.wing                 As wing,
                        dm.bay                  As bay
                    From
                        swp_smart_attendance_plan w,
                        dms.dm_deskmaster         dm
                    Where
                        w.empno      = cp_empno
                        And w.deskid = dm.deskid(+)
                        And attendance_date Between cp_start_date And cp_end_date
                )
            Select
                e.empno                   As empno,
                dd.d_day,
                dd.d_date,
                nvl(atnd_days.planned, 0) As planned,
                atnd_days.deskid          As deskid,
                atnd_days.office          As office,
                atnd_days.floor           As floor,
                atnd_days.wing            As wing,
                atnd_days.bay             As bay
            From
                ss_emplmast     e,
                ss_days_details dd,
                atnd_days
            Where
                e.empno       = Trim(cp_empno)

                And dd.d_date = atnd_days.attendance_date
                And d_date Between cp_start_date And cp_end_date
            Order By
                dd.d_date;
        Type typ_tab_emp_smart_plan Is Table Of cur_emp_smart_attend_plan%rowtype;
        tab_emp_smart_plan typ_tab_emp_smart_plan;
    Begin
        Select
            *
        Into
            row_config_week
        From
            swp_config_weeks
        Where
            planning_flag = 2;

        Open cur_sws_emp_list(trunc(row_config_week.start_date), trunc(row_config_week.end_date));
        Loop
            Fetch cur_sws_emp_list Bulk Collect Into tab_sws_emp_list Limit 50;
            For i In 1..tab_sws_emp_list.count
            Loop
                Begin
                    Select
                        email
                    Into
                        v_emp_mail
                    From
                        ss_emplmast
                    Where
                        empno      = tab_sws_emp_list(i).empno
                        And status = 1;
                    If v_emp_mail Is Null Then
                        Continue;
                    End If;
                Exception
                    When Others Then
                        Continue;
                End;

                --PRIMARY WORK SPACE
                If tab_sws_emp_list(i).primary_workspace = 1 Then
                    v_mail_body := v_ows_mail_body;
                    v_mail_body := replace(v_mail_body, '!@User@!', tab_sws_emp_list(i).employee_name);
                    v_mail_body := replace(v_mail_body, '!@StartDate@!', to_char(row_config_week.start_date, 'dd-Mon-yyyy'));
                    v_mail_body := replace(v_mail_body, '!@EndDate@!', to_char(row_config_week.end_date, 'dd-Mon-yyyy'));

                    /*
                    v_emp_desk := get_swp_planned_desk(
                            p_empno => emp_row.empno
                    );
                    */
                    --SMART WORK SPACE
                Elsif tab_sws_emp_list(i).primary_workspace = 2 Then
                    If cur_emp_smart_attend_plan%isopen Then
                        Close cur_emp_smart_attend_plan;
                    End If;
                    Open cur_emp_smart_attend_plan(tab_sws_emp_list(i).empno, row_config_week.start_date, row_config_week.
                    end_date);
                    Fetch cur_emp_smart_attend_plan Bulk Collect Into tab_emp_smart_plan Limit 5;
                    For i In 1..tab_emp_smart_plan.count
                    Loop

                        v_day_row := nvl(v_day_row, '') || v_sws_empty_day_row;
                        v_day_row := replace(v_day_row, 'DESKID', tab_emp_smart_plan(i).deskid);
                        v_day_row := replace(v_day_row, 'DATE', to_char(tab_emp_smart_plan(i).d_date, 'dd-Mon-yyyy'));
                        v_day_row := replace(v_day_row, 'DAY', tab_emp_smart_plan(i).d_day);
                        v_day_row := replace(v_day_row, 'OFFICE', tab_emp_smart_plan(i).office);
                        v_day_row := replace(v_day_row, 'FLOOR', tab_emp_smart_plan(i).floor);
                        v_day_row := replace(v_day_row, 'WING', tab_emp_smart_plan(i).wing);

                    End Loop;

                    If v_day_row = v_sws_empty_day_row Or v_day_row Is Null Then
                        Continue;
                    End If;
                    v_mail_body := v_sws_mail_body;
                    v_mail_body := replace(v_mail_body, '!@StartDate@!', to_char(row_config_week.start_date, 'dd-Mon-yyyy'));
                    v_mail_body := replace(v_mail_body, '!@EndDate@!', to_char(row_config_week.end_date, 'dd-Mon-yyyy'));
                    v_mail_body := replace(v_mail_body, '!@User@!', tab_sws_emp_list(i).employee_name);
                    v_mail_body := replace(v_mail_body, '!@WEEKLYPLANNING@!', v_day_row);

                End If;
                tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
                    p_person_id    => Null,
                    p_meta_id      => Null,
                    p_mail_to      => v_emp_mail,
                    p_mail_cc      => Null,
                    p_mail_bcc     => Null,
                    p_mail_subject => 'SWP : Attendance schedule for Smart Workspace',
                    p_mail_body1   => v_mail_body,
                    p_mail_body2   => Null,
                    p_mail_type    => 'HTML',
                    p_mail_from    => 'SELFSERVICE',
                    p_message_type => v_msg_type,
                    p_message_text => v_msg_text
                );
                Commit;
                v_day_row   := Null;
                v_mail_body := Null;
                v_msg_type  := Null;
                v_msg_text  := Null;
            End Loop;
            Exit When cur_sws_emp_list%notfound;

        End Loop;

    End;

    Procedure sp_mail_ows_plan_to_emp
    As
        cur_dept_rows     Sys_Refcursor;
        cur_emp_week_plan Sys_Refcursor;
        row_config_week   swp_config_weeks%rowtype;
        v_mail_body       Varchar2(4000);
        v_day_row         Varchar2(1000);
        v_emp_mail        Varchar2(100);
        v_msg_type        Varchar2(15);
        v_msg_text        Varchar2(1000);
        v_emp_desk        Varchar2(10);
        Cursor cur_ows_emp_list(cp_monday_date Date,
                                cp_friday_date Date) Is

            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        a.empno,
                        e.name                                           As employee_name,
                        replace(e.email, ',', '.')                       user_email,
                        a.primary_workspace,
                        a.start_date,
                        ceil((Row_Number() Over(Order By e.empno)) / 50) group_id
                    From
                        swp_primary_workspace a,
                        ss_emplmast           e
                    Where
                        e.status                = 1
                        And a.empno             = e.empno
                        And a.primary_workspace = 1
                        And e.emptype In (
                            Select
                                emptype
                            From
                                swp_include_emptype
                        )
                        And e.assign Not In(
                            Select
                                assign
                            From
                                swp_exclude_assign
                        )
                        And trunc(a.start_date) = (
                            Select
                                Max(trunc(start_date))
                            From
                                swp_primary_workspace b
                            Where
                                b.empno = a.empno
                                And b.start_date <= cp_friday_date
                        )
                        And e.empno Not In(
                            Select
                                empno
                            From
                                swp_exclude_emp
                            Where
                                empno = e.empno
                                And (cp_monday_date Between start_date And end_date
                                    Or cp_friday_date Between start_date And end_date)
                        )
                        And e.grade <> 'X1'
                        And e.email Is Not Null
                        And e.empno Not In ('04484')
                ) data
            Group By
                group_id;

        Type typ_tab_ows_emp_list Is Table Of cur_ows_emp_list%rowtype;
        tab_ows_emp_list  typ_tab_ows_emp_list;

    Begin

        Select
            *
        Into
            row_config_week
        From
            swp_config_weeks
        Where
            planning_flag = 2;

        v_mail_body := v_ows_mail_body;
        v_mail_body := replace(v_mail_body, '!@StartDate@!', to_char(row_config_week.start_date, 'dd-Mon-yyyy'));
        v_mail_body := replace(v_mail_body, '!@EndDate@!', to_char(row_config_week.end_date, 'dd-Mon-yyyy'));

        Open cur_ows_emp_list(trunc(row_config_week.start_date), trunc(row_config_week.end_date));
        Loop
            Fetch cur_ows_emp_list Bulk Collect Into tab_ows_emp_list Limit 50;
            For i In 1..tab_ows_emp_list.count
            Loop

                tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
                    p_person_id    => Null,
                    p_meta_id      => Null,
                    p_mail_to      => Null,
                    p_mail_cc      => Null,
                    p_mail_bcc     => tab_ows_emp_list(i).email_csv_list,
                    p_mail_subject => 'SWP : Attendance schedule for Office Workspace',
                    p_mail_body1   => v_mail_body,
                    p_mail_body2   => Null,
                    p_mail_type    => 'HTML',
                    p_mail_from    => 'SELFSERVICE',
                    p_message_type => v_msg_type,
                    p_message_text => v_msg_text
                );
                Commit;
                v_day_row  := Null;

                v_msg_type := Null;
                v_msg_text := Null;
            End Loop;
            Exit When cur_ows_emp_list%notfound;

        End Loop;

    End;

    --

    Procedure sp_add_new_joinees_to_pws
    As
        v_config_week_row swp_config_weeks%rowtype;
        v_count           Number;

    Begin
        Insert Into swp_primary_workspace (key_id, empno, primary_workspace, start_date, modified_on, modified_by, active_code,
            assign_code)
        Select
            dbms_random.string('X', 10),
            empno,

            Case
                When dd.assign Is Not Null Then
                    3
                Else
                    1
            End As pws,

            --1   As pws,
            greatest(doj, To_Date('31-Jan-2022')),
            sysdate,
            'Sys',
            2,
            e.assign
        From
            ss_emplmast                e,
            swp_deputation_departments dd
        Where
            e.status     = 1
            And e.assign = dd.assign(+)
            And emptype In (
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
            And empno Not In (
                Select
                    empno
                From
                    swp_primary_workspace
            );

        --Add new joinees to Dept Quota
        Select
            Count(*)
        Into
            v_count
        From
            swp_config_weeks
        Where
            planning_flag = 2;

        --Iff planning not exists then RETURN
        If v_count = 0 Then
            Return;
        End If;
        Select
            *
        Into
            v_config_week_row
        From
            swp_config_weeks
        Where
            planning_flag = 2;
        sp_generate_workspace_summary(
            p_sysdate          => sysdate,
            p_next_week_key_id => v_config_week_row.key_id
        );
        --************----
    End sp_add_new_joinees_to_pws;

    Procedure init_configuration(p_sysdate Date) As
        v_cur_week_mon        Date;
        v_cur_week_fri        Date;
        v_next_week_key_id    Varchar2(8);
        v_current_week_key_id Varchar2(8);
        v_count               Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            swp_config_weeks;
        If v_count > 0 Then
            Return;
        End If;
        v_cur_week_mon        := iot_swp_common.get_monday_date(p_sysdate);
        v_cur_week_fri        := iot_swp_common.get_friday_date(p_sysdate);
        v_current_week_key_id := dbms_random.string('X', 8);
        --Insert New Plan dates
        Insert Into swp_config_weeks(
            key_id,
            start_date,
            end_date,
            planning_flag,
            pws_open,
            ows_open,
            sws_open
        )
        Values(
            v_current_week_key_id,
            v_cur_week_mon,
            v_cur_week_fri,
            c_cur_plan_code,
            c_plan_close_code,
            c_plan_close_code,
            c_plan_close_code
        );

    End;

    --
    Procedure close_planning As
        b_update_planning_flag Boolean := False;
    Begin
        Update
            swp_config_weeks
        Set
            pws_open = c_plan_close_code,
            ows_open = c_plan_close_code,
            sws_open = c_plan_close_code
        Where
            pws_open    = c_plan_open_code
            Or ows_open = c_plan_open_code
            Or sws_open = c_plan_open_code;
        If b_update_planning_flag Then
            Update
                swp_config_weeks
            Set
                planning_flag = c_past_plan_code
            Where
                planning_flag = c_cur_plan_code;

            Update
                swp_config_weeks
            Set
                planning_flag = c_cur_plan_code
            Where
                planning_flag = c_future_plan_code;

        End If;
    End close_planning;
    --

    Procedure do_dms_data_to_plan(p_week_key_id Varchar2) As
    Begin
        Delete
            From dms.dm_usermaster_swp_plan;
        Delete
            From dms.dm_deskallocation_swp_plan;
        Delete
            From dms.dm_desklock_swp_plan;
        Commit;

        Insert Into dms.dm_usermaster_swp_plan(
            fk_week_key_id,
            empno,
            deskid,
            costcode,
            dep_flag
        )
        Select
            p_week_key_id,
            empno,
            deskid,
            costcode,
            dep_flag
        From
            dms.dm_usermaster;

        Insert Into dms.dm_deskallocation_swp_plan(
            fk_week_key_id,
            deskid,
            assetid
        )
        Select
            p_week_key_id,
            deskid,
            assetid
        From
            dms.dm_deskallocation;

        Insert Into dms.dm_desklock_swp_plan(
            fk_week_key_id,
            unqid,
            empno,
            deskid,
            targetdesk,
            blockflag,
            blockreason
        )
        Select
            p_week_key_id,
            unqid,
            empno,
            deskid,
            targetdesk,
            blockflag,
            blockreason
        From
            dms.dm_desklock;
    End;

    Procedure do_dms_snapshot(p_sysdate Date) As

    Begin

        Delete
            From dms.dm_deskallocation_snapshot
        Where
            snapshot_date = p_sysdate;

        Insert Into dms.dm_deskallocation_snapshot(
            snapshot_date,
            deskid,
            assetid
        )
        Select
            p_sysdate,
            deskid,
            assetid
        From
            dms.dm_deskallocation;

        Delete
            From dms.dm_usermaster_snapshot
        Where
            snapshot_date = p_sysdate;

        Insert Into dms.dm_usermaster_snapshot(
            snapshot_date,
            empno,
            deskid,
            costcode,
            dep_flag
        )
        Select
            p_sysdate,
            empno,
            deskid,
            costcode,
            dep_flag
        From
            dms.dm_usermaster;

        Delete
            From dms.dm_desklock_snapshot
        Where
            snapshot_date = p_sysdate;

        Insert Into dms.dm_desklock_snapshot(
            snapshot_date,
            unqid,
            empno,
            deskid,
            targetdesk,
            blockflag,
            blockreason
        )
        Select
            p_sysdate,
            unqid,
            empno,
            deskid,
            targetdesk,
            blockflag,
            blockreason
        From
            dms.dm_desklock;

        Commit;
        tcmpl_app_config.task_scheduler.sp_log_success(
            p_proc_name     => 'Selfservice.iot_swp_config_week.do_dms_snap_shot',
            p_business_name => 'DMS SnapShot'
        );
    Exception
        When Others Then

            tcmpl_app_config.task_scheduler.sp_log_failure(
                p_proc_name     => 'Selfservice.iot_swp_config_week.do_dms_snap_shot',
                p_business_name => 'DMS SnapShot',
                p_message       => 'EX-' || sqlcode || ' - ' || sqlerrm);

    End;
    --
    Procedure toggle_plan_future_to_curr(
        p_sysdate Date
    ) As
        rec_config_week swp_config_weeks%rowtype;
        v_sysdate       Date;

    Begin
        v_sysdate := trunc(p_sysdate);

        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            key_id In (
                Select
                    key_id
                From
                    (
                        Select
                            key_id
                        From
                            swp_config_weeks
                        Order By start_date Desc
                    )
                Where
                    Rownum = 1
            );
        /*
                If rec_config_week.start_date != v_sysdate Then
                    Return;
                End If;
                --
        */
        sp_plan_visible_to_emp(p_show_plan => False);
        --------------
        --Close Planning
        close_planning;

        --toggle CURRENT to PAST
        Update
            swp_config_weeks
        Set
            planning_flag = c_past_plan_code
        Where
            planning_flag = c_cur_plan_code;

        --toggle FUTURE to CURRENT
        Update
            swp_config_weeks
        Set
            planning_flag = c_cur_plan_code
        Where
            planning_flag = c_future_plan_code;

        --Toggle WorkSpace planning FUTURE to CURRENT
        Update
            swp_primary_workspace
        Set
            active_code = c_past_plan_code
        Where
            active_code != c_past_plan_code;

        Update
            swp_primary_workspace pws
        Set
            active_code = c_cur_plan_code
        Where
            pws.empno In (
                Select
                    empno
                From
                    ss_emplmast
                Where
                    status = 1
                    And emptype In (
                        Select
                            emptype
                        From
                            swp_include_emptype
                    )
            )
            And start_date = (
                Select
                    Max(start_date)
                From
                    swp_primary_workspace
                Where
                    empno = pws.empno
            );

    End toggle_plan_future_to_curr;
    --
    Procedure rollover_n_open_planning(p_sysdate Date) As
        v_next_week_mon       Date;
        v_next_week_fri       Date;
        v_next_week_key_id    Varchar2(8);

        rec_config_week       swp_config_weeks%rowtype;
        v_full_week           swp_config_weeks%rowtype;
        v_days_to_add         Number;
        v_prev_week_day_count Number;
    Begin
        v_next_week_mon       := iot_swp_common.get_monday_date(p_sysdate + 6);
        v_next_week_fri       := iot_swp_common.get_friday_date(p_sysdate + 6);

        v_next_week_mon       := trunc(v_next_week_mon);
        v_next_week_fri       := trunc(v_next_week_fri);

        --Get current week key id
        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            key_id In (
                Select
                    key_id
                From
                    (
                        Select
                            key_id
                        From
                            swp_config_weeks

                        Order By start_date Desc
                    )
                Where
                    Rownum = 1

            );
        --Check planning for next week already open
        If rec_config_week.start_date >= v_next_week_mon Then
            Return;
        End If;

        --Close and toggle existing planning
        If rec_config_week.planning_flag = c_future_plan_code Then
            toggle_plan_future_to_curr(p_sysdate);
        End If;

        v_next_week_key_id    := dbms_random.string('X', 8);
        --Insert New Plan dates
        Insert Into swp_config_weeks(
            key_id,
            start_date,
            end_date,
            planning_flag,
            pws_open,
            ows_open,
            sws_open
        )
        Values(
            v_next_week_key_id,
            v_next_week_mon,
            v_next_week_fri,
            c_future_plan_code,
            c_plan_close_code,
            c_plan_close_code,
            c_plan_close_code
        );

        --
        --Roll-over SMART Attendance Plan
        --

        --if exists, Delete smart attendance plan for next week
        Delete
            From swp_smart_attendance_plan
        Where
            attendance_date Between v_next_week_mon And v_next_week_fri;
        v_prev_week_day_count := fn_get_prev_week_day_count(v_next_week_mon);
        If v_prev_week_day_count = 5 Then
            v_full_week   := fn_get_prev_full_week(v_next_week_mon);
            v_days_to_add := v_next_week_mon - v_full_week.start_date;
            --Rollover current weeks plan to next week
            Insert Into swp_smart_attendance_plan(
                key_id,
                ws_key_id,
                empno,
                attendance_date,
                modified_on,
                modified_by,
                deskid,
                week_key_id
            )
            Select
                dbms_random.string('X', 10),
                a.ws_key_id,
                a.empno,
                trunc(a.attendance_date) + v_days_to_add,
                p_sysdate,
                'Sys',
                a.deskid,
                v_next_week_key_id
            From
                swp_smart_attendance_plan a
            Where
                week_key_id = v_full_week.key_id;
        Else
            iot_swp_auto_assign_desk.sp_auto_generate_plan;
        End If;
        --delete invalid smart attendance plan
        --
        sp_del_invalid_swp_attend_plan(
            p_next_week_key_id => v_next_week_key_id,
            p_next_week_mon    => v_next_week_mon,
            p_next_week_fri    => v_next_week_fri
        );
        --
        --
        --
        sp_sws_to_ows_4non_eligible(v_next_week_mon);
        --
        --
        --Generate DEPT-Wise workspace summary for Quota purpose
        sp_generate_workspace_summary(
            p_sysdate          => p_sysdate,
            p_next_week_key_id => v_next_week_key_id
        );
        --
        --
        --do snapshot of DESK+USER & DESK+ASSET & Also DESKLOCK mapping
        --do_dms_snapshot(trunc(p_sysdate));
        ---

        --do_dms_data_to_plan(v_next_week_key_id);

    End rollover_n_open_planning;

    --
    Procedure sp_configuration Is
        v_secondlast_workdate      Date;
        v_sysdate                  Date;
        v_fri_date                 Date;
        is_second_last_wkday       Boolean;

        is_first_work_date         Boolean;
        is_last_work_date          Boolean;

        b_curr_week_less_work_days Boolean;
        b_next_week_less_work_days Boolean;

        b_open_pws                 Boolean;
        b_open_sws                 Boolean;
        b_close_pws                Boolean;
        b_close_sws                Boolean;

        Type rec Is Record(
                work_date     Date,
                work_day_desc Varchar2(100),
                rec_num       Number
            );

        Type typ_tab_work_day Is Table Of rec;
        tab_work_day               typ_tab_work_day;
        v_flag_open_pws_plan       Varchar2(4)  := 'F005';
        v_flag_open_sws_plan       Varchar2(4)  := 'F006';

        v_flag_close_pws_plan      Varchar2(4)  := 'F007';
        v_flag_close_sws_plan      Varchar2(4)  := 'F008';

        v_cur_env                  Varchar2(60);
        c_dev_env                  Varchar2(60) := 'tpldev11g.ticb.comp';
        c_qual_env                 Varchar2(60) := lower('TPLQUALORADB');
        ok                         Varchar2(2)  := 'OK';
        not_ok                     Varchar2(2)  := 'KO';
        row_plan_week              swp_config_weeks%rowtype;
        v_next_week_workdays       Number;
        v_curr_week_workdays       Number;
        v_min_work_days_required   Number;
    Begin
        v_next_week_workdays       := 0;
        v_curr_week_workdays       := 0;

        sp_add_new_joinees_to_pws;
        v_min_work_days_required   := 4;

        v_sysdate                  := trunc(sysdate);
        --v_sysdate                  
        v_fri_date                 := iot_swp_common.get_friday_date(trunc(v_sysdate));

        v_next_week_workdays       := fn_get_next_week_work_days(v_sysdate);
        v_curr_week_workdays       := fn_get_curr_week_work_days(v_sysdate);
        is_last_work_date          := fn_is_day_num_of_week(v_sysdate, -1);

        b_curr_week_less_work_days := v_curr_week_workdays < v_min_work_days_required;

        b_next_week_less_work_days := v_next_week_workdays < v_min_work_days_required;

        --

        init_configuration(v_sysdate);

        do_dms_snapshot(v_sysdate);

        If to_char(v_sysdate, 'Dy') = 'Mon' Then
            toggle_plan_future_to_curr(v_sysdate);
        End If;

        is_second_last_wkday       := fn_is_second_last_day_of_week(v_sysdate);
        is_first_work_date         := fn_is_first_work_day_of_week(v_sysdate);

        b_open_pws                 := fn_is_action_day_4_flag(
                                          p_action_flag => v_flag_open_pws_plan,
                                          p_sysdate     => v_sysdate
                                      );
        b_close_pws                := fn_is_close_day_4_flag(
                                          p_action_flag   => v_flag_open_pws_plan,
                                          p_duration_flag => v_flag_close_pws_plan,
                                          p_sysdate       => v_sysdate
                                      );

        b_open_sws                 := fn_is_action_day_4_flag(
                                          p_action_flag => v_flag_open_sws_plan,
                                          p_sysdate     => v_sysdate
                                      );

        b_close_sws                := fn_is_close_day_4_flag(
                                          p_action_flag   => v_flag_open_sws_plan,
                                          p_duration_flag => v_flag_close_sws_plan,
                                          p_sysdate       => v_sysdate
                                      );

        --

        --PWS / SWS is open
        --OR
        --Current week has less number of work DAYS
        --AND
        --It is first working day
        If b_open_pws Or b_open_sws Or (is_first_work_date And b_curr_week_less_work_days) Then
            rollover_n_open_planning(v_sysdate);
        End If;

        --Current week of Next week has less numbe of workdays
        If b_curr_week_less_work_days Or b_next_week_less_work_days Then

            --Send mail Planning shall not be enabled.
            If (Not b_curr_week_less_work_days) And b_open_pws Then
                send_mail_planning_not_enable(c_cause_next_week_less);
            End If;

            b_open_sws := False;
            b_open_pws := False;

        End If;

        --Current week has less number of work DAYS
        --AND It is first working day
        --Send mail Planning shall not be enabled.
        If b_curr_week_less_work_days And is_first_work_date Then
            send_mail_planning_not_enable(c_cause_curr_week_less);

        End If;

        -- do primary workspace planning open
        If b_open_pws Then

            --When Current + Next week has required work days
            If Not(b_curr_week_less_work_days Or b_next_week_less_work_days) Then
                --Change plannig status
                sp_set_plan_status(
                    p_plan_type        => c_pws,
                    p_plan_status_code => c_plan_open_code
                );
                sp_plan_visible_to_emp(p_show_plan => False);
                send_mail_planning_open(
                    p_plan_type => c_pws
                );

            End If;
        End If;

        --do primary workspace planning close
        If b_close_pws Then
            sp_set_plan_status(
                p_plan_type        => c_pws,
                p_plan_status_code => c_plan_close_code
            );
        End If;

        -- do smart workspace planning open
        If b_open_sws Then
            --if current and next week has required work days
            If Not (b_curr_week_less_work_days Or b_next_week_less_work_days) Then
                sp_set_plan_status(
                    p_plan_type        => c_sws,
                    p_plan_status_code => c_plan_open_code
                );
                sp_plan_visible_to_emp(
                    p_show_plan => False
                );
                send_mail_planning_open(
                    p_plan_type => c_sws
                );
            End If;
        End If;

        -- do smart workspace planning close
        If b_close_sws Then
            sp_set_plan_status(
                p_plan_type        => c_sws,
                p_plan_status_code => c_plan_close_code
            );
        End If;

        -- last day of the week
        If is_last_work_date Then
            --Auto generate SMART attendance plan
            If v_next_week_workdays >= v_min_work_days_required Then
                iot_swp_auto_assign_desk.sp_auto_generate_plan;
            End If;

            close_planning;
            sp_plan_visible_to_emp(
                p_show_plan => True
            );

            --send mail to employees
            sp_mail_sws_plan_to_emp;
            sp_mail_ows_plan_to_emp;
        End If;
    End sp_configuration;

End iot_swp_config_week;