Create Or Replace Package Body selfservice.pkg_absent As

    c_ows Constant Number := 1;
    c_sws Constant Number := 2;
    c_dws Constant Number := 3;

    Function get_emp_absent_update_date(
        param_empno                Varchar2,
        param_period_keyid         Varchar2,
        param_absent_list_gen_date Date
    ) Return Date Is
        v_ret_date Date;
    Begin
        Select
            trunc(modified_on)
        Into
            v_ret_date
        From
            ss_absent_detail
        Where
            empno      = param_empno
            And key_id = param_period_keyid;

        Return (v_ret_date);
    Exception
        When Others Then
            Return (param_absent_list_gen_date);
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
        v_first_date  Date;
        v_last_day    Date;
        --v_empno       varchar2(5);
        v_requester   Varchar2(5);
        v_param_empno Varchar2(10);
    Begin
        /*
            check_payslip_month_isopen(param_payslip_yyyymm,param_success,param_message);
            if param_success = 'KO' then
                return;
            end if;
            */

        If param_absent_yyyymm = '202106' Then
            v_first_date := To_Date(param_absent_yyyymm || '07', 'yyyymmdd');
        Else
            v_first_date := To_Date(param_absent_yyyymm || '01', 'yyyymmdd');
        End If;

        If param_absent_yyyymm = '202003' Then
            v_last_day := To_Date('20-Mar-2020', 'dd-Mon-yyyy');
        Else
            v_last_day := last_day(v_first_date);
        End If;

        v_key_id      := dbms_random.string('X', 8);
        v_requester   := ss.get_empno(param_requester);
        If param_empno = 'ALL' Then
            v_param_empno := '%';
        Else
            v_param_empno := param_empno || '%';
        End If;

        Delete
            From ss_absent_detail
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm
            And empno Like v_param_empno;

        If param_empno = 'ALL' Then
            Delete
                From ss_absent_master
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm;

            Insert Into ss_absent_master (
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
                ss_absent_master
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm;

        End If;

        Commit;
        Insert Into ss_absent_detail (
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
                        With
                            days_tab As (
                                Select
                                    d_date pdate,
                                    d_dd   dy
                                From
                                    ss_days_details
                                Where
                                    d_date Between v_first_date And v_last_day
                            )
                        Select
                            a.empno,
                            dy,
                            pkg_absent.is_emp_absent(
                                a.empno, pdate, substr(s_mrk, ((dy - 1) * 2) + 1, 2), a.doj
                            ) is_absent
                        From
                            ss_emplmast a,
                            days_tab    b,
                            ss_muster   c
                        Where
                            mnth         = Trim(Trim(param_absent_yyyymm))
                            And a.empno  = c.empno
                            And a.status = 1
                            And a.parent Not In (
                                Select
                                    parent
                                From
                                    ss_dept_not_4_absent
                            )
                            And emptype In (
                                'R', 'F'
                            )
                            And a.empno Like v_param_empno
                            And a.empno Not In (
                                Select
                                    empno
                                From
                                    tcmpl_hr.ofb_emp_exits
                            )
                    )
                Where
                    is_absent = 1
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
            From ss_absent_lop
        Where
            payslip_yyyymm                    = param_payslip_yyyymm
            And to_char(lop_4_date, 'yyyymm') = param_absent_yyyymm;

        generate_list(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            'ALL',
            param_requester,
            param_success,
            param_message
        );
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
            From ss_absent_lop
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

    Function is_emp_absent(
        param_empno      In Varchar2,
        param_date       In Date,
        param_shift_code In Varchar2,
        param_doj        In Date
    ) Return Number As

        v_swp_start_date    Date;
        v_holiday           Number;
        v_count             Number;
        c_is_absent         Constant Number := 1;
        c_not_absent        Constant Number := 0;
        c_leave_depu_tour   Constant Number := 2;
        v_on_ldt            Number;
        v_ldt_appl          Number;
        v_pws               Number;
        v_attendance_status Varchar2(100);
    Begin
        v_swp_start_date := To_Date('18-Apr-2022', 'dd-Mon-yyyy');
        v_holiday        := get_holiday(param_date);
        If v_holiday > 0 Or nvl(param_shift_code, 'ABCD') In (
                'HH', 'OO'
            )
        Then
            --return -1;
            Return c_not_absent;
        End If;

        --Check DOJ & DOL
        If param_date < nvl(param_doj, param_date) Then
            --return -5;
            Return c_not_absent;
        End If;

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
        Else
            v_on_ldt := isleavedeputour(param_date, param_empno);
            If v_on_ldt = 1 Then
                Return c_not_absent;
            End If;

        End If;

        Select
            Count(empno)
        Into
            v_count
        From
            ss_integratedpunch
        Where
            empno     = Trim(param_empno)
            And pdate = param_date;

        If v_count > 0 Then
            --return -3;
            Return c_not_absent;
        End If;
        v_ldt_appl       := isldt_appl(param_empno, param_date);
        If v_ldt_appl > 0 Then
            --return -6;
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

        --

        --return -4;
        Return c_is_absent;
    End is_emp_absent;

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

            Insert Into ss_absent_lop (
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
            ss_absent_lop
        Where
            empno          = param_empno
            And lop_4_date = param_pdate;

        Return v_lop;
    Exception
        When Others Then
            Return 0;
    End;

    Procedure update_no_mail_list(
        param_absent_yyyymm       Varchar2,
        param_payslip_yyyymm      Varchar2,
        param_emp_list_4_no_mail  Varchar2,
        param_emp_list_4_yes_mail Varchar2,
        param_requester           Varchar2,
        param_success Out         Varchar2,
        param_message Out         Varchar2
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
        /*
        If Trim(param_emp_list_4_no_mail) Is Null Then
            param_success   := 'KO';
            param_message   := 'Err - Employee List for NO-MAIL is blank.';
            return;
        End If;
        */
        Update
            ss_absent_detail
        Set
            no_mail = Null
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm
            And empno In (
                Select
                    column_value empno
                From
                    Table (ss.csv_to_table(param_emp_list_4_yes_mail))
            );

        Commit;
        Update
            ss_absent_detail
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

    Procedure add_payslip_period(
        param_period      Varchar2,
        param_open        Varchar2,
        param_by_win_uid  Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) As
        v_count    Number;
        v_date     Date;
        v_by_empno Varchar2(5);
    Begin
        Begin
            v_date := To_Date(param_period, 'Mon-yyyy');
        Exception
            When Others Then
                param_success := 'KO';
                param_message := 'Err - Invalid date format';
                Return;
        End;

        v_by_empno    := pkg_09794.get_empno(param_by_win_uid);
        If v_by_empno Is Null Then
            param_success := 'KO';
            param_message := 'Err - Data Entry by EmpNo not found.';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_absent_payslip_period
        Where
            period = to_char(v_date, 'yyyymm');

        If v_count <> 0 Then
            param_success := 'KO';
            param_message := 'Err - Period already exists.';
            Return;
        End If;

        Insert Into ss_absent_payslip_period (
            period,
            is_open,
            modified_on,
            modified_by
        )
        Values (
            to_char(v_date, 'yyyymm'),
            param_open,
            sysdate,
            v_by_empno
        );

        If param_open = 'OK' Then
            Update
                ss_absent_payslip_period
            Set
                is_open = 'KO'
            Where
                period != to_char(v_date, 'yyyymm')
                And is_open = 'OK';

        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Period successfully added.';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure edit_payslip_period(
        param_period      Varchar2,
        param_open        Varchar2,
        param_by_win_uid  Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) As
        v_count    Number;
        v_date     Date;
        v_by_empno Varchar2(5);
    Begin
        Begin
            v_date := To_Date(param_period, 'Mon-yyyy');
        Exception
            When Others Then
                param_success := 'KO';
                param_message := 'Err - Invalid date format';
                Return;
        End;

        v_by_empno    := pkg_09794.get_empno(param_by_win_uid);
        If v_by_empno Is Null Then
            param_success := 'KO';
            param_message := 'Err - Data Entry by EmpNo not found.';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_absent_payslip_period
        Where
            period = to_char(v_date, 'yyyymm');

        If v_count <> 1 Then
            param_success := 'KO';
            param_message := 'Err - Period not found in database.';
            Return;
        End If;

        Update
            ss_absent_payslip_period
        Set
            is_open = param_open
        Where
            period = to_char(v_date, 'yyyymm');

        If param_open = 'OK' Then
            Update
                ss_absent_payslip_period
            Set
                is_open = 'KO'
            Where
                period != to_char(v_date, 'yyyymm')
                And is_open = 'OK';

        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Period successfully updated.';
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

        v_count             Number;
        v_absent_list_date  Date;
        v_absent_list_keyid Varchar2(8);
        Cursor cur_onduty(
            pc_list_keyid Varchar2,
            pc_list_date  Date
        ) Is
            With
                absent_list As (
                    Select
                        empno
                    From
                        ss_absent_detail
                    Where
                        absent_yyyymm      = param_absent_yyyymm
                        And payslip_yyyymm = param_payslip_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_absent_lop
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
                        app_date >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
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
                        deleted_on >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And to_char(pdate, 'yyyymm') = param_absent_yyyymm
                        And type In ('OD', 'IO')
                    Union
                    Select
                        empno
                    From
                        ss_ondutyapp_rejected
                    Where
                        rejected_on >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And to_char(pdate, 'yyyymm') = param_absent_yyyymm
                        And type In ('OD', 'IO')
                    Union
                    Select
                        empno
                    From
                        swp_exclude_emp
                    Where
                        modified_on >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And ((to_char(start_date, 'yyyymm')    = param_absent_yyyymm
                                Or to_char(end_date, 'yyyymm') = param_absent_yyyymm)
                            Or To_Date(param_absent_yyyymm, 'yyyymm') Between start_date And end_date)

                );

        Cursor cur_depu(
            pc_list_keyid Varchar2,
            pc_list_date  Date
        ) Is
            With
                absent_list As (
                    Select
                        empno
                    From
                        ss_absent_detail
                    Where
                        absent_yyyymm      = param_absent_yyyymm
                        And payslip_yyyymm = param_payslip_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_absent_lop
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
                        (app_date >= get_emp_absent_update_date(
                                empno, pc_list_keyid, pc_list_date
                            )
                            Or chg_date >= get_emp_absent_update_date(
                                empno, pc_list_keyid, pc_list_date
                            ))
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
                        deleted_on >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And type In ('TR', 'DP')
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_depu_rejected
                    Where
                        rejected_on >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
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
                        And chg_date >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                );

        Cursor cur_leave(
            pc_list_keyid Varchar2,
            pc_list_date  Date
        ) Is
            With
                absent_list As (
                    Select
                        empno
                    From
                        ss_absent_detail
                    Where
                        absent_yyyymm      = param_absent_yyyymm
                        And payslip_yyyymm = param_payslip_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_absent_lop
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
                        (app_date >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        ))
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
                    Select
                        empno
                    From
                        ss_leaveapp_deleted
                    Where
                        deleted_on >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_leaveapp_rejected
                    Where
                        rejected_on >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)

                    Union
                    Select
                        empno
                    From
                        ss_leaveledg
                    Where
                        adj_type In ('SW', 'LC')

                        And (app_date >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        ))

                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )

                );
        --Cursor for LoP deducted for attendance + timesheet purpose
        Cursor cur_lop_emps(
            pc_list_keyid Varchar2,
            pc_list_date  Date
        ) Is

            Select
                empno
            From
                ss_absent_lop
            Where
                payslip_yyyymm = param_payslip_yyyymm
                And entry_date >= get_emp_absent_update_date(
                    empno, pc_list_keyid, pc_list_date
                )
            Union
            Select
                empno
            From
                ss_absent_ts_lop
            Where
                payslip_yyyymm = param_payslip_yyyymm
                And entry_date >= get_emp_absent_update_date(
                    empno, pc_list_keyid, pc_list_date
                );
        Cursor cur_emplist Is
            Select
                empno
            From
                ss_emplmast
            Where
                status = 1
                And emptype In ('R', 'F');
        /*
            Select
                empno
            From
                ss_absent_detail
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm
            Union
            Select
                empno
            From
                ss_absent_lop
            Where
                payslip_yyyymm = param_payslip_yyyymm;
        */
        --XXXXXXXXXXXXXXX--

        --

        v_sysdate           Date := sysdate;
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
                trunc(nvl(refreshed_on, modified_on)),
                key_id
            Into
                v_absent_list_date,
                v_absent_list_keyid
            From
                ss_absent_master
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm;

        Exception
            When Others Then
                param_success := 'KO';
                param_message := 'Absent list not yet generated for the said period.';
                Return;
        End;

        Delete
            From ss_absent_no_mail
        Where
            modified_on < (v_sysdate + (1 / 1440 * -7));

        --mail record exists 7 minutes earlier
        Select
            Count(*)
        Into
            v_count
        From
            ss_absent_no_mail
        Where
            key_id = v_absent_list_keyid;

        If v_count > 0 Then
            param_success := 'KO';
            param_message := 'Please try after 7 minutes.';

            Return;
        End If;

        Insert Into ss_absent_no_mail (key_id, empno, modified_on)
        Select
            v_absent_list_keyid, empno, v_sysdate
        From
            ss_absent_detail
        Where
            key_id                     = v_absent_list_keyid
            And nvl(no_mail, '123465') = 'OK';
        Commit;

        For c_empno In cur_emplist
        Loop
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                c_empno.empno,
                param_requester,
                param_success,
                param_message
            );
        End Loop;

        Update
            ss_absent_detail
        Set
            no_mail = 'OK'
        Where
            key_id = v_absent_list_keyid
            And empno In (
                Select
                    empno
                From
                    ss_absent_no_mail
                Where
                    key_id = v_absent_list_keyid
            );

        Delete
            From ss_absent_no_mail
        Where
            key_id = v_absent_list_keyid
            And empno Not In (
                Select
                    empno
                From
                    ss_absent_detail
                Where
                    key_id = v_absent_list_keyid
            );
        Commit;
        Return;
        --XXXXXXXXXXXXXXXXX--
        --End of new logic
        --XXXXXXXXXXXXXXXX--

        For c_empno In cur_onduty(v_absent_list_keyid, v_absent_list_date)
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

        For c_empno In cur_depu(v_absent_list_keyid, v_absent_list_date)
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

        For c_empno In cur_leave(v_absent_list_keyid, v_absent_list_date)
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
        For c_lop_emp In cur_lop_emps(v_absent_list_keyid, v_absent_list_date)
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
            ss_absent_master
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

            Insert Into ss_absent_lop_reverse (
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
        --v_ret_val := substr(v_payslip_month_rec.period,1,4) || '-' || substr(v_payslip_month_rec.period,5,2);

        Return v_payslip_month_rec.period;
    Exception
        When Others Then
            Return 'ERR';
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
            From ss_absent_lop
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

    Function get_pending_app_4_month(
        param_yyyymm Varchar2
    ) Return typ_tab_pending_app
        Pipelined
    As

        Cursor cur_pending_apps Is
            Select
                empno                        empno,
                emp_name                     emp_name,
                parent                       parent,
                app_no                       app_no,
                bdate                        bdate,
                edate                        edate,
                leavetype                    leavetype,
                ss.approval_text(hrd_apprl)  hrd_apprl_txt,
                ss.approval_text(hod_apprl)  hod_apprl_txt,
                ss.approval_text(lead_apprl) lead_apprl_txt
            From
                (
                    With
                        emp_list As (
                            Select
                                empno As emp_num,
                                name  As emp_name,
                                parent
                            From
                                ss_emplmast
                            Where
                                status = 1
                                And emptype In (
                                    'R', 'F'
                                )
                        ), dates As (
                            Select
                                To_Date(param_yyyymm, 'yyyymm')           As first_day,
                                last_day(To_Date(param_yyyymm, 'yyyymm')) As last_day
                            From
                                dual
                        )
                    Select
                        empno,
                        emp_name,
                        parent,
                        app_no,
                        bdate,
                        edate,
                        leavetype,
                        hrd_apprl,
                        hod_apprl,
                        lead_apprl
                    From
                        ss_leaveapp a,
                        emp_list    b,
                        dates       c
                    Where
                        a.empno = b.emp_num
                        And nvl(lead_apprl, ss.pending) In (
                            ss.pending, ss.approved, ss.apprl_none
                        )
                        And nvl(hod_apprl, ss.pending) In (
                            ss.pending, ss.approved
                        )
                        And nvl(hrd_apprl, ss.pending) In (
                            ss.pending
                        )
                        And (bdate Between first_day And last_day
                            Or nvl(bdate, edate) Between first_day And last_day
                            Or first_day Between bdate And nvl(bdate, edate))
                    Union
                    Select
                        empno,
                        emp_name,
                        parent,
                        app_no,
                        pdate,
                        Null,
                        type As od_type,
                        hrd_apprl,
                        hod_apprl,
                        lead_apprl
                    From
                        ss_ondutyapp a,
                        emp_list     b,
                        dates
                    Where
                        a.empno = b.emp_num
                        And type In (
                            'IO', 'OD'
                        )
                        And nvl(lead_apprl, ss.pending) In (
                            ss.pending, ss.approved, ss.apprl_none
                        )
                        And nvl(hod_apprl, ss.pending) In (
                            ss.pending, ss.approved
                        )
                        And nvl(hrd_apprl, ss.pending) In (
                            ss.pending
                        )
                        And (pdate Between first_day And last_day)
                    Union
                    Select
                        empno,
                        emp_name,
                        parent,
                        app_no,
                        bdate,
                        edate,
                        type As depu_type,
                        hrd_apprl,
                        hod_apprl,
                        lead_apprl
                    From
                        ss_depu  a,
                        emp_list b,
                        dates
                    Where
                        a.empno = b.emp_num
                        And type In (
                            'HT', 'VS', 'TR', 'DP'
                        )
                        And nvl(lead_apprl, ss.pending) In (
                            ss.pending, ss.approved, ss.apprl_none
                        )
                        And nvl(hod_apprl, ss.pending) In (
                            ss.pending, ss.approved
                        )
                        And nvl(hrd_apprl, ss.pending) In (
                            ss.pending
                        )
                        And (bdate Between first_day And last_day
                            Or nvl(bdate, edate) Between first_day And last_day
                            Or first_day Between bdate And nvl(bdate, edate))
                /*union
                select
                    empno,
                    emp_name,
                    parent,
                    app_no,
                    bdate,
                    edate,
                    type,
                    hrd_apprl,
                    hod_apprl,
                    lead_apprl
                from
                    ss_depu a,
                    emp_list b,
                    dates
                where
                    a.empno = b.emp_num
                    and type in (
                        'HT',
                        'VS',
                        'TR',
                        'DP'
                    )
                    and nvl(lead_apprl,ss.pending) in (
                        ss.pending,
                        ss.approved,
                        ss.apprl_none
                    )
                    and nvl(hod_apprl,ss.pending) in (
                        ss.pending,
                        ss.approved
                    )
                    and nvl(hrd_apprl,ss.pending) in (
                        ss.pending
                    )
                    and ( bdate between first_day and last_day
                          or nvl(bdate,edate) between first_day and last_day
                          or first_day between bdate and nvl(bdate,edate) )*/
                );

        v_rec      typ_rec_pending_app;
        v_tab      typ_tab_pending_app;
        v_tab_null typ_tab_pending_app;
    Begin
        Open cur_pending_apps;
        Loop
            Fetch cur_pending_apps Bulk Collect Into v_tab Limit 50;
            For i In 1..v_tab.count
            Loop
                Pipe Row (v_tab(i));
            End Loop;

            v_tab := v_tab_null;
            Exit When cur_pending_apps%notfound;
        End Loop;
        --pipe row ( v_rec );

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
                                ss_absent_detail
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

    Procedure send_hod_approval_pending_mail(
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
        Cursor cur_mail_list Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        emp_no) email_csv_list
            From
                (
                    Select
                        e.emp_no,
                        replace(e.emp_email, ',', '.')                    user_email,
                        ceil((Row_Number() Over(Order By e.emp_no)) / 50) group_id
                    From
                        Table(pending_approvals.list_of_hod_not_approving()) e
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
        v_msg_body := c_pending_approval_body;
        v_subject  := 'SELFSERVICE : ' || c_pending_approval_sub;

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

    Procedure send_leadapproval_pending_mail(
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
        Cursor cur_mail_list Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        emp_no) email_csv_list
            From
                (
                    Select
                        e.emp_no,
                        replace(e.emp_email, ',', '.')                    user_email,
                        ceil((Row_Number() Over(Order By e.emp_no)) / 50) group_id
                    From
                        Table(pending_approvals.list_of_leads_not_approving()) e
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
        v_msg_body := c_pending_approval_body;
        v_subject  := 'SELFSERVICE : ' || c_pending_approval_sub;

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

End pkg_absent;