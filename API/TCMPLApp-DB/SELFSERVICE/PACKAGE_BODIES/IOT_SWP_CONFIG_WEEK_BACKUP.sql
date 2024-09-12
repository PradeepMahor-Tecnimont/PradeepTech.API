create or replace Package Body iot_swp_config_week As
    c_plan_close_code  Constant Number := 0;
    c_plan_open_code   Constant Number := 1;
    c_past_plan_code   Constant Number := 0;
    c_cur_plan_code    Constant Number := 1;
    c_future_plan_code Constant Number := 2;

    Procedure send_mail_pws_planning_open
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

        v_msg_body := v_mail_body_pws_open;
        v_msg_body := replace(v_msg_body, '!PLAN_STARTDATE!', to_char(row_config_week.start_date, 'dd-Mon-yyyy'));
        v_subject  := 'SWP : Primary work space planning enabled for change';
        For email_csv_row In cur_hod_sec
        Loop
            v_mail_csv := email_csv_row.email_csv_list;

            tcmpl_app_config.pkg_app_mail_queue.sp_add_to_hold_queue(
                p_person_id    => Null,
                p_meta_id      => Null,
                p_mail_to      => v_mail_csv,
                p_mail_cc      => Null,
                p_mail_bcc     => Null,
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
            Update
                swp_flags
            Set
                flag_value = v_flag_value
            Where
                flag_id = show_future_plan_to_emp_flag;

        End If;

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
                    )
                Order By d_date Desc
            )
        Where
            Rownum In(1, 2);
        If tab_work_day.count = 2 Then
            --v_sysdate EQUAL SECOND_LAST working day "THURSDAY"
            If p_sysdate = tab_work_day(2).work_date Then --SECOND_LAST working day
                Return true;
            End If;
        End If;
        Return false;
    Exception
        When Others Then
            Return false;
    End;

    Function fn_can_open_planning(
        p_sysdate Date
    ) Return Boolean As
        c_flag_days_before_fri  Constant Varchar2(4) := 'F005';
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
            flag_id = c_flag_days_before_fri;

        --            

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
                        And holiday >= trunc(p_sysdate))
            );

        If v_count = v_no_of_days_before_fri + 1 Then
            Return true;
        Else
            Return false;
        End If;
    Exception
        When Others Then
            Return false;
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

    Procedure sp_mail_plan_to_emp
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
                tcmpl_app_config.pkg_app_mail_queue.sp_add_to_hold_queue(
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
    --
    Procedure sp_add_new_joinees_to_pws
    As
    Begin
        Insert Into swp_primary_workspace (key_id, empno, primary_workspace, start_date, modified_on, modified_by, active_code,
            assign_code)
        Select
            dbms_random.string('X', 10),
            empno,
            1 As pws,
            greatest(doj, to_date('31-Jan-2022')),
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
        b_update_planning_flag Boolean := false;
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
            From dms.dm_deskallocation_snapshot;

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
            From dms.dm_usermaster_snapshot;

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
            From dms.dm_desklock_snapshot;

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

        If rec_config_week.start_date != v_sysdate Then
            Return;
        End If;
        --

        sp_plan_visible_to_emp(p_show_plan => false);
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
            active_code = c_cur_plan_code
            And empno In (
                Select
                    empno
                From
                    swp_primary_workspace
                Where
                    active_code = c_future_plan_code
            );

        Update
            swp_primary_workspace
        Set
            active_code = c_cur_plan_code
        Where
            active_code = c_future_plan_code;

    End toggle_plan_future_to_curr;
    --
    Procedure rollover_n_open_planning(p_sysdate Date) As
        v_next_week_mon    Date;
        v_next_week_fri    Date;
        v_next_week_key_id Varchar2(8);

        rec_config_week    swp_config_weeks%rowtype;
    Begin
        --Close and toggle existing planning
        toggle_plan_future_to_curr(p_sysdate);

        v_next_week_mon    := iot_swp_common.get_monday_date(p_sysdate + 6);
        v_next_week_fri    := iot_swp_common.get_friday_date(p_sysdate + 6);

        v_next_week_mon    := trunc(v_next_week_mon);
        v_next_week_fri    := trunc(v_next_week_fri);

        v_next_week_key_id := dbms_random.string('X', 8);
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
                        Where
                            key_id <> v_next_week_key_id
                        Order By start_date Desc
                    )
                Where
                    Rownum = 1
            );

        --
        --
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
            trunc(a.attendance_date) + 7,
            p_sysdate,
            'Sys',
            a.deskid,
            v_next_week_key_id
        From
            swp_smart_attendance_plan a
        Where
            week_key_id = rec_config_week.key_id;
        --
        --
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
            And week_key_id = v_next_week_key_id;
        Delete
            From swp_smart_attendance_plan
        Where
            attendance_date In (
                Select
                    trunc(holiday)
                From
                    ss_holidays
                Where
                    holiday Between v_next_week_mon And v_next_week_fri
            );
        --
        --
        --do snapshot of DESK+USER & DESK+ASSET & Also DESKLOCK mapping
        do_dms_snapshot(trunc(p_sysdate));
        ---

        do_dms_data_to_plan(v_next_week_key_id);

        --

        send_mail_pws_planning_open;
    End rollover_n_open_planning;

    --
    Procedure sp_configuration Is
        v_secondlast_workdate Date;
        v_sysdate             Date;
        v_fri_date            Date;
        v_is_second_last_day  Boolean;
        Type rec Is Record(
                work_date     Date,
                work_day_desc Varchar2(100),
                rec_num       Number
            );

        Type typ_tab_work_day Is Table Of rec;
        tab_work_day          typ_tab_work_day;
        v_can_open_planning   Boolean;
    Begin
        sp_add_new_joinees_to_pws;
        v_sysdate            := trunc(sysdate);
        v_fri_date           := iot_swp_common.get_friday_date(trunc(v_sysdate));
        --
        init_configuration(v_sysdate);

        v_is_second_last_day := fn_is_second_last_day_of_week(v_sysdate);

        v_can_open_planning  := fn_can_open_planning(v_sysdate);

        If v_can_open_planning Then
            rollover_n_open_planning(v_sysdate);
            --v_sysdate EQUAL LAST working day "FRIDAY"
            --        ElsIf V_SYSDATE = tab_work_day(1).work_date Then --LAST working day
        Elsif v_sysdate = v_fri_date Then
            close_planning;
            sp_plan_visible_to_emp(p_show_plan => true);
        Elsif to_char(v_sysdate, 'Dy') = 'Mon' Then
            toggle_plan_future_to_curr(v_sysdate);
        Else
            Null;
            --ToBeDecided
        End If;
    End sp_configuration;




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

                

                tcmpl_app_config.pkg_app_mail_queue.sp_add_to_hold_queue(
                    p_person_id    => Null,
                    p_meta_id      => Null,
                    p_mail_to      => Null,
                    p_mail_cc      => null,
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
                v_day_row   := Null;
                
                v_msg_type  := Null;
                v_msg_text  := Null;
            End Loop;
            Exit When cur_ows_emp_list%notfound;

        End Loop;

    End;


End iot_swp_config_week;