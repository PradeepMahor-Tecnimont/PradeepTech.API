--------------------------------------------------------
--  File created - Saturday-April-09-2022   
--------------------------------------------------------
---------------------------
--New PACKAGE
--TASK_SCHEDULER
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."TASK_SCHEDULER" As

    Procedure sp_daily_swp_add_nu_joinees;

    procedure sp_daily_swp_config_week ;

End task_scheduler;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_CONFIG_WEEK
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_CONFIG_WEEK" As

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;

    Procedure sp_configuration;

    Procedure sp_add_new_joinees_to_pws;

    Procedure sp_mail_plan_to_emp;

    v_ows_mail_body Varchar2(1000) := '<p>Dear User,</p><p>You have been assigned <strong>Office</strong> as your 
    primary workspace for the week between <strong>!@StartDate@!</strong> and <strong>!@EndDate@!</strong> .</p><p>
    You will be required to attend office daily between such period.</p><p></p><p>SWP</p>';

    v_sws_mail_body Varchar2(2000) := '<p>Dear User,</p>rn<p>You have been assigned <strong>Smart</strong> as your 
    primary workspace for the week between <strong>!@StartDate@!</strong> and <strong>!@EndDate@!</strong> .</p>rn<p>
    You will be required to attend office on below mentioned days between such period.
    </p>rn<table border="1" style="border-collapse: collapse; width: 75.7746%;" height="56">rn
    <tbody>rn<tr>rn<td>Date</td>rn<td>Day</td>rn<td>DeskId</td>rn<td>Office</td>rn<td>Floor</td>rn<td>Wing</td>rn</tr>rn
    !@WEEKLYPLANNING@!    
	</tbody>rn
    </table>rn<p></p>rn<p></p>rn<p>SWP</p>';

    v_sws_empty_day_row Varchar2(200) := '<tr><td>DATE</td><td>DAY</td><td>DESKID</td><td>OFFICE</td><td>FLOOR</td><td>WING</td></tr>';

    Type typ_rec_pws Is Record(
            empno                Varchar2(5),
            employee_name        Varchar2(30),
            assign               Varchar2(4),
            parent               Varchar2(4),
            office               Varchar2(2),
            emptype              Varchar2(1),
            work_area            Varchar2(60),
            is_laptop_user       Number,
            is_laptop_user_text  Varchar2(3),
            emp_grade            Varchar2(2),
            primary_workspace    Number,
            is_swp_eligible      varchar2(2),
            is_swp_eligible_desc Varchar2(3),
            row_number           Number,
            total_row            Number
        );

    Type typ_rec_sws Is Record(
            empno      Varchar2(5),
            d_day      Varchar2(3),
            d_date     Date,
            planned    Number,
            deskid     Varchar2(7),
            is_holiday Number,
            office     Varchar2(5),
            floor      Varchar2(8),
            wing       Varchar2(5),
            bay        Varchar2(20)
        );
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
            Else
                Return false;
            End If;
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
        Cursor cur_dept_seat_plan Is
            Select
                *
            From
                swp_include_assign_4_seat_plan;
        cur_dept_rows     Sys_Refcursor;
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
    Begin
        Select
            *
        Into
            row_config_week
        From
            swp_config_weeks
        Where
            planning_flag = 2;
        For c1 In cur_dept_seat_plan
        Loop
            cur_dept_rows := iot_swp_primary_workspace_qry.fn_emp_primary_ws_list(
                                 p_person_id             => Null,
                                 p_meta_id               => Null,

                                 p_assign_code           => c1.assign,
                                 p_start_date            => row_config_week.start_date,

                                 p_empno                 => Null,

                                 p_emptype_csv           => Null,
                                 p_grade_csv             => Null,
                                 p_primary_workspace_csv => Null,
                                 p_laptop_user           => Null,
                                 p_eligible_for_swp      => Null,
                                 p_generic_search        => Null,

                                 p_is_admin_call         => true,

                                 p_row_number            => 0,
                                 p_page_length           => 10000
                             );

            Loop
                Fetch cur_dept_rows Into rec_pws_plan;
                Exit When cur_dept_rows%notfound;
                Begin
                    Select
                        email
                    Into
                        v_emp_mail
                    From
                        ss_emplmast
                    Where
                        empno      = rec_pws_plan.empno
                        And status = 1;
                    If v_emp_mail Is Null Then
                        Continue;
                    End If;
                Exception
                    When Others Then
                        Continue;
                End;
                --PRIMARY WORK SPACE
                If rec_pws_plan.primary_workspace = 1 Then
                    v_mail_body := v_ows_mail_body;
                    v_mail_body := replace(v_mail_body, '!@User@!', rec_pws_plan.employee_name);
                    v_mail_body := replace(v_mail_body, '!@StartDate@!', to_char(row_config_week.start_date, 'dd-Mon-yyyy'));
                    v_mail_body := replace(v_mail_body, '!@EndDate@!', to_char(row_config_week.start_date, 'dd-Mon-yyyy'));

                    /*
                    v_emp_desk := get_swp_planned_desk(
                            p_empno => emp_row.empno
                    );
                    */
                    --SMART WORK SPACE
                Elsif rec_pws_plan.primary_workspace = 2 Then

                    cur_emp_week_plan := iot_swp_smart_workspace_qry.fn_emp_week_attend_planning(
                                             p_person_id => Null,
                                             p_meta_id   => Null,
                                             p_empno     => rec_pws_plan.empno,
                                             p_date      => row_config_week.start_date
                                         );
                    Loop
                        Fetch cur_emp_week_plan Into rec_sws_plan;
                        Exit When cur_emp_week_plan%notfound;
                        v_day_row := nvl(v_day_row, '') || v_sws_empty_day_row;
                        v_day_row := replace(v_day_row, 'DESKID', rec_sws_plan.deskid);
                        v_day_row := replace(v_day_row, 'DATE', rec_sws_plan.d_date);
                        v_day_row := replace(v_day_row, 'DAY', rec_sws_plan.d_day);
                        v_day_row := replace(v_day_row, 'OFFICE', rec_sws_plan.office);
                        v_day_row := replace(v_day_row, 'FLOOR', rec_sws_plan.floor);
                        v_day_row := replace(v_day_row, 'WING', rec_sws_plan.wing);

                    End Loop;
                    Close cur_emp_week_plan;

                    If v_day_row = v_sws_empty_day_row Or v_day_row Is Null Then
                        Continue;
                    End If;
                    v_mail_body       := v_sws_mail_body;
                    v_mail_body       := replace(v_mail_body, '!@User@!', rec_pws_plan.employee_name);
                    v_mail_body       := replace(v_mail_body, '!@WEEKLYPLANNING@!', v_day_row);

                End If;
                tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
                    p_person_id    => Null,
                    p_meta_id      => Null,
                    p_mail_to      => v_emp_mail,
                    p_mail_cc      => Null,
                    p_mail_bcc     => 'd.bhavsar@tecnimont.in',
                    p_mail_subject => 'Smart work planning',
                    p_mail_body1   => v_mail_body,
                    p_mail_body2   => Null,
                    p_mail_type    => 'HTML',
                    p_mail_from    => 'selfservice.tecnimont.in',
                    p_message_type => v_msg_type,
                    p_message_text => v_msg_text
                );
                v_day_row   := Null;
                v_mail_body := Null;
                v_msg_type  := Null;
                v_msg_text  := Null;
            End Loop;
        End Loop;
    End;
    --
    Procedure sp_add_new_joinees_to_pws
    As
    Begin
        Insert Into swp_primary_workspace (key_id, empno, primary_workspace, start_date, modified_on, modified_by, active_code,
            assign_code)
        Select
            dbms_random.string('X', 10), empno, 1, doj, sysdate, 'Sys', 2, assign
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
            And assign Not In (
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
    Procedure toggle_plan_future_to_curr As
    Begin
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
        toggle_plan_future_to_curr;

        v_next_week_mon    := iot_swp_common.get_monday_date(p_sysdate + 6);
        v_next_week_fri    := iot_swp_common.get_friday_date(p_sysdate + 6);
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
    Begin
        sp_add_new_joinees_to_pws;
        v_sysdate            := trunc(sysdate);
        v_fri_date           := iot_swp_common.get_friday_date(trunc(v_sysdate));
        --
        init_configuration(v_sysdate);
        --
        /*
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
                    And d_date >= trunc(v_sysdate)
                    And d_date Not In
                    (
                        Select
                            trunc(holiday)
                        From
                            ss_holidays
                        Where
                            (holiday <= v_fri_date
                                And holiday >= trunc(v_sysdate))
                    )
                Order By d_date Desc
            )
        Where
            Rownum In(1, 2);
*/

        v_is_second_last_day := fn_is_second_last_day_of_week(v_sysdate);

        If v_is_second_last_day Then --SECOND_LAST working day (THURSDAY)
            rollover_n_open_planning(v_sysdate);
            --v_sysdate EQUAL LAST working day "FRIDAY"
            --        ElsIf V_SYSDATE = tab_work_day(1).work_date Then --LAST working day
        Else
            toggle_plan_future_to_curr;

        End If;
    End sp_configuration;

End iot_swp_config_week;
/
---------------------------
--New PACKAGE BODY
--TASK_SCHEDULER
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."TASK_SCHEDULER" As

    Procedure sp_daily_swp_add_nu_joinees As
    Begin
        iot_swp_config_week.sp_add_new_joinees_to_pws;
    End ;

    procedure sp_daily_swp_config_week as
    begin
        iot_swp_config_week.sp_configuration;
    end;

End task_scheduler;
/
