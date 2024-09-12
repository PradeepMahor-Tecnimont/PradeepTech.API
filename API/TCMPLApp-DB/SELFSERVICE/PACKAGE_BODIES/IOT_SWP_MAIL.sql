Create Or Replace Package Body selfservice.iot_swp_mail As
    c_ows_code Constant Number := 1;
    c_sws_code Constant Number := 2;

    Function fn_get_prev_working_day Return Date As
        v_date  Date := sysdate;
        v_count Number;
    Begin
        Loop
            v_date := v_date - 1;
            Select
                Count(*)
            Into
                v_count
            From
                ss_holidays
            Where
                holiday = v_date;
            If v_count = 0 Then
                Exit;
            End If;
        End Loop;
        Return v_date;
    End;

    Procedure sp_send_to_ows_absent_emp As

        Cursor cur_ows_absent_emp(cp_date Date) Is
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
                                a.empno,
                                e.name,
                                e.email,
                                iot_swp_common.fn_is_present_4_swp(a.empno, cp_date) is_swp_present
                            From
                                swp_primary_workspace       a,
                                ss_emplmast                 e,
                                swp_primary_workspace_types wt,
                                swp_include_emptype         et
                            Where
                                trunc(a.start_date)     = (
                                        Select
                                            Max(trunc(start_date))
                                        From
                                            swp_primary_workspace b
                                        Where
                                            b.empno = a.empno
                                            And b.start_date <= sysdate
                                    )
                                And a.empno             = e.empno
                                And e.emptype           = et.emptype
                                And status              = 1
                                And a.primary_workspace = wt.type_code
                                And a.primary_workspace = c_ows_code
                                And e.email Is Not Null
                                And e.empno Not In ('04132', '04600', '04484')
                                And e.grade <> 'X1'
                                And e.doj <= cp_date
                                And e.assign Not In(
                                    Select
                                        assign
                                    From
                                        swp_exclude_assign
                                )
                        )
                    Where
                        is_swp_present = 0
                    Order By empno
                )
            Group By
                group_id;

        --
        Type typ_tab_ows_absent_emp Is
            Table Of cur_ows_absent_emp%rowtype;
        tab_ows_abent_emp typ_tab_ows_absent_emp;

        v_count           Number;
        v_mail_csv        Varchar2(2000);
        v_subject         Varchar2(1000);
        v_msg_body        Varchar2(2000);
        v_success         Varchar2(1000);
        v_message         Varchar2(500);
        v_absent_date     Date;
    Begin

        v_absent_date := trunc(sysdate - 1);

        Select
            Count(*)
        Into
            v_count
        From
            (
                Select
                    holiday
                From
                    ss_holidays
                Where
                    holiday = v_absent_date
                Union
                Select
                    trunc(holiday_leave_date) holiday_lv_date
                From
                    ss_holiday_against_leave
                Where
                    holiday_leave_date = v_absent_date
            );

        If v_count > 0 Then
            Return;
        End If;

        v_msg_body    := v_mail_body_ows_absent;
        v_subject     := 'SWP : Office Workspace allocated but not reporting to office';
        For email_csv_row In cur_ows_absent_emp(v_absent_date)
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

    Procedure sp_send_to_sws_absent_emp As
        Cursor cur_sws_absent_emp(cp_date Date) Is

            With
                sws_attendance As (
                    Select
                        empno, attendance_date
                    From
                        swp_smart_attendance_plan
                    Where
                        attendance_date = cp_date
                )
            Select
                empno,
                name                     employee_name,
                replace(email, ',', '.') user_email
            From
                (
                    Select
                        a.empno,
                        e.name,
                        e.email,
                        iot_swp_common.fn_is_present_4_swp(a.empno, cp_date) is_swp_present
                    From
                        swp_primary_workspace       a,
                        sws_attendance              sa,
                        ss_emplmast                 e,
                        swp_primary_workspace_types wt,
                        swp_include_emptype         et
                    Where
                        a.empno                 = sa.empno
                        And trunc(a.start_date) = (
                            Select
                                Max(trunc(start_date))
                            From
                                swp_primary_workspace b
                            Where
                                b.empno = a.empno
                                And b.start_date <= sysdate
                        )
                        And a.empno             = e.empno
                        And e.emptype           = et.emptype
                        And status              = 1
                        And a.primary_workspace = wt.type_code
                        And a.primary_workspace = c_sws_code
                        And e.email Is Not Null
                        And e.empno Not In ('04132', '04600', '04484')
                        And e.grade <> 'X1'
                        And e.doj <= cp_date
                        And e.assign Not In(
                            Select
                                assign
                            From
                                swp_exclude_assign
                        )
                )
            Where
                is_swp_present = 0
            Order By
                empno;

        --
        Type typ_tab_sws_absent_emp Is
            Table Of cur_sws_absent_emp%rowtype;
        tab_sws_absent_emp typ_tab_sws_absent_emp;

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

        v_count            Number;
        row_config_week    swp_config_weeks%rowtype;
        v_mail_csv         Varchar2(2000);
        v_subject          Varchar2(1000);
        v_mail_body        Varchar2(4000);
        v_day_row          Varchar2(1000);
        v_msg_type         Varchar2(15);
        v_msg_text         Varchar2(1000);
        v_msg_body         Varchar2(2000);
        v_success          Varchar2(1000);
        v_message          Varchar2(500);
        v_absent_date      Date;
    Begin

        v_absent_date := trunc(sysdate - 1);

        Select
            Count(*)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = v_absent_date;

        If v_count > 0 Then
            Return;
        End If;

        Select
            *
        Into
            row_config_week
        From
            swp_config_weeks
        Where
            v_absent_date Between start_date And end_date;

        v_msg_body    := v_mail_body_sws_absent;
        v_subject     := 'SWP : SMART Workspace employee not attending office';

        Open cur_sws_absent_emp(v_absent_date);
        Loop
            Fetch cur_sws_absent_emp Bulk Collect Into tab_sws_absent_emp Limit 50;
            For i In 1..tab_sws_absent_emp.count
            Loop
                If tab_sws_absent_emp(i).user_email Is Null Then
                    Continue;
                End If;
                --

                If cur_emp_smart_attend_plan%isopen Then
                    Close cur_emp_smart_attend_plan;
                End If;
                --
                Open cur_emp_smart_attend_plan(tab_sws_absent_emp(i).empno, row_config_week.start_date, row_config_week.end_date);
                Fetch cur_emp_smart_attend_plan Bulk Collect Into tab_emp_smart_plan Limit 5;
                For cntr In 1..tab_emp_smart_plan.count
                Loop
                    If tab_emp_smart_plan(cntr).d_date = v_absent_date Then

                        v_day_row := nvl(v_day_row, '') || replace(v_sws_empty_day_row, '<tr>', '<tr style="background-color:yellow">');
                    Else
                        v_day_row := nvl(v_day_row, '') || v_sws_empty_day_row;
                    End If;
                    --tr style="background-color:yellow">
                    v_day_row := replace(v_day_row, 'DESKID', tab_emp_smart_plan(cntr).deskid);
                    v_day_row := replace(v_day_row, 'DATE', to_char(tab_emp_smart_plan(cntr).d_date, 'dd-Mon-yyyy'));
                    v_day_row := replace(v_day_row, 'DAY', tab_emp_smart_plan(cntr).d_day);
                    v_day_row := replace(v_day_row, 'OFFICE', tab_emp_smart_plan(cntr).office);
                    v_day_row := replace(v_day_row, 'FLOOR', tab_emp_smart_plan(cntr).floor);
                    v_day_row := replace(v_day_row, 'WING', tab_emp_smart_plan(cntr).wing);

                End Loop;

                If v_day_row = v_sws_empty_day_row Or v_day_row Is Null Then
                    Continue;
                End If;
                v_mail_body := v_msg_body;
                v_mail_body := replace(v_mail_body, '!@StartDate@!', to_char(row_config_week.start_date, 'dd-Mon-yyyy'));
                v_mail_body := replace(v_mail_body, '!@EndDate@!', to_char(row_config_week.end_date, 'dd-Mon-yyyy'));
                v_mail_body := replace(v_mail_body, '!@User@!', tab_sws_absent_emp(i).employee_name);
                v_mail_body := replace(v_mail_body, '!@WEEKLYPLANNING@!', v_day_row);
                tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
                    p_person_id    => Null,
                    p_meta_id      => Null,
                    p_mail_to      => tab_sws_absent_emp(i).user_email,
                    p_mail_cc      => Null,
                    p_mail_bcc     => Null,
                    p_mail_subject => v_subject,
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
            Exit When cur_sws_absent_emp%notfound;
        End Loop;

    End;
End;