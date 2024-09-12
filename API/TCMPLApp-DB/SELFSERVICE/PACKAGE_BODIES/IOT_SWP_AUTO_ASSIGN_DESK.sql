Create Or Replace Package Body "SELFSERVICE"."IOT_SWP_AUTO_ASSIGN_DESK" As

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

    Procedure sp_assign_desk_to_exclude_emp(
        p_config_row swp_config_weeks%rowtype
    ) As
        Cursor cur_emp_list Is
            With
                exclude_emp As(
                    Select
                        *
                    From
                        swp_exclude_emp
                    Where
                        start_date Between p_config_row.start_date And p_config_row.end_date
                        Or end_date Between p_config_row.start_date And p_config_row.end_date

                )
            Select
                pws.empno,
                e.name,
                e.parent,
                e.assign,
                pws.primary_workspace,
                e.emptype,
                e.status,
                exclude_emp.start_date As exclude_start_date,
                exclude_emp.end_date   As exclude_end_date
            From
                swp_primary_workspace pws,
                ss_emplmast           e,
                exclude_emp           exclude_emp
            Where
                pws.empno                 = e.empno
                And exclude_emp.empno     = e.empno
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

                And e.grade <> 'X1'
            Order By
                e.assign,
                pws.empno;

        Type typ_tab_emp Is Table Of cur_emp_list%rowtype;
        tab_emp        typ_tab_emp;

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

        row_dept_area  dms.dm_desk_area_dept_map%rowtype;
        v_start_cntr   Number;
        v_cur_cntr     Number;
        v_desk_id      dms.dm_deskmaster.deskid%Type;
    Begin
        Open cur_week_dates;
        Fetch cur_week_dates Bulk Collect Into tab_week_dates Limit 5;

        Open cur_emp_list;
        Loop
            Fetch cur_emp_list Bulk Collect Into tab_emp Limit 50;
            --1st Loop
            For i In 1..tab_emp.count
            Loop
                /*
                Begin
                    Select
                        *
                    Into
                        row_dept_area
                    From
                        dms.dm_desk_area_dept_map
                    Where
                        assign = tab_emp(i).assign;
                Exception
                    When Others Then
                        row_dept_area := Null;
                End;
                */
                --2nd Loop
                v_start_cntr := 1;
                For ii In v_start_cntr..tab_week_dates.count
                Loop
                    v_cur_cntr := ii;
                    v_desk_id  := Null;
                    If tab_week_dates(ii).is_full = 1 Then
                        Continue;
                    End If;

                    If tab_week_dates(ii).d_date Between tab_emp(i).exclude_start_date And tab_emp(i).exclude_end_date Then
                        Continue;
                    End If;

                    If v_desk_id Is Null Then
                        v_desk_id := fn_get_available_smart_desk(tab_week_dates(ii).d_date, Null);
                    End If;

                    If v_desk_id Is Null Then
                        tab_week_dates(ii).is_full := 1;
                        Continue;
                    End If;
                    assign_sws_desk(tab_emp(i).empno, tab_week_dates(ii).d_date,
                                    v_desk_id);
                    Exit;
                End Loop;
                --2nd Loop End
                If v_cur_cntr In (tab_week_dates.count, 0) Then
                    v_start_cntr := 1;
                Else
                    v_start_cntr := v_cur_cntr + 1;
                End If;
            End Loop;
            Exit When cur_emp_list%notfound;
        End Loop;
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
            
            
        --delete invalid smart attendance plan
        --
        iot_swp_config_week.sp_del_invalid_swp_attend_plan(
            p_next_week_key_id => row_config_week.key_id,
            p_next_week_mon    => row_config_week.start_date,
            p_next_week_fri    => row_config_week.end_date
        );
        ---
        
        
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
            
        --XXXXXXXXXXXX--
        sp_assign_desk_to_exclude_emp(row_config_week);
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

            )
            And
            empno Not In (
                Select
                    empno
                From
                    swp_exclude_emp
                Where
                    start_date Between row_config_week.start_date And row_config_week.end_date
                    Or end_date Between row_config_week.start_date And row_config_week.end_date
            );

    End;

End;
/