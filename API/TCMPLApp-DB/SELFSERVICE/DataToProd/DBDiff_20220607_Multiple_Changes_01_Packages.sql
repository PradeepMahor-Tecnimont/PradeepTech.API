
---------------------------
--Changed PACKAGE
--IOT_SWP_COMMON
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_COMMON" As

    Function fn_get_pws_text(
        p_pws_type_code Number
    ) Return Varchar2;

    Function fn_get_dept_group(
        p_costcode Varchar2
    ) Return Varchar2;

    Function get_emp_work_area(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2
    ) Return Varchar2;

    Function get_emp_work_area_code(
        p_empno Varchar2
    ) Return Varchar2;

    Function get_desk_from_dms(
        p_empno In Varchar2
    ) Return Varchar2;

    Function get_swp_planned_desk(
        p_empno In Varchar2
    ) Return Varchar2;

    Function get_total_desk(
        p_work_area Varchar2,
        p_office    Varchar2,
        p_floor     Varchar2,
        p_wing      Varchar2
    ) Return Number;

    Function get_occupied_desk(
        p_work_area Varchar2,
        p_office    Varchar2,
        p_floor     Varchar2,
        p_wing      Varchar2,
        p_date      Date Default Null
    ) Return Number;

    Function get_monday_date(p_date Date) Return Date;

    Function get_friday_date(p_date Date) Return Date;

    --
    Function is_emp_eligible_for_swp(
        p_empno Varchar2
    ) Return Varchar2;

    --
    Function get_default_costcode_hod_sec(
        p_hod_sec_empno Varchar2,
        p_assign_code   Varchar2 Default Null
    ) Return Varchar2;

    Function get_default_dept4plan_hod_sec(
        p_hod_sec_empno Varchar2,
        p_assign_code   Varchar2 Default Null
    ) Return Varchar2;

    Function get_hod_sec_costcodes_csv(
        p_hod_sec_empno    Varchar2,
        p_assign_codes_csv Varchar2 Default Null
    ) Return Varchar2;

    Function is_emp_laptop_user(
        p_empno Varchar2
    ) Return Number;
    --
    Function csv_to_ary_grades(
        p_grades_csv Varchar2 Default Null
    ) Return Sys_Refcursor;

    Function fn_get_emp_pws(
        p_empno Varchar2,
        p_date  Date Default Null
    ) Return Number;

    Function fn_get_emp_pws_planning(
        p_empno Varchar2 Default Null
    ) Return Varchar2;

    Function is_desk_in_general_area(
        p_deskid Varchar2
    ) Return Boolean;

    Function fn_can_do_desk_plan_4_emp(
        p_empno Varchar2
    ) Return Boolean;

    Function fn_can_work_smartly(
        p_empno Varchar2
    ) Return Number;

    Function fn_is_present_4_swp(
        p_empno Varchar2,
        p_date  Date
    ) Return Number;

    Function get_emp_is_eligible_4swp(
        p_empno Varchar2 Default Null
    ) Return Varchar2;

    Function is_emp_dualmonitor_user(
        p_empno Varchar2 Default Null
    ) Return Number;

    Function get_emp_projno_desc(
        p_empno Varchar2
    ) Return Varchar2;

    Function fn_get_attendance_status(
        p_empno Varchar2,
        p_date  Date
    ) Return Varchar2;

    Function fn_get_attendance_status(
        p_empno Varchar2,
        p_date  Date,
        p_pws   Number
    ) Return Varchar2;

    Function fn_is_attendance_required(
        p_empno Varchar2,
        p_date  Date,
        p_pws   Number
    ) Return Varchar2;

    Function fn_get_prev_work_date(
        p_prev_date Date Default Null
    ) Return Date;    
    -----------------------
    Procedure get_planning_week_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_plan_start_date Out Date,
        p_plan_end_date   Out Date,
        p_curr_start_date Out Date,
        p_curr_end_date   Out Date,
        p_planning_exists Out Varchar2,
        p_pws_open        Out Varchar2,
        p_sws_open        Out Varchar2,
        p_ows_open        Out Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2

    );

    Procedure sp_primary_workspace(
        p_person_id                   Varchar2,
        p_meta_id                     Varchar2,
        p_empno                       Varchar2 Default Null,

        p_current_workspace_text  Out Varchar2,
        p_current_workspace_val   Out Varchar2,
        p_current_workspace_date  Out Varchar2,

        p_planning_workspace_text Out Varchar2,
        p_planning_workspace_val  Out Varchar2,
        p_planning_workspace_date Out Varchar2,

        p_message_type            Out Varchar2,
        p_message_text            Out Varchar2

    );

    Procedure sp_emp_office_workspace(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,

        p_office       Out Varchar2,
        p_floor        Out Varchar2,
        p_wing         Out Varchar2,
        p_desk         Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_get_emp_workspace_details(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        p_empno                 Varchar2,
        p_current_pws       Out Number,
        p_planning_pws      Out Number,
        p_current_pws_text  Out Varchar2,
        p_planning_pws_text Out Varchar2,
        p_curr_desk_id      Out Varchar2,
        p_curr_office       Out Varchar2,
        p_curr_floor        Out Varchar2,
        p_curr_wing         Out Varchar2,
        p_curr_bay          Out Varchar2,
        p_plan_desk_id      Out Varchar2,
        p_plan_office       Out Varchar2,
        p_plan_floor        Out Varchar2,
        p_plan_wing         Out Varchar2,
        p_plan_bay          Out Varchar2,
        p_message_type      Out Varchar2,
        p_message_text      Out Varchar2
    );

End iot_swp_common;
/
---------------------------
--Changed PACKAGE BODY
--PKG_ABSENT
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."PKG_ABSENT" As

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
            v_first_date := to_date(param_absent_yyyymm || '07', 'yyyymmdd');
        Else
            v_first_date := to_date(param_absent_yyyymm || '01', 'yyyymmdd');
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
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) cl_bal,
            closingslbal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) sl_bal,
            closingplbal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) pl_bal,
            closingcobal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
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
                                    to_date(param_absent_yyyymm || to_char(days, 'FM00'), 'yyyymmdd') pdate,
                                    days                                                              dy
                                From
                                    ss_days
                                Where
                                    --days <= to_number(to_char(last_day(to_date(param_absent_yyyymm, 'yyyymm')), 'dd'))
                                    days <= to_number(to_char(v_last_day, 'dd'))
                                    And days >= to_number(to_char(v_first_date, 'dd'))
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
    ) Return Varchar2 As

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
            If v_attendance_status = 'Punch not exists' Then
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
                to_date(param_absent_yyyymm || v_day, 'yyyymmdd'),
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
            v_date := to_date(param_period, 'Mon-yyyy');
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
            v_date := to_date(param_period, 'Mon-yyyy');
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
                        ss_leave_adj
                    Where
                        adj_type                                    = 'SW'

                        And (adj_dt >= get_emp_absent_update_date(
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
            v_date := to_date(param_payslip_yyyymm, 'yyyymm');
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
                to_date(v_day, 'yyyymmdd'),
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
                                to_date(param_yyyymm, 'yyyymm')           As first_day,
                                last_day(to_date(param_yyyymm, 'yyyymm')) As last_day
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
            v_absent_month_date := to_date(p_absent_yyyymm, 'yyyymm');
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
/
---------------------------
--Changed PACKAGE BODY

---------------------------
--Changed PACKAGE BODY
--IOT_SWP_COMMON
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_COMMON" As

    Function fn_get_pws_text(
        p_pws_type_code Number
    ) Return Varchar2 As
        v_ret_val Varchar2(100);
    Begin
        If p_pws_type_code Is Null Or p_pws_type_code = -1 Then
            Return Null;
        End If;
        Select
            type_desc
        Into
            v_ret_val
        From
            swp_primary_workspace_types
        Where
            type_code = p_pws_type_code;
        Return v_ret_val;
    Exception
        When Others Then
            Return Null;
    End;

    Function fn_get_dept_group(
        p_costcode Varchar2
    ) Return Varchar2 As
        v_retval Varchar2(100);
    Begin
        Select
            group_name
        Into
            v_retval
        From
            ss_dept_grouping
        Where
            parent = p_costcode;
        Return v_retval;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_emp_work_area(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2
    ) Return Varchar2 As
        v_count  Number;
        v_projno Varchar2(5);
        v_area   Varchar2(60);
    Begin

        Select
            Count(dapm.office || ' - ' || ep.projno || ' - ' || da.area_desc)
        Into
            v_count
        From
            swp_emp_proj_mapping      ep,
            dms.dm_desk_area_proj_map dapm,
            dms.dm_desk_areas         da
        Where
            ep.projno          = dapm.projno
            And dapm.area_code = da.area_key_id
            And ep.empno       = p_empno;

        If (v_count > 0) Then

            Select
                dapm.office || ' - ' || ep.projno || ' - ' || da.area_desc
            Into
                v_area
            From
                swp_emp_proj_mapping      ep,
                dms.dm_desk_area_proj_map dapm,
                dms.dm_desk_areas         da
            Where
                ep.projno          = dapm.projno
                And dapm.area_code = da.area_key_id
                And ep.empno       = p_empno
                And Rownum         = 1;

        Else
            Begin
                Select
                    da.area_desc
                Into
                    v_area
                From
                    dms.dm_desk_area_dept_map dad,
                    dms.dm_desk_areas         da,
                    ss_emplmast               e
                Where
                    dad.area_code = da.area_key_id
                    And e.assign  = dad.assign
                    And e.empno   = p_empno;

            Exception
                When Others Then
                    v_area := Null;
            End;
        End If;

        Return v_area;
    Exception
        When Others Then
            Return Null;
    End get_emp_work_area;

    Function get_emp_work_area_code(
        p_empno Varchar2
    ) Return Varchar2 As
        v_count     Number;
        v_projno    Varchar2(5);
        v_area_code Varchar2(3);
    Begin
        Select
            da.area_key_id
        Into
            v_area_code
        From
            dms.dm_desk_area_dept_map dad,
            dms.dm_desk_areas         da,
            ss_emplmast               e
        Where
            dad.area_code = da.area_key_id
            And e.assign  = dad.assign
            And e.empno   = p_empno;

        Return v_area_code;
    Exception
        When Others Then
            Return Null;
    End get_emp_work_area_code;

    Function get_desk_from_dms(
        p_empno In Varchar2
    ) Return Varchar2 As
        v_retval Varchar(50);
        v_count  Number;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_usermaster
        Where
            empno = Trim(p_empno)
            And deskid Not Like 'H%';

        If v_count > 0 Then
            Select
                deskid
            Into
                v_retval
            From
                dms.dm_usermaster
            Where
                empno = Trim(p_empno)
                And deskid Not Like 'H%';
            Return v_retval;
        End If;
        --Return v_retval;
        Select
            Count(*)
        Into
            v_count
        From
            swp_temp_desk_allocation
        Where
            empno = p_empno;

        If v_count > 0 Then
            Select
                deskid
            Into
                v_retval
            From
                swp_temp_desk_allocation
            Where
                empno = Trim(p_empno);
            Return '*!-' || v_retval;
        End If;

        Return v_retval;
    Exception
        When Others Then
            Return Null;
    End get_desk_from_dms;

    Function get_swp_planned_desk(
        p_empno In Varchar2
    ) Return Varchar2 As
        v_retval Varchar(50) := 'NA';
    Begin

        Select
        Distinct deskid As desk
        Into
            v_retval
        From
            dms.dm_usermaster_swp_plan dmst
        Where
            dmst.empno = Trim(p_empno)
            And dmst.deskid Not Like 'H%';

        Return v_retval;
    Exception
        When Others Then
            Return Null;
    End get_swp_planned_desk;

    Function get_total_desk(
        p_work_area Varchar2,
        p_office    Varchar2,
        p_floor     Varchar2,
        p_wing      Varchar2
    ) Return Number As
        v_count Number := 0;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_deskmaster                         mast, dms.dm_desk_areas area
        Where
            mast.work_area       = p_work_area
            And area.area_key_id = mast.work_area
            And mast.office      = Trim(p_office)
            And mast.floor       = Trim(p_floor)
            And (mast.wing       = p_wing Or p_wing Is Null);

        Return v_count;
    End;

    Function get_occupied_desk(
        p_work_area Varchar2,
        p_office    Varchar2,
        p_floor     Varchar2,
        p_wing      Varchar2,
        p_date      Date Default Null
    ) Return Number As
        v_count Number := 0;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_deskmaster                         mast, dms.dm_desk_areas area
        Where
            mast.work_area        = p_work_area
            And area.area_key_id  = mast.work_area
            And Trim(mast.office) = Trim(p_office)
            And Trim(mast.floor)  = Trim(p_floor)
            And (mast.wing        = p_wing Or p_wing Is Null)
            And mast.deskid
            In (
                (
                    Select
                    Distinct swptbl.deskid
                    From
                        swp_smart_attendance_plan swptbl
                    Where
                        (trunc(attendance_date) = trunc(p_date) Or p_date Is Null)
                    Union
                    Select
                    Distinct c.deskid
                    From
                        dm_vu_emp_desk_map_swp_plan c
                )
            );
        Return v_count;
    End;

    Function get_monday_date(p_date Date) Return Date As
        v_day_num Number;
    Begin
        v_day_num := to_number(to_char(p_date, 'd'));
        If v_day_num <= 2 Then
            Return p_date + (2 - v_day_num);
        Else
            Return p_date - v_day_num + 2;
        End If;

    End;

    Function get_friday_date(p_date Date) Return Date As
        v_day_num Number;
    Begin
        v_day_num := to_char(p_date, 'd');

        Return p_date + (6 - v_day_num);

    End;

    Function is_emp_eligible_for_swp(
        p_empno Varchar2
    ) Return Varchar2
    As
        v_count Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            swp_emp_response
        Where
            empno        = p_empno
            And hr_apprl = 'OK';
        If v_count = 1 Then
            Return 'OK';
        Else
            Return 'KO';
        End If;
    End;

    Function get_default_costcode_hod_sec(
        p_hod_sec_empno Varchar2,
        p_assign_code   Varchar2 Default Null
    ) Return Varchar2
    As
        v_assign        Varchar2(4);
        v_hod_sec_empno Varchar2(5);
    Begin
        Select
            p_hod_sec_empno
        Into
            v_hod_sec_empno
        From
            ss_emplmast
        Where
            status    = 1
            And empno = lpad(p_hod_sec_empno, 5, '0');
        Select
            assign
        Into
            v_assign
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
                            hod = v_hod_sec_empno
                        Union
                        Select
                            parent As assign
                        From
                            ss_user_dept_rights
                        Where
                            empno = v_hod_sec_empno
                    )
                Where
                    assign = nvl(p_assign_code, assign)
                Order By assign
            )
        Where
            Rownum = 1;
        Return v_assign;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_default_dept4plan_hod_sec(
        p_hod_sec_empno Varchar2,
        p_assign_code   Varchar2 Default Null
    ) Return Varchar2
    As
        v_assign        Varchar2(4);
        v_hod_sec_empno Varchar2(5);
    Begin
        Select
            p_hod_sec_empno
        Into
            v_hod_sec_empno
        From
            ss_emplmast
        Where
            status    = 1
            And empno = lpad(p_hod_sec_empno, 5, '0');
        Select
            assign
        Into
            v_assign
        From
            (
                Select
                    assign
                From
                    (
                        Select
                            parent As assign
                        From
                            ss_user_dept_rights                                   a, swp_include_assign_4_seat_plan b
                        Where
                            empno        = v_hod_sec_empno
                            And a.parent = b.assign
                        Union
                        Select
                            costcode As assign
                        From
                            ss_costmast                                   a, swp_include_assign_4_seat_plan b
                        Where
                            hod            = v_hod_sec_empno
                            And a.costcode = b.assign
                    )
                Where
                    assign = nvl(p_assign_code, assign)
                Order By assign
            )
        Where
            Rownum = 1;
        Return v_assign;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_hod_sec_costcodes_csv(
        p_hod_sec_empno    Varchar2,
        p_assign_codes_csv Varchar2 Default Null
    ) Return Varchar2
    As
        v_assign        Varchar2(4);
        v_hod_sec_empno Varchar2(5);
        v_ret_val       Varchar2(4000);
    Begin
        Select
            p_hod_sec_empno
        Into
            v_hod_sec_empno
        From
            ss_emplmast
        Where
            status    = 1
            And empno = lpad(p_hod_sec_empno, 5, '0');
        If p_assign_codes_csv Is Null Then
            Select
                Listagg(assign, ',') Within
                    Group (Order By
                        assign)
            Into
                v_ret_val
            From
                (
                    Select
                        costcode As assign
                    From
                        ss_costmast
                    Where
                        hod = v_hod_sec_empno
                    Union
                    Select
                        parent As assign
                    From
                        ss_user_dept_rights
                    Where
                        empno = v_hod_sec_empno
                );
        Else
            Select
                Listagg(assign, ',') Within
                    Group (Order By
                        assign)
            Into
                v_ret_val
            From
                (
                    Select
                        costcode As assign
                    From
                        ss_costmast
                    Where
                        hod = v_hod_sec_empno
                    Union
                    Select
                        parent As assign
                    From
                        ss_user_dept_rights
                    Where
                        empno = v_hod_sec_empno
                )
            Where
                assign In (
                    Select
                        regexp_substr(p_assign_codes_csv, '[^,]+', 1, level) value
                    From
                        dual
                    Connect By
                        level <=
                        length(p_assign_codes_csv) - length(replace(p_assign_codes_csv, ',')) + 1
                );

        End If;
        Return v_ret_val;
    Exception
        When Others Then
            Return Null;
    End;

    Function is_emp_laptop_user(
        p_empno Varchar2
    ) Return Number
    As
        v_laptop_count Number;
    Begin
        v_laptop_count := itinv_stk.dist.is_laptop_user(p_empno);
        If v_laptop_count > 0 Then
            Return 1;
        Else
            Return 0;
        End If;
    End;

    Function csv_to_ary_grades(
        p_grades_csv Varchar2 Default Null
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        If p_grades_csv Is Null Then
            Open c For
                Select
                    grade_id grade
                From
                    ss_vu_grades
                Where
                    grade_id <> '-';
        Else
            Open c For
                Select
                    regexp_substr(p_grades_csv, '[^,]+', 1, level) grade
                From
                    dual
                Connect By
                    level <=
                    length(p_grades_csv) - length(replace(p_grades_csv, ',')) + 1;
        End If;
    End;

    Function is_desk_in_general_area(p_deskid Varchar2) Return Boolean

    As
        v_general_area Varchar2(4) := 'A002';
        v_count        Number;
    Begin
        --Check if the desk is General desk.
        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_deskmaster d,
            dms.dm_desk_areas da
        Where
            deskid                = p_deskid
            And d.work_area       = da.area_key_id
            And da.area_catg_code = v_general_area;
        Return v_count = 1;

    End;

    Function fn_get_emp_pws(
        p_empno Varchar2,
        p_date  Date Default Null
    ) Return Number As
        v_emp_pws      Number;
        v_friday_date  Date;
        v_pws_for_date Date;
    Begin
        v_pws_for_date := trunc(nvl(p_date, sysdate));
        Begin
            Select
                a.primary_workspace
            Into
                v_emp_pws
            From
                swp_primary_workspace a
            Where
                a.empno             = p_empno
                And
                trunc(a.start_date) = (
                    Select
                        Max(trunc(start_date))
                    From
                        swp_primary_workspace b
                    Where
                        b.empno = a.empno
                        And b.start_date <= v_pws_for_date
                );
            Return v_emp_pws;
        Exception
            When Others Then
                Return Null;
        End;
    End;

    Function fn_get_emp_pws_planning(
        p_empno Varchar2 Default Null
    ) Return Varchar2 As
        v_emp_pws        Number;
        v_pws_for_date   Date;
        row_config_weeks swp_config_weeks%rowtype;
    Begin
        If p_empno Is Null Then
            Return Null;
        End If;
        Begin
            Select
                *
            Into
                row_config_weeks
            From
                swp_config_weeks
            Where
                planning_flag = 2;
            v_pws_for_date := row_config_weeks.end_date;
        Exception
            When Others Then
                Null;
        End;
        v_emp_pws := fn_get_emp_pws(p_empno, v_pws_for_date);
        v_emp_pws := nvl(v_emp_pws, -1);
        Return fn_get_pws_text(v_emp_pws);
    Exception
        When Others Then
            Return Null;
    End;

    Function fn_can_do_desk_plan_4_emp(p_empno Varchar2) Return Boolean As
        v_count Number;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast                    e,
            swp_include_assign_4_seat_plan sp
        Where
            empno        = p_empno
            And e.assign = sp.assign;
        Return v_count > 0;
    End;

    Function fn_can_work_smartly(
        p_empno Varchar2
    ) Return Number As
        v_is_swp_eligible Varchar2(2);
        v_is_dual_monitor Number(1);
        v_is_laptop_user  Number(1);
    Begin

        v_is_laptop_user  := is_emp_laptop_user(p_empno);
        v_is_dual_monitor := is_emp_dualmonitor_user(p_empno);
        v_is_swp_eligible := get_emp_is_eligible_4swp(p_empno);

        If v_is_laptop_user = 1 And v_is_swp_eligible = 'OK' And v_is_dual_monitor = 0 Then
            Return 1;
        Else
            Return 0;
        End If;
    Exception
        When Others Then
            Return Null;
    End;

    Function fn_is_present_4_swp(
        p_empno Varchar2,
        p_date  Date
    ) Return Number
    As
        v_count Number;
    Begin

        --Punch Count
        Select
            Count(*)
        Into
            v_count
        From
            ss_punch
        Where
            empno     = p_empno
            And pdate = p_date;
        If v_count > 0 Then
            Return 1;
        End If;

        --Approved Leave
        Select
            Count(*)
        Into
            v_count
        From
            ss_leaveledg
        Where
            empno           = p_empno
            And bdate <= p_date
            And nvl(edate, bdate) >= p_date
            And (adj_type   = 'LA'
                Or adj_type = 'LC');
        If v_count > 0 Then
            Return 1;
        End If;

        --Forgot Punch
        Select
            Count(*)
        Into
            v_count
        From
            ss_ondutyapp
        Where
            empno     = p_empno
            And pdate = p_date
            And type  = 'IO';
        If v_count > 0 Then
            Return 1;
        End If;

        --OnTour / Deputation / Remote Work
        Select
            Count(*)
        Into
            v_count
        From
            ss_depu
        Where
            empno         = Trim(p_empno)
            And bdate <= p_date
            And nvl(edate, bdate) >= p_date

            And hrd_apprl = 1;

        If v_count > 0 Then
            Return 1;
        End If;

        --Exception
        Select
            Count(*)
        Into
            v_count
        From
            swp_exclude_emp
        Where
            empno         = Trim(p_empno)
            And p_date Between start_date And end_date
            And is_active = 1;
        If v_count > 0 Then
            Return 1;
        End If;
        Return 0;
    End;

    Function get_emp_is_eligible_4swp(
        p_empno Varchar2 Default Null
    ) Return Varchar2 As
    Begin
        If Trim(p_empno) Is Null Then
            Return Null;
        End If;
        Return is_emp_eligible_for_swp(p_empno);
    End;

    Function is_emp_dualmonitor_user(
        p_empno Varchar2 Default Null
    ) Return Number As
        v_count Number;
    Begin
        Select
            Count(da.assetid)
        Into
            v_count
        From
            dms.dm_deskallocation da,
            dms.dm_usermaster     um,
            dms.dm_assetcode      ac
        Where
            um.deskid             = da.deskid
            And um.empno          = p_empno
            And ac.sub_asset_type = 'IT0MO'
            And da.assetid        = ac.barcode
            And um.deskid Not Like 'H%';
        If v_count >= 2 Then
            Return 1;
        Else
            Return 0;

        End If;

        --
        Select
            Count(da.assetid)
        Into
            v_count
        From
            dms.dm_deskallocation da,
            dms.dm_usermaster     um,
            dms.dm_assetcode      ac
        Where
            um.deskid             = da.deskid
            And um.empno          = p_empno
            And ac.sub_asset_type = 'IT0MO'
            And da.assetid        = ac.barcode
            And um.deskid Like 'H%';
        If v_count >= 2 Then
            Return 1;
        Else
            Return 0;

        End If;

    Exception
        When Others Then
            Return 0;
    End;

    Function get_emp_projno_desc(
        p_empno Varchar2
    ) Return Varchar2 As
        v_projno    Varchar2(5);
        v_proj_name ss_projmast.name%Type;
    Begin
        Select
            projno
        Into
            v_projno
        From
            swp_emp_proj_mapping
        Where
            empno = p_empno;
        Select
        Distinct name
        Into
            v_proj_name
        From
            ss_projmast
        Where
            proj_no = v_projno;
        Return v_projno || ' - ' || v_proj_name;
    Exception
        When Others Then
            Return '';
    End;

    Function fn_get_attendance_status(
        p_empno Varchar2,
        p_date  Date
    ) Return Varchar2 As
        v_count         Number;
        v_punch_exists  Boolean;
        row_depu_tour   ss_depu%rowtype;
        row_onduty      ss_ondutyapp%rowtype;
        row_leave       ss_leaveapp%rowtype;
        row_leaveledg   ss_leaveledg%rowtype;
        row_exclude_emp swp_exclude_emp%rowtype;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = trunc(p_date);
        If v_count > 0 Then
            Return '';
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_integratedpunch

        Where
            empno     = p_empno
            And pdate = p_date
            And mach <> 'WFH0';

        If v_count > 0 Then
            Return 'Present';
        End If;

        --Check Leave app
        Begin
            Declare
                v_leave_desc Varchar2(100);
            Begin
                Select
                    *
                Into
                    row_leave
                From
                    ss_leaveapp
                Where
                    empno = p_empno
                    And p_date Between bdate And nvl(edate, bdate);

                If row_leave.hrd_apprl = 1 Then
                    v_leave_desc := 'Leave';
                Else
                    v_leave_desc := 'Leave applied';
                End If;
                If nvl(row_exclude_emp.is_active, 0) = 1 Then
                    Return v_leave_desc || ' + Exception';
                Else
                    Return v_leave_desc;
                End If;

            Exception
                When Others Then
                    Null;
            End;

            --Check Leave LEDG for Leave Claim & Smart Work Leave deduction
            Declare
                v_leave_desc Varchar2(100);
            Begin
                Select
                    *
                Into
                    row_leaveledg
                From
                    ss_leaveledg
                Where
                    empno     = p_empno
                    And p_date Between bdate And nvl(edate, bdate)
                    And adj_type In ('LC', 'SW')
                    And db_cr = 'D';
                If row_leaveledg.adj_type = 'SW' Then
                    v_leave_desc := 'SWP-Leave';
                Else
                    v_leave_desc := 'Leave';
                End If;
                If nvl(row_exclude_emp.is_active, 0) = 1 Then
                    Return v_leave_desc || ' + Exception';
                Else
                    Return v_leave_desc;
                End If;
            Exception
                When Others Then
                    Null;
            End;

            --Check deputation / tour / remote work
            Begin
                Select
                    Count(*)
                Into
                    v_count
                From
                    ss_depu
                Where
                    type In ('TR', 'DP', 'RW')
                    And empno = p_empno
                    And p_date Between bdate And edate;

                If v_count > 1 Then
                    Return 'Tour-Deputation-err';
                End If;

                Select
                    *
                Into
                    row_depu_tour
                From
                    ss_depu
                Where
                    type In ('TR', 'DP', 'RW')
                    And empno = p_empno
                    And p_date Between bdate And edate;

                If row_depu_tour.hrd_apprl = 1 Then
                    If row_depu_tour.type = 'RW' Then
                        Return 'Smart Work Applied';
                    End If;
                    Return 'Tour-Deputation';
                Else
                    Return 'Tour-Deputation applied';
                End If;
            Exception
                When Others Then
                    Null;
            End;
            --Check Missed / In-Out punch onduty
            Begin
                Select
                    *
                Into
                    row_onduty
                From
                    ss_ondutyapp
                Where
                    type In (
                        'IO', 'OD'
                    )
                    And empno = p_empno
                    And pdate = trunc(p_date);
                If row_onduty.hrd_apprl = 1 Then
                    Return 'Onduty MP/IO';
                Else
                    Return 'Onduty MP/IO applied';

                End If;
            Exception
                When Others Then
                    Null;
            End;

            --Check Exception
            Begin
                Select
                    *
                Into
                    row_exclude_emp
                From
                    swp_exclude_emp
                Where
                    p_date Between start_date And end_date
                    And empno = p_empno;

                If row_exclude_emp.is_active = 1 Then
                    Return 'Exception';
                End If;
            Exception
                When Others Then
                    Null;
            End;

            Return 'Absent';
        Exception
            When Others Then
                Return 'ERR';
        End;
    End;

    Function fn_get_attendance_status(
        p_empno Varchar2,
        p_date  Date,
        p_pws   Number
    ) Return Varchar2 As
        v_count   Number;
        v_ret_val Varchar2(100);
    Begin
        If p_empno Is Null Or p_date Is Null Or p_pws Is Null Then
            Return Null;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = trunc(p_date);
        If v_count > 0 Then
            Return '';
        End If;
        v_ret_val := fn_get_attendance_status(
                         p_empno => p_empno,
                         p_date  => p_date
                     );
        If p_pws Not In (2, 3) Then --Office workspace
            Return v_ret_val;
        End If;
        If p_pws = 3 Then -- Deputation workspace
            If v_ret_val = 'Absent' Then
                Return 'OnSite';
            Else
                Return v_ret_val;
            End If;
        End If;
        --Smart workspace
        Select
            Count(*)
        Into
            v_count
        From
            swp_smart_attendance_plan
        Where
            empno               = p_empno
            And attendance_date = p_date;
        If v_count = 0 Then
            If v_ret_val = 'Present' Then
                Return 'OutOfTurn Present';
            Elsif v_ret_val = 'Absent' Then
                Return 'Smartly Present';
            End If;
        End If;
        Return v_ret_val;
    End;

    Function fn_is_attendance_required(
        p_empno Varchar2,
        p_date  Date,
        p_pws   Number
    ) Return Varchar2 As
        v_count   Number;
        v_ret_val Varchar2(100);
    Begin
        If p_pws = 1 Then
            Return 'Yes';
        End If;
        If p_pws = 3 Then
            Return 'No';
        End If;
        If p_pws = 2 Then
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
                Return 'Yes';
            Else
                Return 'No';
            End If;
        End If;
        Return '--';
    End;
    --

    Function fn_get_prev_work_date(
        p_prev_date Date Default Null
    ) Return Date
    As
        v_prev_date Date;
        v_count     Number;
    Begin
        v_prev_date := trunc(nvl(p_prev_date, sysdate));
        Select
            Count(*)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = v_prev_date;
        If v_count = 0 Then
            Return v_prev_date;
        Else
            Return fn_get_prev_work_date(v_prev_date - 1);
        End If;

    End;

    Procedure sp_get_emp_workspace_details(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        p_empno                 Varchar2,
        p_current_pws       Out Number,
        p_planning_pws      Out Number,
        p_current_pws_text  Out Varchar2,
        p_planning_pws_text Out Varchar2,
        p_curr_desk_id      Out Varchar2,
        p_curr_office       Out Varchar2,
        p_curr_floor        Out Varchar2,
        p_curr_wing         Out Varchar2,
        p_curr_bay          Out Varchar2,
        p_plan_desk_id      Out Varchar2,
        p_plan_office       Out Varchar2,
        p_plan_floor        Out Varchar2,
        p_plan_wing         Out Varchar2,
        p_plan_bay          Out Varchar2,
        p_message_type      Out Varchar2,
        p_message_text      Out Varchar2
    ) As
        v_current_pws     Number;
        v_planning_pws    Number;
        v_plan_start_date Date;
        v_plan_end_date   Date;
        v_curr_start_date Date;
        v_curr_end_date   Date;
        v_planning_exists Varchar2(2);
        v_pws_open        Varchar2(2);
        v_sws_open        Varchar2(2);
        v_ows_open        Varchar2(2);
        v_msg_type        Varchar2(10);
        v_msg_text        Varchar2(1000);
        v_emp_pws         Number;
        v_friday_date     Date;
    Begin
        get_planning_week_details(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,
            p_plan_start_date => v_plan_start_date,
            p_plan_end_date   => v_plan_end_date,
            p_curr_start_date => v_curr_start_date,
            p_curr_end_date   => v_curr_end_date,
            p_planning_exists => v_planning_exists,
            p_pws_open        => v_pws_open,
            p_sws_open        => v_sws_open,
            p_ows_open        => v_ows_open,
            p_message_type    => v_msg_type,
            p_message_text    => v_msg_text

        );

        p_current_pws       := fn_get_emp_pws(
                                   p_empno => p_empno,
                                   p_date  => trunc(sysdate)
                               );
        If v_plan_end_date Is Not Null Then
            p_planning_pws := fn_get_emp_pws(
                                  p_empno => p_empno,
                                  p_date  => v_plan_end_date
                              );
        End If;
        p_current_pws_text  := fn_get_pws_text(p_current_pws);
        p_planning_pws_text := fn_get_pws_text(p_planning_pws);
        If p_current_pws = 1 Then --Office
            Begin
                p_curr_desk_id := get_desk_from_dms(p_empno);
                Select
                    dm.office,
                    dm.floor,
                    dm.wing,
                    dm.bay
                Into
                    p_curr_office,
                    p_curr_floor,
                    p_curr_wing,
                    p_curr_bay
                From
                    dms.dm_deskmaster dm
                Where
                    dm.deskid = p_curr_desk_id;
            Exception
                When Others Then
                    Null;
            End;
        End If;

        If p_planning_pws = 1 Then --Office
            Begin
                p_plan_desk_id := get_desk_from_dms(p_empno);
                Select
                    dm.office,
                    dm.floor,
                    dm.wing,
                    dm.bay
                Into
                    p_plan_office,
                    p_plan_floor,
                    p_plan_wing,
                    p_plan_bay
                From
                    dms.dm_deskmaster dm
                Where
                    dm.deskid = p_plan_desk_id;
            Exception
                When Others Then
                    Null;
            End;
            /*
        Elsif p_planning_pws = 2 Then --SMART
            p_plan_sws := iot_swp_smart_workspace_qry.fn_emp_week_attend_planning(
                              p_person_id => p_person_id,
                              p_meta_id   => p_meta_id,
                              p_empno     => p_empno,
                              p_date      => v_plan_start_date
                          );
*/
        End If;
    End;

    Procedure sp_emp_office_workspace(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,

        p_office       Out Varchar2,
        p_floor        Out Varchar2,
        p_wing         Out Varchar2,
        p_desk         Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2

    ) As
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
        End If;

        Select
        Distinct
            'P_Office' As p_office,
            'P_Floor'  As p_floor,
            'P_Desk'   As p_desk,
            'P_Wing'   As p_wing
        Into
            p_office,
            p_floor,
            p_wing,
            p_desk
        From
            dual;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_emp_office_workspace;

    Procedure sp_primary_workspace(
        p_person_id                   Varchar2,
        p_meta_id                     Varchar2,
        p_empno                       Varchar2 Default Null,

        p_current_workspace_text  Out Varchar2,
        p_current_workspace_val   Out Varchar2,
        p_current_workspace_date  Out Varchar2,

        p_planning_workspace_text Out Varchar2,
        p_planning_workspace_val  Out Varchar2,
        p_planning_workspace_date Out Varchar2,

        p_message_type            Out Varchar2,
        p_message_text            Out Varchar2

    ) As
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        If p_empno Is Not Null Then
            v_empno := p_empno;
        Else
            v_empno := get_empno_from_meta_id(p_meta_id);
        End If;

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
        End If;
        Begin
            Select
            Distinct
                a.primary_workspace As p_primary_workspace_val,
                b.type_desc         As p_primary_workspace_text,
                a.start_date        As p_primary_workspace_date
            Into
                p_current_workspace_val,
                p_current_workspace_text,
                p_current_workspace_date
            From
                swp_primary_workspace       a,
                swp_primary_workspace_types b
            Where
                a.primary_workspace = b.type_code
                And a.empno         = v_empno
                And a.active_code   = 1;
        Exception
            When Others Then
                p_current_workspace_text := 'NA';
        End;

        Begin
            Select
            Distinct
                a.primary_workspace As p_primary_workspace_val,
                b.type_desc         As p_primary_workspace_text,
                a.start_date        As p_primary_workspace_date
            Into
                p_planning_workspace_val,
                p_planning_workspace_text,
                p_planning_workspace_date
            From
                swp_primary_workspace       a,
                swp_primary_workspace_types b
            Where
                a.primary_workspace = b.type_code
                And a.empno         = v_empno
                And a.active_code   = 2;
        Exception
            When Others Then
                p_planning_workspace_text := 'NA';
        End;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_primary_workspace;

    Procedure get_planning_week_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_plan_start_date Out Date,
        p_plan_end_date   Out Date,
        p_curr_start_date Out Date,
        p_curr_end_date   Out Date,
        p_planning_exists Out Varchar2,
        p_pws_open        Out Varchar2,
        p_sws_open        Out Varchar2,
        p_ows_open        Out Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2

    ) As
        v_count         Number;
        v_rec_plan_week swp_config_weeks%rowtype;
        v_rec_curr_week swp_config_weeks%rowtype;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            swp_config_weeks
        Where
            planning_flag = 2;
        If v_count = 0 Then
            p_pws_open        := 'KO';
            p_sws_open        := 'KO';
            p_ows_open        := 'KO';
            p_planning_exists := 'KO';
        Else
            Select
                *
            Into
                v_rec_plan_week
            From
                swp_config_weeks
            Where
                planning_flag = 2;

            p_plan_start_date := v_rec_plan_week.start_date;
            p_plan_end_date   := v_rec_plan_week.end_date;
            p_planning_exists := 'OK';
            p_pws_open        := Case
                                     When nvl(v_rec_plan_week.pws_open, 0) = 1 Then
                                         'OK'
                                     Else
                                         'KO'
                                 End;
            p_sws_open        := Case
                                     When nvl(v_rec_plan_week.sws_open, 0) = 1 Then
                                         'OK'
                                     Else
                                         'KO'
                                 End;
            p_ows_open        := Case
                                     When nvl(v_rec_plan_week.ows_open, 0) = 1 Then
                                         'OK'
                                     Else
                                         'KO'
                                 End;
        End If;
        Select
            *
        Into
            v_rec_curr_week
        From
            (
                Select
                    *
                From
                    swp_config_weeks
                Where
                    planning_flag <> 2
                Order By start_date Desc
            )
        Where
            Rownum = 1;

        p_curr_start_date := v_rec_curr_week.start_date;
        p_curr_end_date   := v_rec_curr_week.end_date;

        p_message_type    := 'OK';
        p_message_text    := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End get_planning_week_details;

End iot_swp_common;
/
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
        v_swp_start_date := to_date('18-Apr-2022');
        If p_for_ot = 'OK' Then
            v_end_date := n_getenddate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));
        Else
            v_end_date := last_day(to_date(p_yyyymm, 'yyyymm'));
        End If;
        v_start_date     := n_getstartdate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));

        v_max_punch      := n_maxpunch(v_empno, v_start_date, v_end_date);

        n_cfwd_lwd_deltahrs(
            p_empno       => v_empno,
            p_pdate       => to_date(p_yyyymm, 'yyyymm'),
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
                    tab_punch_data(i).remarks := trim (Leading ' - ' From nvl(tab_punch_data(i).remarks, ''));
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
    Begin
        If Trim(p_empno) Is Null Then
            v_empno := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return;
            End If;
        Else
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
            End If;
        End If;
        If p_for_ot = 'OK' Then
            v_end_date := n_getenddate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));
        Else
            v_end_date := last_day(to_date(p_yyyymm, 'yyyymm'));
        End If;
        v_start_date := n_getstartdate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));

        v_max_punch  := n_maxpunch(v_empno, v_start_date, v_end_date);

        n_cfwd_lwd_deltahrs(
            p_empno       => v_empno,
            p_pdate       => to_date(p_yyyymm, 'yyyymm'),
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

                --tab_punch_data(i).str_wrk_hrs              := to_hrs(tab_punch_data(i).wrk_hrs);
                --tab_punch_data(i).str_delta_hrs            := to_hrs(tab_punch_data(i).delta_hrs);
                --tab_punch_data(i).str_extra_hrs            := to_hrs(tab_punch_data(i).extra_hrs);

                If tab_punch_data(i).is_absent = 1 Then
                    tab_punch_data(i).remarks := 'Absent';
                Elsif tab_punch_data(i).penalty_hrs > 0 Then
                    If tab_punch_data(i).day_punch_count = 1 Then
                        tab_punch_data(i).remarks := tab_punch_data(i).penalty_hrs || '-HoursLeaveDeducted(MissedPunch)';
                    Else
                        tab_punch_data(i).remarks := tab_punch_data(i).penalty_hrs || '-HoursLeaveDeducted';
                    End If;
                Elsif tab_punch_data(i).is_ldt = c_ldt_leave Then
                    tab_punch_data(i).remarks := 'OnLeave';
                Elsif tab_punch_data(i).is_ldt = c_ldt_tour_depu Then
                    tab_punch_data(i).remarks := 'OnTour-Depu';
                Elsif tab_punch_data(i).is_ldt = c_ldt_remote_work Then
                    tab_punch_data(i).remarks := 'RemoteWork';
                Elsif tab_punch_data(i).day_punch_count = 1 Then
                    tab_punch_data(i).remarks := 'MissedPunch';
                End If;
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
                End If;

                --tab_punch_data(i).str_wk_sum_work_hrs      := to_hrs(tab_punch_data(i).wk_sum_work_hrs);
                --tab_punch_data(i).str_wk_sum_delta_hrs     := to_hrs(tab_punch_data(i).wk_sum_delta_hrs);
                --tab_punch_data(i).str_wk_bfwd_delta_hrs    := to_hrs(tab_punch_data(i).wk_bfwd_delta_hrs);
                --tab_punch_data(i).str_wk_cfwd_delta_hrs    := to_hrs(tab_punch_data(i).wk_cfwd_delta_hrs);
                --tab_punch_data(i).str_wk_penalty_leave_hrs := to_hrs(tab_punch_data(i).wk_penalty_leave_hrs);

            End Loop;
            tab_punch_data := Null;
            Exit When cur_for_punch_data%notfound;
        End Loop;
        Close cur_for_punch_data;
        Return;
    End;

End iot_punch_details;
/
