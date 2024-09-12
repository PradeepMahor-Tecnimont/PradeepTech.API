--------------------------------------------------------
--  File created - Thursday-April-21-2022   
--------------------------------------------------------
---------------------------
--Changed PACKAGE
--IOT_SWP_SMART_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_SMART_WORKSPACE" As
    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;
    c_office_workspace Constant Number := 1;
    c_smart_workspace Constant Number := 2;
    c_not_in_mum_office Constant Number := 3;

    Procedure sp_add_weekly_atnd(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_weekly_attendance typ_tab_string,
        p_empno             Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    );

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
    );

    Procedure sp_sys_assign_sws_desk(
        p_empno            Varchar2,
        p_attendance_date  Date,
        p_deskid           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );
End iot_swp_smart_workspace;
/
---------------------------
--New PACKAGE BODY
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
                    office = nvl(p_office, office)
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
                    office        = p_office
                    And work_area = p_area_code
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
                        And b.start_date <= sysdate
                )
                And pws.empno Not In (
                    Select
                        empno
                    From
                        swp_smart_attendance_plan
                    Where
                        attendance_date Between p_config_row.start_date And p_config_row.end_date
                );

        Type typ_tab_tf_emp_list Is Table Of cur_tf_emp_list%rowtype;
        tab_tf_emp_list typ_tab_tf_emp_list;

        Cursor cur_week_dates Is
            Select
                d_date, 0 is_full
            From
                ss_days_details dd,
                ss_holidays     h
            Where
                d_date Between p_config_row.start_date And p_config_row.end_date
                And dd.d_date <> h.holiday
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

        Open cur_week_dates;
        Fetch cur_week_dates Bulk Collect Into tab_week_dates Limit 5;

        For task_force_office_row In cur_tf_office_list
        --1st Loop
        Loop
            v_start_cntr := 1;
            v_cur_cntr   := 0;

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
                        And b.start_date <= sysdate
                )

                And pws.empno Not In (
                    Select
                        empno
                    From
                        swp_smart_attendance_plan
                    Where
                        attendance_date Between p_config_row.start_date And p_config_row.end_date
                );

        Cursor cur_week_dates Is
            Select
                d_date, 0 is_full
            From
                ss_days_details dd,
                ss_holidays     h
            Where
                d_date Between p_config_row.start_date And p_config_row.end_date
                And dd.d_date <> h.holiday
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

                    v_desk_id  := fn_get_available_smart_desk(tab_week_dates(ii).d_date, null);

                    If v_desk_id Is Null Then
                        tab_week_dates(ii).is_full := 1;
                        Continue;
                    End If;
                    assign_sws_desk(
                        tab_emp(i).empno,
                        tab_week_dates(ii).d_date,
                        v_desk_id
                    );
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
            cp_area_code Varchar2,
            cp_office    Varchar2
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
                        And b.start_date <= sysdate
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
                );
        Type typ_tab_deptemp Is Table Of cur_deptemp_list%rowtype;
        tab_deptemp    typ_tab_deptemp;

        Cursor cur_week_dates Is
            Select
                d_date, 0 is_full
            From
                ss_days_details                 dd, ss_holidays h
            Where
                d_date Between p_config_row.start_date And p_config_row.end_date
                And dd.d_date <> h.holiday
            Order By
                d_date;

        Type typ_tab_week_dates Is Table Of cur_week_dates%rowtype;
        tab_week_dates typ_tab_week_dates;

        Cursor cur_dept_area_list Is
            Select
            Distinct
                area_code, office
            From
                dms.dm_desk_area_dept_map;
        v_start_cntr   Number := 1;
        v_cur_cntr     Number;
        v_desk_id      Varchar2(7);

    Begin

        Open cur_week_dates;
        Fetch cur_week_dates Bulk Collect Into tab_week_dates Limit 5;

        --1st Loop
        For dept_area_list_row In cur_dept_area_list
        Loop
            Open cur_deptemp_list(dept_area_list_row.area_code, dept_area_list_row.office);
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

    End;

End;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_SMART_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_SMART_WORKSPACE" As
    c_planning_future  Constant Number(1) := 2;
    c_planning_current Constant Number(1) := 1;
    c_planning_is_open Constant Number(1) := 1;
    Procedure del_emp_sws_atend_plan(
        p_empno Varchar2,
        p_date  Date
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

        If Not iot_swp_common.is_desk_in_general_area(rec_smart_attendance_plan.deskid) Then
            Return;
        End If;
        --

        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = c_planning_future
            And sws_open  = c_planning_is_open;

        iot_swp_dms.sp_unlock_desk(
            p_person_id   => Null,
            p_meta_id     => Null,

            p_deskid      => rec_smart_attendance_plan.deskid,
            p_week_key_id => rec_config_week.key_id
        );

    End;

    Procedure sp_add_weekly_atnd(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_weekly_attendance typ_tab_string,
        p_empno             Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
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
        rec_config_week   swp_config_weeks%rowtype;
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
                to_date(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) attendance_date,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3))          desk,
                Trim(regexp_substr(str, '[^~!~]+', 1, 4))          status
            Into
                v_empno, v_attendance_date, v_desk, v_status
            From
                csv;

            If v_status = 0 Then
                del_emp_sws_atend_plan(
                    p_empno => v_empno,
                    p_date  => trunc(v_attendance_date)
                );
            End If;

            Delete
                From swp_smart_attendance_plan
            Where
                empno               = v_empno
                And attendance_date = v_attendance_date;

            If v_status = '1' Then

                v_pk := dbms_random.string('X', 10);

                Select
                    key_id
                Into
                    v_fk
                From
                    swp_primary_workspace
                Where
                    Trim(empno)                 = Trim(p_empno)
                    And Trim(primary_workspace) = '2';

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
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_weekly_atnd;

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

        For c1 In cur_summary(v_start_date, v_end_date)
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

        v_pk           := dbms_random.string('X', 10);

        Select
            key_id
        Into
            v_fk
        From
            swp_primary_workspace
        Where
            Trim(empno)                 = Trim(p_empno)
            And Trim(primary_workspace) = '2';

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
/
