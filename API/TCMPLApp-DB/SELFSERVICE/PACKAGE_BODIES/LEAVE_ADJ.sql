--------------------------------------------------------
--  DDL for Package Body LEAVE_ADJ
--------------------------------------------------------

Create Or Replace Package Body "SELFSERVICE"."LEAVE_ADJ" As

    Procedure debit_leave(
        p_empno        Varchar2,
        p_pdate        Date,
        p_adj_type     Varchar2,
        p_leavetype    Varchar2,
        p_leave_period Number
    ) As
        v_success Varchar2(10);
        v_message Varchar2(1000);
        v_desc    Varchar2(30);
    Begin
        Select
            description
        Into
            v_desc
        From
            ss_leave_adj_mast
        Where
            adj_type = p_adj_type
            And dc   = 'D';

        leave.add_leave_adj(
            param_empno      => p_empno,
            param_adj_date   => p_pdate,
            param_adj_type   => p_adj_type || 'D',
            param_leave_type => p_leavetype,
            param_adj_period => p_leave_period,
            param_entry_by   => 'SYS',
            param_desc       => v_desc,
            param_success    => v_success,
            param_message    => v_message
        );

    End;

    Procedure adjust_leave_202012(
        p_empno       Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As

        Cursor cur_emplist(
            cp_empno Varchar2
        ) Is
            Select
                empno
            From
                ss_emplmast
            Where
                status = 1
                And emptype In (
                    'R', 'F'
                )
                And empno Like cp_empno;

        v_max_leave_bal_limit ss_leave_bal_max_limit.max_leave_bal%Type;
        Type typ_tab_emplist Is
            Table Of cur_emplist%rowtype;
        tab_emplist           typ_tab_emplist;
        v_processing_date     Date;
        v_count               Number;
        v_cl_bal              Number;
        v_pl_bal              Number;
        v_sl_bal              Number;
        v_p_empno             Varchar2(5);
        c_yyyymm              Constant Varchar2(6) := '202012';
        c_adj_type            Constant Varchar(2)  := 'YA';
    Begin
        v_p_empno := nvl(trim(p_empno), '%');
        Begin
            v_processing_date := last_day(to_date(c_yyyymm, 'yyyymm'));
        Exception
            When Others Then
                p_success := 'KO';
                p_message := 'Invalid YYYYMM.';
                Return;
        End;

        Begin
            Select
                max_leave_bal
            Into
                v_max_leave_bal_limit
            From
                ss_leave_bal_max_limit
            Where
                yyyymm = c_yyyymm;

        Exception
            When Others Then
                v_max_leave_bal_limit := c_max_leave_bal_limit;
        End;

        If v_p_empno <> '%' Then
            Select
                Count(*)
            Into
                v_count
            From
                ss_emplmast
            Where
                empno      = v_p_empno
                And status = 1
                And emptype In (
                    'R', 'F'
                );

            If v_count = 0 Then
                p_success := 'KO';
                p_message := 'Err - Incorrect Employee number.';
                Return;
            End If;

        End If;

        Open cur_emplist(v_p_empno);
        Loop
            Fetch cur_emplist Bulk Collect Into tab_emplist Limit 50;
            For i In 1..tab_emplist.count
            Loop
                Delete
                    From ss_leave_adj
                Where
                    empno            = tab_emplist(i).empno
                    And adj_type     = c_adj_type
                    And db_cr        = 'D'
                    And trunc(bdate) = trunc(v_processing_date)
                    And leavetype In (
                        'CL', 'PL', 'SL'
                    );

                Delete
                    From ss_leaveledg
                Where
                    empno        = tab_emplist(i).empno
                    And adj_type = c_adj_type
                    And db_cr    = 'D'
                    And bdate    = v_processing_date
                    And app_no Like '%'
                    And leavetype In (
                        'CL', 'PL', 'SL'
                    );

                v_cl_bal := leave_bal.get_cl_bal(tab_emplist(i).empno, v_processing_date);
                v_pl_bal := leave_bal.get_pl_bal(tab_emplist(i).empno, v_processing_date);
                v_sl_bal := leave_bal.get_sl_bal(tab_emplist(i).empno, v_processing_date);
                If v_cl_bal > 0 Then
                    debit_leave(
                        p_empno        => tab_emplist(i).empno,
                        p_pdate        => v_processing_date,
                        p_adj_type     => c_adj_type,
                        p_leavetype    => 'CL',
                        p_leave_period => v_cl_bal
                    );
                End If;

                If v_sl_bal > 0 Then
                    debit_leave(
                        p_empno        => tab_emplist(i).empno,
                        p_pdate        => v_processing_date,
                        p_adj_type     => c_adj_type,
                        p_leavetype    => 'SL',
                        p_leave_period => v_sl_bal
                    );
                End If;

                If v_pl_bal > v_max_leave_bal_limit Then
                    v_pl_bal := v_pl_bal - v_max_leave_bal_limit;
                    debit_leave(
                        p_empno        => tab_emplist(i).empno,
                        p_pdate        => v_processing_date,
                        p_adj_type     => c_adj_type,
                        p_leavetype    => 'PL',
                        p_leave_period => v_pl_bal
                    );

                End If;

            End Loop;

            Exit When cur_emplist%notfound;
        End Loop;

    End adjust_leave_202012;

    Procedure adjust_leave_yearly(
        p_empno       Varchar2,
        p_yyyymm      Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As

        Cursor cur_emplist(
            cp_empno Varchar2
        ) Is
            Select
                empno
            From
                ss_emplmast
            Where
                status = 1
                And emptype In (
                    'R', 'F'
                )
                And empno Like cp_empno;

        v_max_leave_bal_limit ss_leave_bal_max_limit.max_leave_bal%Type;
        Type typ_tab_emplist Is
            Table Of cur_emplist%rowtype;
        tab_emplist           typ_tab_emplist;
        v_processing_date     Date;
        v_count               Number;
        v_cl_bal              Number;
        v_pl_bal              Number;
        v_sl_bal              Number;
        v_co_bal              Number;
        v_p_empno             Varchar2(5);
        --c_yyyymm                Constant Varchar2(6) := '202012';
        c_adj_type            Constant Varchar(2) := 'YA';
    Begin
        v_p_empno := nvl(trim(p_empno), '%');
        Begin
            v_processing_date := last_day(to_date(p_yyyymm, 'yyyymm'));
        Exception
            When Others Then
                p_success := 'KO';
                p_message := 'Invalid YYYYMM.';
                Return;
        End;

        Begin
            Select
                max_leave_bal
            Into
                v_max_leave_bal_limit
            From
                ss_leave_bal_max_limit
            Where
                yyyymm = p_yyyymm;

        Exception
            When Others Then
                v_max_leave_bal_limit := c_max_leave_bal_limit;
        End;

        If v_p_empno <> '%' Then
            Select
                Count(*)
            Into
                v_count
            From
                ss_emplmast
            Where
                empno      = v_p_empno
                And status = 1
                And emptype In (
                    'R', 'F'
                );

            If v_count = 0 Then
                p_success := 'KO';
                p_message := 'Err - Incorrect Employee number.';
                Return;
            End If;

        End If;

        Open cur_emplist(v_p_empno);
        Loop
            Fetch cur_emplist Bulk Collect Into tab_emplist Limit 50;
            For i In 1..tab_emplist.count
            Loop
                Delete
                    From ss_leave_adj
                Where
                    empno            = tab_emplist(i).empno
                    And adj_type     = c_adj_type
                    And db_cr        = 'D'
                    And trunc(bdate) = trunc(v_processing_date)
                    And leavetype In (
                        'CL', 'PL', 'SL', 'CO'
                    );

                Delete
                    From ss_leaveledg
                Where
                    empno        = tab_emplist(i).empno
                    And adj_type = c_adj_type
                    And db_cr    = 'D'
                    And bdate    = v_processing_date
                    And app_no Like '%'
                    And leavetype In (
                        'CL', 'PL', 'SL', 'CO'
                    );

                v_cl_bal := leave_bal.get_cl_bal(tab_emplist(i).empno, v_processing_date);
                v_pl_bal := leave_bal.get_pl_bal(tab_emplist(i).empno, v_processing_date);
                v_sl_bal := leave_bal.get_sl_bal(tab_emplist(i).empno, v_processing_date);
                v_co_bal := leave_bal.get_co_bal(tab_emplist(i).empno, v_processing_date);
                If v_cl_bal > 0 Then
                    debit_leave(
                        p_empno        => tab_emplist(i).empno,
                        p_pdate        => v_processing_date,
                        p_adj_type     => c_adj_type,
                        p_leavetype    => 'CL',
                        p_leave_period => v_cl_bal
                    );
                End If;

                If v_sl_bal > 0 Then
                    debit_leave(
                        p_empno        => tab_emplist(i).empno,
                        p_pdate        => v_processing_date,
                        p_adj_type     => c_adj_type,
                        p_leavetype    => 'SL',
                        p_leave_period => v_sl_bal
                    );
                End If;

                If v_co_bal > 0 Then
                    debit_leave(
                        p_empno        => tab_emplist(i).empno,
                        p_pdate        => v_processing_date,
                        p_adj_type     => c_adj_type,
                        p_leavetype    => 'CO',
                        p_leave_period => v_co_bal
                    );
                End If;

                If v_pl_bal > v_max_leave_bal_limit Then
                    v_pl_bal := v_pl_bal - v_max_leave_bal_limit;
                    debit_leave(
                        p_empno        => tab_emplist(i).empno,
                        p_pdate        => v_processing_date,
                        p_adj_type     => c_adj_type,
                        p_leavetype    => 'PL',
                        p_leave_period => v_pl_bal
                    );

                End If;

            End Loop;

            Exit When cur_emplist%notfound;
        End Loop;

    End adjust_leave_yearly;

    Procedure adjust_leave_monthly(
        p_empno       Varchar2,
        p_yyyymm      Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As

        Cursor cur_emplist(
            cp_empno Varchar2
        ) Is
            Select
                empno
            From
                ss_emplmast
            Where
                status = 1
                And emptype In (
                    'R', 'F'
                )
                And empno Like cp_empno;

        v_max_leave_bal_limit ss_leave_bal_max_limit.max_leave_bal%Type;
        Type typ_tab_emplist Is
            Table Of cur_emplist%rowtype;
        tab_emplist           typ_tab_emplist;
        v_processing_date     Date;
        v_count               Number;
        v_cl_bal              Number;
        v_pl_bal              Number;
        v_sl_bal              Number;
        v_p_empno             Varchar2(5);
        c_202012              Constant Varchar2(6) := '202012';

        c_adj_type            Constant Varchar(2)  := 'MA';
    Begin
        v_p_empno := nvl(trim(p_empno), '%');
        Begin
            v_processing_date := last_day(to_date(p_yyyymm, 'yyyymm'));
            If v_processing_date <= to_date(c_202012, 'yyyymm') Then
                p_success := 'KO';
                p_message := 'Invalid YYYYMM.';
                Return;
            End If;

        Exception
            When Others Then
                p_success := 'KO';
                p_message := 'Invalid YYYYMM.';
                Return;
        End;

        Begin
            Select
                max_leave_bal
            Into
                v_max_leave_bal_limit
            From
                ss_leave_bal_max_limit
            Where
                yyyymm = p_yyyymm;

        Exception
            When Others Then
                v_max_leave_bal_limit := c_max_leave_bal_limit;
        End;

        If v_p_empno <> '%' Then
            Select
                Count(*)
            Into
                v_count
            From
                ss_emplmast
            Where
                empno      = v_p_empno
                And status = 1
                And emptype In (
                    'R', 'F'
                );

            If v_count = 0 Then
                p_success := 'KO';
                p_message := 'Err - Incorrect Employee number.';
                Return;
            End If;

        End If;

        Open cur_emplist(v_p_empno);
        Loop
            Fetch cur_emplist Bulk Collect Into tab_emplist Limit 50;
            For i In 1..tab_emplist.count
            Loop
                Delete
                    From ss_leave_adj
                Where
                    empno            = tab_emplist(i).empno
                    And adj_type     = c_adj_type
                    And db_cr        = 'D'
                    And trunc(bdate) = trunc(v_processing_date)
                    And leavetype    = 'PL';

                Delete
                    From ss_leaveledg
                Where
                    empno         = tab_emplist(i).empno
                    And adj_type  = c_adj_type
                    And db_cr     = 'D'
                    And bdate     = v_processing_date
                    And app_no Like '%'
                    And leavetype = 'PL';

                --v_cl_bal   := leave_bal.get_cl_bal(tab_emplist(i).empno, v_processing_date);

                v_pl_bal := leave_bal.get_pl_bal(tab_emplist(i).empno, v_processing_date);
                --v_sl_bal   := leave_bal.get_sl_bal(tab_emplist(i).empno, v_processing_date);
                /*
                If v_cl_bal > 0 Then
                    debit_leave(
                        p_empno          => tab_emplist(i).empno,
                        p_pdate          => v_processing_date,
                        p_adj_type       => c_adj_type,
                        p_leavetype      => 'CL',
                        p_leave_period   => v_cl_bal
                    );
                End If;

                If v_sl_bal > 0 Then
                    debit_leave(
                        p_empno          => tab_emplist(i).empno,
                        p_pdate          => v_processing_date,
                        p_adj_type       => c_adj_type,
                        p_leavetype      => 'SL',
                        p_leave_period   => v_sl_bal
                    );
                End If;
                */
                If v_pl_bal > v_max_leave_bal_limit Then
                    v_pl_bal := v_pl_bal - v_max_leave_bal_limit;
                    debit_leave(
                        p_empno        => tab_emplist(i).empno,
                        p_pdate        => v_processing_date,
                        p_adj_type     => c_adj_type,
                        p_leavetype    => 'PL',
                        p_leave_period => v_pl_bal
                    );

                End If;

            End Loop;

            Exit When cur_emplist%notfound;
        End Loop;

    End adjust_leave_monthly;

    Procedure lapse_leave(
        p_yyyymm   Varchar2,
        p_adj_type Varchar2,
        p_empno    Varchar2
    ) As
        v_success Varchar2(10);
        v_msg     Varchar2(1000);
    Begin
        If p_yyyymm = '202012' Then
            adjust_leave_202012(
                p_empno   => p_empno,
                p_success => v_success,
                p_message => v_msg
            );
        Elsif p_adj_type = 'YA' and substr(p_yyyymm,5,2) = '12' and to_date(p_yyyymm,'yyyymm') > to_date('1-Jan-2021','dd-Mon-yyyy') Then
            adjust_leave_yearly(
                p_empno   => p_empno,
                p_yyyymm  => p_yyyymm,
                p_success => v_success,
                p_message => v_msg
            );
        Else
            adjust_leave_monthly(
                p_empno   => p_empno,
                p_yyyymm  => p_yyyymm,
                p_success => v_success,
                p_message => v_msg
            );
        End If;
    End;

    Procedure adjust_leave_async(
        p_yyyymm      Varchar2,
        p_adj_type    Varchar2,
        p_empno       Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
        v_result Varchar2(10);
        v_msg    Varchar2(1000);
        v_count  Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            all_scheduler_running_jobs
        Where
            job_name = c_lapse_leave_job;

        If v_count > 0 Then
            p_success := 'KO';
            p_message := 'Err - Previously scheduled job is still running.';
            Return;
        End If;

        dbms_scheduler.create_job(
            job_name            => c_lapse_leave_job,
            job_type            => 'STORED_PROCEDURE',
            job_action          => 'leave_adj.lapse_leave',
            number_of_arguments => 3,
            enabled             => false,
            job_class           => 'TCMPL_JOB_CLASS',
            comments            => 'to send Email'
        );

        dbms_scheduler.set_job_argument_value(
            job_name          => c_lapse_leave_job,
            argument_position => 1,
            argument_value    => p_yyyymm
        );

        dbms_scheduler.set_job_argument_value(
            job_name          => c_lapse_leave_job,
            argument_position => 2,
            argument_value    => p_adj_type
        );

        dbms_scheduler.set_job_argument_value(
            job_name          => c_lapse_leave_job,
            argument_position => 3,
            argument_value    => p_empno
        );

        dbms_scheduler.enable(c_lapse_leave_job);
        p_success := 'OK';
        p_message := 'Lapse Employee Leave Job has been scheduled.';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure rollback_lapse_leave(
        p_yyyymm      Varchar2,
        p_adj_type    Varchar2,
        p_empno       Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
        v_processing_date Date;
        v_p_empno         Varchar2(5);
        v_count           Number;
    Begin
        v_p_empno := nvl(trim(p_empno), '%');
        Begin
            v_processing_date := last_day(to_date(p_yyyymm, 'yyyymm'));
        Exception
            When Others Then
                p_success := 'KO';
                p_message := 'Invalid YYYYMM.';
                Return;
        End;

        Select
            Count(*)
        Into
            v_count
        From
            ss_leaveledg
        Where
            adj_type         = p_adj_type
            And db_cr        = 'D'
            And trunc(bdate) = trunc(v_processing_date)
            And leavetype In (
                'CL', 'PL', 'SL','CO'
            )
            And empno Like v_p_empno;

        If v_count = 0 Then
            p_success := 'KK';
            p_message := 'No Employee Leave Lapse found for the given criteria.';
            Return;
        End If;

        Delete
            From ss_leave_adj
        Where
            adj_type         = p_adj_type
            And db_cr        = 'D'
            And trunc(bdate) = trunc(v_processing_date)
            And leavetype In (
                'CL', 'PL', 'SL','CO'
            )
            And empno Like v_p_empno;

        Delete
            From ss_leaveledg
        Where
            adj_type  = p_adj_type
            And db_cr = 'D'
            And bdate = v_processing_date
            And app_no Like '%'
            And leavetype In (
                'CL', 'PL', 'SL','CO'
            )
            And empno Like v_p_empno;

        Commit;
        p_success := 'OK';
        p_message := 'Lapse Leave successfully rolled back.';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure lapse_leave_single_emp(
        p_yyyymm      Varchar2,
        p_adj_type    Varchar2,
        p_empno       Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
    Begin
        lapse_leave(
            p_yyyymm   => p_yyyymm,
            p_adj_type => p_adj_type,
            p_empno    => p_empno
        );
        p_success := 'OK';
        p_message := 'Procedure executed.';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    ---
    --Procedure to be delete after Use
    --
    --Procedures to Debit TimeSheet Leave

    Procedure post_leave_as_per_ts(
        p_empno                   Varchar2,
        p_leave_type              Varchar2,
        p_actual_leave_bal        Number,
        p_leave_to_adjust         Number,
        p_leave_adj_date          Date,
        p_bal_leave_to_adjust Out Number,
        p_success             Out Varchar2,
        p_message             Out Varchar2
    ) As
        v_bal_leave_to_adj Number;
    Begin
        If nvl(p_actual_leave_bal, 0) <= 0 Then
            p_bal_leave_to_adjust := p_leave_to_adjust;
            p_success             := 'OK';
            Return;
        End If;

        v_bal_leave_to_adj := 0;
        If p_leave_type <> 'PL' Then
            If p_actual_leave_bal > p_leave_to_adjust Then
                v_bal_leave_to_adj    := p_leave_to_adjust;
                p_bal_leave_to_adjust := 0;
            Else
                v_bal_leave_to_adj    := p_actual_leave_bal;
                p_bal_leave_to_adjust := p_leave_to_adjust - p_actual_leave_bal;
            End If;
        End If;
        --call post leave procedure

        leave.add_leave_adj(
            param_empno      => p_empno,
            param_adj_date   => p_leave_adj_date,
            param_adj_type   => 'TSD',
            param_leave_type => p_leave_type,
            param_adj_period => v_bal_leave_to_adj,
            param_entry_by   => 'Sys',
            param_desc       => 'Timesheet Leave Debit',
            param_success    => p_success,
            param_message    => p_message
        );

    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure ts_leave_update_remarks(
        p_empno   Varchar2,
        p_success Varchar2,
        p_message Varchar2
    ) As
    Begin
        Update
            ss_debit_ts_leave
        Set
            remark = p_success || ' - ' || p_message
        Where
            empno = p_empno;

    End;

    Procedure process_leave_as_per_ts As

        Cursor cur_ts_leave Is
            Select
                empno,
                leave_period
            From
                ss_debit_ts_leave
            Order By
                empno;

        Type typ_tab Is
            Table Of cur_ts_leave%rowtype;
        tab_emplist        typ_tab;
        v_count            Number;
        v_processing_date  Date;
        v_cl_bal           Number;
        v_pl_bal           Number;
        v_sl_bal           Number;
        v_p_empno          Varchar2(5);
        c_yyyymm           Constant Varchar2(6) := '202012';
        c_ya_adj_type      Constant Varchar(2)  := 'YA';
        v_success          Varchar2(10);
        v_message          Varchar2(1000);
        v_leave_to_adj     Number;
        v_bal_leave_to_adj Number;
    Begin
        v_processing_date := last_day(to_date(c_yyyymm, 'yyyymm'));
        Update
            ss_debit_ts_leave
        Set
            remark = Null;

        Open cur_ts_leave;
        Loop
            Fetch cur_ts_leave Bulk Collect Into tab_emplist Limit 50;
            Commit;
            For i In 1..tab_emplist.count
            Loop
                Update
                    ss_debit_ts_leave
                Set
                    remark = 'Started'
                Where
                    empno = tab_emplist(i).empno;

                Commit;
                Delete
                    From ss_leave_adj
                Where
                    empno        = tab_emplist(i).empno
                    And adj_type = 'TS'
                    And db_cr    = 'D'
                    And adj_dt   = v_processing_date;

                Delete
                    From ss_leaveledg
                Where
                    empno        = tab_emplist(i).empno
                    And adj_type = 'TS'
                    And db_cr    = 'D'
                    And bdate    = v_processing_date;

                rollback_lapse_leave(
                    p_yyyymm   => c_yyyymm,
                    p_adj_type => c_ya_adj_type,
                    p_empno    => tab_emplist(i).empno,
                    p_success  => v_success,
                    p_message  => v_message
                );

                If v_success = 'KO' Then
                    ts_leave_update_remarks(
                        p_empno   => tab_emplist(i).empno,
                        p_success => v_success,
                        p_message => v_message
                    );

                    Rollback;
                    Continue;
                End If;

                v_cl_bal           := leave_bal.get_cl_bal(tab_emplist(i).empno, v_processing_date);
                v_pl_bal           := leave_bal.get_pl_bal(tab_emplist(i).empno, v_processing_date);
                v_sl_bal           := leave_bal.get_sl_bal(tab_emplist(i).empno, v_processing_date);
                v_bal_leave_to_adj := tab_emplist(i).leave_period;

                --
                --
                --1st CL
                post_leave_as_per_ts(
                    p_empno               => tab_emplist(i).empno,
                    p_leave_type          => 'CL',
                    p_actual_leave_bal    => v_cl_bal,
                    p_leave_to_adjust     => v_bal_leave_to_adj,
                    p_leave_adj_date      => v_processing_date,
                    p_bal_leave_to_adjust => v_bal_leave_to_adj,
                    p_success             => v_success,
                    p_message             => v_message
                );

                If v_success != 'OK' Then
                    ts_leave_update_remarks(
                        p_empno   => tab_emplist(i).empno,
                        p_success => v_success,
                        p_message => v_message
                    );
                End If;

                If v_bal_leave_to_adj = 0 Then
                    adjust_leave_202012(
                        p_empno   => tab_emplist(i).empno,
                        p_success => v_success,
                        p_message => v_message
                    );

                    Continue;
                End If;

                --2nd SL

                post_leave_as_per_ts(
                    p_empno               => tab_emplist(i).empno,
                    p_leave_type          => 'SL',
                    p_actual_leave_bal    => v_sl_bal,
                    p_leave_to_adjust     => v_bal_leave_to_adj,
                    p_leave_adj_date      => v_processing_date,
                    p_bal_leave_to_adjust => v_bal_leave_to_adj,
                    p_success             => v_success,
                    p_message             => v_message
                );

                If v_bal_leave_to_adj = 0 Then
                    adjust_leave_202012(
                        p_empno   => tab_emplist(i).empno,
                        p_success => v_success,
                        p_message => v_message
                    );

                    Continue;
                End If;

                --post PL leave directly
                --Last PL

                leave.add_leave_adj(
                    param_empno      => tab_emplist(i).empno,
                    param_adj_date   => v_processing_date,
                    param_adj_type   => 'TSD',
                    param_leave_type => 'PL',
                    param_adj_period => v_bal_leave_to_adj,
                    param_entry_by   => 'Sys',
                    param_desc       => 'Timesheet Leave Debit',
                    param_success    => v_success,
                    param_message    => v_message
                );

                --XXXXX
                --Do Year End Lapse

                adjust_leave_202012(
                    p_empno   => tab_emplist(i).empno,
                    p_success => v_success,
                    p_message => v_message
                );

                If v_success != 'OK' Then
                    ts_leave_update_remarks(
                        p_empno   => tab_emplist(i).empno,
                        p_success => v_success,
                        p_message => v_message
                    );
                End If;

            End Loop;

            Exit When cur_ts_leave%notfound;
        End Loop;

        Close cur_ts_leave;
    End;

End leave_adj;
/