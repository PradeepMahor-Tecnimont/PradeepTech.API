Create Or Replace Package Body selfservice.iot_swp_smart_workspace As
    c_planning_future  Constant Number(1) := 2;
    c_planning_current Constant Number(1) := 1;
    c_planning_is_open Constant Number(1) := 1;
    Procedure del_emp_sws_atend_plan(
        p_empno            Varchar2,
        p_date             Date,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
        rec_smart_attendance_plan swp_smart_attendance_plan%rowtype;
        v_plan_start_date         Date;
        v_plan_end_date           Date;
        v_planning_exists         Varchar2(2);
        v_planning_open           Varchar2(2);
        v_message_type            Varchar2(10);
        v_message_text            Varchar2(1000);

        v_general_area            Varchar2(4) := 'A002';
        v_count                   Number;
        rec_config_week           swp_config_weeks%rowtype;
    Begin
        If Not iot_swp_common.fn_can_do_desk_plan_4_emp(p_empno) Then
            Return;
        End If;

        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = c_planning_future
            And sws_open  = c_planning_is_open;

        Select
            Count(*)
        Into
            v_count
        From
            swp_smart_attendance_plan
        Where
            empno           = p_empno
            And week_key_id = rec_config_week.key_id;
        If v_count < 2 Then
            p_message_type := 'KO';
            p_message_text := 'Only one attendance day availabe. Hence cannot delete.';
            Return;
        End If;
        Begin
            Select
                *
            Into
                rec_smart_attendance_plan
            From
                swp_smart_attendance_plan
            Where
                empno               = p_empno
                And attendance_date = p_date;
        Exception
            When no_data_found Then
                Return;
        End;
        --Delete from Planning table

        Delete
            From swp_smart_attendance_plan
        Where
            key_id = rec_smart_attendance_plan.key_id;

        --Check if the desk is General desk.
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

        If Not iot_swp_common.is_desk_in_general_area(rec_smart_attendance_plan.deskid) Then
            Return;
        End If;
        --

        iot_swp_dms.sp_unlock_desk(
            p_person_id   => Null,
            p_meta_id     => Null,

            p_deskid      => rec_smart_attendance_plan.deskid,
            p_week_key_id => rec_config_week.key_id
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_add_weekly_atnd(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_weekly_attendance typ_tab_string,
        p_empno             Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        strsql                    Varchar2(600);
        v_count                   Number;
        v_status                  Varchar2(5);
        v_mod_by_empno            Varchar2(5);
        v_pk                      Varchar2(10);
        v_fk                      Varchar2(10);
        v_empno                   Varchar2(5);
        v_attendance_date         Date;
        v_desk                    Varchar2(20);
        rec_config_week           swp_config_weeks%rowtype;
        rec_smart_attendance_plan swp_smart_attendance_plan%rowtype;
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
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = c_planning_future
            And sws_open  = c_planning_is_open;

        ---    
        Select
            Count(*)
        Into
            v_count
        From
            swp_primary_workspace a
        Where
            Trim(a.empno)                 = Trim(p_empno)
            And Trim(a.primary_workspace) = 2
            And trunc(a.start_date)       = (
                      Select
                          Max(trunc(start_date))
                      From
                          swp_primary_workspace b
                      Where
                          b.empno = a.empno
                          And b.start_date <= rec_config_week.end_date
                  );

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number ' || p_empno;
            Return;
        End If;

        For i In 1..p_weekly_attendance.count
        Loop

            With
                csv As (
                    Select
                        p_weekly_attendance(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1))          empno,
                To_Date(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) attendance_date,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3))          desk,
                Trim(regexp_substr(str, '[^~!~]+', 1, 4))          status
            Into
                v_empno, v_attendance_date, v_desk, v_status
            From
                csv;

            If v_status = 0 Then
                del_emp_sws_atend_plan(
                    p_empno        => v_empno,
                    p_date         => trunc(v_attendance_date),
                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
                Return;
            End If;
            Begin
                Select
                    *
                Into
                    rec_smart_attendance_plan
                From
                    swp_smart_attendance_plan
                Where
                    empno               = v_empno
                    And attendance_date = v_attendance_date;
            Exception
                When Others Then
                    Null;
            End;
            If v_status = '1' Then
                If rec_smart_attendance_plan.empno Is Null Then
                    v_pk := dbms_random.string('X', 10);

                    ---    
                    Select
                        key_id
                    Into
                        v_fk
                    From
                        swp_primary_workspace a
                    Where
                        Trim(a.empno)                 = Trim(p_empno)
                        And Trim(a.primary_workspace) = 2
                        And trunc(a.start_date)       = (
                                  Select
                                      Max(trunc(start_date))
                                  From
                                      swp_primary_workspace b
                                  Where
                                      b.empno = a.empno
                                      And b.start_date <= rec_config_week.end_date
                              );

                    --Check attendance date is holiday
                    Select
                        Count(*)
                    Into
                        v_count
                    From
                        ss_holidays
                    Where
                        holiday = v_attendance_date;
                    If v_count > 0 Then
                        p_message_type := 'KO';
                        p_message_text := 'Cannot assign holiday as attendance day.';
                        Continue;
                    End If;

                    --Insert into Attendance Plan
                    Insert Into swp_smart_attendance_plan
                    (
                        key_id,
                        ws_key_id,
                        empno,
                        attendance_date,
                        deskid,
                        modified_on,
                        modified_by,
                        week_key_id
                    )
                    Values
                    (
                        v_pk,
                        v_fk,
                        v_empno,
                        v_attendance_date,
                        v_desk,
                        sysdate,
                        v_mod_by_empno,
                        rec_config_week.key_id
                    );
                Else
                    Update
                        swp_smart_attendance_plan
                    Set
                        deskid = v_desk, modified_on = sysdate, modified_by = v_mod_by_empno
                    Where
                        key_id = rec_smart_attendance_plan.key_id;
                End If;
                If iot_swp_common.is_desk_in_general_area(v_desk) Then
                    /*
                    iot_swp_dms.sp_clear_desk(
                        p_person_id => Null,
                        p_meta_id   => p_meta_id,

                        p_deskid    => v_desk

                    );
                    */
                    iot_swp_dms.sp_lock_desk(
                        p_person_id => Null,
                        p_meta_id   => Null,

                        p_deskid    => v_desk
                    );
                End If;
            End If;

        End Loop;
        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When dup_val_on_index Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || v_desk || ' is not available. It has be assigned to other Employee.';

        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_weekly_atnd;

    Procedure sp_delete_weekly_attendance(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_empno             Varchar2,
        p_date              Date,
        p_deskid            Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
    Begin
        del_emp_sws_atend_plan(
            p_empno        => p_empno,
            p_date         => p_date,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
    End;

    Procedure sp_add_weekly_attendance(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_empno             Varchar2,
        p_date              Date,
        p_deskid            Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        strsql                    Varchar2(600);
        v_count                   Number;
        v_status                  Varchar2(5);
        v_mod_by_empno            Varchar2(5);
        v_pk                      Varchar2(10);
        v_fk                      Varchar2(10);
        v_empno                   Varchar2(5);
        v_attendance_date         Date;
        v_desk                    Varchar2(20);
        rec_config_week           swp_config_weeks%rowtype;
        rec_smart_attendance_plan swp_smart_attendance_plan%rowtype;
    Begin

        v_mod_by_empno    := get_empno_from_meta_id(p_meta_id);

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
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = c_planning_future
            And sws_open  = c_planning_is_open;

        ---    
        Select
            Count(*)
        Into
            v_count
        From
            swp_primary_workspace a
        Where
            Trim(a.empno)                 = Trim(p_empno)
            And Trim(a.primary_workspace) = 2
            And trunc(a.start_date)       = (
                      Select
                          Max(trunc(start_date))
                      From
                          swp_primary_workspace b
                      Where
                          b.empno = a.empno
                          And b.start_date <= rec_config_week.end_date
                  );

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number ' || p_empno;
            Return;
        End If;
        /*
                For i In 1..p_weekly_attendance.count
                Loop
        
                    With
                        csv As (
                            Select
                                p_weekly_attendance(i) str
                            From
                                dual
                        )
                    Select
                        Trim(regexp_substr(str, '[^~!~]+', 1, 1))          empno,
                        To_Date(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) attendance_date,
                        Trim(regexp_substr(str, '[^~!~]+', 1, 3))          desk,
                        Trim(regexp_substr(str, '[^~!~]+', 1, 4))          status
                    Into
                        v_empno, v_attendance_date, v_desk, v_status
                    From
                        csv;
                        del_emp_sws_atend_plan(
                            p_empno        => v_empno,
                            p_date         => trunc(v_attendance_date),
                            p_message_type => p_message_type,
                            p_message_text => p_message_text
                        );
                        Return;
                        */
        v_attendance_date := p_date;
        v_empno           := p_empno;
        v_desk            := p_deskid;
        Begin
            Select
                *
            Into
                rec_smart_attendance_plan
            From
                swp_smart_attendance_plan
            Where
                empno               = v_empno
                And attendance_date = v_attendance_date;
        Exception
            When Others Then
                Null;
        End;

        If rec_smart_attendance_plan.empno Is Null Then
            v_pk := dbms_random.string('X', 10);

            ---    
            Select
                key_id
            Into
                v_fk
            From
                swp_primary_workspace a
            Where
                Trim(a.empno)                 = Trim(p_empno)
                And Trim(a.primary_workspace) = 2
                And trunc(a.start_date)       = (
                          Select
                              Max(trunc(start_date))
                          From
                              swp_primary_workspace b
                          Where
                              b.empno = a.empno
                              And b.start_date <= rec_config_week.end_date
                      );

            --Check attendance date is holiday
            Select
                Count(*)
            Into
                v_count
            From
                ss_holidays
            Where
                holiday = v_attendance_date;
            If v_count > 0 Then
                p_message_type := 'KO';
                p_message_text := 'Cannot assign holiday as attendance day.';
                Return;
            End If;

            --Insert into Attendance Plan
            Insert Into swp_smart_attendance_plan
            (
                key_id,
                ws_key_id,
                empno,
                attendance_date,
                deskid,
                modified_on,
                modified_by,
                week_key_id
            )
            Values
            (
                v_pk,
                v_fk,
                v_empno,
                v_attendance_date,
                v_desk,
                sysdate,
                v_mod_by_empno,
                rec_config_week.key_id
            );
        Else
            Update
                swp_smart_attendance_plan
            Set
                deskid = v_desk, modified_on = sysdate, modified_by = v_mod_by_empno
            Where
                key_id = rec_smart_attendance_plan.key_id;
        End If;
        If iot_swp_common.is_desk_in_general_area(v_desk) Then
            /*
            iot_swp_dms.sp_clear_desk(
                p_person_id => Null,
                p_meta_id   => p_meta_id,

                p_deskid    => v_desk

            );
            */
            iot_swp_dms.sp_lock_desk(
                p_person_id => Null,
                p_meta_id   => Null,

                p_deskid    => v_desk
            );
        End If;
        --          End If;

        --        End Loop;
        Commit;

        p_message_type    := 'OK';
        p_message_text    := 'Procedure executed successfully.';
    Exception
        When dup_val_on_index Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || v_desk || ' is not available. It has be assigned to other Employee.';

        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_weekly_attendance;

    Procedure sp_smart_ws_weekly_summary(
        p_person_id                     Varchar2,
        p_meta_id                       Varchar2,

        p_assign_code                   Varchar2,
        p_date                          Date,

        p_emp_count_smart_workspace Out Number,
        p_emp_count_mon             Out Number,
        p_emp_count_tue             Out Number,
        p_emp_count_wed             Out Number,
        p_emp_count_thu             Out Number,
        p_emp_count_fri             Out Number,
        p_costcode_desc             Out Varchar2,
        p_message_type              Out Varchar2,
        p_message_text              Out Varchar2
    ) As
        v_start_date Date;
        v_end_date   Date;
        Cursor cur_summary(cp_start_date Date,
                           cp_end_date   Date) Is
            Select
                attendance_day, Count(empno) emp_count
            From
                (
                    Select
                        e.empno, to_char(attendance_date, 'DY') attendance_day
                    From
                        ss_emplmast               e,
                        swp_smart_attendance_plan wa
                    Where
                        e.assign    = p_assign_code
                        And attendance_date Between cp_start_date And cp_end_date
                        And e.empno = wa.empno(+)
                        And status  = 1
                        And emptype In (
                            Select
                                emptype
                            From
                                swp_include_emptype
                        )
                )
            Group By
                attendance_day;

    Begin
        v_start_date   := iot_swp_common.get_monday_date(p_date);
        v_end_date     := iot_swp_common.get_friday_date(p_date);
        Select
            costcode || ' - ' || name
        Into
            p_costcode_desc
        From
            ss_costmast
        Where
            costcode = p_assign_code;

        For c1 In cur_summary(trunc(v_start_date), trunc(v_end_date))
        Loop
            If c1.attendance_day = 'MON' Then
                p_emp_count_mon := c1.emp_count;
            Elsif c1.attendance_day = 'TUE' Then
                p_emp_count_tue := c1.emp_count;
            Elsif c1.attendance_day = 'WED' Then
                p_emp_count_wed := c1.emp_count;
            Elsif c1.attendance_day = 'THU' Then
                p_emp_count_thu := c1.emp_count;
            Elsif c1.attendance_day = 'FRI' Then
                p_emp_count_fri := c1.emp_count;
            End If;
        End Loop;

        --Total Count
        Select
            --e.empno, emptype, status, aw.primary_workspace
            Count(*)
        Into
            p_emp_count_smart_workspace
        From
            ss_emplmast           e,
            swp_primary_workspace aw

        Where
            e.assign                 = p_assign_code
            And e.empno              = aw.empno
            And status               = 1
            And emptype In (
                Select
                    emptype
                From
                    swp_include_emptype
            )
            And aw.primary_workspace = 2
            And
            trunc(aw.start_date)     = (
                    Select
                        Max(trunc(start_date))
                    From
                        swp_primary_workspace b
                    Where
                        b.empno = aw.empno
                        And b.start_date <= v_end_date
                );

        /*

                Select
                    Count(*)
                Into
                    p_emp_count_smart_workspace
                From
                    swp_primary_workspace
                Where
                    primary_workspace = 2
                    And empno In (
                        Select
                            empno
                        From
                            ss_emplmast
                        Where
                            status     = 1
                            And assign = p_assign_code
                    );
        */
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_sys_assign_sws_desk(
        p_empno            Varchar2,
        p_attendance_date  Date,
        p_deskid           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count         Number;
        v_pk            Varchar2(10);
        v_fk            Varchar2(10);
        rec_config_week swp_config_weeks%rowtype;
    Begin

        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = c_planning_future;

        Select
            Count(*)
        Into
            v_count
        From
            swp_primary_workspace
        Where
            Trim(empno)                 = Trim(p_empno)
            And Trim(primary_workspace) = 2;

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number ' || p_empno;
            Return;
        End If;
        
        --Check attendance date is holidy
        Select
            Count(*)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = p_attendance_date;
        If v_count > 0 Then
            p_message_type := 'KO';
            p_message_text := 'Cannot assign holiday as attendance day.';
            Return;
        End If;

        v_pk           := dbms_random.string('X', 10);

        Select
            key_id
        Into
            v_fk
        From
            swp_primary_workspace pws
        Where
            Trim(pws.empno)           = Trim(p_empno)
            And pws.primary_workspace = 2
            And trunc(pws.start_date) = (
                Select
                    Max(trunc(start_date))
                From
                    swp_primary_workspace b
                Where
                    b.empno = pws.empno
                    And b.start_date <= rec_config_week.end_date
            );

        Insert Into swp_smart_attendance_plan
        (
            key_id,
            ws_key_id,
            empno,
            attendance_date,
            deskid,
            modified_on,
            modified_by,
            week_key_id
        )
        Values
        (
            v_pk,
            v_fk,
            p_empno,
            p_attendance_date,
            p_deskid,
            sysdate,
            'Sys',
            rec_config_week.key_id
        );
        If iot_swp_common.is_desk_in_general_area(p_deskid) Then

            iot_swp_dms.sp_lock_desk(
                p_person_id => Null,
                p_meta_id   => Null,

                p_deskid    => p_deskid
            );
        End If;
        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_sys_assign_sws_desk;

End iot_swp_smart_workspace;