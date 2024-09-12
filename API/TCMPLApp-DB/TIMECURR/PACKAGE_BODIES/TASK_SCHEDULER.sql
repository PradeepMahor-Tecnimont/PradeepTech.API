Create Or Replace Package Body timecurr.task_scheduler As

    Procedure sp_daily_del_rap_batch_reports As
    Begin
        Delete
            From rap_rpt_process
        Where
            trunc(sdate) < sysdate;
        Commit;
    End sp_daily_del_rap_batch_reports;

    Procedure sp_daily_update_emp_count As
    Begin
        Update
            costmast
        Set
            noofemps = 0, noofcons = 0, cnt_ftc = 0, cnt_roll = 0;
        Update
            costmast
        Set
            noofemps =
            nvl((
                    Select
                        Count(empno)
                    From
                        emplmast
                    Where
                        emplmast.parent             = costmast.costcode
                        -- aDD THIS LINE IF NO OF EMPLOYEES SHOULD NOT INCLUDE NEW ED DIVISION
                        --AND EMPNO NOT LIKE '10%'
                        And emplmast.emptype In ('C', 'R', 'F')
                        And nvl(emplmast.status, 0) = 1
                ), 0);

        Update
            costmast
        Set
            noofcons =
            nvl((
                    Select
                        Count(empno)
                    From
                        emplmast
                    Where
                        emplmast.parent             = costmast.costcode
                        -- aDD THIS LINE IF NO OF EMPLOYEES SHOULD NOT INCLUDE NEW ED DIVISION
                        --AND EMPNO NOT LIKE '10%'
                        And emplmast.emptype In ('C')
                        And nvl(emplmast.status, 0) = 1
                ), 0);

        Update
            costmast
        Set
            cnt_ftc =
            nvl((
                    Select
                        Count(empno)
                    From
                        emplmast
                    Where
                        emplmast.parent             = costmast.costcode
                        -- aDD THIS LINE IF NO OF EMPLOYEES SHOULD NOT INCLUDE NEW ED DIVISION
                        --AND EMPNO NOT LIKE '10%'
                        And emplmast.emptype        = 'F'
                        And nvl(emplmast.status, 0) = 1
                ), 0);

        Update
            costmast
        Set
            cnt_roll =
            nvl((
                    Select
                        Count(empno)
                    From
                        emplmast
                    Where
                        emplmast.parent             = costmast.costcode
                        -- aDD THIS LINE IF NO OF EMPLOYEES SHOULD NOT INCLUDE NEW ED DIVISION
                        --AND EMPNO NOT LIKE '10%'
                        And emplmast.emptype        = 'R'
                        And nvl(emplmast.status, 0) = 1
                ), 0);

        Commit;

    End;

    Procedure sp_daily_update_jobform_mode As
        Cursor cur_job Is Select projno, closing_date_rev1
        From jobmaster
        Where closing_date_rev1 Is Not Null And job_mode_status = 'O1';
    Begin
        If to_char(sysdate,'DD') = '01' Then
            For c1 In cur_job Loop
                If trunc(add_months(sysdate,-1),'mm') = trunc(c1.closing_date_rev1,'mm') Then
                    Update jobmaster
                        Set job_mode_status = 'O2'
                    Where projno = c1.projno;
                End If;
            End Loop;
        End If;
    End;

End task_scheduler;