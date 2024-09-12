Create Or Replace Package Body selfservice.pkg_absent_ts As

    Function get_payslip_month Return Varchar2 Is
        v_payslip_month_rec ss_absent_payslip_period%rowtype;
        v_ret_val           Varchar2(7);
    Begin
        Select
            *
        Into
            v_payslip_month_rec
        From
            ss_absent_payslip_period
        Where
            is_open = 'OK';

        Return v_payslip_month_rec.period;
    Exception
        When Others Then
            Return 'ERR';
    End;

    Procedure check_payslip_month_isopen(
        param_payslip_yyyymm Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
        v_open_payslip_yyyymm Varchar2(10);
    Begin
        v_open_payslip_yyyymm := get_payslip_month;
        If v_open_payslip_yyyymm <> param_payslip_yyyymm Then
            param_success := 'KO';
            param_message := 'Err - Payslip month "' || param_payslip_yyyymm || '" is not open in the system';
            Return;
        Else
            param_success := 'OK';
        End If;

    End;

    Procedure generate_list(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_empno          Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        v_key_id      Varchar2(8);
        v_first_day   Date;
        v_last_day    Date;
        v_requester   Varchar2(5);
        v_param_empno Varchar2(10);
    Begin
        v_first_day   := To_Date(param_absent_yyyymm || '01', 'yyyymmdd');
        If param_absent_yyyymm = '202003' Then
            v_last_day := To_Date('20-Mar-2020', 'dd-Mon-yyyy');
        Else
            v_last_day := last_day(v_first_day);
        End If;

        v_key_id      := dbms_random.string('X', 8);
        v_requester   := ss.get_empno(param_requester);
        If param_empno = 'ALL' Then
            v_param_empno := '%';
        Else
            v_param_empno := param_empno || '%';
        End If;

        Delete
            From ss_absent_ts_detail
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm
            And empno Like v_param_empno;
        --commit;
        --param_success   := 'OK';
        --return;
        If param_empno = 'ALL' Then
            Delete
                From ss_absent_ts_master
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm;

            Insert Into ss_absent_ts_master (
                absent_yyyymm,
                payslip_yyyymm,
                modified_on,
                modified_by,
                key_id
            )
            Values (
                param_absent_yyyymm,
                param_payslip_yyyymm,
                sysdate,
                v_requester,
                v_key_id
            );

        Else
            Select
                key_id
            Into
                v_key_id
            From
                ss_absent_ts_master
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm;

        End If;

        Commit;
        Insert Into ss_absent_ts_detail (
            key_id,
            absent_yyyymm,
            payslip_yyyymm,
            empno,
            absent_days,
            cl_bal,
            sl_bal,
            pl_bal,
            co_bal
        )
        Select
            v_key_id,
            param_absent_yyyymm,
            param_payslip_yyyymm,
            empno,
            absent_days,
            closingclbal(
                empno,
                trunc(last_day(To_Date(param_absent_yyyymm, 'yyyymm'))),
                0
            ) cl_bal,
            closingslbal(
                empno,
                trunc(last_day(To_Date(param_absent_yyyymm, 'yyyymm'))),
                0
            ) sl_bal,
            closingplbal(
                empno,
                trunc(last_day(To_Date(param_absent_yyyymm, 'yyyymm'))),
                0
            ) pl_bal,
            closingcobal(
                empno,
                trunc(last_day(To_Date(param_absent_yyyymm, 'yyyymm'))),
                0
            ) co_bal
        From
            (
                Select
                    empno,
                    Listagg(dy, ', ') Within
                        Group (Order By dy) As absent_days
                From
                    (
                        Select
                            a.empno,
                            b.day_no                        dy,
                            is_emp_absent(a.empno, b.tdate) is_emp_absent
                        From
                            ss_emplmast        a,
                            ss_absent_ts_leave b
                        Where
                            b.yyyymm     = Trim(Trim(param_absent_yyyymm))
                            And a.empno  = b.empno
                            And a.status = 1
                            And a.parent Not In (
                                Select
                                    parent
                                From
                                    ss_dept_not_4_absent
                            )
                            And a.emptype In (
                                'R', 'F'
                            )
                            And a.empno Like v_param_empno
                            And b.leave_hrs > 0
                            And a.empno Not In (
                                Select
                                    empno
                                From
                                    tcmpl_hr.ofb_emp_exits
                            )
                    )
                Where
                    is_emp_absent = 1
                Group By empno
            );

        Commit;
        param_success := 'OK';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End generate_list;

    Procedure generate_nu_list_4_all_emp(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Delete
            From ss_absent_as_lop
        Where
            payslip_yyyymm                    = param_payslip_yyyymm
            And to_char(lop_4_date, 'yyyymm') = param_absent_yyyymm;

        pop_timesheet_leave_data(
            param_yyyymm  => param_absent_yyyymm,
            param_success => param_success,
            param_message => param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        generate_list(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            'ALL',
            param_requester,
            param_success,
            param_message
        );
    End generate_nu_list_4_all_emp;

    Procedure pop_timesheet_leave_data(
        param_yyyymm      Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) As
    Begin
        Delete
            From ss_absent_ts_leave
        Where
            yyyymm = param_yyyymm;

        Insert Into ss_absent_ts_leave (
            yyyymm,
            empno,
            projno,
            wpcode,
            activity,
            day_no,
            tdate,
            leave_hrs
        )
        Select
            yymm,
            empno,
            projno,
            wpcode,
            activity,
            day_no,
            t_date,
            Sum(colvalue)
        From
            (
                Select
                    yymm,
                    empno,
                    projno,
                    wpcode,
                    activity,
                    day_no,
                    To_Date(yymm || '-' || day_no, 'yyyymm-dd') t_date,
                    colvalue
                From
                    (
                        With
                            t As (
                                Select
                                    yymm,
                                    empno,
                                    parent,
                                    assign,
                                    a.projno,
                                    wpcode,
                                    activity,
                                    d1,
                                    d2,
                                    d3,
                                    d4,
                                    d5,
                                    d6,
                                    d7,
                                    d8,
                                    d9,
                                    d10,
                                    d11,
                                    d12,
                                    d13,
                                    d14,
                                    d15,
                                    d16,
                                    d17,
                                    d18,
                                    d19,
                                    d20,
                                    d21,
                                    d22,
                                    d23,
                                    d24,
                                    d25,
                                    d26,
                                    d27,
                                    d28,
                                    d29,
                                    d30,
                                    d31
                                From
                                    timecurr.time_daily a,
                                    timecurr.tm_leave   b
                                Where
                                    substr(a.projno, 1, 5) = b.projno
                                    And a.wpcode <> 4
                                    And yymm               = param_yyyymm
                            )
                        Select
                            yymm,
                            empno,
                            parent,
                            assign,
                            projno,
                            wpcode,
                            activity,
                            To_Number(replace(col, 'D', '')) day_no,
                            colvalue
                        From
                            t Unpivot (colvalue
                            For col
                            In (d1,
                            d2,
                            d3,
                            d4,
                            d5,
                            d6,
                            d7,
                            d8,
                            d9,
                            d10,
                            d11,
                            d12,
                            d13,
                            d14,
                            d15,
                            d16,
                            d17,
                            d18,
                            d19,
                            d20,
                            d21,
                            d22,
                            d23,
                            d24,
                            d25,
                            d26,
                            d27,
                            d28,
                            d29,
                            d30,
                            d31))
                    )
                Where
                    day_no <= To_Number(to_char(last_day(To_Date(param_yyyymm, 'yyyymm')), 'dd'))
            )
        --Where
        --colvalue > 0
        Group By
            yymm,
            empno,
            projno,
            wpcode,
            activity,
            day_no,
            t_date;

        Commit;
        param_success := 'OK';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure update_no_mail_list(
        param_absent_yyyymm      Varchar2,
        param_payslip_yyyymm     Varchar2,
        param_emp_list_4_no_mail Varchar2,
        param_requester          Varchar2,
        param_success Out        Varchar2,
        param_message Out        Varchar2
    ) As
    Begin
        Null;
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        If Trim(param_emp_list_4_no_mail) Is Null Then
            param_success := 'KO';
            param_message := 'Err - Employee List for NO-MAIL is blank.';
            Return;
        End If;

        Update
            ss_absent_ts_detail
        Set
            no_mail = Null
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm;

        Commit;
        Update
            ss_absent_ts_detail
        Set
            no_mail = 'OK'
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm
            And empno In (
                Select
                    column_value empno
                From
                    Table (ss.csv_to_table(param_emp_list_4_no_mail))
            );

        Commit;
        param_success := 'OK';
        param_message := 'Employee List for NO-MAIL successfully updated';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            Rollback;
    End;

    Function get_lop(
        param_empno Varchar2,
        param_pdate Date
    ) Return Number Is
        v_lop Number;
    Begin
        Select
            half_full
        Into
            v_lop
        From
            ss_absent_ts_lop
        Where
            empno          = param_empno
            And lop_4_date = param_pdate;

        Return v_lop;
    Exception
        When Others Then
            Return 0;
    End;

    Procedure set_lop_4_emp(
        param_empno          Varchar2,
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_lop_val        Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        Cursor c1 Is
            Select
                column_value
            From
                Table (ss.csv_to_table(param_lop_val));

        Type typ_tab Is
            Table Of c1%rowtype Index By Binary_Integer;
        v_tab  typ_tab;
        v_day  Varchar2(5);
        v_lop  Varchar2(5);
        v_cntr Number;
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        param_success := 'KO';
        v_cntr        := 0;
        For c2 In c1
        Loop
            v_cntr := v_cntr + 1;
            v_day  := lpad(substr(c2.column_value, 1, instr(c2.column_value, '-') - 1), 2, '0');

            v_lop  := substr(c2.column_value, instr(c2.column_value, '-') + 1);

            Insert Into ss_absent_ts_lop (
                empno,
                lop_4_date,
                payslip_yyyymm,
                half_full,
                entry_date
            )
            Values (
                param_empno,
                To_Date(param_absent_yyyymm || v_day, 'yyyymmdd'),
                param_payslip_yyyymm,
                v_lop,
                sysdate
            );

        End Loop;

        If v_cntr > 0 Then
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                param_empno,
                param_requester,
                param_success,
                param_message
            );
        Else
            param_success := 'KO';
            param_message := 'Err - Zero rows updated.';
        End If;

    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            Rollback;
    End;

    Procedure regenerate_list_4_one_emp(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_empno          Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        generate_list(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            param_empno,
            param_requester,
            param_success,
            param_message
        );
    End;

    Procedure reset_emp_lop(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_empno          Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Delete
            From ss_absent_ts_lop
        Where
            payslip_yyyymm                    = param_payslip_yyyymm
            And to_char(lop_4_date, 'yyyymm') = param_absent_yyyymm
            And empno                         = param_empno;

        Commit;
        regenerate_list_4_one_emp(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            param_empno,
            param_requester,
            param_success,
            param_message
        );
    End;

    Procedure delete_user_lop(
        param_empno          Varchar2,
        param_payslip_yyyymm Varchar2,
        param_absent_yyyymm  Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        Delete
            From ss_absent_ts_lop
        Where
            empno                             = param_empno
            And payslip_yyyymm                = param_payslip_yyyymm
            And to_char(lop_4_date, 'yyyymm') = param_absent_yyyymm;

        Commit;
        regenerate_list_4_one_emp(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            param_empno,
            param_requester,
            param_success,
            param_message
        );
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure refresh_absent_list(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        v_count            Number;
        v_absent_list_date Date;
        Cursor cur_onduty Is
            With
                absent_list As (
                    Select
                        empno
                    From
                        ss_absent_ts_detail
                    Where
                        absent_yyyymm      = param_absent_yyyymm
                        And payslip_yyyymm = param_payslip_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_absent_ts_lop
                    Where
                        payslip_yyyymm = param_payslip_yyyymm
                )
            Select
            Distinct
                empno
            From
                (
                    Select
                        empno
                    From
                        ss_ondutyapp
                    Where
                        app_date >= trunc(v_absent_list_date)
                        And type In ('OD', 'IO')
                        And nvl(lead_apprl, 0) <> 2
                        And nvl(hod_apprl, 0) <> 2
                        And nvl(hrd_apprl, 0) <> 2
                        And to_char(pdate, 'yyyymm') = param_absent_yyyymm
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                    Union
                    Select
                        empno
                    From
                        ss_ondutyapp_deleted
                    Where
                        deleted_on >= trunc(v_absent_list_date)
                        And type In ('OD', 'IO')
                        And to_char(pdate, 'yyyymm') = param_absent_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_ondutyapp_rejected
                    Where
                        rejected_on >= trunc(v_absent_list_date)
                        And type In ('OD', 'IO')
                        And to_char(pdate, 'yyyymm') = param_absent_yyyymm
                );

        Cursor cur_depu Is
            With
                absent_list As (
                    Select
                        empno
                    From
                        ss_absent_ts_detail
                    Where
                        absent_yyyymm      = param_absent_yyyymm
                        And payslip_yyyymm = param_payslip_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_absent_ts_lop
                    Where
                        payslip_yyyymm = param_payslip_yyyymm
                )
            Select
            Distinct
                empno
            From
                (
                    Select
                        empno
                    From
                        ss_depu
                    Where
                        (app_date >= trunc(v_absent_list_date)
                            Or chg_date >= trunc(v_absent_list_date))
                        And type In ('TR', 'DP')
                        And nvl(hod_apprl, 0) <> 2
                        And nvl(hrd_apprl, 0) <> 2
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                    Union
                    Select
                        empno
                    From
                        ss_depu_deleted
                    Where
                        deleted_on >= trunc(v_absent_list_date)
                        And type In ('TR', 'DP')
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_depu_rejected
                    Where
                        rejected_on >= trunc(v_absent_list_date)
                        And type In ('TR', 'DP')
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_depu_hist
                    Where
                        empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                        And type In ('TR', 'DP')
                        And chg_date >= trunc(v_absent_list_date)
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                );

        Cursor cur_leave Is
            With
                absent_list As (
                    Select
                        empno
                    From
                        ss_absent_ts_detail
                    Where
                        absent_yyyymm      = param_absent_yyyymm
                        And payslip_yyyymm = param_payslip_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_absent_ts_lop
                    Where
                        payslip_yyyymm = param_payslip_yyyymm
                )
            Select
            Distinct
                empno
            From
                (
                    Select
                        empno
                    From
                        ss_leaveapp
                    Where
                        (app_date >= trunc(v_absent_list_date))
                        And nvl(lead_apprl, 0) <> 2
                        And nvl(hod_apprl, 0) <> 2
                        And nvl(hrd_apprl, 0) <> 2
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                    Union
                    /*
                    Select
                        empno
                    From
                        ss_leave_adj
                    Where
                        (adj_dt >= trunc(v_absent_list_date))
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    */
                    Select
                        empno
                    From
                        ss_leaveapp_deleted
                    Where
                        deleted_on >= trunc(v_absent_list_date)
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_leaveapp_rejected
                    Where
                        rejected_on >= trunc(v_absent_list_date)
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_leaveledg
                    Where
                        adj_type In ('SW', 'LC')

                        And (app_date >= v_absent_list_date)

                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)

                );

        --Cursor for LoP deducted for attendance + timesheet purpose
        Cursor cur_lop_emps Is

            Select
                empno
            From
                ss_absent_lop
            Where
                payslip_yyyymm = param_payslip_yyyymm
                And entry_date >= v_absent_list_date
            Union
            Select
                empno
            From
                ss_absent_ts_lop
            Where
                payslip_yyyymm = param_payslip_yyyymm
                And entry_date >= v_absent_list_date;

        --XXXXXXXXXXXXXXX--

        --

        v_sysdate          Date := sysdate;
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Begin
            Select
                nvl(refreshed_on, modified_on)
            Into
                v_absent_list_date
            From
                ss_absent_ts_master
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm;

        Exception
            When Others Then
                param_success := 'KO';
                param_message := 'Absent list not yet generated for the said period.';
                Return;
        End;

        For c_empno In cur_onduty
        Loop
            Null;
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                c_empno.empno,
                param_requester,
                param_success,
                param_message
            );
        End Loop;

        For c_empno In cur_depu
        Loop
            Null;
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                c_empno.empno,
                param_requester,
                param_success,
                param_message
            );
        End Loop;

        For c_empno In cur_leave
        Loop
            Null;
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                c_empno.empno,
                param_requester,
                param_success,
                param_message
            );
        End Loop;

        --Re-Generate for employee for LoP deducted for attendance + timesheet purpose
        For c_lop_emp In cur_lop_emps
        Loop
            Null;
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                c_lop_emp.empno,
                param_requester,
                param_success,
                param_message
            );
        End Loop;
        --XXXXXXXXXXXXX--

        Update
            ss_absent_ts_master
        Set
            refreshed_on = v_sysdate
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm;

        Commit;
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Function is_emp_absent(
        param_empno In Varchar2,
        param_date  In Date
    ) Return Number As

        v_count             Number;
        c_is_absent         Constant Number := 1;
        c_not_absent        Constant Number := 0;
        c_leave_depu_tour   Constant Number := 2;
        v_on_ldt            Number;
        v_ldt_appl          Number;
        v_pws               Number;
        v_swp_start_date    Date;
        v_attendance_status Varchar2(100);
        c_dws               Number          := 3;
    Begin
        /*
                v_swp_start_date := To_Date('18-Apr-2022', 'dd-Mon-yyyy');
                If param_date >= v_swp_start_date Then
                    v_pws               := iot_swp_common.fn_get_emp_pws(
                                               p_empno => param_empno,
                                               p_date  => param_date
                                           );
        
                    If v_pws = c_dws Then
                        Return c_not_absent;
                    End If;
        
                    v_attendance_status := iot_swp_common.fn_get_attendance_status(
                                               p_empno => param_empno,
                                               p_date  => param_date,
                                               p_pws   => v_pws
                                           );
                    If v_attendance_status = 'Absent' Then
                        Return c_is_absent;
                    Else
                        Return c_not_absent;
                    End If;
                End If;
        */
        v_on_ldt   := isleavedeputour(param_date, param_empno);
        If v_on_ldt = 1 Then
            Return c_not_absent;
        End If;
        v_ldt_appl := isldt_appl(param_empno, param_date);
        If v_ldt_appl > 0 Then
            Return c_not_absent;
        End If;
        
        --Check LoP deducted for attendance purpose
        Select
            Count(*)
        Into
            v_count
        From
            ss_absent_lop
        Where
            empno          = param_empno
            And lop_4_date = param_date;

        If v_count > 0 Then
            Return c_not_absent;
        End If;
        --XXXXXXXXXXXXXXX--

        --Check LoP deducted for timesheet purpose
        Select
            Count(*)
        Into
            v_count
        From
            ss_absent_ts_lop
        Where
            empno          = param_empno
            And lop_4_date = param_date;

        If v_count > 0 Then
            Return c_not_absent;
        End If;
        --XXXXXXXXXXXXXXX--

        --Check punch exists
        Select
            Count(*)
        Into
            v_count
        From
            ss_integratedpunch
        Where
            empno     = param_empno
            And pdate = param_date;
        If v_count > 0 Then
            Return c_not_absent;
        End If;
        --XXXXXXXXXXXXXXX--
        --

        Return c_is_absent;
    End is_emp_absent;

    Procedure reverse_lop_4_emp(
        param_empno          Varchar2,
        param_payslip_yyyymm Varchar2,
        param_lop_val        Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        Cursor c1 Is
            Select
                column_value
            From
                Table (ss.csv_to_table(param_lop_val));

        Type typ_tab Is
            Table Of c1%rowtype Index By Binary_Integer;
        v_tab  typ_tab;
        v_day  Varchar2(8);
        v_lop  Varchar2(5);
        v_cntr Number;
        v_date Date;
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Begin
            v_date := To_Date(param_payslip_yyyymm, 'yyyymm');
        Exception
            When Others Then
                param_success := 'KO';
                param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
                Return;
        End;

        param_success := 'KO';
        v_cntr        := 0;
        For c2 In c1
        Loop
            v_cntr := v_cntr + 1;
            v_day  := substr(c2.column_value, 1, instr(c2.column_value, '-') - 1);

            v_lop  := substr(c2.column_value, instr(c2.column_value, '-') + 1);

            Insert Into ss_absent_ts_lop_reverse (
                empno,
                lop_4_date,
                payslip_yyyymm,
                half_full,
                entry_date
            )
            Values (
                param_empno,
                To_Date(v_day, 'yyyymmdd'),
                to_char(v_date, 'yyyymm'),
                v_lop,
                sysdate
            );

        End Loop;

        If v_cntr = 0 Then
            param_success := 'KO';
            param_message := 'Err - Zero rows updated.';
        Else
            param_success := 'OK';
        End If;

    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            Rollback;
    End;

    Procedure send_absent_email(
        p_payslip_yyyymm Varchar2,
        p_absent_yyyymm  Varchar2,
        p_success Out    Varchar2,
        p_message Out    Varchar2
    ) As
        Cursor cur_mail_list Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        e.empno,
                        replace(e.email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By e.empno)) / 50) group_id
                    From
                        ss_emplmast e
                    Where
                        e.empno In (
                            Select
                                empno
                            From
                                ss_absent_ts_detail
                            Where
                                absent_yyyymm          = p_absent_yyyymm
                                And payslip_yyyymm     = p_payslip_yyyymm
                                And nvl(no_mail, 'KO') = 'KO'
                                And empno Not In ('04600', '04132')
                        )
                        And email Is Not Null
                    Order By e.empno
                )
            Group By
                group_id;

        v_subject           Varchar2(1000);
        v_msg_body          Varchar2(2000);
        v_mail_csv          Varchar2(2000);
        v_success           Varchar2(100);
        v_message           Varchar2(500);
        v_absent_month_date Date;
        v_absent_month_text Varchar2(30);
    Begin
        Begin
            v_absent_month_date := To_Date(p_absent_yyyymm, 'yyyymm');
            v_absent_month_text := regexp_replace(to_char(v_absent_month_date, 'Month-yyyy'), '\s{2,}', ' ');
        Exception
            When Others Then
                p_success := 'KO';
                p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
                Return;
        End;
        v_msg_body := replace(c_absent_mail_body, '!@MONTH@!', v_absent_month_text);
        v_subject  := 'SELFSERVICE : ' || replace(c_absent_mail_sub, '!@MONTH@!', v_absent_month_text);

        For email_csv_row In cur_mail_list
        Loop
            v_mail_csv := email_csv_row.email_csv_list;
            send_mail_from_api(
                p_mail_to      => Null,
                p_mail_cc      => 'a.kotian@tecnimont.in;',
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body    => v_msg_body,
                p_mail_profile => 'SELFSERVICE',
                --(example --> SQSI, OSD, ALHR, etc...)
                p_mail_format  => 'HTML',
                p_success      => v_success,
                p_message      => v_message
            );

        End Loop;
        p_success  := 'OK';
        p_message  := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;

End pkg_absent_ts;
/