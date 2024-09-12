Create Or Replace Package Body "IOT_SWP_PRIMARY_WORKSPACE" As
    c_ows              Constant Number(1) := 1;
    c_sws              Constant Number(1) := 2;
    c_dws              Constant Number(1) := 3;
    c_planning_future  Constant Number(1) := 2;
    c_planning_current Constant Number(1) := 1;

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

    Function fn_dept_ows_quota_exists(
        p_assign           Varchar2,
        p_week_key_id      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) Return Varchar2 As
        v_swp_dept_ws_sum  swp_dept_workspace_summary%rowtype;
        c_office_workspace Constant Number := 1;

        v_config_week_row  swp_config_weeks%rowtype;
        v_dept_ows_count   Number;
    Begin

        --Get department workspace summary
        Select
            *
        Into
            v_swp_dept_ws_sum
        From
            swp_dept_workspace_summary
        Where
            assign          = p_assign
            And week_key_id = p_week_key_id;

        --Get config week row.
        Select
            *
        Into
            v_config_week_row
        From
            swp_config_weeks
        Where
            key_id = p_week_key_id;

        --Get department Office Workspace emp count 
        Select
            Count(*)
        Into
            v_dept_ows_count
        From
            swp_primary_workspace pws,
            ss_emplmast           e
        Where
            pws.empno                 = e.empno
            And e.status              = 1
            And e.emptype In (
                Select
                    emptype
                From
                    swp_include_emptype
            )
            And e.assign              = p_assign
            And e.assign Not In (
                Select
                    assign
                From
                    swp_exclude_assign
            )
            And start_date            = (
                           Select
                               Max(start_date)
                           From
                               swp_primary_workspace pws_sub
                           Where
                               pws_sub.empno = pws.empno
                               And pws_sub.start_date <= v_config_week_row.end_date
                       )
            And pws.primary_workspace = c_office_workspace;

        --Compare workspace assignment and quota for the department
        If v_dept_ows_count < nvl(v_swp_dept_ws_sum.ows_emp_count, 0) + nvl(v_swp_dept_ws_sum.sws_emp_count, 0) + nvl(v_swp_dept_ws_sum.
        dws_emp_count, 0) Then
            Return 'OK';
        Else
            Return 'KO';
        End If;
    Exception
        When Others Then
            Return 'ER';
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
                /*If same FUTURE record exists in database then continue*/
                /*If no change then continue*/
                If tab_primary_workspace(1).primary_workspace = v_workspace_code Then
                    Continue;
                End If;

                /*Delete existing SWP DESK ASSIGNMENT planning*/
                del_emp_future_planning(
                    p_empno               => v_empno,
                    p_planning_start_date => trunc(rec_config_week.start_date)
                );
                /**/
                v_ows_desk_id := iot_swp_common.get_swp_planned_desk(v_empno);
                /*Remove user desk association in DMS*/
                If Trim(v_ows_desk_id) Is Not Null Then
                    iot_swp_dms.sp_remove_desk_user(
                        p_person_id => p_person_id,
                        p_meta_id   => p_meta_id,

                        p_empno     => v_empno,
                        p_deskid    => v_ows_desk_id
                    );
                End If;

                /*If furture planning is reverted to old planning then continue*/
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
        /*,modified_on,*/
        /*modified_by*/
        )
        Values (
            p_empno,
            p_deskid
        /*,sysdate,*/
        /*v_mod_by_empno*/
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

    /* By Pradeep only for information*/

    Procedure sp_admin_assign_work_space(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_workspace_code   Number,
        p_start_date       Date,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_mod_by_empno Varchar2(5);
        v_key          Varchar2(10);
        c_active_code  Constant Number(1) := 0;
    Begin
        v_mod_by_empno := get_empno_from_meta_id(p_meta_id);
        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        v_key          := dbms_random.string('X', 10);

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
            p_empno,
            p_workspace_code,
            p_start_date,
            sysdate,
            v_mod_by_empno,
            c_active_code
        );

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_admin_delete_work_space(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,
        p_start_date       Date,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count             Number;
        v_mod_by            Varchar2(5);
        v_tab_from          Varchar2(2);

        v_empno             Varchar2(5);
        v_primary_workspace Number;
        v_start_date        Date;
        v_modified_on       Date;
        v_modified_by       Varchar2(5);

    Begin
        v_count        := 0;
        v_mod_by       := get_empno_from_meta_id(p_meta_id);

        If v_mod_by = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            empno, primary_workspace, start_date, modified_on, modified_by
        Into
            v_empno, v_primary_workspace, v_start_date, v_modified_on, v_modified_by
        From
            swp_primary_workspace
        Where
            key_id = p_application_id
            And start_date >= p_start_date;

        Insert Into swp_primary_workspace_det
        (key_id, empno, primary_workspace, start_date,
            source_modifiedon, source_modifiedby, deleted_on, deleted_by)
        Values
        (p_application_id, v_empno, v_primary_workspace, v_start_date,
            v_modified_on, v_modified_by, sysdate, v_mod_by);

        If (Sql%rowcount > 0) Then
            Delete
                From swp_primary_workspace
            Where
                key_id = p_application_id
                And start_date >= p_start_date;
            Commit;
        Else
            p_message_type := 'KO';
            p_message_text := 'Faild to insert record into delete table ';
            Return;
            Rollback;
        End If;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_admin_delete_work_space;

    Procedure sp_assign_pws_emp(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_is_admin_call    Number Default 0,
        p_empno            Varchar2,
        p_workspace_code   Number,
        p_start_date       Date   Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_mod_by_empno        Varchar2(5);
        v_key                 Varchar2(10);
        c_active_code         Constant Number(1) := 0;

        Type typ_tab_primary_workspace Is Table Of swp_primary_workspace%rowtype Index By Binary_Integer;
        tab_primary_workspace typ_tab_primary_workspace;
        rec_config_week       swp_config_weeks%rowtype;
        c_planning_future     Constant Number(1) := 2;
        c_planning_current    Constant Number(1) := 1;
        c_planning_is_open    Constant Number(1) := 1;
        v_ows_desk_id         Varchar2(10);
        v_count               Number;
        v_is_emp_resigned     Varchar2(2);
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
                    empno = Trim(p_empno)
                Order By start_date Desc
            )
        Where
            Rownum <= 2;

        If p_workspace_code = '02' Then
            Select
                Count(*)
            Into
                v_count
            From
                ss_emplmast
            Where
                empno     = p_empno
                And grade = 'X1';
            v_is_emp_resigned := tcmpl_hr.pkg_common.fn_is_emp_resigned(p_empno);
            If v_is_emp_resigned = ok Or v_count > 0 Then
                p_message_type := not_ok;
                p_message_text := 'Err - Employee cannot be assigned smart workspace.';
                Return;
            End If;
        End If;

        If tab_primary_workspace.count > 0 Then
            /*If same FUTURE record exists in database then continue*/
            /*If no change then continue*/
            If tab_primary_workspace(1).primary_workspace = p_workspace_code Then
                p_message_type := 'OK';
                p_message_text := 'Procedure executed successfully.';
                Return;
            End If;

            /*Delete existing SWP DESK ASSIGNMENT planning*/
            del_emp_future_planning(
                p_empno               => p_empno,
                p_planning_start_date => trunc(rec_config_week.start_date)
            );

            v_ows_desk_id := iot_swp_common.get_swp_planned_desk(p_empno);
            /*Remove user desk association in DMS*/
            If Trim(v_ows_desk_id) Is Not Null Then
                iot_swp_dms.sp_remove_desk_user(
                    p_person_id => p_person_id,
                    p_meta_id   => p_meta_id,

                    p_empno     => p_empno,
                    p_deskid    => v_ows_desk_id
                );
            End If;

            /*If furture planning is reverted to old planning then continue*/
            If tab_primary_workspace(1).active_code = c_planning_future Then
                If tab_primary_workspace.Exists(2) Then
                    If tab_primary_workspace(2).primary_workspace = p_workspace_code Then
                        p_message_type := 'OK';
                        p_message_text := 'Procedure executed successfully.';
                        Return;
                    End If;
                End If;
            End If;
        End If;

        v_key          := dbms_random.string('X', 10);

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
            p_empno,
            p_workspace_code,
            rec_config_week.start_date,
            sysdate,
            v_mod_by_empno,
            c_planning_future
        );
        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_task_set_ows_of_resign_emp(
        p_empno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_is_emp_resigned Varchar2(2);
        v_key             Varchar2(10);
        n_pws             Number(1);
        n_pws_after_7days Number(1);
        v_sysdate         Date;
    Begin
        v_sysdate         := trunc(sysdate);
        v_is_emp_resigned := tcmpl_hr.pkg_common.fn_is_emp_resigned(p_empno);
        If v_is_emp_resigned = not_ok Then
            p_message_type := not_ok;
            p_message_text := 'Err - Employee not in resignation list.';
            Return;
        End If;
        
        --Get PWS as on today
        n_pws             := iot_swp_common.fn_get_emp_pws(p_empno, v_sysdate);

        If n_pws <> c_sws Then
            p_message_type := not_ok;
            p_message_text := 'Info - Employee not in SWS.';
            Return;

        End If;
        
        --Delete all SWS after today
        Delete
            From swp_primary_workspace
        Where
            empno = p_empno
            And start_date >= v_sysdate;

        --Delete SWS planning dates
        Delete
            From swp_smart_attendance_plan
        Where
            empno = p_empno
            And attendance_date >= v_sysdate;

        v_key             := dbms_random.string('X', 10);

        --Insert OWS as current PWS
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
            p_empno,
            c_ows,
            v_sysdate,
            sysdate,
            'RESIN',
            c_planning_future
        );
        Commit;
        p_message_type    := ok;
        p_message_text    := 'Procedure executed successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_task_set_dws_of_onsite_emp(
        p_empno            Varchar2,
        p_date             Date,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_is_emp_resigned Varchar2(2);
        v_key             Varchar2(10);
        n_pws             Number(1);
        n_pws_after_7days Number(1);
        v_sysdate         Date;
    Begin
        v_sysdate      := trunc(sysdate);
        
        --Get PWS as on today
        n_pws          := iot_swp_common.fn_get_emp_pws(p_empno, p_date);
        
        --Delete all PWS after today

        If n_pws = c_dws Then
            p_message_type := not_ok;
            p_message_text := 'Info - Employee already in DWS.';
            Return;
        Else
                
            -- delete all entries from PWS after PDATE
            Delete
                From swp_primary_workspace
            Where
                empno = p_empno
                And start_date >= p_date;
                
            --Delete SWS weekly planning dates
            Delete
                From swp_smart_attendance_plan
            Where
                empno = p_empno
                And attendance_date >= p_date;
        End If;

        v_key          := dbms_random.string('X', 10);

        --Insert DWS as current PWS
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
            p_empno,
            c_dws,
            p_date,
            sysdate,
            'SITE',
            c_planning_current
        );
        Commit;
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_task_set_ows_of_rejoin_emp(
        p_empno            Varchar2,
        p_date             Date,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_is_emp_resigned Varchar2(2);
        v_key             Varchar2(10);
        n_pws             Number(1);
        n_pws_after_7days Number(1);
        v_sysdate         Date;
    Begin
        v_sysdate      := trunc(sysdate);
        
        --Get PWS as on today
        n_pws          := iot_swp_common.fn_get_emp_pws(p_empno, p_date);
        
        --Delete all PWS after today

        If n_pws = c_ows Then
            p_message_type := not_ok;
            p_message_text := 'Info - Employee already in OWS.';
            Return;
        Else
                
            -- delete all entries from PWS after PDATE
            Delete
                From swp_primary_workspace
            Where
                empno = p_empno
                And start_date > p_date;
                
            --Delete SWS weekly planning dates
            Delete
                From swp_smart_attendance_plan
            Where
                empno = p_empno
                And attendance_date >= p_date;
        End If;

        v_key          := dbms_random.string('X', 10);

        --Insert OWS as current PWS
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
            p_empno,
            c_ows,
            p_date,
            sysdate,
            'OFFI',
            c_planning_current
        );
        Commit;
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

End iot_swp_primary_workspace;