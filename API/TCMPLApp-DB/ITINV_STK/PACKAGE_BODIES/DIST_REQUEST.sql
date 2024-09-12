--------------------------------------------------------
--  DDL for Package Body DIST_REQUEST
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "ITINV_STK"."DIST_REQUEST" As

    Procedure revoke_request (
        param_win_uid   Varchar2,
        param_empno     Varchar2,
        param_success   Out             Varchar2,
        param_message   Out             Varchar2
    ) As
        v_req_by Char(5);
    Begin
        v_req_by        := dist_users.get_empno_from_win_uid(param_win_uid);
        If v_req_by Is Null Then
            param_success   := 'KO';
            param_message   := 'Err - Invalid WIN_UID';
            return;
        End If;

        Update dist_laptop_request
        Set
            is_requested = 'KO',
            req_by = v_req_by
        Where
            empno = param_empno;

        Commit;
        param_success   := 'OK';
        param_message   := 'Request successfully revoked';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End revoke_request;

    Procedure add_request (
        param_win_uid   Varchar2,
        param_empno     Varchar2,
        param_sw        Varchar2,
        param_success   Out             Varchar2,
        param_message   Out             Varchar2
    ) As
        v_req_by   Char(5);
        v_count    Number;
    Begin
        v_req_by        := dist_users.get_empno_from_win_uid(param_win_uid);
        If v_req_by Is Null Then
            param_success   := 'KO';
            param_message   := 'Err - Invalid WIN_UID';
            return;
        End If;

        Select
            Count(*)
        Into v_count
        From
            dist_laptop_request
        Where
            empno = param_empno;

        If v_count = 0 Then
            Insert Into dist_laptop_request (
                empno,
                sw_required,
                windows_ver,
                req_date,
                req_by,
                it_action_code,
                is_requested
            ) Values (
                param_empno,
                Substr(param_sw, 1, 100),
                '10',
                Sysdate,
                v_req_by,
                'PP',
                'OK'
            );

        Else
            Update dist_laptop_request
            Set
                is_requested = 'OK',
                req_by = v_req_by,
                sw_required = param_sw
            Where
                empno = param_empno;

        End If;

        Commit;
        param_success   := 'OK';
        param_message   := 'Request successfully created';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End add_request;

    Procedure it_action (
        param_win_uid            Varchar2,
        param_empno              Varchar2,
        param_it_rem             Varchar2,
        param_it_action_code     Varchar2,
        param_laptop_qrcode      Varchar2,
        param_headphone_qrcode   Varchar2,
        param_docking_qrcode     Varchar2,
        param_issue_date         Varchar2,
        param_success            Out                      Varchar2,
        param_message            Out                      Varchar2
    ) As
        v_approval_by   Char(5);
        v_issue_date    Date;
        v_count         Number;
    Begin
        Select
            Count(*)
        Into v_count
        From
            dist_req_status_mast
        Where
            status_code = param_it_action_code;

        If v_count = 0 Then
            param_success   := 'KO';
            param_message   := 'Err - Incorrect status assigned.';
            return;
        End If;

        v_approval_by   := dist_users.get_empno_from_win_uid(param_win_uid);
        If v_approval_by Is Null Then
            param_success   := 'KO';
            param_message   := 'Err - Invalid WIN_UID';
            return;
        End If;
--Issued

        If param_it_action_code = 'II' Then
            If param_issue_date Is Null Then
                param_success   := 'KO';
                param_message   := 'Issue date is required.';
                return;
            End If;

            Begin
                v_issue_date := To_Date(param_issue_date, 'dd-Mon-yyyy');
            Exception
                When Others Then
                    param_success   := 'KO';
                    param_message   := 'Incorrect date specified.';
                    return;
            End;

        End If;

        Update dist_laptop_request
        Set
            it_action_code = param_it_action_code,
            it_action_by = v_approval_by,
            it_action_date = Sysdate,
            it_remarks = param_it_rem,
            laptop_ams_id = param_laptop_qrcode,
            headphone_qrcode = param_headphone_qrcode,
            docking_qrcode = param_docking_qrcode,
            issue_date = v_issue_date
        Where
            empno = param_empno;

        Commit;
        param_success   := 'OK';
        param_message   := 'Request successfully created';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;

    Function get_a3_emp_count (
        param_parent Varchar2
    ) Return Number Is
        v_ret_val Number;
    Begin
        Select
            Count(empno)
        Into v_ret_val
        From
            stk_empmaster
        Where
            parent = param_parent
            And status  = 1
            And grade   = 'A3'
            And assign Not In (
                Select
                    assign
                From
                    dist_exclude_assign
            );

        Return v_ret_val;
    Exception
        When Others Then
            Return -1;
    End;

    Function get_requests_count (
        param_parent Varchar2
    ) Return Number Is
        v_ret_val Number;
    Begin
        Select
            Count(empno)
        Into v_ret_val
        From
            dist_laptop_request
        Where
            empno In (
                Select
                    empno
                From
                    stk_empmaster
                Where
                    parent = param_parent
                    And status = 1
                    And grade Not In (
                        'A2'
                    )
            );

        Return v_ret_val;
    Exception
        When Others Then
            Return -1;
    End;

    Function get_action_desc (
        param_action_code Varchar2
    ) Return Varchar2 Is
        v_ret_val Varchar2(100);
    Begin
        Select
            status_desc
        Into v_ret_val
        From
            dist_req_status_mast
        Where
            status_code = param_action_code;

        Return v_ret_val;
    Exception
        When Others Then
            Return '-';
            Return v_ret_val;
    End;

    Function get_emp_count (
        param_parent Varchar2,
        param_grade Varchar2
    ) Return Number Is
        v_count Number;
    Begin
        If param_grade Like 'A%' Then
            Select
                Count(*)
            Into v_count
            From
                vu_emplmast
            Where
                status = 1
                And parent Like param_parent
                And assign Not In (
                    Select
                        assign
                    From
                        dist_exclude_assign
                )
                And grade = param_grade
                And emptype In (
                    Select
                        emptype
                    From
                        Table ( dist.get_emp_type_list() )
                );

        Else
            Select
                Count(*)
            Into v_count
            From
                vu_emplmast
            Where
                status = 1
                And parent Like param_parent
                And assign Not In (
                    Select
                        assign
                    From
                        dist_exclude_assign
                )
                And grade Not In (
                    Select
                        grade
                    From
                        Table ( dist.get_exclude_grade_list() )
                )
                And grade Not In (
                    'A2',
                    'A3'
                )
                And emptype In (
                    Select
                        emptype
                    From
                        Table ( dist.get_emp_type_list() )
                );

        End If;

        Return v_count;
    Exception
        When Others Then
            Return 0;
    End;

    Function get_req_count (
        param_parent Varchar2,
        param_grade Varchar2
    ) Return Number As
        v_count Number;
    Begin
        If param_grade Like 'A%' Then
            Select
                Count(*)
            Into v_count
            From
                vu_emplmast           a,
                dist_laptop_request   b
            Where
                a.empno = b.empno
                And status                  = 1
                And Nvl(is_requested, 'KO') = 'OK'
                And parent Like param_parent
                And assign Not In (
                    Select
                        assign
                    From
                        dist_exclude_assign
                )
                And grade                   = param_grade
                And emptype In (
                    Select
                        emptype
                    From
                        Table ( dist.get_emp_type_list() )
                );

        Else
            Select
                Count(*)
            Into v_count
            From
                vu_emplmast           a,
                dist_laptop_request   b
            Where
                a.empno = b.empno
                And status                  = 1
                And Nvl(is_requested, 'KO') = 'OK'
                And parent Like param_parent
                And assign Not In (
                    Select
                        assign
                    From
                        dist_exclude_assign
                )
                And grade Not In (
                    'A2',
                    'A3'
                )
                And grade Not In (
                    Select
                        grade
                    From
                        Table ( dist.get_exclude_grade_list() )
                )
                And emptype In (
                    Select
                        emptype
                    From
                        Table ( dist.get_emp_type_list() )
                );

        End If;

        Return v_count;
    Exception
        When Others Then
            Return 0;
    End;

    Function get_prev_issued_count (
        param_parent Varchar2,
        param_grade Varchar2
    ) Return Number Is
        v_count Number;
    Begin
        If param_grade Like 'A%' Then
            Select
                Count(*)
            Into v_count
            From
                dist_laptop_already_issued
            Where
                permanent_issued = 'OK'
                And empno In (
                    Select
                        empno
                    From
                        vu_emplmast
                    Where
                        status = 1
                        And parent Like param_parent
                        And assign Not In (
                            Select
                                assign
                            From
                                dist_exclude_assign
                        )
                        And grade = param_grade
                        And emptype In (
                            Select
                                emptype
                            From
                                Table ( dist.get_emp_type_list() )
                        )
                );

        Else
            Select
                Count(*)
            Into v_count
            From
                dist_laptop_already_issued
            Where
                permanent_issued = 'OK'
                And empno In (
                    Select
                        empno
                    From
                        vu_emplmast
                    Where
                        status = 1
                        And parent Like param_parent
                        And assign Not In (
                            Select
                                assign
                            From
                                dist_exclude_assign
                        )
                        And grade Not In (
                            Select
                                grade
                            From
                                Table ( dist.get_exclude_grade_list() )
                        )
                        And grade Not In (
                            'A2',
                            'A3'
                        )
                        And emptype In (
                            Select
                                emptype
                            From
                                Table ( dist.get_emp_type_list() )
                        )
                );

        End If;

        Return v_count;
    Exception
        When Others Then
            Return 0;
    End;

    Function get_now_issued_count (
        param_parent Varchar2,
        param_grade Varchar2
    ) Return Number As
        v_count Number;
    Begin
        If param_grade Like 'A%' Then
            Select
                Count(*)
            Into v_count
            From
                --dist_surface_laptop_mast
                dist_vu_emp_it_equipments
            Where
                current_status = 11
                --And assigned_to_empno In (
                And empno In (
                    Select
                        empno
                    From
                        vu_emplmast
                    Where
                        status = 1
                        And parent Like param_parent
                        And assign Not In (
                            Select
                                assign
                            From
                                dist_exclude_assign
                        )
                        And grade = param_grade
                        And emptype In (
                            Select
                                emptype
                            From
                                Table ( dist.get_emp_type_list() )
                        )
                );

        Else
            Select
                Count(*)
            Into v_count
            From
                --dist_surface_laptop_mast
                dist_vu_emp_it_equipments
            Where
                current_status = 11
                --And assigned_to_empno In (
                And empno In (
                    Select
                        empno
                    From
                        vu_emplmast
                    Where
                        status = 1
                        And parent Like param_parent
                        And assign Not In (
                            Select
                                assign
                            From
                                dist_exclude_assign
                        )
                        And grade Not In (
                            Select
                                grade
                            From
                                Table ( dist.get_exclude_grade_list() )
                        )
                        And grade Not In (
                            'A2',
                            'A3'
                        )
                        And emptype In (
                            Select
                                emptype
                            From
                                Table ( dist.get_emp_type_list() )
                        )
                );

        End If;

        Return v_count;
    Exception
        When Others Then
            Return 0;
    End;

    Procedure get_dept_request_summary (
        param_parent            Varchar2,
        param_a2_emp_count      Out                     Number,
        param_a2_quota          Out                     Number,
        param_a2_req_count      Out                     Number,
        param_a2_prev_issued    Out                     Number,
        param_a2_tot_issued     Out                     Number,
        param_a3_emp_count      Out                     Number,
        param_a3_quota          Out                     Number,
        param_a3_req_count      Out                     Number,
        param_a3_prev_issued    Out                     Number,
        param_a3_tot_issued     Out                     Number,
        param_oth_emp_count     Out                     Number,
        param_oth_quota         Out                     Number,
        param_oth_req_count     Out                     Number,
        param_oth_prev_issued   Out                     Number,
        param_oth_tot_issued    Out                     Number,
        param_tot_quota         Out                     Number,
        param_tot_req           Out                     Number,
        param_tot_prev_issued   Out                     Number,
        param_tot_issued        Out                     Number,
        param_success           Out                     Varchar2,
        param_message           Out                     Varchar2
    ) As
    Begin
        param_a2_emp_count      := get_emp_count(
            param_parent,
            'A2'
        );
        param_a3_emp_count      := get_emp_count(
            param_parent,
            'A3'
        );
        param_oth_emp_count     := get_emp_count(
            param_parent,
            'OTH'
        );
        param_a2_quota          := param_a2_emp_count;
        param_a3_quota          := Floor(param_a3_emp_count *.9);
        param_oth_quota         := 0;
        
        --
        param_a2_prev_issued    := get_prev_issued_count(
            param_parent,
            'A2'
        );
        param_a3_prev_issued    := get_prev_issued_count(
            param_parent,
            'A3'
        );
        param_oth_prev_issued   := get_prev_issued_count(
            param_parent,
            'OTH'
        );
        --
        --
        param_a2_tot_issued     := get_now_issued_count(
            param_parent,
            'A2'
        );
        param_a3_tot_issued     := get_now_issued_count(
            param_parent,
            'A3'
        );
        param_oth_tot_issued    := get_now_issued_count(
            param_parent,
            'OTH'
        );
        param_a2_tot_issued     := param_a2_tot_issued + param_a2_prev_issued;
        param_a3_tot_issued     := param_a3_tot_issued + param_a3_prev_issued;
        param_oth_tot_issued    := param_oth_tot_issued + param_oth_prev_issued;
        --
        --
        param_a2_req_count      := get_req_count(
            param_parent,
            'A2'
        );
        param_a3_req_count      := get_req_count(
            param_parent,
            'A3'
        );
        param_oth_req_count     := get_req_count(
            param_parent,
            'OTH'
        );
        --
        --
        param_tot_quota         := param_a2_quota + param_a3_quota;
        param_tot_req           := param_a2_req_count + param_a3_req_count + param_oth_req_count;
        param_tot_prev_issued   := param_a2_prev_issued + param_a3_prev_issued + param_oth_prev_issued;
        param_tot_issued        := param_a2_tot_issued + param_a3_tot_issued + param_oth_tot_issued;
        param_success           := 'OK';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;

    Function get_all_dept_summary Return typ_tab_summary
        Pipelined
    As

        v_summ_rec          typ_rec_summary;
        Cursor cur_parent Is
        Select
            costcode,
            name
        From
            vu_costmast
        Where
            noofemps > 0
            And costcode Not In (
                Select
                    assign
                From
                    dist_exclude_assign
            )
        Order By
            costcode;

        Type typ_tab_parent Is
            Table Of cur_parent%rowtype;
        tab_parent          typ_tab_parent;
        
        --
        v_a2_emp_count      Number;
        v_a2_quota          Number;
        v_a2_req_count      Number;
        v_a2_prev_issued    Number;
        v_a2_tot_issued     Number;
        v_a3_emp_count      Number;
        v_a3_quota          Number;
        v_a3_req_count      Number;
        v_a3_prev_issued    Number;
        v_a3_tot_issued     Number;
        v_oth_emp_count     Number;
        v_oth_quota         Number;
        v_oth_req_count     Number;
        v_oth_prev_issued   Number;
        v_oth_tot_issued    Number;
        v_tot_quota         Number;
        v_tot_req           Number;
        v_tot_prev_issued   Number;
        v_tot_issued        Number;
        --
        v_success           Varchar2(10);
        v_message           Varchar2(1000);
    Begin
        Open cur_parent;
        Loop
            Fetch cur_parent Bulk Collect Into tab_parent Limit 50;
            For i In 1..tab_parent.count Loop

                --
                v_a2_emp_count              := Null;
                v_a2_quota                  := Null;
                v_a2_req_count              := Null;
                v_a2_prev_issued            := Null;
                v_a2_tot_issued             := Null;
                v_a3_emp_count              := Null;
                v_a3_quota                  := Null;
                v_a3_req_count              := Null;
                v_a3_prev_issued            := Null;
                v_a3_tot_issued             := Null;
                v_oth_emp_count             := Null;
                v_oth_quota                 := Null;
                v_oth_req_count             := Null;
                v_oth_prev_issued           := Null;
                v_oth_tot_issued            := Null;
                v_tot_quota                 := Null;
                v_tot_req                   := Null;
                v_tot_prev_issued           := Null;
                v_tot_issued                := Null;
                
                --
                v_summ_rec.parent           := tab_parent(i).costcode;
                v_summ_rec.dept_desc        := tab_parent(i).name;
                dist_request.get_dept_request_summary(
                    param_parent            => v_summ_rec.parent,
                    param_a2_emp_count      => v_a2_emp_count,
                    param_a2_quota          => v_a2_quota,
                    param_a2_req_count      => v_a2_req_count,
                    param_a2_prev_issued    => v_a2_prev_issued,
                    param_a2_tot_issued     => v_a2_tot_issued,
                    param_a3_emp_count      => v_a3_emp_count,
                    param_a3_quota          => v_a3_quota,
                    param_a3_req_count      => v_a3_req_count,
                    param_a3_prev_issued    => v_a3_prev_issued,
                    param_a3_tot_issued     => v_a3_tot_issued,
                    param_oth_emp_count     => v_oth_emp_count,
                    param_oth_quota         => v_oth_quota,
                    param_oth_req_count     => v_oth_req_count,
                    param_oth_prev_issued   => v_oth_prev_issued,
                    param_oth_tot_issued    => v_oth_tot_issued,
                    param_tot_quota         => v_tot_quota,
                    param_tot_req           => v_tot_req,
                    param_tot_prev_issued   => v_tot_prev_issued,
                    param_tot_issued        => v_tot_issued,
                    param_success           => v_success,
                    param_message           => v_message
                );

                If v_success = 'KO' Then
                    Continue;
                End If;
            --A2
                v_summ_rec.grade_desc       := 'A2 (100%)';
                v_summ_rec.emp_count        := v_a2_emp_count;
                v_summ_rec.eligible_count   := v_a2_quota;
                v_summ_rec.prev_issued      := v_a2_prev_issued;
                v_summ_rec.now_requested    := v_a2_req_count;
                v_summ_rec.total_issued     := v_a2_tot_issued;
                Pipe Row ( v_summ_rec );
            
            --A3
                v_summ_rec.grade_desc       := 'A3 (90%)';
                v_summ_rec.emp_count        := v_a3_emp_count;
                v_summ_rec.eligible_count   := v_a3_quota;
                v_summ_rec.prev_issued      := v_a3_prev_issued;
                v_summ_rec.now_requested    := v_a3_req_count;
                v_summ_rec.total_issued     := v_a3_tot_issued;
                Pipe Row ( v_summ_rec );
            
            --Others
                v_summ_rec.grade_desc       := 'Others (0%)';
                v_summ_rec.emp_count        := v_oth_emp_count;
                v_summ_rec.eligible_count   := v_oth_quota;
                v_summ_rec.prev_issued      := v_oth_prev_issued;
                v_summ_rec.now_requested    := v_oth_req_count;
                v_summ_rec.total_issued     := v_oth_tot_issued;
                Pipe Row ( v_summ_rec );
            End Loop;

            Exit When cur_parent%notfound;
        End Loop;

        return;
    End;

    Procedure get_all_dept_request_summary (
        param_parent            Varchar2,
        param_a2_emp_count      Out                     Number,
        param_a2_quota          Out                     Number,
        param_a2_req_count      Out                     Number,
        param_a2_prev_issued    Out                     Number,
        param_a2_tot_issued     Out                     Number,
        param_a3_emp_count      Out                     Number,
        param_a3_quota          Out                     Number,
        param_a3_req_count      Out                     Number,
        param_a3_prev_issued    Out                     Number,
        param_a3_tot_issued     Out                     Number,
        param_oth_emp_count     Out                     Number,
        param_oth_quota         Out                     Number,
        param_oth_req_count     Out                     Number,
        param_oth_prev_issued   Out                     Number,
        param_oth_tot_issued    Out                     Number,
        param_tot_quota         Out                     Number,
        param_tot_req           Out                     Number,
        param_tot_prev_issued   Out                     Number,
        param_tot_issued        Out                     Number,
        param_success           Out                     Varchar2,
        param_message           Out                     Varchar2
    ) As

        Cursor c1 Is
        Select
            grade_desc,
            Sum(emp_count) sum_emp_count,
            Sum(eligible_count) sum_eligible_count,
            Sum(prev_issued) sum_prev_issued,
            Sum(now_requested) sum_now_requested,
            Sum(total_issued) sum_total_issued
        From
            Table ( dist_request.get_all_dept_summary() )
        Group By
            grade_desc
        Order By
            grade_desc;

    Begin
        For c2 In c1 Loop --
            Null;
            If c2.grade_desc Like 'A2%' Then
                param_a2_emp_count     := c2.sum_emp_count;
                param_a2_quota         := c2.sum_eligible_count;
                param_a2_req_count     := c2.sum_now_requested;
                param_a2_prev_issued   := c2.sum_prev_issued;
                param_a2_tot_issued    := c2.sum_total_issued;
            End If;

            If c2.grade_desc Like 'A3%' Then
                param_a3_emp_count     := c2.sum_emp_count;
                param_a3_quota         := c2.sum_eligible_count;
                param_a3_req_count     := c2.sum_now_requested;
                param_a3_prev_issued   := c2.sum_prev_issued;
                param_a3_tot_issued    := c2.sum_total_issued;
            End If;

            If c2.grade_desc Like 'Other%' Then
                param_oth_emp_count     := c2.sum_emp_count;
                param_oth_quota         := c2.sum_eligible_count;
                param_oth_req_count     := c2.sum_now_requested;
                param_oth_prev_issued   := c2.sum_prev_issued;
                param_oth_tot_issued    := c2.sum_total_issued;
            End If;

        End Loop;
/*
        param_a2_tot_issued     := param_a2_tot_issued + param_a2_prev_issued;
        param_a3_tot_issued     := param_a3_tot_issued + param_a3_prev_issued;
        param_oth_tot_issued    := param_oth_tot_issued + param_oth_prev_issued;
        */
        --
        --
 
        --
        --

        param_tot_quota         := param_a2_quota + param_a3_quota;
        param_tot_req           := param_a2_req_count + param_a3_req_count + param_oth_req_count;
        param_tot_prev_issued   := param_a2_prev_issued + param_a3_prev_issued + param_oth_prev_issued;
        param_tot_issued        := param_a2_tot_issued + param_a3_tot_issued + param_oth_tot_issued;
        param_success           := 'OK';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;

    Procedure reason_4_nopickup (
        param_win_uid       Varchar2,
        param_empno         Varchar2,
        param_reason_code   Varchar2,
        param_success       Out                 Varchar2,
        param_message       Out                 Varchar2
    ) As
        v_action_by     Char(5);
        v_count         Number;
        v_reason_code   Number;
    Begin
        v_action_by     := dist_users.get_empno_from_win_uid(param_win_uid);
        Select
            Count(*)
        Into v_count
        From
            dist_surface_laptop_mast
        Where
            assigned_to_empno = param_empno
            And current_status = 11;

        If v_count > 0 Then
            param_success   := 'KO';
            param_message   := 'Laptop has been already deliverd. Cannot change status.';
            return;
        End If;

        If Trim(param_reason_code) Is Not Null Then
            v_reason_code := To_Number(param_reason_code);
            Select
                Count(*)
            Into v_count
            From
                dist_lov_no_reason4pickup
            Where
                reason_id = To_Number(v_reason_code);

            If v_count = 0 Then
                param_success   := 'KO';
                param_message   := 'Incorrect reason code provided. Cannot proceed.';
                return;
            End If;

        End If;

        Update dist_laptop_request
        Set
            reason_4_nopickup = v_reason_code,
            pickupreason_modified_by = v_action_by,
            pickupreason_modified_on = Sysdate
        Where
            empno = param_empno;

        If Sql%rowcount = 0 Then
            Insert Into dist_laptop_request (
                empno,
                is_requested,
                req_by,
                reason_4_nopickup,
                pickupreason_modified_by,
                pickupreason_modified_on
            ) Values (
                param_empno,
                'KO',
                v_action_by,
                To_Number(param_reason_code),
                v_action_by,
                Sysdate
            );

        End If;

        Commit;
        param_success   := 'OK';
        param_message   := 'Request successfully revoked';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;

    Function reason_4_nopickup_desc (
        param_reason_code Varchar2
    ) Return Varchar2 As
        v_retval Varchar2(100);
    Begin
        Select
            reason_desc
        Into v_retval
        From
            dist_lov_no_reason4pickup
        Where
            reason_id = param_reason_code;

        Return v_retval;
    Exception
        When Others Then
            Return Null;
    End;

End dist_request;

/
