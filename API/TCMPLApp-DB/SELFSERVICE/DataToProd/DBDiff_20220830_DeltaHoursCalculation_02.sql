--------------------------------------------------------
--  File created - Tuesday-August-30-2022   
--------------------------------------------------------
---------------------------
--Changed PACKAGE BODY
--IOT_PUNCH_DETAILS
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_PUNCH_DETAILS" As

    Procedure calculate_weekly_cfwd_hrs(
        p_wk_bfwd_dhrs   Number,
        p_wk_dhrs        Number,
        p_lday_lcome_ego Number,
        p_fri_sl_app     Number,
        p_cfwd_dhrs Out  Number,
        p_pn_hrs    Out  Number
    )
    As
        v_wk_negative_delta Number;
    Begin
        v_wk_negative_delta := nvl(p_wk_bfwd_dhrs, 0) + nvl(p_wk_dhrs, 0);
        If v_wk_negative_delta >= 0 Then
            p_pn_hrs    := 0;
            p_cfwd_dhrs := 0;
            Return;
        End If;
        If p_fri_sl_app <> 1 Then
            p_pn_hrs := ceil((v_wk_negative_delta * -1) / 60);
            If p_pn_hrs Between 5 And 8 Then
                p_pn_hrs := 8;
            End If;

            If p_pn_hrs * 60 > v_wk_negative_delta * -1 Then
                p_cfwd_dhrs := 0;
            Else
                p_cfwd_dhrs := v_wk_negative_delta + p_pn_hrs * 60;
            End If;
        Elsif p_fri_sl_app = 1 Then
            If v_wk_negative_delta > p_lday_lcome_ego Then
                p_pn_hrs    := 0;
                p_cfwd_dhrs := v_wk_negative_delta;
            Elsif v_wk_negative_delta < p_lday_lcome_ego Then
                p_pn_hrs := ceil((v_wk_negative_delta + (p_lday_lcome_ego * -1)) * -1 / 60);
                If p_pn_hrs Between 5 And 8 Then
                    p_pn_hrs := 8;
                End If;
                If p_pn_hrs * 60 > v_wk_negative_delta * -1 Then
                    p_cfwd_dhrs := 0;
                Else
                    p_cfwd_dhrs := v_wk_negative_delta + p_pn_hrs * 60;
                End If;
            End If;
        End If;
        p_pn_hrs            := nvl(p_pn_hrs, 0) * 60;
        
        --Comment next line
        --p_cfwd_dhrs         := nvl(p_fri_sl_app, 10);
    End;

    Function fn_punch_details_4_self(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2 Default Null,
        p_yyyymm    Varchar2,
        p_for_ot    Varchar2 Default 'KO'
    ) Return typ_tab_punch_data
        Pipelined
    Is
        v_prev_delta_hrs               Number;
        v_prev_lwrk_day_cfwd_delta_hrs Number;
        v_curr_lwrk_day_cfwd_delta_hrs Number;
        v_prev_lcome_app_cntr          Number;
        tab_punch_data                 typ_tab_punch_data;
        v_start_date                   Date;
        v_end_date                     Date;
        v_max_punch                    Number;
        v_empno                        Varchar2(5);
        e_employee_not_found           Exception;
        v_is_fri_lcome_ego_app         Number;
        c_absent                       Constant Number := 1;
        c_ldt_leave                    Constant Number := 1;
        c_ldt_tour_depu                Constant Number := 2;
        c_ldt_remote_work              Constant Number := 3;
        v_count                        Number;
        Pragma exception_init(e_employee_not_found, -20001);
        v_swp_start_date               Date;
        v_daily_remarks                Varchar2(200);
    Begin
        If Trim(p_empno) Is Null Then
            v_empno := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return;
            End If;
            /*Else
                Select
                    Count(*)
                Into
                    v_count
                From
                    ss_emplmast
                Where
                    empno      = p_empno
                    And status = 1;

                If v_count = 0 Then
                    Raise e_employee_not_found;
                    Return;
                Else
                    v_empno := p_empno;
                End If;*/
        Else
            v_empno := p_empno;

        End If;
        v_swp_start_date := To_Date('18-Apr-2022');
        If p_for_ot = 'OK' Then
            v_end_date := n_getenddate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));
        Else
            v_end_date := last_day(To_Date(p_yyyymm, 'yyyymm'));
        End If;
        v_start_date     := n_getstartdate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));

        v_max_punch      := n_maxpunch(v_empno, v_start_date, v_end_date);

        n_cfwd_lwd_deltahrs(
            p_empno       => v_empno,
            p_pdate       => To_Date(p_yyyymm, 'yyyymm'),
            p_savetot     => 0,
            p_deltahrs    => v_prev_delta_hrs,
            p_lwddeltahrs => v_prev_lwrk_day_cfwd_delta_hrs,
            p_lcappcntr   => v_prev_lcome_app_cntr
        );

        Open cur_for_punch_data(v_empno, v_start_date, v_end_date);
        Loop
            Fetch cur_for_punch_data Bulk Collect Into tab_punch_data Limit 7;
            For i In 1..tab_punch_data.count
            Loop

                If tab_punch_data(i).punch_date < v_swp_start_date Then
                    If tab_punch_data(i).is_absent = 1 Then
                        tab_punch_data(i).remarks := 'Absent';
                    Elsif tab_punch_data(i).penalty_hrs > 0 Then
                        If tab_punch_data(i).day_punch_count = 1 Then
                            tab_punch_data(i).remarks := tab_punch_data(i).penalty_hrs || '_HrsLeaveDedu(MissedPunch)';
                        Else
                            tab_punch_data(i).remarks := tab_punch_data(i).penalty_hrs || '_HrsLeaveDeducted';
                        End If;
                    Elsif tab_punch_data(i).is_ldt = c_ldt_leave Then
                        tab_punch_data(i).remarks := 'OnLeave';
                    Elsif tab_punch_data(i).is_ldt = c_ldt_tour_depu Then
                        tab_punch_data(i).remarks := 'OnTour-Depu';
                    Elsif tab_punch_data(i).is_ldt = c_ldt_remote_work Then
                        tab_punch_data(i).remarks := 'RemoteWork';
                    Elsif (tab_punch_data(i).is_sleave_app > 0 And tab_punch_data(i).sl_app_cntr < 3) Then
                        tab_punch_data(i).remarks := 'SLeave(Apprd)';
                    Elsif tab_punch_data(i).is_lc_app > 0 Then
                        tab_punch_data(i).remarks := 'LCome(Apprd)';
                    Elsif tab_punch_data(i).day_punch_count = 1 Then
                        tab_punch_data(i).remarks := 'MissedPunch';
                    End If;
                Else -- d_date  >= SWP Start Date
                    v_daily_remarks           := '';
                    If tab_punch_data(i).penalty_hrs > 0 Then
                        If tab_punch_data(i).day_punch_count = 1 Then
                            v_daily_remarks := tab_punch_data(i).penalty_hrs || '_HrsLeaveDedu(MissedPunch)';
                        Else
                            v_daily_remarks := tab_punch_data(i).penalty_hrs || '_HrsLeaveDeducted';
                        End If;
                    Elsif (tab_punch_data(i).is_sleave_app > 0 And tab_punch_data(i).sl_app_cntr < 3) Then
                        v_daily_remarks := 'SLeave(Apprd)';
                    Elsif tab_punch_data(i).is_lc_app > 0 Then
                        v_daily_remarks := 'LCome(Apprd)';
                    Elsif tab_punch_data(i).day_punch_count = 1 Then
                        v_daily_remarks := 'MissedPunch';
                    End If;
                    tab_punch_data(i).remarks := iot_swp_common.fn_get_attendance_status(
                                                     v_empno,
                                                     trunc(tab_punch_data(i).punch_date),
                                                     iot_swp_common.fn_get_emp_pws(v_empno, tab_punch_data(i).punch_date)
                                                 );
                    tab_punch_data(i).remarks := nvl(v_daily_remarks, '') || ' - ' || nvl(tab_punch_data(i).remarks, '');
                    tab_punch_data(i).remarks := trim(nvl(tab_punch_data(i).remarks, ''));
                    tab_punch_data(i).remarks := trim (Leading '-' From nvl(tab_punch_data(i).remarks, ''));
                    If upper(tab_punch_data(i).remarks) Like upper('%Present%') And tab_punch_data(i).is_ldt = c_ldt_leave
                    Then
                        tab_punch_data(i).remarks := tab_punch_data(i).remarks || ' - Leave';
                    End If;

                End If;
                --Remarks

                If tab_punch_data(i).is_lwd = 1 Then
                    If tab_punch_data(i).is_sleave_app = 1 And tab_punch_data(i).sl_app_cntr < 3 Then
                        v_is_fri_lcome_ego_app         := 1;
                        v_curr_lwrk_day_cfwd_delta_hrs := tab_punch_data(i).last_day_cfwd_dhrs;
                    Else
                        v_is_fri_lcome_ego_app := 0;
                    End If;
                End If;
                /*
                                if tab_punch_data(i).is_lwd =1 then
                                v_curr_lwrk_day_cfwd_delta_hrs := tab_punch_data(i).last_day_cfwd_dhrs;
                                end if;
                */
                If i = 7 Then
                    tab_punch_data(i).wk_bfwd_delta_hrs := v_prev_lwrk_day_cfwd_delta_hrs;
                    calculate_weekly_cfwd_hrs(
                        p_wk_bfwd_dhrs   => tab_punch_data(i).wk_bfwd_delta_hrs,
                        p_wk_dhrs        => tab_punch_data(i).wk_sum_delta_hrs,
                        p_lday_lcome_ego => nvl(v_curr_lwrk_day_cfwd_delta_hrs, 0),
                        p_fri_sl_app     => nvl(v_is_fri_lcome_ego_app, 0),
                        p_cfwd_dhrs      => tab_punch_data(i).wk_cfwd_delta_hrs,
                        p_pn_hrs         => tab_punch_data(i).wk_penalty_leave_hrs
                    );
                    v_prev_lwrk_day_cfwd_delta_hrs      := tab_punch_data(i).wk_cfwd_delta_hrs;
                    --If p_meta_id = '4EFFBD4567B5FCD5C2D9' Then
                    If tab_punch_data(i).wk_sum_delta_hrs <= 0 Then
                        tab_punch_data(i).wk_sum_weekday_extra_hrs := 0;
                    Else
                        tab_punch_data(i).wk_sum_weekday_extra_hrs := trunc((least(tab_punch_data(i).wk_sum_weekday_extra_hrs,
                                                                                   tab_punch_data(i).wk_sum_delta_hrs)) /
                                                                          120) * 120;
                    End If;
                    --End If;
                    v_curr_lwrk_day_cfwd_delta_hrs      := 0;
                End If;

                --tab_punch_data(i).str_wk_sum_work_hrs      := to_hrs(tab_punch_data(i).wk_sum_work_hrs);
                --tab_punch_data(i).str_wk_sum_delta_hrs     := to_hrs(tab_punch_data(i).wk_sum_delta_hrs);
                --tab_punch_data(i).str_wk_bfwd_delta_hrs    := to_hrs(tab_punch_data(i).wk_bfwd_delta_hrs);
                --tab_punch_data(i).str_wk_cfwd_delta_hrs    := to_hrs(tab_punch_data(i).wk_cfwd_delta_hrs);
                --tab_punch_data(i).str_wk_penalty_leave_hrs := to_hrs(tab_punch_data(i).wk_penalty_leave_hrs);

                Pipe Row(tab_punch_data(i));
            End Loop;
            tab_punch_data := Null;
            Exit When cur_for_punch_data%notfound;
        End Loop;
        Close cur_for_punch_data;
        Return;
    End fn_punch_details_4_self;

    Function fn_day_punch_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2,
        p_date      Date
    ) Return typ_tab_day_punch_list
        Pipelined
    Is
        tab_day_punch_list   typ_tab_day_punch_list;
        v_count              Number;

        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = p_empno;
        If v_count = 0 Then
            Raise e_employee_not_found;
            Return;
        End If;

        Open cur_day_punch_list(p_empno, p_date);
        Loop
            Fetch cur_day_punch_list Bulk Collect Into tab_day_punch_list Limit 50;
            For i In 1..tab_day_punch_list.count
            Loop
                Pipe Row(tab_day_punch_list(i));
            End Loop;
            Exit When cur_day_punch_list%notfound;
        End Loop;
        Close cur_day_punch_list;
        Return;
    End fn_day_punch_list;

    Procedure punch_details_pipe(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2 Default Null,
        p_yyyymm    Varchar2,
        p_for_ot    Varchar2 Default 'KO'
    )
    Is
        v_prev_delta_hrs               Number;
        v_prev_lwrk_day_cfwd_delta_hrs Number;
        v_prev_lcome_app_cntr          Number;
        tab_punch_data                 typ_tab_punch_data;
        v_start_date                   Date;
        v_end_date                     Date;
        v_max_punch                    Number;
        v_empno                        Varchar2(5);
        e_employee_not_found           Exception;
        v_is_fri_lcome_ego_app         Number;
        c_absent                       Constant Number := 1;
        c_ldt_leave                    Constant Number := 1;
        c_ldt_tour_depu                Constant Number := 2;
        c_ldt_remote_work              Constant Number := 3;
        v_count                        Number;
        Pragma exception_init(e_employee_not_found, -20001);
        v_swp_start_date               Date;
        v_daily_remarks                Varchar2(200);
    Begin
        If Trim(p_empno) Is Null Then
            v_empno := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return;
            End If;
            /*Else
                Select
                    Count(*)
                Into
                    v_count
                From
                    ss_emplmast
                Where
                    empno      = p_empno
                    And status = 1;

                If v_count = 0 Then
                    Raise e_employee_not_found;
                    Return;
                Else
                    v_empno := p_empno;
                End If;*/
        Else
            v_empno := p_empno;

        End If;
        v_swp_start_date := To_Date('18-Apr-2022');
        If p_for_ot = 'OK' Then
            v_end_date := n_getenddate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));
        Else
            v_end_date := last_day(To_Date(p_yyyymm, 'yyyymm'));
        End If;
        v_start_date     := n_getstartdate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));

        v_max_punch      := n_maxpunch(v_empno, v_start_date, v_end_date);

        n_cfwd_lwd_deltahrs(
            p_empno       => v_empno,
            p_pdate       => To_Date(p_yyyymm, 'yyyymm'),
            p_savetot     => 0,
            p_deltahrs    => v_prev_delta_hrs,
            p_lwddeltahrs => v_prev_lwrk_day_cfwd_delta_hrs,
            p_lcappcntr   => v_prev_lcome_app_cntr
        );

        Open cur_for_punch_data(v_empno, v_start_date, v_end_date);
        Loop
            Fetch cur_for_punch_data Bulk Collect Into tab_punch_data Limit 7;
            For i In 1..tab_punch_data.count
            Loop
                If to_char(tab_punch_data(i).punch_date, 'yyyymmdd') = '20220701' Then
                    v_count := v_count;
                End If;
                If tab_punch_data(i).punch_date < v_swp_start_date Then
                    If tab_punch_data(i).is_absent = 1 Then
                        tab_punch_data(i).remarks := 'Absent';
                    Elsif tab_punch_data(i).penalty_hrs > 0 Then
                        If tab_punch_data(i).day_punch_count = 1 Then
                            tab_punch_data(i).remarks := tab_punch_data(i).penalty_hrs || '_HrsLeaveDedu(MissedPunch)';
                        Else
                            tab_punch_data(i).remarks := tab_punch_data(i).penalty_hrs || '_HrsLeaveDeducted';
                        End If;
                    Elsif tab_punch_data(i).is_ldt = c_ldt_leave Then
                        tab_punch_data(i).remarks := 'OnLeave';
                    Elsif tab_punch_data(i).is_ldt = c_ldt_tour_depu Then
                        tab_punch_data(i).remarks := 'OnTour-Depu';
                    Elsif tab_punch_data(i).is_ldt = c_ldt_remote_work Then
                        tab_punch_data(i).remarks := 'RemoteWork';
                    Elsif (tab_punch_data(i).is_sleave_app > 0 And tab_punch_data(i).sl_app_cntr < 3) Then
                        tab_punch_data(i).remarks := 'SLeave(Apprd)';
                    Elsif tab_punch_data(i).is_lc_app > 0 Then
                        tab_punch_data(i).remarks := 'LCome(Apprd)';
                    Elsif tab_punch_data(i).day_punch_count = 1 Then
                        tab_punch_data(i).remarks := 'MissedPunch';
                    End If;
                Else -- d_date  >= SWP Start Date
                    v_daily_remarks           := '';
                    If tab_punch_data(i).penalty_hrs > 0 Then
                        If tab_punch_data(i).day_punch_count = 1 Then
                            v_daily_remarks := tab_punch_data(i).penalty_hrs || '_HrsLeaveDedu(MissedPunch)';
                        Else
                            v_daily_remarks := tab_punch_data(i).penalty_hrs || '_HrsLeaveDeducted';
                        End If;
                    Elsif (tab_punch_data(i).is_sleave_app > 0 And tab_punch_data(i).sl_app_cntr < 3) Then
                        v_daily_remarks := 'SLeave(Apprd)';
                    Elsif tab_punch_data(i).is_lc_app > 0 Then
                        v_daily_remarks := 'LCome(Apprd)';
                    Elsif tab_punch_data(i).day_punch_count = 1 Then
                        v_daily_remarks := 'MissedPunch';
                    End If;
                    tab_punch_data(i).remarks := iot_swp_common.fn_get_attendance_status(
                                                     v_empno,
                                                     trunc(tab_punch_data(i).punch_date),
                                                     iot_swp_common.fn_get_emp_pws(v_empno, tab_punch_data(i).punch_date)
                                                 );
                    tab_punch_data(i).remarks := nvl(v_daily_remarks, '') || ' - ' || nvl(tab_punch_data(i).remarks, '');
                    tab_punch_data(i).remarks := trim(nvl(tab_punch_data(i).remarks, ''));
                    tab_punch_data(i).remarks := trim (Leading '-' From nvl(tab_punch_data(i).remarks, ''));
                End If;
                --Remarks

                If tab_punch_data(i).is_lwd = 1 And tab_punch_data(i).is_sleave_app = 1 And tab_punch_data(i).sl_app_cntr < 3
                Then
                    v_is_fri_lcome_ego_app := 1;
                Else
                    v_is_fri_lcome_ego_app := 0;
                End If;

                If i = 7 Then
                    tab_punch_data(i).wk_bfwd_delta_hrs := v_prev_lwrk_day_cfwd_delta_hrs;
                    calculate_weekly_cfwd_hrs(
                        p_wk_bfwd_dhrs   => tab_punch_data(i).wk_bfwd_delta_hrs,
                        p_wk_dhrs        => tab_punch_data(i).wk_sum_delta_hrs,
                        p_lday_lcome_ego => tab_punch_data(i).last_day_cfwd_dhrs,
                        p_fri_sl_app     => v_is_fri_lcome_ego_app,
                        p_cfwd_dhrs      => tab_punch_data(i).wk_cfwd_delta_hrs,
                        p_pn_hrs         => tab_punch_data(i).wk_penalty_leave_hrs
                    );
                    v_prev_lwrk_day_cfwd_delta_hrs      := tab_punch_data(i).wk_cfwd_delta_hrs;
                    --If p_meta_id = '4EFFBD4567B5FCD5C2D9' Then
                    If tab_punch_data(i).wk_sum_delta_hrs <= 0 Then
                        tab_punch_data(i).wk_sum_weekday_extra_hrs := 0;
                    Else
                        tab_punch_data(i).wk_sum_weekday_extra_hrs := trunc((least(tab_punch_data(i).wk_sum_weekday_extra_hrs,
                                                                                   tab_punch_data(i).wk_sum_delta_hrs)) /
                                                                          120) * 120;
                    End If;
                    --End If;
                End If;

                --tab_punch_data(i).str_wk_sum_work_hrs      := to_hrs(tab_punch_data(i).wk_sum_work_hrs);
                --tab_punch_data(i).str_wk_sum_delta_hrs     := to_hrs(tab_punch_data(i).wk_sum_delta_hrs);
                --tab_punch_data(i).str_wk_bfwd_delta_hrs    := to_hrs(tab_punch_data(i).wk_bfwd_delta_hrs);
                --tab_punch_data(i).str_wk_cfwd_delta_hrs    := to_hrs(tab_punch_data(i).wk_cfwd_delta_hrs);
                --tab_punch_data(i).str_wk_penalty_leave_hrs := to_hrs(tab_punch_data(i).wk_penalty_leave_hrs);

                --Pipe Row(tab_punch_data(i));
            End Loop;
            tab_punch_data := Null;
            Exit When cur_for_punch_data%notfound;
        End Loop;
        Close cur_for_punch_data;
    End;

End iot_punch_details;
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
            And e.assign = p_assign
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
        If v_dept_ows_count < v_swp_dept_ws_sum.ows_emp_count Then
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

    /* End*/

End iot_swp_primary_workspace;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_CONFIG_WEEK
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_CONFIG_WEEK" As
    c_plan_close_code   Constant Number      := 0;
    c_plan_open_code    Constant Number      := 1;
    c_past_plan_code    Constant Number      := 0;
    c_cur_plan_code     Constant Number      := 1;
    c_future_plan_code  Constant Number      := 2;

    c_pws               Constant Number      := 100;

    c_ows               Constant Number      := 1;
    c_sws               Constant Number      := 2;
    c_dws               Constant Number      := 3;

    c_general_area_catg Constant Varchar2(4) := 'A002';

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
            Sum(pws) sum_pws,
            Sum(sws) sum_sws,
            Sum(ows) sum_ows,
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
                    End As pws,
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
                    End As ows

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
                            )
                        Order By d_date Desc
                    )
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
                            )
                        Order By d_date Desc
                    )
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
            1 As pws,
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

        --if exists, Delete smart attendance plan for next week 
        Delete
            From swp_smart_attendance_plan
        Where
            attendance_date Between v_next_week_mon And v_next_week_fri;

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
            And week_key_id = v_next_week_key_id;
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
                    holiday Between v_next_week_mon And v_next_week_fri
            )
            And week_key_id = v_next_week_key_id;

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
            And week_key_id = v_next_week_key_id;

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
            And week_key_id = v_next_week_key_id;
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
        v_flag_open_pws_plan  Varchar2(4)  := 'F005';
        v_flag_open_sws_plan  Varchar2(4)  := 'F006';

        v_flag_close_pws_plan Varchar2(4)  := 'F007';
        v_flag_close_sws_plan Varchar2(4)  := 'F008';

        v_open_pws            Boolean;
        v_open_sws            Boolean;

        v_close_pws           Boolean;
        v_close_sws           Boolean;
        v_cur_env             Varchar2(60);
        c_dev_env             Varchar2(60) := 'tpldev11g.ticb.comp';
        c_qual_env            Varchar2(60) := lower('TPLQUALORADB');
        ok                    Varchar2(2)  := 'OK';
        not_ok                Varchar2(2)  := 'KO';
    Begin

        Select
            sys_context('userenv', 'service_name')
        Into
            v_cur_env
        From
            dual;

        sp_add_new_joinees_to_pws;

        v_sysdate            := trunc(sysdate);
        v_fri_date           := iot_swp_common.get_friday_date(trunc(v_sysdate));

        --Hard-Code date for DEV env
        If lower(v_cur_env) In (c_dev_env, c_qual_env) Then
            --v_sysdate := To_Date('9-Aug-2022');
            Null;
        End If;
        --

        remove_temp_desks(v_sysdate);

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

        --
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
--New FUNCTION
--N_WRK_HRS_BEFORE_SHIFT_INTIME
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."N_WRK_HRS_BEFORE_SHIFT_INTIME" (
    p_empno      In Varchar2,
    p_date       In Date,
    p_shift_code In Varchar2
) Return Number As

    Cursor c1(p_shift_in_time Number) Is
        Select
            *
        From
            (
                Select
                    (hh * 60) + mm punch_time,
                    odtype
                From
                    ss_integratedpunch
                Where
                    empno         = Trim(p_empno)
                    And pdate     = p_date
                    And falseflag = 1

                Order By pdate,
                    hhsort,
                    mmsort,
                    hh,
                    mm
            )
        Where
            punch_time < p_shift_in_time;

    Type typ_hrs Is
        Table Of c1%rowtype Index By Binary_Integer;
    tab_hrs                     typ_hrs;
    v_shift_in_time             Number;
    v_rec_count                 Number;
    v_wrk_hrs                   Number;
    v_punch_count_after_shiftin Number;
Begin
    v_wrk_hrs   := 0;
    If p_shift_code In ('OO', 'HH') Then
        Return 0;
    Else
        Select
            (timein_hh * 60) + timein_mn
        Into
            v_shift_in_time
        From
            ss_shiftmast
        Where
            shiftcode = ltrim(rtrim(p_shift_code));
    End If;
    Open c1(v_shift_in_time);
    Fetch c1 Bulk Collect Into tab_hrs Limit 100;
    Close c1;

    Select
        Count(*)
    Into
        v_punch_count_after_shiftin
    From
        (
            Select
                (hh * 60) + mm punch_time,
                odtype
            From
                ss_integratedpunch
            Where
                empno         = Trim(p_empno)
                And pdate     = p_date
                And falseflag = 1

            Order By pdate,
                hhsort,
                mmsort,
                hh,
                mm
        )
    Where
        punch_time >= v_shift_in_time;

    If tab_hrs.count = 0 Then
        Return 0;
    End If;

    v_rec_count := tab_hrs.count;
    --When odd punch found add extra element
    If (v_rec_count Mod 2) = 1 And v_punch_count_after_shiftin > 0 Then
        tab_hrs(v_rec_count + 1).punch_time := v_shift_in_time;
        tab_hrs(v_rec_count + 1).odtype     := 0;
        --If there are no punch after shiftin
        --and only one punch
    Elsif v_rec_count <= 1 Then
        Return 0;
    End If;

    For i In 1..tab_hrs.count
    Loop
        If i > 1 Then
            --Odd counter "i"
            If (i Mod 2) = 1 Then
                --For OnDuty application timing Continuity
                --(difference between CurrTime and PrevTime <= 60) 
                -- and (IsOdd punch) and (CurrIsOnDuty or PrevIsOnDuty)
                If (tab_hrs(i).odtype <> 0 Or tab_hrs(i - 1).odtype <> 0) And
                    (tab_hrs(i).punch_time - tab_hrs(i - 1).punch_time <= 60)
                Then
                    tab_hrs(i) := tab_hrs(i - 1);
                End If;
            End If;
            If (i Mod 2) = 0 Then
                v_wrk_hrs := v_wrk_hrs + (tab_hrs(i).punch_time - tab_hrs(i - 1).punch_time);
            End If;
        End If;
    End Loop;

    If v_shift_in_time > (12 * 60) Then --Second shift
        If p_date >= To_Date('27-Jun-2022', 'dd-Mon-yyyy') Then -- After 12:00  noon
            If v_wrk_hrs < 120 Then
                v_wrk_hrs := least(15, v_wrk_hrs);
            End If;

            --Else
            --v_wrk_hrs := least(15, v_wrk_hrs);
        End If;
    Else
        v_wrk_hrs := least(15, v_wrk_hrs);
    End If;
    Return v_wrk_hrs;
End n_wrk_hrs_before_shift_intime;
/
---------------------------
--Changed FUNCTION
--N_WORKEDHRS_INCLUDE_2ND_SHIFT
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."N_WORKEDHRS_INCLUDE_2ND_SHIFT" (
    p_empno      In Varchar2,
    p_date       In Date,
    p_shift_code In Varchar2
) Return Number Is
    Cursor c1(cp_shift_in_time Number) Is

        Select
            (hh * 60) + mm punch_time,
            odtype
        From
            ss_integratedpunch
        Where
            empno         = Trim(p_empno)
            And pdate     = p_date
            And falseflag = 1

        Order By
            pdate,
            hhsort,
            mmsort,
            hh,
            mm;

    Type typ_hrs Is
        Table Of c1%rowtype Index By Binary_Integer;
    tab_hrs            typ_hrs;
    v_shift_in_time    Number;
    v_rec_count        Number;
    v_wrk_hrs          Number;

    Type tabhrs Is
        Table Of Number Index By Binary_Integer;
    Type tabodappl Is
        Table Of Number Index By Binary_Integer;
    v_tabhrs           tabhrs;
    v_tabodappl        tabodappl;
    cntr               Number;
    thrs               Varchar2(10);
    totalhrs           Number;
    v_i_hh             Number;
    v_i_mm             Number;
    v_o_hh             Number;
    v_o_mm             Number;
    v_intime           Number;
    v_outtime          Number;
    v_count            Number;
    v_availedlunchtime Number := 0;
    v_first_punch_min  Number;
    v_morning_wrk_hrs  Number;
    v_prev_punchtime   Number;
Begin
    v_morning_wrk_hrs  := 0;
    If p_shift_code = 'OO' And p_shift_code = 'HH' Then
        v_shift_in_time := 0;

    Else
        Select
            (timein_hh * 60) + timein_mn
        Into
            v_shift_in_time
        From
            ss_shiftmast
        Where
            shiftcode = ltrim(rtrim(p_shift_code));
    End If;
    Open c1(v_shift_in_time);
    Fetch c1 Bulk Collect Into tab_hrs Limit 200;
    Close c1;

    If tab_hrs.count <= 1 Then
        Return 0;
    End If;

    v_morning_wrk_hrs  := n_wrk_hrs_before_shift_intime(p_empno, p_date, p_shift_code);

    v_wrk_hrs          := 0;
    For i In 1..tab_hrs.count
    Loop
        If i > 1 Then
            --Odd counter "i"
            If (i Mod 2) = 1 Then
                --For OnDuty application timing Continuity
                --(difference between CurrTime and PrevTime <= 60) 
                -- and (IsOdd punch) and (CurrIsOnDuty or PrevIsOnDuty)
                /*If (tab_hrs(i).odtype <> 0 Or tab_hrs(i - 1).odtype <> 0) And
                    (tab_hrs(i).punch_time - tab_hrs(i - 1).punch_time <= 60)
                Then
                    tab_hrs(i) := tab_hrs(i - 1);
                End If;
                */
                Null;
            End If;
            If (i Mod 2) = 0 Then
                If tab_hrs(i).punch_time < v_shift_in_time Then
                    Continue;
                End If;
                v_prev_punchtime := greatest(v_shift_in_time, tab_hrs(i - 1).punch_time);
                v_wrk_hrs        := v_wrk_hrs + (tab_hrs(i).punch_time - v_prev_punchtime);
            End If;
        End If;
    End Loop;

    v_availedlunchtime := availedlunchtime1(p_empno, p_date, p_shift_code);
    totalhrs           := v_wrk_hrs - v_availedlunchtime + v_morning_wrk_hrs;
    Return greatest(nvl(totalhrs, 0), 0);
Exception
    When Others Then
        Return 0;
End;
/
