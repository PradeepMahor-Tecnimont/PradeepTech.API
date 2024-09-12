Create Or Replace Package Body "SELFSERVICE"."IOT_PUNCH_DETAILS" As

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