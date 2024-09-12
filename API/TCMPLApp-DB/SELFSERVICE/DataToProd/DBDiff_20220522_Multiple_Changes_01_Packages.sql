--------------------------------------------------------
--  File created - Sunday-May-22-2022   
--------------------------------------------------------
---------------------------
--New PACKAGE
--IOT_SWP_ATTENDANCE_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_ATTENDANCE_QRY" As

    Function fn_swp_attendance_list(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_start_date              Date,
        p_end_date                Date,
        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor;

    Function fn_date_list(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,

        p_start_date Date,
        p_end_date   Date

    ) Return Sys_Refcursor;

End iot_swp_attendance_qry;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_CONFIG_WEEK
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_CONFIG_WEEK" As

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;

    Procedure sp_configuration;

    Procedure sp_add_new_joinees_to_pws;

    Procedure sp_mail_sws_plan_to_emp;

    v_ows_mail_body Varchar2(2000) := '<p>Dear Colleague,</p>
<p><br />This is to inform you that as per our new working arrangement in accordance with the Smart Work Policy sent vide email on 1st June 2021, employees have been allocated a Primary Workspace which can be either an "Office Workspace" or a "Smart Workspace".</p>
<p><br />You have been assigned Office Workspace as your primary workspace for the week between <strong>!@StartDate@!</strong> and <strong>!@EndDate@!</strong>.</p>
<p>You are required to attend the Company''s office on regular basis.<br />For information related to office desk assigned to you, please visit TCMPL Intranet Portal -> TCMPLApp -> Home page.</p>
<p>If any/all of the following, company provided IT inventory is with you, please bring all of it to the office, install it at your designated work desk and start working.<br />1. PC<br />2. Laptop<br />3. Docking Station with charger<br />4. Monitor(s)<br />5. Keyboard<br />6. Mouse<br />7. Wi-Fi dongle<br />8. Headphone</p>
<p>This is an auto-generated mail. Please do not reply to this mail.</p>';


v_sws_mail_body Varchar2(3000) := '<p>Dear Colleague,</p>
<p>This is to inform you that as per our new working arrangement in accordance with the Smart Work Policy sent vide email on 1st June 2021, employees have been allocated a Primary Workspace which can be either an "Office Workspace" or a "Smart Workspace".</p>
<p>You have been assigned <strong>Smart Workspace</strong> as your primary workspace for the week between <strong>!@StartDate@!</strong> and <strong>!@EndDate@!</strong> .</p>
<p>You will be required to attend office on below mentioned day/s between such period.</p>
<p><strong>!@User@!</strong> attendance plan</p>
<table style="border-collapse: collapse; width: 75.7746%;" border="1">
<tbody>
<tr>
<td>Date</td>
<td>Day</td>
<td>DeskId</td>
<td>Office</td>
<td>Floor</td>
<td>Wing</td>
</tr>
!@WEEKLYPLANNING@!
</tbody>
</table>
<p> </p>
<p>The above mentioned desk/s are dynamically allocated. It may not be the same desk as the one occupied by you prior to moving to Smart Workspace.</p>
<p><strong>Please report to the office on the above mentioned date/s only and occupy the corresponding desk only.</strong></p>
<p>You are expected to observe the above schedule strictly.</p>
<p>In case you do not report to office on the above mentioned date/s, you must apply for leave for those date/s or the system will deduct your leave / log an LOP (Loss of Pay), as applicable.</p>
<p>Interchanging of scheduled date/s with other date/s or other colleagues is not allowed and the employee will be considered as "Absent" for the scheduled date/s in case of such interchange.</p>
<p>If any/all of the following, company provided IT inventory is with you, please carry all of it along with you to Office / Home, install it at your designated work desk and start working.</p>
<p>1. Laptop<br />2. Docking Station with charger<br />3. Mouse<br />4. Headphone</p>
<p><strong>Special note to Microsoft Surface users : Surface users must also bring DP to mini DP cable provided to them at the time of issue of Laptop, along with the docking station.</strong></p>
<p><strong><u>Note</u></strong> : Employees on deputation need to fill appropriate form by following the path mentioned below to stop receiving this mailer.</p>
<p>TCMPL Intranet Portal <strong>-></strong> TCMPLApp <strong>-></strong> SelfService <strong>-></strong> On duty <strong>-></strong> On duty application <strong>-></strong> Deput/On Tour <strong>-></strong> On duty type / Deputation</p>
<p>This is an auto-generated mail. Please do not reply to this mail.</p>';

    v_sws_empty_day_row Varchar2(200) := '<tr><td>DATE</td><td>DAY</td><td>DESKID</td><td>OFFICE</td><td>FLOOR</td><td>WING</td></tr>';

v_mail_body_pws_open varchar2(1000):= '
<p>Dear All,</p>
<p>Please be informed that the Primary Workspace planning is now enabled for change for the week starting !PLAN_STARTDATE!</p>
<p>Any changes made in the Primary Workspace planning of employees shall be effective only from next Monday !PLAN_STARTDATE!.</p>
<p>You need to complete this activity by (end-of-day) today.</p>
<p>The Smart Workspace weekly planning shall be enabled on the next working day</p>
<p>Best Regards,</p>
<p>Smart Work Planning Team</p>';

v_mail_body_sws_open varchar2(1000):= '
<p>Dear All,</p>
<p>Please note Smart Workspace planning is now enabled to change. The office attendance schedule for the Smart Workspace employees for week starting <strong>!PLAN_STARTDATE!</strong> can now be changed.</p>
<p>Any changes made in the weekly schedule shall be effective only from next Monday <strong>!PLAN_STARTDATE!</strong>.</p>
<p>You need to complete this activity by end-of-day today after which the system shall be locked for planning.</p>
<p> </p>
<p>Best Regards,<br />Smart Work Planning Team</p>';

End iot_swp_config_week;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_CONFIG_WEEK
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_CONFIG_WEEK" As
    c_plan_close_code  Constant Number := 0;
    c_plan_open_code   Constant Number := 1;
    c_past_plan_code   Constant Number := 0;
    c_cur_plan_code    Constant Number := 1;
    c_future_plan_code Constant Number := 2;

    c_pws              Constant Number := 100;

    c_ows              Constant Number := 1;
    c_sws              Constant Number := 2;
    c_dws              Constant Number := 3;

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

            tcmpl_app_config.pkg_app_mail_queue.sp_add_to_hold_queue(
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
                    d_date, Rownum As row_num
                From
                    ss_days_details
                Where
                    d_date Between v_fri_date - 5 And v_fri_date
                Order By d_date Desc
            )
        Where
            row_num = v_no_of_days_before_fri + 1;

        If v_date = p_sysdate Then
            Return true;
        Else
            Return false;
        End If;
    Exception
        When Others Then
            Return false;
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
                    d_date, Rownum As row_num
                From
                    ss_days_details
                Where
                    d_date Between v_fri_date - 5 And v_fri_date
                Order By d_date Desc
            )
        Where
            row_num = v_no_of_days_before_fri + 1 - v_duration;

        If v_date = p_sysdate Then
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
        /*
                If rec_config_week.start_date != v_sysdate Then
                    Return;
                End If;
                --
        */
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
        v_next_week_mon    Date;
        v_next_week_fri    Date;
        v_next_week_key_id Varchar2(8);

        rec_config_week    swp_config_weeks%rowtype;
    Begin
        v_next_week_mon    := iot_swp_common.get_monday_date(p_sysdate + 6);
        v_next_week_fri    := iot_swp_common.get_friday_date(p_sysdate + 6);

        v_next_week_mon    := trunc(v_next_week_mon);
        v_next_week_fri    := trunc(v_next_week_fri);

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

        --
        --Roll-over SMART Attendance Plan
        --
        Delete
            From swp_smart_attendance_plan
        Where
            attendance_date Between v_next_week_mon And v_next_week_fri;
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
            And week_key_id = v_next_week_key_id;

        --
        --
        --do snapshot of DESK+USER & DESK+ASSET & Also DESKLOCK mapping
        do_dms_snapshot(trunc(p_sysdate));
        ---

        do_dms_data_to_plan(v_next_week_key_id);

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
        v_flag_open_pws_plan  Varchar2(4) := 'F005';
        v_flag_open_sws_plan  Varchar2(4) := 'F006';

        v_flag_close_pws_plan Varchar2(4) := 'F007';
        v_flag_close_sws_plan Varchar2(4) := 'F008';

        v_open_pws            Boolean;
        v_open_sws            Boolean;

        v_close_pws           Boolean;
        v_close_sws           Boolean;
    Begin
        sp_add_new_joinees_to_pws;
        v_sysdate            := trunc(sysdate + 2);
        v_fri_date           := iot_swp_common.get_friday_date(trunc(v_sysdate));
        --
        init_configuration(v_sysdate);

        v_is_second_last_day := fn_is_second_last_day_of_week(v_sysdate);

        v_open_pws           := fn_is_action_day_4_flag(
                                    p_action_flag => v_flag_open_pws_plan,
                                    p_sysdate     => v_sysdate
                                );
        v_close_pws          := fn_is_close_day_4_flag(
                                    p_action_flag   => v_flag_open_pws_plan,
                                    p_duration_flag => v_flag_close_pws_plan,
                                    p_sysdate       => v_sysdate
                                );

        v_open_sws           := fn_is_action_day_4_flag(
                                    p_action_flag => v_flag_open_sws_plan,
                                    p_sysdate     => v_sysdate
                                );

        v_close_sws          := fn_is_close_day_4_flag(
                                    p_action_flag   => v_flag_open_sws_plan,
                                    p_duration_flag => v_flag_close_sws_plan,
                                    p_sysdate       => v_sysdate
                                );

        If v_open_pws Or v_open_sws Then
            rollover_n_open_planning(v_sysdate);
        End If;

        If v_open_pws Then
            sp_set_plan_status(
                p_plan_type        => c_pws,
                p_plan_status_code => c_plan_open_code
            );
            sp_plan_visible_to_emp(p_show_plan => false);
            send_mail_planning_open(
                p_plan_type => c_pws
            );
        End If;

        If v_close_pws Then
            sp_set_plan_status(
                p_plan_type        => c_pws,
                p_plan_status_code => c_plan_close_code
            );
        End If;

        If v_open_sws Then
            sp_set_plan_status(
                p_plan_type        => c_sws,
                p_plan_status_code => c_plan_open_code
            );
            sp_plan_visible_to_emp(
                p_show_plan => false
            );
            send_mail_planning_open(
                p_plan_type => c_sws
            );
        End If;

        If v_close_sws Then
            sp_set_plan_status(
                p_plan_type        => c_sws,
                p_plan_status_code => c_plan_close_code
            );
        End If;

        If v_sysdate = v_fri_date Then
            --Auto generate SMART attendance plan
            iot_swp_auto_assign_desk.sp_auto_generate_plan;

            close_planning;
            sp_plan_visible_to_emp(
                p_show_plan => true
            );
            sp_mail_sws_plan_to_emp;
            sp_mail_ows_plan_to_emp;
        Elsif to_char(v_sysdate, 'Dy') = 'Mon' Then
            toggle_plan_future_to_curr(v_sysdate);
        Else
            Null;
            --ToBeDecided
        End If;
    End sp_configuration;

End iot_swp_config_week;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_AUTO_ASSIGN_DESK
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_AUTO_ASSIGN_DESK" As

    Function fn_get_available_smart_desk(
        p_date   Date,
        p_office Varchar2 Default Null
    ) Return Varchar2 As
        v_ret_desk_id     Varchar2(7);
        v_smart_area_code Varchar2(4) := 'A001';
    Begin
        Select
            deskid
        Into
            v_ret_desk_id
        From
            (
                Select
                    deskid
                From
                    dms.dm_deskmaster
                Where
                    Trim(office) = nvl(Trim(p_office), Trim(office))
                    And work_area In (
                        Select
                            area_key_id
                        From
                            dms.dm_desk_areas
                        Where
                            area_catg_code = v_smart_area_code
                    )
                    And deskid Not In (
                        Select
                            deskid
                        From
                            swp_smart_attendance_plan
                        Where
                            trunc(attendance_date) = p_date
                    )
                Order By deskid
            )
        Where
            Rownum = 1;
        Return v_ret_desk_id;
    Exception
        When Others Then
            Return Null;
    End;

    Function fn_get_available_dept_desk(
        p_area_code Varchar2,
        p_date      Date,
        p_office    Varchar2
    ) Return Varchar2 As
        v_deskid Varchar2(7);
    Begin
        Select
            deskid
        Into
            v_deskid
        From
            (

                Select
                    deskid
                From
                    dms.dm_deskmaster
                Where
                    Trim(office)  = Trim(p_office)
                    And work_area = Trim(p_area_code)
                    And deskid Not In (
                        Select
                            deskid
                        From
                            dms.dm_usermaster
                    )
                    And deskid Not In (
                        Select
                            deskid
                        From
                            dms.dm_desklock
                    )

                    And deskid Not In (
                        Select
                            deskid
                        From
                            swp_smart_attendance_plan
                        Where
                            trunc(attendance_date) = p_date
                    )
                Order By deskid
            )
        Where
            Rownum = 1;
        Return v_deskid;
    Exception
        When Others Then
            Return Null;
    End;

    Procedure assign_sws_desk(
        p_empno  Varchar2,
        p_date   Date,
        p_deskid Varchar2
    ) As
        v_message_type Varchar2(10);
        v_message_text Varchar2(1000);
    Begin
        iot_swp_smart_workspace.sp_sys_assign_sws_desk(
            p_empno           => p_empno,
            p_attendance_date => p_date,
            p_deskid          => p_deskid,
            p_message_type    => v_message_type,
            p_message_text    => v_message_text
        );
    End;

    Procedure sp_assign_desk_to_sws_tf_emp(
        p_config_row swp_config_weeks%rowtype
    ) As
        Cursor cur_tf_emp_list(cp_office Varchar2) Is
            Select
                pws.empno,
                e.name,
                ep.projno,
                apm.office
            From
                swp_primary_workspace     pws,
                swp_emp_proj_mapping      ep,
                ss_emplmast               e,
                dms.dm_desk_area_proj_map apm
            Where
                pws.empno                 = ep.empno
                And e.empno               = pws.empno
                And e.status              = 1
                And apm.office            = cp_office
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
                And pws.primary_workspace = 2
                And ep.projno             = apm.projno
                And trunc(pws.start_date) = (
                    Select
                        Max(trunc(start_date))
                    From
                        swp_primary_workspace b
                    Where
                        b.empno = pws.empno
                        And b.start_date <= p_config_row.end_date
                )
                And pws.empno Not In (
                    Select
                        empno
                    From
                        swp_smart_attendance_plan
                    Where
                        attendance_date Between p_config_row.start_date And p_config_row.end_date
                )
                And e.grade <> 'X1';

        Type typ_tab_tf_emp_list Is Table Of cur_tf_emp_list%rowtype;
        tab_tf_emp_list typ_tab_tf_emp_list;

        Cursor cur_week_dates Is
            Select
                d_date, 0 is_full
            From
                ss_days_details dd
            Where
                d_date Between p_config_row.start_date And p_config_row.end_date
                And dd.d_date Not In (
                    Select
                        holiday
                    From
                        ss_holidays
                )
            Order By
                d_date;

        Type typ_tab_week_dates Is Table Of cur_week_dates%rowtype;
        tab_week_dates  typ_tab_week_dates;

        Cursor cur_tf_office_list Is
            Select
            Distinct office
            From
                dms.dm_desk_area_proj_map
            Where
                is_active = 1;
        Type typ_tab_tf_office_list Is Table Of cur_tf_office_list%rowtype;

        v_start_cntr    Number := 1;
        v_cur_cntr      Number;
        v_found_cntr    Number := 0;
        v_desk_id       dms.dm_deskmaster.deskid%Type;
    Begin

        If cur_week_dates%isopen Then
            Close cur_week_dates;
        End If;
        Open cur_week_dates;
        Fetch cur_week_dates Bulk Collect Into tab_week_dates Limit 5;

        For task_force_office_row In cur_tf_office_list
        --1st Loop
        Loop
            v_start_cntr := 1;
            v_cur_cntr   := 0;
            If cur_tf_emp_list%isopen Then
                Close cur_tf_emp_list;
            End If;
            Open cur_tf_emp_list(task_force_office_row.office);
            --2nd Loop
            Loop
                Fetch cur_tf_emp_list Bulk Collect Into tab_tf_emp_list Limit 50;
                --3rd Loop
                For i In 1..tab_tf_emp_list.count
                Loop
                    --4th Loop
                    For ii In v_start_cntr..tab_week_dates.count
                    Loop
                        v_cur_cntr := ii;
                        v_desk_id  := Null;
                        If tab_week_dates(ii).is_full = 1 Then
                            Continue;
                        End If;
                        v_desk_id  := fn_get_available_smart_desk(tab_week_dates(ii).d_date, task_force_office_row.office);
                        If v_desk_id Is Null Then
                            tab_week_dates(ii).is_full := 1;
                            Continue;
                        End If;
                        assign_sws_desk(tab_tf_emp_list(i).empno, tab_week_dates(ii).d_date, v_desk_id);
                        Exit;
                    End Loop;
                    --4th Loop End
                    If v_cur_cntr In (tab_week_dates.count, 0) Then
                        v_start_cntr := 1;
                    Else
                        v_start_cntr := v_cur_cntr + 1;
                    End If;
                End Loop;
                Exit When cur_tf_emp_list%notfound;

                --3rd Loop End
                --
            End Loop;
            --2nd Loop End
            --
            Close cur_week_dates;
        End Loop;
        --1st Loop End
        --
    End;

    Procedure sp_assign_desk_to_sws_gen(
        p_config_row swp_config_weeks%rowtype
    ) As
        Cursor cur_emp_list Is

            Select
                pws.empno,
                e.name,
                e.parent,
                e.assign,
                pws.primary_workspace,
                e.emptype,
                e.status
            From
                swp_primary_workspace pws,
                ss_emplmast           e
            Where
                pws.empno                 = e.empno
                And e.empno               = pws.empno
                And e.status              = 1
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
                And pws.primary_workspace = 2

                And trunc(pws.start_date) = (
                    Select
                        Max(trunc(start_date))
                    From
                        swp_primary_workspace b
                    Where
                        b.empno = pws.empno
                        And b.start_date <= p_config_row.end_date
                )

                And pws.empno Not In (
                    Select
                        empno
                    From
                        swp_smart_attendance_plan
                    Where
                        attendance_date Between p_config_row.start_date And p_config_row.end_date
                )
                And e.grade <> 'X1';

        Cursor cur_week_dates Is
            Select
                d_date, 0 is_full
            From
                ss_days_details dd
            Where
                d_date Between p_config_row.start_date And p_config_row.end_date
                And dd.d_date Not In (
                    Select
                        holiday
                    From
                        ss_holidays
                )
            Order By
                d_date;

        Type typ_tab_week_dates Is Table Of cur_week_dates%rowtype;
        tab_week_dates typ_tab_week_dates;

        Type typ_tab_emp Is Table Of cur_emp_list%rowtype;
        tab_emp        typ_tab_emp;
        v_start_cntr   Number := 1;
        v_cur_cntr     Number;
        v_desk_id      Varchar2(7);
    Begin

        Open cur_week_dates;
        Fetch cur_week_dates Bulk Collect Into tab_week_dates Limit 5;

        If cur_emp_list%isopen Then
            Close cur_emp_list;
        End If;
        Open cur_emp_list;
        --1nd Loop infinite loop
        Loop
            Fetch cur_emp_list Bulk Collect Into tab_emp Limit 50;
            --2rd Loop
            For i In 1..tab_emp.count
            Loop
                --3th Loop
                For ii In v_start_cntr..tab_week_dates.count
                Loop
                    v_cur_cntr := ii;
                    v_desk_id  := Null;
                    If tab_week_dates(ii).is_full = 1 Then
                        Continue;
                    End If;

                    v_desk_id  := fn_get_available_smart_desk(tab_week_dates(ii).d_date, Null);

                    If v_desk_id Is Null Then
                        tab_week_dates(ii).is_full := 1;
                        Continue;
                    End If;
                    assign_sws_desk(
                        tab_emp(i).empno,
                        tab_week_dates(ii).d_date,
                        v_desk_id
                    );
                    Exit;
                End Loop;
                --3th Loop End
                If v_cur_cntr In (tab_week_dates.count, 0) Then
                    v_start_cntr := 1;
                Else
                    v_start_cntr := v_cur_cntr + 1;
                End If;
            End Loop;
            --2rd Loop end

            --To exit infinite loop
            Exit When cur_emp_list%notfound;
        End Loop;
        --1nd Loop end
    End;

    Procedure sp_assign_desk_to_sws_deptemp(
        p_config_row swp_config_weeks%rowtype
    ) As
        Cursor cur_deptemp_list(
            cp_area_code   Varchar2,
            cp_office      Varchar2,
            cp_friday_date Date
        ) Is
            Select
                pws.empno,
                e.name,
                e.parent,
                e.assign,
                pws.primary_workspace,
                e.emptype,
                e.status
            From
                swp_primary_workspace pws,
                ss_emplmast           e
            Where
                pws.empno                 = e.empno
                And e.empno               = pws.empno
                And e.status              = 1
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
                And pws.primary_workspace = 2
                And pws.empno Not In (
                    Select
                        empno
                    From
                        swp_emp_proj_mapping
                )

                And trunc(pws.start_date) = (
                    Select
                        Max(trunc(start_date))
                    From
                        swp_primary_workspace b
                    Where
                        b.empno = pws.empno
                        And b.start_date <= p_config_row.end_date
                )

                And pws.empno Not In (
                    Select
                        empno
                    From
                        swp_smart_attendance_plan
                    Where
                        attendance_date Between p_config_row.start_date And p_config_row.end_date
                )
                And e.assign In (
                    Select
                        assign
                    From
                        dms.dm_desk_area_dept_map
                    Where
                        area_code  = cp_area_code
                        And office = cp_office
                )
                And e.grade <> 'X1'
            Order By
                e.assign,
                pws.empno;
        Type typ_tab_deptemp Is Table Of cur_deptemp_list%rowtype;
        tab_deptemp     typ_tab_deptemp;

        Cursor cur_week_dates Is
            Select
                d_date, 0 is_full
            From
                ss_days_details dd
            Where
                d_date Between p_config_row.start_date And p_config_row.end_date
                And dd.d_date Not In (
                    Select
                        holiday
                    From
                        ss_holidays
                )
            Order By
                d_date;

        Type typ_tab_week_dates Is Table Of cur_week_dates%rowtype;
        tab_week_dates  typ_tab_week_dates;

        Cursor cur_dept_area_list Is
            Select
            Distinct
                area_code, office
            From
                dms.dm_desk_area_dept_map
            Order By
                office,
                area_code;
        v_start_cntr    Number := 1;
        v_cur_cntr      Number;
        v_desk_id       Varchar2(7);

        rec_config_week swp_config_weeks%rowtype;

    Begin

        Open cur_week_dates;
        Fetch cur_week_dates Bulk Collect Into tab_week_dates Limit 5;

        --1st Loop
        For dept_area_list_row In cur_dept_area_list
        Loop
            If cur_deptemp_list%isopen Then
                Close cur_deptemp_list;
            End If;
            Open cur_deptemp_list(dept_area_list_row.area_code, dept_area_list_row.office, rec_config_week.end_date);
            --2nd Loop infinite loop
            Loop
                Fetch cur_deptemp_list Bulk Collect Into tab_deptemp Limit 50;
                --3rd Loop
                For i In 1..tab_deptemp.count
                Loop
                    --4th Loop
                    For ii In v_start_cntr..tab_week_dates.count
                    Loop
                        v_cur_cntr := ii;
                        v_desk_id  := Null;
                        If tab_week_dates(ii).is_full = 1 Then
                            Continue;
                        End If;
                        v_desk_id  := fn_get_available_dept_desk(dept_area_list_row.area_code, tab_week_dates(ii).d_date,
                                                                 dept_area_list_row.office);
                        If v_desk_id Is Null Then
                            v_desk_id := fn_get_available_smart_desk(tab_week_dates(ii).d_date, dept_area_list_row.office);
                        End If;

                        If v_desk_id Is Null Then
                            tab_week_dates(ii).is_full := 1;
                            Continue;
                        End If;
                        assign_sws_desk(tab_deptemp(i).empno, tab_week_dates(ii).d_date,
                                        v_desk_id);
                        Exit;
                    End Loop;
                    --4th Loop End
                    If v_cur_cntr In (tab_week_dates.count, 0) Then
                        v_start_cntr := 1;
                    Else
                        v_start_cntr := v_cur_cntr + 1;
                    End If;
                End Loop;
                --3rd Loop end

                --To exit infinite loop
                Exit When cur_deptemp_list%notfound;
            End Loop;
            --2nd Loop end
        End Loop;
        --1st Loop end
    End;

    Procedure sp_auto_generate_plan As
        cur_sws_rows      Sys_Refcursor;
        cur_emp_week_plan Sys_Refcursor;
        row_config_week   swp_config_weeks%rowtype;
        v_mail_body       Varchar2(4000);
        v_day_row         Varchar2(300);
        v_emp_mail        Varchar2(100);
        v_msg_type        Varchar2(15);
        v_msg_text        Varchar2(1000);
        v_emp_desk        Varchar2(10);
        rec_sws_plan      typ_rec_sws;
        rec_pws_plan      typ_rec_pws;
        v_count           Number;
    Begin
        Select
            *
        Into
            row_config_week
        From
            swp_config_weeks
        Where
            planning_flag = 2;

        --XXXXXXXXXXXX--
        sp_assign_desk_to_sws_deptemp(row_config_week);
        --XXXXXXXXXXXX--

        --XXXXXXXXXXXX--
        sp_assign_desk_to_sws_tf_emp(row_config_week);
        --XXXXXXXXXXXX--

        --XXXXXXXXXXXX--
        sp_assign_desk_to_sws_gen(row_config_week);
        --XXXXXXXXXXXX--

        Delete
            From swp_smart_attendance_plan
        Where
            empno In (
                Select
                    empno
                From
                    swp_exclude_emp
                Where
                    row_config_week.start_date Between start_date And end_date
                    Or row_config_week.end_date Between start_date And end_date

            );
        Commit;
    End;

End;
/
---------------------------
--New PACKAGE BODY
--IOT_SWP_ATTENDANCE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_ATTENDANCE_QRY" As

    Function fn_swp_attendance_list(
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

End iot_swp_attendance_qry;
/
