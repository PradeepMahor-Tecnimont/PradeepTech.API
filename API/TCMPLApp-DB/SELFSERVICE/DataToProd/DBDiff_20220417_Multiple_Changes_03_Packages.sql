--------------------------------------------------------
--  File created - Sunday-April-17-2022   
--------------------------------------------------------
---------------------------
--Changed PACKAGE
--IOT_SWP_PRIMARY_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_PRIMARY_WORKSPACE" As

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;
    c_office_workspace constant number := 1;
    c_smart_workspace constant number := 2;
    c_not_in_mum_office constant number := 3;


    Procedure sp_add_office_ws_desk(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_deskid           Varchar2,
        p_empno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_hod_assign_work_space(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_emp_workspace_array typ_tab_string,
        p_message_type Out    Varchar2,
        p_message_text Out    Varchar2
    );

    Procedure sp_hr_assign_work_space(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_emp_workspace_array typ_tab_string,
        p_message_type Out    Varchar2,
        p_message_text Out    Varchar2
    );

    Procedure sp_workspace_summary(
        p_person_id                      Varchar2,
        p_meta_id                        Varchar2,

        p_assign_code                    Varchar2 Default Null,
        p_start_date                     Date     Default Null,

        p_total_emp_count            Out Number,
        p_emp_count_office_workspace Out Number,
        p_emp_count_smart_workspace  Out Number,
        p_emp_count_not_in_ho        Out Number,

        p_emp_perc_office_workspace        Out Number,
        p_emp_perc_smart_workspace        Out Number,

        p_message_type               Out Varchar2,
        p_message_text               Out Varchar2
    );

    Procedure sp_workspace_plan_summary(
        p_person_id                      Varchar2,
        p_meta_id                        Varchar2,

        p_assign_code                    Varchar2 default null,

        p_total_emp_count            Out Number,
        p_emp_count_office_workspace Out Number,
        p_emp_count_smart_workspace  Out Number,
        p_emp_count_not_in_ho        Out Number,

        p_emp_perc_office_workspace       Out Number,
        p_emp_perc_smart_workspace        Out Number,

        p_message_type               Out Varchar2,
        p_message_text               Out Varchar2
    );



End iot_swp_primary_workspace;
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
            dbms_random.string('X', 10),
            empno,
            case when dd.assign = null then 1 else 2 end pws,
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

        v_is_second_last_day := fn_is_second_last_day_of_week(v_sysdate);

        If v_is_second_last_day Then --SECOND_LAST working day (THURSDAY)
            rollover_n_open_planning(v_sysdate);
            --v_sysdate EQUAL LAST working day "FRIDAY"
            --        ElsIf V_SYSDATE = tab_work_day(1).work_date Then --LAST working day
        Elsif v_sysdate = v_fri_date Then
            close_planning;
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
--IOT_SWP_PRIMARY_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_PRIMARY_WORKSPACE" As

    Procedure del_emp_future_planning(
        p_empno               Varchar2,
        p_planning_start_date Date
    ) As
        v_ows_desk_id Varchar2(10);
    Begin

        Delete
            From swp_smart_attendance_plan
        Where
            empno = Trim(p_empno)
            And attendance_date >= p_planning_start_date;

        Delete
            From swp_primary_workspace
        Where
            empno = Trim(p_empno)
            And start_date >= p_planning_start_date;

    End;

    Procedure sp_assign_work_space(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_is_admin_call       Number Default 0,
        p_emp_workspace_array typ_tab_string,
        p_message_type Out    Varchar2,
        p_message_text Out    Varchar2
    ) As
        v_workspace_code      Number;
        v_mod_by_empno        Varchar2(5);
        v_count               Number;
        v_key                 Varchar2(10);
        v_empno               Varchar2(5);
        rec_config_week       swp_config_weeks%rowtype;
        c_planning_future     Constant Number(1) := 2;
        c_planning_current    Constant Number(1) := 1;
        c_planning_is_open    Constant Number(1) := 1;
        Type typ_tab_primary_workspace Is Table Of swp_primary_workspace%rowtype Index By Binary_Integer;
        tab_primary_workspace typ_tab_primary_workspace;
        v_ows_desk_id         Varchar2(10);
    Begin
        v_mod_by_empno := get_empno_from_meta_id(p_meta_id);
        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If nvl(p_is_admin_call, 0) != 1 Then
            Begin

                Select
                    *
                Into
                    rec_config_week
                From
                    swp_config_weeks
                Where
                    planning_flag = c_planning_future
                    And pws_open  = c_planning_is_open;
            Exception
                When Others Then
                    p_message_type := 'KO';
                    p_message_text := 'Err - SWP Planning is not open. Cannot proceed.';
                    Return;
            End;
        Elsif nvl(p_is_admin_call, 0) = 1 Then

            Begin

                Select
                    *
                Into
                    rec_config_week
                From
                    swp_config_weeks
                Where
                    planning_flag = c_planning_future;
            Exception
                When Others Then
                    p_message_type := 'KO';
                    p_message_text := 'Err - SWP Planning is not open. Cannot proceed.';
                    Return;
            End;

        End If;

        For i In 1..p_emp_workspace_array.count
        Loop

            With
                csv As (
                    Select
                        p_emp_workspace_array(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1)) empno,
                Trim(regexp_substr(str, '[^~!~]+', 1, 2)) workspace_code
            Into
                v_empno, v_workspace_code
            From
                csv;

            Select
                * Bulk Collect
            Into
                tab_primary_workspace
            From
                (
                    Select
                        *
                    From
                        swp_primary_workspace
                    Where
                        empno = Trim(v_empno)
                    Order By start_date Desc
                )
            Where
                Rownum <= 2;

            If tab_primary_workspace.count > 0 Then
                --If same FUTURE record exists in database then continue
                --If no change then continue
                If tab_primary_workspace(1).primary_workspace = v_workspace_code Then
                    Continue;
                End If;

                --Delete existing SWP DESK ASSIGNMENT planning
                del_emp_future_planning(
                    p_empno               => v_empno,
                    p_planning_start_date => trunc(rec_config_week.start_date)
                );
                --
                v_ows_desk_id := iot_swp_common.get_swp_planned_desk(v_empno);
                --Remove user desk association in DMS
                If Trim(v_ows_desk_id) Is Not Null Then
                    iot_swp_dms.sp_remove_desk_user(
                        p_person_id => p_person_id,
                        p_meta_id   => p_meta_id,

                        p_empno     => v_empno,
                        p_deskid    => v_ows_desk_id
                    );
                End If;

                --If furture planning is reverted to old planning then continue
                If tab_primary_workspace(1).active_code = c_planning_future Then
                    If tab_primary_workspace.Exists(2) Then
                        If tab_primary_workspace(2).primary_workspace = v_workspace_code Then
                            Continue;
                        End If;
                    End If;
                End If;
            End If;
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
                v_empno,
                v_workspace_code,
                rec_config_week.start_date,
                sysdate,
                v_mod_by_empno,
                c_planning_future
            );
            Commit;
        End Loop;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    /*
        Procedure sp_assign_work_space(
            p_person_id           Varchar2,
            p_meta_id             Varchar2,

            p_emp_workspace_array typ_tab_string,
            p_message_type Out    Varchar2,
            p_message_text Out    Varchar2
        ) As
            v_workspace_code      Number;
            v_mod_by_empno        Varchar2(5);
            v_count               Number;
            v_key                 Varchar2(10);
            v_empno               Varchar2(5);
            rec_config_week       swp_config_weeks%rowtype;
            c_planning_future     Constant Number(1) := 2;
            c_planning_current    Constant Number(1) := 1;
            c_planning_is_open    Constant Number(1) := 1;
            Type typ_tab_primary_workspace Is Table Of swp_primary_workspace%rowtype Index By Binary_Integer;
            tab_primary_workspace typ_tab_primary_workspace;
            v_ows_desk_id         Varchar2(10);
        Begin
            v_mod_by_empno := get_empno_from_meta_id(p_meta_id);
            If v_mod_by_empno = 'ERRRR' Then
                p_message_type := 'KO';
                p_message_text := 'Invalid employee number';
                Return;
            End If;
            Begin

                Select
                    *
                Into
                    rec_config_week
                From
                    swp_config_weeks
                Where
                    planning_flag = c_planning_future
                    And pws_open  = c_planning_is_open;
            Exception
                When Others Then
                    p_message_type := 'KO';
                    p_message_text := 'Err - SWP Planning is not open. Cannot proceed.';
                    Return;
            End;

            For i In 1..p_emp_workspace_array.count
            Loop

                With
                    csv As (
                        Select
                            p_emp_workspace_array(i) str
                        From
                            dual
                    )
                Select
                    Trim(regexp_substr(str, '[^~!~]+', 1, 1)) empno,
                    Trim(regexp_substr(str, '[^~!~]+', 1, 2)) workspace_code
                Into
                    v_empno, v_workspace_code
                From
                    csv;

                Select
                    * Bulk Collect
                Into
                    tab_primary_workspace
                From
                    (
                        Select
                            *
                        From
                            swp_primary_workspace
                        Where
                            empno = Trim(v_empno)
                        Order By start_date Desc
                    )
                Where
                    Rownum <= 2;

                If tab_primary_workspace.count > 0 Then
                    --If same FUTURE record exists in database then continue
                    --If no change then continue
                    If tab_primary_workspace(1).primary_workspace = v_workspace_code Then
                        Continue;
                    End If;

                    --Delete existing SWP DESK ASSIGNMENT planning
                    del_emp_future_planning(
                        p_empno               => v_empno,
                        p_planning_start_date => trunc(rec_config_week.start_date)
                    );
                    --
                    v_ows_desk_id := iot_swp_common.get_swp_planned_desk(v_empno);
                    --Remove user desk association in DMS
                    If Trim(v_ows_desk_id) Is Not Null Then
                        iot_swp_dms.sp_remove_desk_user(
                            p_person_id => p_person_id,
                            p_meta_id   => p_meta_id,

                            p_empno     => v_empno,
                            p_deskid    => v_ows_desk_id
                        );
                    End If;

                    --If furture planning is reverted to old planning then continue
                    If tab_primary_workspace(1).active_code = c_planning_future Then
                        If tab_primary_workspace.Exists(2) Then
                            If tab_primary_workspace(2).primary_workspace = v_workspace_code Then
                                Continue;
                            End If;
                        End If;
                    End If;
                End If;
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
                    v_empno,
                    v_workspace_code,
                    rec_config_week.start_date,
                    sysdate,
                    v_mod_by_empno,
                    c_planning_future
                );
                Commit;
            End Loop;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Exception
            When Others Then
                Rollback;
                p_message_type := 'KO';
                p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
        End;
    */
    Procedure sp_add_office_ws_desk(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_deskid           Varchar2,
        p_empno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        strsql            Varchar2(600);
        v_count           Number;
        v_status          Varchar2(5);
        v_mod_by_empno    Varchar2(5);
        v_pk              Varchar2(10);
        v_fk              Varchar2(10);
        v_empno           Varchar2(5);
        v_attendance_date Date;
        v_desk            Varchar2(20);
    Begin

        v_mod_by_empno := get_empno_from_meta_id(p_meta_id);

        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        If Not iot_swp_common.fn_can_do_desk_plan_4_emp(p_empno) Then
            p_message_type := 'KO';
            p_message_text := 'Planning not allowed for employee assign code.';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            swp_primary_workspace
        Where
            Trim(empno)                 = Trim(p_empno)
            And Trim(primary_workspace) = '1';

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number ' || p_empno;
            Return;
        End If;

        Insert Into dm_vu_emp_desk_map (
            empno,
            deskid
        --,modified_on,
        --modified_by
        )
        Values (
            p_empno,
            p_deskid
        --,sysdate,
        --v_mod_by_empno
        );
        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_office_ws_desk;

    Procedure sp_workspace_summary(
        p_person_id                      Varchar2,
        p_meta_id                        Varchar2,

        p_assign_code                    Varchar2 Default Null,
        p_start_date                     Date     Default Null,

        p_total_emp_count            Out Number,
        p_emp_count_office_workspace Out Number,
        p_emp_count_smart_workspace  Out Number,
        p_emp_count_not_in_ho        Out Number,

        p_emp_perc_office_workspace  Out Number,
        p_emp_perc_smart_workspace   Out Number,

        p_message_type               Out Varchar2,
        p_message_text               Out Varchar2
    ) As
        v_empno              Varchar2(5);
        v_total              Number;
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_friday_date        Date;
        Cursor cur_sum Is

            With
                assign_codes As (
                    Select
                        assign
                    From
                        (
                            Select
                                assign
                            From
                                (
                                    Select
                                        costcode As assign
                                    From
                                        ss_costmast
                                    Where
                                        hod = v_empno
                                    Union
                                    Select
                                        parent As assign
                                    From
                                        ss_user_dept_rights
                                    Where
                                        empno = v_empno
                                )
                            Where
                                assign = nvl(p_assign_code, assign)
                            Order By assign
                        )
                    Where
                        Rownum = 1
                ),
                primary_work_space As(
                    Select
                        a.empno, a.primary_workspace, a.start_date
                    From
                        swp_primary_workspace a
                    Where
                        trunc(a.start_date) = (
                            Select
                                Max(trunc(start_date))
                            From
                                swp_primary_workspace b
                            Where
                                b.empno = a.empno
                                And b.start_date <= v_friday_date
                        )
                )
            Select
                workspace, Count(empno) emp_count
            From
                (
                    Select
                        empno, nvl(primary_workspace, 3) workspace
                    From
                        (
                            Select
                                e.empno, emptype, status, aw.primary_workspace
                            From
                                ss_emplmast        e,
                                primary_work_space aw,
                                assign_codes       ac
                            Where
                                e.assign    = ac.assign
                                And e.empno = aw.empno(+)
                                And status  = 1
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

                        )
                )
            Group By
                workspace;
    Begin
        v_friday_date               := iot_swp_common.get_friday_date(nvl(p_start_date, sysdate));
        v_empno                     := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;
        For c1 In cur_sum
        Loop
            If c1.workspace = 1 Then
                p_emp_count_office_workspace := c1.emp_count;
            Elsif c1.workspace = 2 Then
                p_emp_count_smart_workspace := c1.emp_count;
            Elsif c1.workspace = 3 Then
                p_emp_count_not_in_ho := c1.emp_count;
            End If;

        End Loop;
        p_total_emp_count           := nvl(p_emp_count_office_workspace, 0) + nvl(p_emp_count_smart_workspace, 0) + nvl(p_emp_count_not_in_ho, 0);
        v_total                     := (nvl(p_total_emp_count, 0) - nvl(p_emp_count_not_in_ho, 0));
        p_emp_perc_office_workspace := round(((nvl(p_emp_count_office_workspace, 0) / v_total) * 100), 1);
        p_emp_perc_smart_workspace  := round(((nvl(p_emp_count_smart_workspace, 0) / v_total) * 100), 1);

        p_message_type              := 'OK';
        p_message_text              := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_workspace_plan_summary(
        p_person_id                      Varchar2,
        p_meta_id                        Varchar2,

        p_assign_code                    Varchar2 Default Null,

        p_total_emp_count            Out Number,
        p_emp_count_office_workspace Out Number,
        p_emp_count_smart_workspace  Out Number,
        p_emp_count_not_in_ho        Out Number,

        p_emp_perc_office_workspace  Out Number,
        p_emp_perc_smart_workspace   Out Number,

        p_message_type               Out Varchar2,
        p_message_text               Out Varchar2
    ) As
        v_plan_friday_date Date;
        rec_config_week    swp_config_weeks%rowtype;
    Begin
        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = 2;
        v_plan_friday_date := rec_config_week.end_date;
        sp_workspace_summary(
            p_person_id                  => p_person_id,
            p_meta_id                    => p_meta_id,

            p_assign_code                => p_assign_code,
            p_start_date                 => v_plan_friday_date,

            p_total_emp_count            => p_total_emp_count,
            p_emp_count_office_workspace => p_emp_count_office_workspace,
            p_emp_count_smart_workspace  => p_emp_count_smart_workspace,
            p_emp_count_not_in_ho        => p_emp_count_not_in_ho,

            p_emp_perc_office_workspace  => p_emp_perc_office_workspace,
            p_emp_perc_smart_workspace   => p_emp_perc_smart_workspace,

            p_message_type               => p_message_type,
            p_message_text               => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_hod_assign_work_space(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_emp_workspace_array typ_tab_string,
        p_message_type Out    Varchar2,
        p_message_text Out    Varchar2
    ) As
        v_workspace_code      Number;
        v_mod_by_empno        Varchar2(5);
        v_count               Number;
        v_key                 Varchar2(10);
        v_empno               Varchar2(5);
        rec_config_week       swp_config_weeks%rowtype;
        c_planning_future     Constant Number(1) := 2;
        c_planning_current    Constant Number(1) := 1;
        c_planning_is_open    Constant Number(1) := 1;
        Type typ_tab_primary_workspace Is Table Of swp_primary_workspace%rowtype Index By Binary_Integer;
        tab_primary_workspace typ_tab_primary_workspace;
        v_ows_desk_id         Varchar2(10);
    Begin

        sp_assign_work_space(
            p_person_id           => p_person_id,
            p_meta_id             => p_meta_id,

            p_emp_workspace_array => p_emp_workspace_array,
            p_message_type        => p_message_type,
            p_message_text        => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_hr_assign_work_space(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_emp_workspace_array typ_tab_string,
        p_message_type Out    Varchar2,
        p_message_text Out    Varchar2
    ) As
        v_workspace_code      Number;
        v_mod_by_empno        Varchar2(5);
        v_count               Number;
        v_key                 Varchar2(10);
        v_empno               Varchar2(5);
        rec_config_week       swp_config_weeks%rowtype;
        c_planning_future     Constant Number(1) := 2;
        c_planning_current    Constant Number(1) := 1;
        c_planning_is_open    Constant Number(1) := 1;
        Type typ_tab_primary_workspace Is Table Of swp_primary_workspace%rowtype Index By Binary_Integer;
        tab_primary_workspace typ_tab_primary_workspace;
        v_ows_desk_id         Varchar2(10);
    Begin

        sp_assign_work_space(
            p_person_id           => p_person_id,
            p_meta_id             => p_meta_id,
            p_is_admin_call       => 1,
            p_emp_workspace_array => p_emp_workspace_array,
            p_message_type        => p_message_type,
            p_message_text        => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;

End iot_swp_primary_workspace;
/
