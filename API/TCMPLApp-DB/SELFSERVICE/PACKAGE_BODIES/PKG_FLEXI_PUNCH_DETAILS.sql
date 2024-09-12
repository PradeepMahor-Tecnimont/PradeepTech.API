Create Or Replace Package Body selfservice.pkg_flexi_punch_details As

    Function fn_is_halfday_leave(
        p_empno Varchar2,
        p_date  Date
    ) Return Number Is
        v_count        Number;
        rec_leave_ledg ss_leaveledg%rowtype;
    Begin
        /*
        Return value meaning
        0 - None
        1 - First Half Leave
        2 - Second Half Leave
        3 - Full Day Leave
        */
        Select
            Count(*)
        Into
            v_count
        From
            ss_leaveledg
        Where
            empno = Trim(p_empno)
            And bdate <= p_date
            And nvl(edate, bdate) >= p_date
            And adj_type In ('LA', 'LC', 'SW');

        If v_count = 0 Then
            Return 0;
        End If;
        Select
            *
        Into
            rec_leave_ledg
        From
            (
                Select
                    *
                From
                    ss_leaveledg
                Where
                    empno = Trim(p_empno)
                    And bdate <= p_date
                    And nvl(edate, bdate) >= p_date
                    And adj_type In ('LA', 'LC', 'SW')
            )
        Where
            Rownum = 1;
        If Mod((rec_leave_ledg.leaveperiod * -1), 8) = 0 Then
            -- Full day leave
            Return 3;
        Else
            Return nvl(rec_leave_ledg.hd_part, 0);
        End If;
    Exception
        When Others Then
            Return 0;
    End;

    Function fn_get_work_hours(
        p_empno      In Varchar2,
        p_date       In Date,
        p_shift_code In Varchar2
    ) Return Number Is
        Cursor c1 Is
            Select
                *
            From
                (
                    Select
                        (hh * 60) + mm punch_time
                    From
                        ss_integratedpunch

                    Where
                        empno         = Trim(p_empno)
                        And pdate     = p_date
                        And falseflag = 1
                )
            Order By
                punch_time;

        Type typ_hrs Is
            Table Of c1%rowtype Index By Binary_Integer;
        tab_hrs               typ_hrs;

        v_wrk_hrs             Number;

        v_prev_punchtime      Number;
        v_curr_punchtime      Number;
        v_work_hrs_start_time Number;
        v_work_hrs_end_time   Number;
    Begin

        If p_shift_code = 'OO' Or p_shift_code = 'HH' Then
            v_work_hrs_start_time := 345;
            v_work_hrs_end_time   := 1400;
        Else
            Select
                work_hrs_start_mi, work_hrs_end_mi
            Into
                v_work_hrs_start_time, v_work_hrs_end_time
            From
                ss_shift_flexi_config
            Where
                shiftcode = ltrim(rtrim(p_shift_code));
        End If;

        Open c1;
        Fetch c1 Bulk Collect Into tab_hrs Limit 200;
        Close c1;

        v_wrk_hrs := 0;

        For i In 1..tab_hrs.count
        Loop
            If i > 1 Then
                --Odd counter "i"
                If (i Mod 2) = 1 Then

                    If tab_hrs(i).punch_time > v_work_hrs_end_time Then
                        Exit;
                    End If;

                End If;
                If (i Mod 2) = 0 Then
                    If tab_hrs(i).punch_time < v_work_hrs_start_time Then
                        Continue;
                    End If;
                    v_prev_punchtime := greatest(v_work_hrs_start_time, tab_hrs(i - 1).punch_time);

                    v_curr_punchtime := least(tab_hrs(i).punch_time, v_work_hrs_end_time);

                    v_wrk_hrs        := v_wrk_hrs + (v_curr_punchtime - v_prev_punchtime);
                End If;
            End If;
        End Loop;

        Return nvl(v_wrk_hrs, 0);
    Exception
        When Others Then
            Return 0;
    End;

    Function fn_flexi_deduction(

        p_flexi_deduction_for In Number
    ) Return Number Is
        v_first_punch          Number;
        v_last_punch           Number;
        v_first_punch_after_mi Number;
        v_last_punch_before_mi Number;
    Begin

        If nvl(p_flexi_deduction_for, 0) = 0 Then
            Return 0;
        End If;

        --if flex deduction is for first or second half
        --deduct 4 hours
        If p_flexi_deduction_for In (1, 2) Then
            Return 240;
        End If;
        --if flex deduction is for full day
        --deduct 8 hours
        If p_flexi_deduction_for = 3 Then
            Return 480;
        End If;

    End;

    Function fn_flexi_deduction_for(

        p_empno      In Varchar2,
        p_date       In Date,
        p_shift_code In Varchar2,
        p_work_hours In Number
    ) Return Number Is
        v_first_punch          Number;
        v_last_punch           Number;
        v_first_punch_after_mi Number;
        v_last_punch_before_mi Number;
        v_leave_for_day        Number;
        v_punch_count          Number;
    Begin
        /*
        Return value meaning
        0 - None
        1 - First Half Leave
        2 - Second Half Leave
        3 - Full Day Leave
        */

        If p_shift_code In ('HH', 'OO') Then
            Return 0;
        End If;

        v_leave_for_day := fn_is_halfday_leave(
                               p_empno => p_empno,
                               p_date  => p_date
                           );

        Select
            Count(*)
        Into
            v_punch_count
        From
            ss_integratedpunch
        Where
            pdate     = p_date
            And empno = p_empno;
        If v_punch_count = 0 Then
            Return 0;
        End If;
        If v_punch_count = 1 And v_leave_for_day = 0 Then
            Return 3;
        End If;
        --If work hours less then 4 hours
        --full day deduction applicable
        If p_work_hours < 240 And v_leave_for_day = 0 Then
            Return 3;
        End If;
        --if work hrs less then 3 hrs and half day leave applied
        --Half day leave to be deducted (1,2) (First half, Second Half)
        If p_work_hours < 180 And v_leave_for_day In (1, 2) Then
            If v_leave_for_day = 1 Then
                Return 2;
            Else
                Return 1;
            End If;
        Elsif v_leave_for_day In (1, 2) Then
            Return 0;
        End If;
        /*
                Select
                    Min(punch_time),
                    Max(punch_time)
                Into
                    v_first_punch,
                    v_last_punch
                From
                    (
                        Select
                            (hh * 60) + mm punch_time
                        From
                            ss_integratedpunch
        
                        Where
                            empno         = Trim(p_empno)
                            And pdate     = p_date
                            And falseflag = 1
                    );
        
                Select
                    first_punch_after_mi, last_punch_before_mi
                Into
                    v_first_punch_after_mi, v_last_punch_before_mi
                From
                    ss_shift_flexi_config
                Where
                    shiftcode = ltrim(rtrim(p_shift_code));
                    
                --
                --if first punch is after stipulated time
                --Flexi deduction applicable for first half
                If v_first_punch > v_first_punch_after_mi Then
                    Return 1;
                End If;
                    
                --if last punch is before stipulated time
                --Flexi deduction applicable for second half
                If v_last_punch < v_last_punch_before_mi Then
                    Return 2;
                End If;
        */
        Return 0;
    Exception
        When Others Then
            Return 0;
    End;

    Function fn_flexi_hours_to_honor(
        p_empno      In Varchar2,
        p_date       In Date,
        p_shift_code In Varchar2,
        p_work_hours In Number
    ) Return Number Is
        v_leave_for_day Number;
        v_deduction_for Number;
    Begin
        /*
        Return value meaning

        -1 - Cannot be honored
        0 - None
        1 - First Half
        2 - Second Half
        3 - Full Day
        4 - Not applicable
        */
        v_leave_for_day := fn_is_halfday_leave(
                               p_empno => p_empno,
                               p_date  => p_date
                           );

        If p_shift_code In ('HH', 'OO') Or v_leave_for_day = 3 Then
            Return -2;
        End If;

        v_deduction_for := fn_flexi_deduction_for(

                               p_empno      => p_empno,
                               p_date       => p_date,
                               p_shift_code => p_shift_code,
                               p_work_hours => p_work_hours
                           );

        v_leave_for_day := fn_is_halfday_leave(
                               p_empno => p_empno,
                               p_date  => p_date
                           );
        If (v_deduction_for In (1, 2) And v_leave_for_day In (1, 2)) Then
            Return -1;
        End If;
        If 1 In (v_deduction_for, v_leave_for_day) Then
            Return 2;
        End If;

        If 2 In (v_deduction_for, v_leave_for_day) Then
            Return 1;
        End If;
        Return 3;

    End;

    Function fn_flexi_hours_honored(
        p_empno      In Varchar2,
        p_date       In Date,
        p_shift_code In Varchar2,
        p_work_hours In Number
    ) Return Number Is
        v_flexi_hours_to_honor Number;
        v_first_punch          Number;
        v_last_punch           Number;
        rec_shift_flexi_config ss_shift_flexi_config%rowtype;
    Begin
        /*
        Return value meaning
        -1 - Cannot be honored
        0 - None
        1 - First Half Leave
        2 - Second Half Leave
        3 - Full Day Leave
        4 - Not applicable
        */

        v_flexi_hours_to_honor := fn_flexi_hours_to_honor(

                                      p_empno      => p_empno,
                                      p_date       => p_date,
                                      p_shift_code => p_shift_code,
                                      p_work_hours => p_work_hours
                                  );
        --  -1 Cannot be honored / 0 None / 4 Not applicable
        If v_flexi_hours_to_honor In (0, -1, 4) Then
            Return v_flexi_hours_to_honor;
        End If;

        --Get shift flexi config  details
        Select
            *
        Into
            rec_shift_flexi_config
        From
            ss_shift_flexi_config
        Where
            shiftcode = p_shift_code;

        --Get First & Last Punch
        Select
            Min(punch_time),
            Max(punch_time)
        Into
            v_first_punch,
            v_last_punch
        From
            (
                Select
                    (hh * 60) + mm punch_time
                From
                    ss_integratedpunch

                Where
                    empno         = Trim(p_empno)
                    And pdate     = p_date
                    And falseflag = 1
            );

        --First Half
        If v_flexi_hours_to_honor = 1 Then
            --compare Core Hours for First Half
            If rec_shift_flexi_config.ch_fh_start_mi >= v_first_punch And rec_shift_flexi_config.ch_fh_end_mi <= v_last_punch
            Then
                Return 1;

            End If;
        End If;

        --Second Half
        If v_flexi_hours_to_honor = 2 Then

            --compare Core Hours for Second Half
            If rec_shift_flexi_config.ch_sh_start_mi >= v_first_punch And rec_shift_flexi_config.ch_sh_end_mi <= v_last_punch
            Then
                Return 2;

            End If;
        End If;
        --Full Day
        If v_flexi_hours_to_honor = 3 Then
            --compare Core Hours for Full Day
            If rec_shift_flexi_config.ch_fd_start_mi >= v_first_punch And rec_shift_flexi_config.ch_fd_end_mi <= v_last_punch
            Then
                Return 3;

            End If;
        End If;
        Return 0;
    Exception
        When Others Then
            Return 0;

    End;

    Function fn_get_delta_hours(
        p_empno      In Varchar2,
        p_date       In Date,
        p_shift_code In Varchar2,
        p_work_hours In Number

    ) Return Number As
        v_flexi_deduction_for  Number;
        v_work_hours           Number;
        rec_shift_flexi_config ss_shift_flexi_config%rowtype;
        v_is_leave             Number;
        v_est_work_hours       Number;
        v_deductions           Number;
        v_punch_count          Number;
    Begin
        If p_shift_code In ('HH', 'OO') Then
            Return p_work_hours;
        End If;

        v_is_leave   := fn_is_halfday_leave(
                            p_empno => p_empno,
                            p_date  => p_date
                        );

        If v_is_leave = 3 Then
            Return 0;
        End If;
        Select
            Count(*)
        Into
            v_punch_count
        From
            ss_integratedpunch
        Where
            empno     = p_empno
            And pdate = p_date;
        If v_punch_count = 0 Then
            Return 0;
        End If;
        v_work_hours := fn_get_work_hours(
                            p_empno      => p_empno,
                            p_date       => p_date,
                            p_shift_code => p_shift_code
                        );

        v_deductions := fn_flexi_penalty(

                            p_empno      => p_empno,
                            p_date       => p_date,
                            p_shift_code => p_shift_code,
                            p_work_hours => v_work_hours
                        );

        v_is_leave   := fn_is_halfday_leave(
                            p_empno => p_empno,
                            p_date  => p_date
                        );

        Select
            *
        Into
            rec_shift_flexi_config
        From
            ss_shift_flexi_config
        Where
            shiftcode = p_shift_code;

        If v_is_leave In (1, 2) Then
            v_est_work_hours := rec_shift_flexi_config.half_day_work_mi;
        Else
            v_est_work_hours := rec_shift_flexi_config.full_day_work_mi;
        End If;
        Return v_work_hours + v_deductions - v_est_work_hours;
    Exception
        When Others Then
            Return 0;
    End;

    Function fn_get_extra_hours(
        p_empno      In Varchar2,
        p_date       In Date,
        p_shift_code In Varchar2,
        p_work_hours In Number
    ) Return Number Is
        v_delta_hours          Number;
        rec_shift_mast         ss_shiftmast%rowtype;
        rec_shift_flexi_config ss_shift_flexi_config%rowtype;
        v_flexi_hrs_honored    Number;
        v_extra_hrs            Number;
    Begin

        v_delta_hours       := fn_get_delta_hours(
                                   p_empno      => p_empno,
                                   p_date       => p_date,
                                   p_shift_code => p_shift_code,
                                   p_work_hours => p_work_hours
                               );
        If v_delta_hours < 120 Then
            Return 0;
        End If;
        If p_shift_code In ('HH', 'OO') Then
            If v_delta_hours >= 240 Then
                Return (floor(v_delta_hours / 60) * 60);
            Else
                Return 0;
            End If;

        End If;

        v_flexi_hrs_honored := fn_flexi_hours_honored(
                                   p_empno      => p_empno,
                                   p_date       => p_date,
                                   p_shift_code => p_shift_code,
                                   p_work_hours => p_work_hours
                               );
        If v_flexi_hrs_honored In (0, -1) Then
            Return 0;
        End If;
        Select
            *
        Into
            rec_shift_mast
        From
            ss_shiftmast
        Where
            shiftcode = p_shift_code;

        If nvl(rec_shift_mast.ot_applicable, 0) = 0 Then
            Return 0;
        End If;
        Select
            *
        Into
            rec_shift_flexi_config
        From
            ss_shift_flexi_config
        Where
            shiftcode = p_shift_code;

        If v_flexi_hrs_honored In (1, 2) Then
            v_extra_hrs := (floor(greatest(0, (p_work_hours - rec_shift_flexi_config.half_day_work_mi)) / 60) * 60);
        Elsif v_flexi_hrs_honored = 3 Then
            v_extra_hrs := floor(greatest(0, (p_work_hours - rec_shift_flexi_config.full_day_work_mi)) / 60) * 60;
        Else
            v_extra_hrs := 0;
        End If;
        If v_extra_hrs >= 120 Then
            Return 120;
        Else
            Return 0;
        End If;
    End;

    Function fn_get_hh_extra_hours(
        p_empno      In Varchar2,
        p_date       In Date,
        p_shift_code In Varchar2,
        p_work_hours In Number
    ) Return Number Is
        v_delta_hours          Number;
        rec_shift_mast         ss_shiftmast%rowtype;
        rec_shift_flexi_config ss_shift_flexi_config%rowtype;
        v_flexi_hrs_honored    Number;
    Begin

        v_delta_hours := fn_get_delta_hours(
                             p_empno      => p_empno,
                             p_date       => p_date,
                             p_shift_code => p_shift_code,
                             p_work_hours => p_work_hours
                         );
        If v_delta_hours < 120 Then
            Return 0;
        End If;
        If p_shift_code In ('HH', 'OO') Then
            If v_delta_hours >= 240 Then
                Return (floor(v_delta_hours / 60) * 60);
            End If;

        End If;
        Return 0;

    End;

    Function fn_punch_details_qry(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2 Default Null,
        p_yyyymm    Varchar2,
        p_for_ot    Varchar2 Default 'KO'
    ) Return Sys_Refcursor Is
        c                    Sys_Refcursor;
        v_count              Number;
        v_empno              Varchar2(5);
        v_for_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_start_date         Date;
        v_end_date           Date;

    Begin
        v_empno      := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If Trim(p_empno) Is Null Then
            v_for_empno := v_empno;
        Else
            v_for_empno := p_empno;

        End If;

        If p_for_ot = 'OK' Then
            v_end_date := n_getenddate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));
        Else
            v_end_date := last_day(To_Date(p_yyyymm, 'yyyymm'));
        End If;
        v_start_date := n_getstartdate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));

        Open c For
            With
                params As (
                    Select
                        v_for_empno  empno,
                        v_start_date p_startdate,
                        v_end_date   p_enddate
                    From
                        dual
                ),
                punch_details As(
                    Select
                        ip.empno            empno_a,
                        pdate,
                        Min((hh * 60) + mm) first_punch_a,
                        Max((hh * 60) + mm) last_punch_a,
                        Count(*)            punch_count
                    From
                        ss_integratedpunch ip,
                        params             p
                    Where
                        ip.empno         = p.empno
                        And ip.pdate Between p.p_startdate And p.p_enddate
                        And ip.falseflag = 1
                    Group By
                        ip.empno,
                        pdate
                ),
                day_details As (
                    Select
                        p.empno                    empno_d,
                        d_date,
                        d_dd,
                        d_day,
                        wk_of_year,
                        getshift1(p.empno, d_date) As shiftcode
                    From
                        ss_days_details dd,
                        params          p
                    Where
                        dd.d_date Between p.p_startdate And p.p_enddate
                )

            Select
                qry_2.*,

                Sum(deduction_hours) Over (Partition By wk_of_year)       wk_sum_deduction_hrs,
                Sum(ldt_hrs) Over (Partition By wk_of_year)               wk_sum_ldt_hrs,
                Sum(swp_exception_wfh_hrs) Over (Partition By wk_of_year) wk_sum_swp_exception_wfh_hrs,
                Sum(absent_hrs) Over (Partition By wk_of_year)            wk_sum_absent_hrs,
                Sum(est_work_hrs) Over (Partition By wk_of_year)          wk_sum_est_work_hrs,
                Sum(work_hrs) Over (Partition By wk_of_year)              wk_sum_work_hrs,
                Sum(deltahrs) Over (Partition By wk_of_year)              wk_sum_delta_hrs,
                Sum(extra_hrs) Over (Partition By wk_of_year)             wk_sum_extra_hrs,
                Sum(holiday_extra_hours) Over (Partition By wk_of_year)   wk_hh_extra_hrs

            From
                (
                    Select
                        qry_1.*,
                        pkg_flexi_punch_details.fn_get_delta_hours(empno, punch_date, shiftcode, work_hrs)      deltahrs,
                        pkg_flexi_punch_details.fn_flexi_deduction_for(empno, punch_date, shiftcode, work_hrs)  deduction_for,
                        pkg_flexi_punch_details.fn_flexi_hours_to_honor(empno, punch_date, shiftcode, work_hrs) flexi_to_honor,
                        pkg_flexi_punch_details.fn_flexi_hours_honored(empno, punch_date, shiftcode, work_hrs)  flexi_honored,
                        pkg_flexi_punch_details.fn_get_extra_hours(empno, punch_date, shiftcode, work_hrs)      extra_hrs,
                        pkg_flexi_punch_details.fn_get_hh_extra_hours(empno, punch_date, shiftcode, work_hrs)   holiday_extra_hours,
                        /*
                        pkg_flexi_punch_details.fn_flexi_deduction(
                            pkg_flexi_punch_details.fn_flexi_deduction_for(
                                empno, punch_date, shiftcode, work_hrs
                            )
                        )                                                                                       deduction_hours,*/
                        pkg_flexi_punch_details.fn_flexi_penalty(
                            empno, punch_date, shiftcode, work_hrs
                        )                                                                                       deduction_hours,
                        pkg_flexi_punch_details.fn_get_remarks(
                            empno,
                            punch_date,
                            shiftcode,
                            work_hrs,
                            is_absent,
                            is_ldt,
                            day_punch_count
                        )                                                                                       remarks,
                        (is_swp_exception_wfh * 60 * 8)                                                         swp_exception_wfh_hrs,
                        (is_absent * 60 * 8)                                                                    absent_hrs,
                        pkg_flexi_punch_details.fn_get_ldt_hours(is_halfday_leave, is_ldt, shiftcode)           ldt_hrs

                    From
                        (
                            Select
                                p.empno                                                                        As empno,
                                d_dd                                                                           As dd,
                                d_day                                                                          As ddd,
                                wk_of_year,

                                pd.first_punch_a                                                               As first_punch,
                                Case
                                    When punch_count > 1 Then
                                        pd.last_punch_a
                                    Else
                                        Null
                                End                                                                            As last_punch,
                                to_char(d_date, 'dd-Mon-yyyy')                                                 As mdate,
                                d_dd                                                                           As sday,
                                d_date                                                                         As punch_date,
                                dd.shiftcode,
                                nvl(full_day_work_mi, 0)                                                       As est_work_hrs,
                                isleavedeputour(d_date, p.empno)                                               As is_ldt,
                                pkg_region_holiday_calc.fn_get_holiday(p.empno, d_date)                        As is_sunday,
                                isabsent(p.empno, d_date)                                                      As is_absent,
                                pkg_flexi_punch_details.fn_get_work_hours(p.empno, d_date, dd.shiftcode)       As work_hrs,
                                pkg_flexi_punch_details.fn_is_halfday_leave(p.empno, d_date)                   As is_halfday_leave,
                                pkg_flexi_punch_details.fn_is_swp_exception_wfh(p.empno, d_date, dd.shiftcode) As is_swp_exception_wfh,
                                punch_count                                                                    As day_punch_count

                            From
                                day_details                           dd
                                Left Outer Join punch_details         pd
                                On dd.d_date = pd.pdate
                                Left Outer Join ss_shift_flexi_config fc
                                On dd.shiftcode = fc.shiftcode
                                Cross Join params                     p

                        ) qry_1

                ) qry_2
            Order By
                punch_date;
        Return c;

    End;

    Function fn_get_ldt_hours(
        p_halfday_leave Number,
        p_ldt           Number,
        p_shift_code    Varchar2
    ) Return Number Is
    Begin
        If p_shift_code In ('HH', 'OO') Then
            Return 0;
        End If;
        If p_halfday_leave In (1, 2) Then
            Return 60 * 4;
        Elsif p_ldt > 0 Then
            Return 60 * 8;
        Else
            Return 0;
        End If;
    End;

    Function fn_get_remarks(
        p_empno       In Varchar2,
        p_date        In Date,
        p_shift_code  In Varchar2,
        p_work_hours  In Varchar2,
        p_is_absent   In Number,

        p_is_ldt      In Number,
        p_punch_count In Number
    ) Return Varchar2 As
        v_remark     Varchar2(1000);
        v_swp_remark Varchar2(1000);
        v_deductions Number;

    Begin

        If p_is_absent = 1 Then
            Return 'Absent';
        End If;

        v_deductions := fn_flexi_penalty(

                            p_empno      => p_empno,
                            p_date       => p_date,
                            p_shift_code => p_shift_code,
                            p_work_hours => p_work_hours
                        );

        If nvl(v_deductions, 0) > 0 Then
            v_remark := to_char((v_deductions / 60)) || '_HrsLeaveDeducted';
        End If;
        If p_punch_count = 1 Then
            v_remark := nvl(v_remark, '') || '-MissedPunch';
        End If;

        v_swp_remark := iot_swp_common.fn_get_attendance_status(
                            p_empno,
                            trunc(p_date),
                            iot_swp_common.fn_get_emp_pws(p_empno, p_date)
                        );
        v_remark     := nvl(v_remark, '') || '-' || nvl(v_swp_remark, '');

        If upper(v_remark) Like upper('%Present%') And p_is_ldt = 1 Then
            v_remark := nvl(v_remark, '') || '-Leave';
        End If;
        v_remark     := trim (Leading '-' From nvl(v_remark, ''));
        Return v_remark;
    Exception
        When Others Then
            Return '--';
    End;

    Function fn_is_swp_exception_wfh(
        p_empno      Varchar2,
        p_date       Date,
        p_shift_code Varchar2
    ) Return Number Is
        c_sws      Constant Number := 2;
        v_pws      Number;
        v_count    Number;
        v_is_leave Number;
        v_fri_date Date;
    Begin
        /*
        Return value meaning
        0 - None
        1 - Smart work policy Exceptions or Work From Home exists
        */
        If p_shift_code In ('HH', 'OO') Then
            Return 0;
        End If;
        /*
        If p_date > trunc(sysdate) Then
            Return 0;
        End If;
        */
        Select
            Count(*)
        Into
            v_count
        From
            swp_exclude_emp
        Where
            p_date Between start_date And end_date
            And empno = p_empno;

        If v_count > 0 Then
            Return 1;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_integratedpunch
        Where
            empno         = p_empno
            And pdate     = p_date
            And falseflag = 1;
        If v_count > 0 Then
            Return 0;
        End If;

        v_pws      := iot_swp_common.fn_get_emp_pws(p_empno, p_date);
        If v_pws <> c_sws Then
            Return 0;
        End If;
        v_is_leave := isleavedeputour(p_date, p_empno);
        If v_is_leave > 0 Then
            Return 0;
        End If;

        v_fri_date := iot_swp_common.get_friday_date(sysdate);
        If v_fri_date < p_date Then
            Return 0;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            swp_smart_attendance_plan
        Where
            empno               = p_empno
            And attendance_date = p_date;
        If v_count > 0 Then
            Return 0;
        Else
            Return 1;
        End If;

    End;

    Function fn_flexi_penalty(
        p_empno      In Varchar2,
        p_date       In Date,
        p_shift_code In Varchar2,
        p_work_hours In Number
    ) Return Number Is
        v_flexi_hours_honored  Number;

        v_flexi_hours_to_honor Number;
        v_flexi_deduction_for  Number;

        v_count                Number;
        rec_shiftmast          ss_shiftmast%rowtype;
        rec_shift_flexi_config ss_shift_flexi_config%rowtype;
        rec_halfdaymast        ss_halfdaymast%rowtype;

        v_punch_first          Number;
        v_punch_last           Number;
        v_punch_count          Number;
        v_start_penalty        Number;
        v_end_penalty          Number;
        v_ch_start_mi          Number;
        v_ch_end_mi            Number;

        v_shift_start_mi       Number;
        v_shift_end_mi         Number;
        v_missed_ch_applied    Number;
        v_missed_ch_appl_cnt   Number;
        v_ot_bdate             Date;
        v_ot_edate             Date;
        v_yyyy                 Varchar2(4);
        v_mm                   Varchar2(2);
    Begin
        --Check Core work hours is honored
        v_flexi_hours_honored  := fn_flexi_hours_honored(
                                      p_empno      => p_empno,
                                      p_date       => p_date,
                                      p_shift_code => p_shift_code,
                                      p_work_hours => p_work_hours
                                  );

        --RETURN If flexi hours honored 
        If v_flexi_hours_honored <> 0 Then
            Return 0;
        End If;
        --XXXXX

        --Check Flexi Deduction exists
        v_flexi_deduction_for  := fn_flexi_deduction_for(
                                      p_empno      => p_empno,
                                      p_date       => p_date,
                                      p_shift_code => p_shift_code,
                                      p_work_hours => p_work_hours
                                  );

        --RETURN If flexi hours honored 
        If v_flexi_deduction_for <> 0 Then
            Return fn_flexi_deduction(
                    p_flexi_deduction_for => v_flexi_deduction_for
                );
        End If;
        --XXXXX

        --Check Missed CoreWorkHours is applied 
        Select
            Count(*)
        Into
            v_missed_ch_applied
        From
            ss_depu
        Where
            empno                 = p_empno
            And type              = 'MC'
            And bdate             = trunc(p_date)
            And bdate             = edate
            And nvl(hrd_apprl, 0) = 1;

        --If Missed CoreWorkHours is applied return
        If v_missed_ch_applied = 1 Then
            v_yyyy     := to_char(p_date, 'yyyy');
            v_mm       := to_char(p_date, 'mm');
            v_ot_edate := n_getenddate(v_mm, v_yyyy);

            If v_ot_edate < p_date Then

                v_yyyy     := to_char(add_months(p_date, 1), 'yyyy');

                v_mm       := to_char(add_months(p_date, 1), 'mm');

                v_ot_edate := n_getenddate(v_mm, v_yyyy);

            End If;
            v_ot_bdate := n_getstartdate(v_mm, v_yyyy);
            Select
                Count(*)
            Into
                v_missed_ch_appl_cnt
            From
                ss_depu
            Where
                empno                 = p_empno
                And type              = 'MC'
                And bdate Between v_ot_bdate And p_date
                And nvl(hrd_apprl, 0) = 1;

            If v_missed_ch_appl_cnt <= 2 Then
                Return 0;
            End If;
        End If;
        --XXXX

        v_flexi_hours_to_honor := fn_flexi_hours_to_honor(
                                      p_empno      => p_empno,
                                      p_date       => p_date,
                                      p_shift_code => p_shift_code,
                                      p_work_hours => p_work_hours
                                  );

        Select
            *
        Into
            rec_shiftmast
        From
            ss_shiftmast
        Where
            shiftcode = p_shift_code;

        Select
            *
        Into
            rec_shift_flexi_config
        From
            ss_shift_flexi_config
        Where
            shiftcode = p_shift_code;

        --Get First & Last Punch

        Select
            first_punch,
            last_punch,
            punch_count
        Into
            v_punch_first,
            v_punch_last,
            v_punch_count
        From
            (
                Select
                    ip.empno            empno_a,
                    pdate,
                    Min((hh * 60) + mm) first_punch,
                    Max((hh * 60) + mm) last_punch,
                    Count(*)            punch_count

                From
                    ss_integratedpunch ip

                Where
                    ip.empno         = p_empno
                    And ip.pdate     = p_date
                    And ip.falseflag = 1
                Group By ip.empno,
                    pdate
            );
            
        --Get shift Start and end time
        If v_flexi_hours_to_honor In (1, 2) Then
            Begin
                Select
                    *
                Into
                    rec_halfdaymast
                From
                    ss_halfdaymast
                Where
                    shiftcode = p_shift_code
                    And parent In (
                        Select
                            parent
                        From
                            ss_emplmast
                        Where
                            empno = p_empno
                    );
            Exception
                When Others Then
                    Return 0;
            End;

            If v_flexi_hours_to_honor = 1 Then
                v_shift_start_mi := (rec_halfdaymast.hday1_starthh * 60) + rec_halfdaymast.hday1_startmm;
                v_shift_end_mi   := (rec_halfdaymast.hday1_endhh * 60) + rec_halfdaymast.hday1_endmm;
            Elsif v_flexi_hours_to_honor = 2 Then
                v_shift_start_mi := (rec_halfdaymast.hday2_starthh * 60) + rec_halfdaymast.hday2_startmm;
                v_shift_end_mi   := (rec_halfdaymast.hday2_endhh * 60) + rec_halfdaymast.hday2_endmm;
            End If;
        Elsif v_flexi_hours_to_honor = 3 Then
            v_shift_start_mi := (rec_shiftmast.timein_hh * 60) + rec_shiftmast.timein_mn;
            v_shift_end_mi   := (rec_shiftmast.timeout_hh * 60) + rec_shiftmast.timeout_mn;
        End If;

        --Get Core Hours Start & End time
        If v_flexi_hours_to_honor = 1 Then
            v_ch_start_mi := rec_shift_flexi_config.ch_fh_start_mi;
            v_ch_end_mi   := rec_shift_flexi_config.ch_fh_end_mi;

        Elsif v_flexi_hours_to_honor = 2 Then
            v_ch_start_mi := rec_shift_flexi_config.ch_sh_start_mi;
            v_ch_end_mi   := rec_shift_flexi_config.ch_sh_end_mi;

        Elsif v_flexi_hours_to_honor = 3 Then
            v_ch_start_mi := rec_shift_flexi_config.ch_fd_start_mi;
            v_ch_end_mi   := rec_shift_flexi_config.ch_fd_end_mi;

        End If;

        --Calculate short-fall
        v_start_penalty        := 0;
        v_end_penalty          := 0;
        If v_ch_start_mi < v_punch_first Then
            v_start_penalty := v_punch_first - v_shift_start_mi;
            v_start_penalty := ceil(v_start_penalty / 60);
        End If;

        If v_ch_end_mi > v_punch_last Then
            v_end_penalty := v_shift_end_mi - v_punch_last;
            v_end_penalty := ceil(v_end_penalty / 60);
        End If;

        Return (nvl(v_start_penalty, 0) + nvl(v_end_penalty, 0)) * 60;

    Exception
        When Others Then
            Return 0;
    End;
End;
/