Create Or Replace Package Body selfservice.analytical_reports As

    Procedure generate_delta_hours(
        p_start_date Date,
        p_end_date   Date
    ) As
        Cursor cur_dates Is
            Select
                d_date, hh.holiday
            From
                ss_days_details                 dd, ss_holidays hh
            Where
                dd.d_date = hh.holiday(+)
                And d_date Between p_start_date And p_end_date;
        Type typ_tab_dates Is Table Of cur_dates%rowtype;
        tab_dates typ_tab_dates;
    Begin
        Open cur_dates;
        Loop
            Fetch cur_dates Bulk Collect Into tab_dates Limit 50;
            For i In 1..tab_dates.count
            Loop

                Insert Into ss_report_worked_hrs(
                    empno,
                    pdate,
                    worked_hours,
                    is_holiday,
                    shift_code
                )
                With
                    emp_shift As (
                        Select
                            empno,
                            getshift1(empno, tab_dates(i).d_date) shift,
                            Case
                                When tab_dates(i).holiday Is Not Null Then
                                    1
                                Else
                                    0
                            End                                   As is_holiday
                        From
                            ss_emplmast
                        Where
                            empno In (
                                Select
                                    empno
                                From
                                    ss_punch
                                Where
                                    pdate = tab_dates(i).d_date
                            )
                    )
                Select
                    empno,
                    tab_dates(i).d_date,
                    n_workedhrs(empno, tab_dates(i).d_date, shift),
                    is_holiday,
                    shift
                From
                    emp_shift;
            End Loop;
            Delete
                From ss_report_worked_hrs
            Where
                worked_hours < 540
                And is_holiday = 0;
            Commit;
            Exit When cur_dates%notfound;
        End Loop;
    End;

    Function fn_penalty_leaves(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_from_yyyymm Varchar2,
        p_to_yyyymm   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                a.empno,
                b.name,
                b.parent,
                bdate,
                edate,
                app_no,
                app_date,
                leavetype,
                description,
                leaveperiod / 8 As leave_period,
                db_cr,
                adj_type
            From
                ss_leaveledg a,
                ss_emplmast  b
            Where
                bdate >= To_Date(p_from_yyyymm, 'yyyymm')
                And bdate <= last_day(To_Date(p_to_yyyymm, 'yyyymm'))
                And a.empno = b.empno
                And adj_type In ('LP', 'PN');
        Return c;
    End;

    Function fn_lwp_report(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_yyyymm    Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            With
                params As(
                    Select
                        p_date, last_day(add_months(p_date, -1)) p_prev_mon_last_day, last_day(add_months(p_date, -2)) p_prev_prev_mon_last_day
                    From
                        (
                            Select
                                p_yyyymm, To_Date(p_yyyymm || '20', 'yyyymmdd') p_date
                            From
                                dual
                        )
                ),
                emp_list As(
                    Select
                        personid,
                        empno,
                        name,
                        parent,
                        doj
                    From
                        ss_emplmast
                    Where
                        status = 1
                        And emptype In ('R', 'F')
                )
            Select
                personid personid,
                empno    empno,
                name     name,
                parent   parent,
                period   period,
                doj      doj,
                oh * -1  oh,
                pl * -1  pl,
                cl * -1  cl,
                co * -1  co
            From
                (
                    Select
                        personid,
                        empno,
                        name,
                        parent,
                        p.p_date                                                           period,
                        doj,
                        least(least(closingohbal(empno, p.p_date, 0), 0) - least(closingohbal(empno, p.p_prev_mon_last_day, 0), 0) -
                            least(
                                closingohbal(empno, p.p_prev_prev_mon_last_day, 0), 0), 0) oh,
                        least(least(closingplbal(empno, p.p_date, 0), 0) - least(closingplbal(empno, p.p_prev_mon_last_day, 0), 0) -
                            least(
                                closingplbal(empno, p.p_prev_prev_mon_last_day, 0), 0), 0) pl,
                        least(least(closingclbal(empno, p.p_date, 0), 0) - least(closingclbal(empno, p.p_prev_mon_last_day, 0), 0) -
                            least(
                                closingclbal(empno, p.p_prev_prev_mon_last_day, 0), 0), 0) cl,
                        least(least(closingcobal(empno, p.p_date, 0), 0) - least(closingcobal(empno, p.p_prev_mon_last_day, 0), 0) -
                            least(
                                closingcobal(empno, p.p_prev_prev_mon_last_day, 0), 0), 0) co
                    From
                        emp_list,
                        params p
                    Union
                    Select
                        personid,
                        empno,
                        name,
                        parent,
                        p.p_prev_mon_last_day                                                                                                            period,
                        doj,
                        least(least(closingohbal(empno, p.p_prev_mon_last_day, 0), 0) - least(closingohbal(empno, p.p_prev_prev_mon_last_day, 0), 0), 0)
                        oh,
                        least(least(closingplbal(empno, p.p_prev_mon_last_day, 0), 0) - least(closingplbal(empno, p.p_prev_prev_mon_last_day, 0), 0), 0)
                        pl,
                        least(least(closingclbal(empno, p.p_prev_mon_last_day, 0), 0) - least(closingclbal(empno, p.p_prev_prev_mon_last_day, 0), 0), 0)
                        cl,
                        least(least(closingcobal(empno, p.p_prev_mon_last_day, 0), 0) - least(closingcobal(empno, p.p_prev_prev_mon_last_day, 0), 0), 0)
                        co
                    From
                        emp_list, params p

                    Union
                    Select
                        personid,
                        empno,
                        name,
                        parent,
                        p.p_prev_prev_mon_last_day                                   period,
                        doj,
                        least(closingohbal(empno, p.p_prev_prev_mon_last_day, 0), 0) oh,
                        least(closingplbal(empno, p.p_prev_prev_mon_last_day, 0), 0) pl,
                        least(closingclbal(empno, p.p_prev_prev_mon_last_day, 0), 0) cl,
                        least(closingcobal(empno, p.p_prev_prev_mon_last_day, 0), 0) co
                    From
                        emp_list, params p
                )
            Where
                oh < 0
                Or pl < 0
                Or cl < 0
                Or co < 0;

        Return c;
    End;

    Function fn_excess_pl_lapse_report(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,
        p_start_date Date,
        p_end_date   Date
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                l.empno,
                name,
                parent,
                assign,
                grade,
                emptype,
                app_no,
                app_date,
                bdate,
                leavetype,
                (leaveperiod / -8) leave_period
            From
                ss_leaveledg l,
                ss_emplmast  e
            Where
                l.empno   = e.empno
                And db_cr = 'D'
                And adj_type In ('MA')
                And bdate Between p_start_date And p_end_date;
        Return c;
    End;

    Function fn_sick_leave_report(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,
        p_start_date Date,
        p_end_date   Date
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                e.empno,
                name,
                parent,
                assign,
                grade,
                emptype,
                app_no,
                reason,
                leavetype,
                bdate,
                edate,
                (leaveperiod / 8)            leave_period,
                ss.approval_text(lead_apprl) lead_approval,
                ss.approval_text(hod_apprl)  hod_approval,
                ss.approval_text(hrd_apprl)  hr_approval
            From
                ss_leaveapp l,
                ss_emplmast e
            Where
                l.empno       = e.empno
                And leavetype = 'SL'
                And (bdate Between p_start_date And p_end_date
                    Or edate Between p_start_date And p_end_date
                    Or p_start_date Between bdate And edate
                )
                And emptype In ('R', 'F');
        Return c;
    End;

    Function fn_leave_application_pending(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,
        p_start_date Date,
        p_end_date   Date
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For

            With
                params As (
                    Select
                        p_start_date As nu_bdate,
                        p_end_date   As nu_edate
                    From
                        dual
                )
            Select
                aa.empno,
                bb.name,
                bb.parent,
                bb.assign,
                bb.grade,
                aa.app_no,
                aa.leavetype,
                aa.nu_bdate,
                aa.nu_edate,
                aa.nu_leaveperiod,
                aa.bdate,
                aa.edate,
                aa.leave_period
            From
                (
                    Select
                        empno,
                        app_no,
                        app_date,
                        leavetype,
                        nu_bdate,
                        nu_edate,
                        leave_4_mm - holiday_count As nu_leaveperiod,
                        bdate,
                        edate,
                        leave_period
                    From
                        (
                            Select
                                empno,
                                app_no,
                                app_date,
                                leavetype,
                                reason,
                                leave_period,
                                1 + nu_edate - nu_bdate leave_4_mm,
                                bdate,
                                edate,
                                nu_bdate,
                                nu_edate,
                                (
                                    Select
                                        Count(*)
                                    From
                                        ss_holidays
                                    Where
                                        holiday Between a.nu_bdate And a.nu_edate
                                )                       As holiday_count
                            From
                                (
                                    Select
                                        empno,
                                        app_no,
                                        leavetype,
                                        reason,
                                        leave_period,
                                        bdate,
                                        edate,
                                        app_date,
                                        p.nu_bdate,
                                        p.nu_edate
                                    From
                                        ss_leave_pending4apprl,
                                        params p
                                    Where
                                        (p.nu_bdate Between bdate And (edate)
                                            Or p.nu_edate Between bdate And (edate))
                                        And edate Is Not Null
                                ) a
                        )
                    Union
                    Select
                        empno,
                        app_no,
                        app_date,
                        leavetype,
                        bdate        nu_bdate,
                        edate        nu_edate,
                        leave_period nu_leaveperiod,
                        bdate,
                        edate,
                        leave_period
                    From
                        ss_leave_pending4apprl,
                        params p
                    Where
                        bdate Between p.nu_bdate And p.nu_edate
                        And nvl(edate, bdate) Between p.nu_bdate And p.nu_edate
                )           aa,
                ss_emplmast bb
            Where
                aa.empno = bb.empno;
        Return c;
    End;

    Function fn_leave_application_approved(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,
        p_start_date Date,
        p_end_date   Date
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For

            With
                params As(
                    Select
                        p_start_date start_date, p_end_date end_date
                    From
                        dual
                )
            Select
                aa.empno,
                bb.name,
                bb.parent,
                bb.assign,
                bb.grade,
                aa.app_no,
                aa.leavetype,
                aa.nu_bdate,
                aa.nu_edate,
                aa.nu_leaveperiod,
                aa.bdate,
                aa.edate,
                aa.leave_period
            From
                (
                    Select
                        empno,
                        leavetype,
                        app_no,
                        nu_bdate,
                        nu_edate,
                        leave_4_mm - holiday_count As nu_leaveperiod,
                        bdate,
                        edate,
                        leave_period
                    From
                        (
                            Select
                                empno,
                                leavetype,
                                app_no,
                                1 + nu_edate - nu_bdate leave_4_mm,
                                nu_bdate,
                                nu_edate,
                                leave_period,
                                bdate,
                                edate,
                                (
                                    Select
                                        Count(*)
                                    From
                                        ss_holidays
                                    Where
                                        holiday Between a.nu_bdate And a.nu_edate
                                )                       As holiday_count
                            From
                                (
                                    Select
                                        empno,
                                        leavetype,
                                        app_no,
                                        greatest(bdate, p.start_date) nu_bdate,
                                        least(edate, p.end_date)      nu_edate,

                                        edate,
                                        bdate,
                                        leaveperiod / 8 * -1          As leave_period
                                    From
                                        ss_leaveledg a,
                                        params       p
                                    Where
                                        (
                                            (a.bdate Between p.start_date And p.end_date Or a.edate Between p.start_date And p.
                                            end_date)

                                            Or
                                            (p.start_date Between a.bdate And a.edate Or p.end_date Between a.bdate And a.
                                            edate)
                                        )
                                        And edate Is Not Null
                                        And bdate <> edate
                                        And to_char(bdate, 'yyyymm') <> to_char(edate, 'yyyymm')
                                        And adj_type In (
                                            'LA', 'LC', 'SW'
                                        )
                                        And db_cr = 'D'
                                ) a
                        )
                    Union
                    Select
                        empno,
                        leavetype,
                        app_no,
                        bdate,
                        edate,
                        leaveperiod / 8 * -1 leave_period,
                        bdate,
                        edate,
                        leaveperiod / 8 * -1 leave_period
                    From
                        ss_leaveledg al,
                        params       p
                    Where
                        bdate Between p.start_date And p.end_date
                        And nvl(edate, bdate) Between p.start_date And p.end_date
                        And adj_type In (
                            'LA', 'LC', 'SW'
                        )
                        And db_cr = 'D'
                )           aa,
                ss_emplmast bb
            Where
                aa.empno = bb.empno;
        Return c;

    End;

    Function fn_halfday_leave_application_report(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,
        p_start_date Date,
        p_end_date   Date
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            With
                params As (
                    Select
                        p_start_date start_date,
                        p_end_date   end_date
                    From
                        dual
                )
            Select
                empno                                                               empno,
                employee_name                                                       employee_name,
                parent                                                              parent,
                bdate                                                               bdate,
                edate                                                               edate,
                leave_period                                                        leave_period,
                reason                                                              reason,
                pws                                                                 pws,
                iot_swp_common.fn_get_pws_text(pws)                                 pws_name,
                half_day_date,
                iot_swp_common.fn_is_attendance_required(empno, half_day_date, pws) attendance_required,
                punch_count
            From
                (

                    Select
                        l.empno,
                        e.name                                            employee_name,
                        e.parent,
                        l.bdate,
                        l.edate,
                        leaveperiod / 8                                   leave_period,
                        reason,
                        l.hd_date                                         half_day_date,

                        iot_swp_common.fn_get_emp_pws(l.empno, l.hd_date) pws,
                        (
                            Select
                                Count(*)
                            From
                                ss_integratedpunch
                            Where
                                empno     = l.empno
                                And pdate = trunc(l.hd_date)
                        )                                                 punch_count
                    From
                        ss_leaveapp l,
                        ss_emplmast e,
                        params      p
                    Where
                        mod(leaveperiod, 8) > 0
                        And bdate Between p.start_date And p.end_date
                        And l.empno = e.empno

                );
        Return c;
    End;

    Procedure sp_pl_status_report(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_start_date       Date,
        p_end_date         Date,

        p_pl_debits    Out Sys_Refcursor,
        p_pl_credits   Out Sys_Refcursor,
        p_open_bal     Out Sys_Refcursor,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2

    ) As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;
        Open p_pl_debits For
            With
                params As (
                    Select
                        p_start_date start_date,
                        p_end_date   end_date

                    From
                        dual
                ),
                emp As(
                    Select
                        empno
                    From
                        ss_emplmast
                    Where
                        status = 1
                        And emptype In ('R', 'F')
                ),
                leave_ledg As (
                    Select
                        empno,
                        app_no,
                        bdate,
                        edate,
                        (leaveperiod / 8) * -1 leave_period,
                        leavetype,
                        db_cr,
                        adj_type,
                        'LEDG'                 from_tb
                    From
                        ss_leaveledg,
                        params p
                    Where
                        (
                            (
                                bdate Between p.start_date And p.end_date
                                Or
                                nvl(edate, bdate) Between p.start_date And p.end_date
                            )
                            Or
                            (
                                p.start_date Between bdate And nvl(edate, bdate)
                                Or p.end_date Between bdate And nvl(edate, bdate)
                            )
                        )
                        And db_cr     = 'D'
                        And leavetype = 'PL'
                        And adj_type <> 'LP'
                        And empno In (
                            Select
                                empno
                            From
                                emp
                        )
                ),
                leave_app As (
                    Select
                        empno,
                        app_no,
                        bdate,
                        edate,
                        leaveperiod,
                        leavetype,
                        'D'    db_cr,
                        'LA'   adj_type,
                        'APPL' from_tb
                    From
                        ss_leaveapp,
                        params p
                    Where
                        app_no Not In (
                            Select
                                app_no
                            From
                                leave_ledg
                        )
                        And leavetype = 'PL'
                        And ((
                                bdate Between p.start_date And p.end_date
                                Or
                                nvl(edate, bdate) Between p.start_date And p.end_date
                            )
                            Or
                            (
                                p.start_date Between bdate And nvl(edate, bdate)
                                Or p.end_date Between bdate And nvl(edate, bdate)
                            )
                        )
                        And empno In (
                            Select
                                empno
                            From
                                emp
                        )
                )
            Select
                empno,
                app_no,
                bdate,
                edate,
                leaveperiod,
                leavetype,
                nu_bdate,
                nu_edate,
                holiday_count,

                Case recalc_leave_period
                    When 1 Then
                        (nu_edate - nu_bdate) - holiday_count
                    Else
                        leaveperiod
                End nu_leave_period,

                db_cr,
                adj_type,
                from_tb
            From
                (
                    Select
                        empno,
                        app_no,
                        bdate,
                        edate,
                        leaveperiod,
                        leavetype,
                        db_cr,
                        adj_type,
                        Case
                            When bdate < p.start_date
                                Or edate > p.end_date
                            Then
                                1
                            Else
                                0
                        End                                  recalc_leave_period,
                        Case
                            When bdate < p.start_date
                                Or edate > p.end_date
                            Then

                                get_holidays_between(
                                    greatest(bdate, p.start_date),
                                    least(nvl(edate, bdate), p.end_date)
                                )
                            Else
                                0
                        End                                  holiday_count,
                        greatest(bdate, p.start_date)        nu_bdate,
                        least(nvl(edate, bdate), p.end_date) nu_edate,
                        from_tb
                    From
                        (
                            Select
                                empno,
                                app_no,
                                bdate,
                                edate,
                                leaveperiod,
                                leavetype,
                                db_cr,
                                adj_type,
                                from_tb
                            From
                                leave_app
                            Union
                            Select
                                empno,
                                app_no,
                                bdate,
                                edate,
                                leave_period,
                                leavetype,
                                db_cr,
                                adj_type,
                                from_tb
                            From
                                leave_ledg
                        )      a,
                        params p
                );

        Open p_pl_credits For
            With
                params As (
                    Select
                        p_start_date start_date,
                        p_end_date   end_date

                    From
                        dual
                ),
                leave_ledg As (
                    Select
                        l.empno,
                        app_no,
                        bdate,
                        edate,
                        (leaveperiod / 8) leave_period,
                        leavetype,
                        adj_type,
                        db_cr,
                        'LEDG'            from_tb
                    From
                        ss_leaveledg l,
                        ss_emplmast  e,
                        params       p
                    Where
                        l.empno       = e.empno
                        And e.emptype In ('R', 'F')
                        And
                        (
                            (
                                bdate Between p.start_date And p.end_date
                                Or
                                nvl(edate, bdate) Between p.start_date And p.end_date
                            )
                            Or
                            (
                                p.start_date Between bdate And nvl(edate, bdate)
                                Or p.end_date Between bdate And nvl(edate, bdate)
                            )
                        )
                        And db_cr     = 'C'
                        And leavetype = 'PL'
                        And adj_type <> 'LP'
                )
            Select
                empno,
                app_no,
                bdate,
                edate,
                leave_period leaveperiod,
                leavetype,
                db_cr,
                adj_type,
                from_tb
            From
                leave_ledg;

        Open p_open_bal For
            With
                params As (
                    Select
                        p_start_date start_date,
                        p_end_date   end_date

                    From
                        dual
                )
            Select
                empno,
                name,
                parent,
                assign,
                grade,
                emptype,
                doj,
                closingplbal(empno, p.start_date, 1) open_bal

            From
                ss_emplmast e,
                params      p
            Where
                status = 1
                And emptype In ('R', 'F');

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

End analytical_reports;