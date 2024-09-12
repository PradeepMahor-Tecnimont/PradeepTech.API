--------------------------------------------------------
--  DDL for Package Body PKG_OFB_APPROVAL
--------------------------------------------------------

Create Or Replace Package Body "TCMPL_HR"."PKG_OFB_APPROVAL" As

    c_module_id Constant Char(3) := 'M02';

    Procedure sp_validate_rollback_ofb(
        p_empno            Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_is_rollback_initiated Char(2);
    Begin
        Select
            pkg_ofb_common.fn_check_rollback_ofb(oee.empno, oee.created_on)
        Into
            v_is_rollback_initiated
        From
            ofb_emp_exits oee
        Where
            oee.empno = Trim(p_empno);

        If v_is_rollback_initiated = ok Then
            p_message_type := not_ok;
            p_message_text := 'Approval failed. Rollback initiated !!!';
            Return;
        End If;
        p_message_type := ok;
        p_message_text := p_message_type;
    End;

    Procedure sp_insert_ofb_exit_approvals_log(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_action_id        Varchar2,
        p_remarks          Varchar2 Default Null,
        p_apprl_type       Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Insert Into ofb_exit_approvals_log
        (
            empno,
            action_id,
            is_approved,
            remarks,
            approved_by,
            modified_on,
            key_id)
        Values
        (
            p_empno,
            p_action_id,
            p_apprl_type,
            p_remarks,
            v_empno,
            sysdate,
            dbms_random.string('X', 8)
        );

        p_message_type := ok;
        p_message_text := p_message_type;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_update_ofb_emp_exits(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
      
        Update
            ofb_emp_exits
        Set
            is_approval_complete = fn_is_approval_complete(p_empno)  
        Where
            empno = p_empno;
     
        p_message_type := ok;
        p_message_text := p_message_type;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure prc_ofb_approve(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_remarks          Varchar2 Default Null,
        p_apprl_action_id  Varchar2,
        p_is_hold          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_is_approved  ofb_emp_exit_approvals.is_approved%Type;
        v_approval_due Varchar2(2);
        v_apprl_type   Varchar2(2);
        v_apprl_onhold varchar2(2) := 'OO';
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_remarks Is Not Null Then
            If length(trim(p_remarks)) > 200 Then
                p_message_type := not_ok;
                p_message_text := 'Approval failed. Remarks too long !!!';
                Return;
            End If;
        End If;

        sp_validate_rollback_ofb(
            p_empno        => p_empno,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        v_approval_due := fn_is_approval_due(
                              p_ofb_empno       => p_empno,
                              p_apprl_action_id => p_apprl_action_id
                          );

        If nvl(v_approval_due, not_ok) = not_ok Then
            p_message_type := not_ok;
            p_message_text := 'Approval failed. Approval pending for previous steps !!!';
            Return;
        End If;

        If p_is_hold = ok Then
            v_apprl_type := v_apprl_onhold;
        Else
            v_apprl_type := ok;
        End If;

        Update
            ofb_emp_exit_approvals oeea
        Set
            oeea.is_approved = v_apprl_type,
            oeea.approval_date = sysdate,
            oeea.approved_by = Trim(v_empno),
            oeea.remarks = Trim(p_remarks)
        Where
            nvl(oeea.is_approved, not_ok) != ok
            And oeea.empno                = Trim(p_empno)
            And oeea.apprl_action_id      = Trim(p_apprl_action_id);

        If Sql%found Then
            sp_insert_ofb_exit_approvals_log(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_empno        => p_empno,
                p_action_id    => p_apprl_action_id,
                p_apprl_type   => v_apprl_type,
                p_remarks      => p_remarks,

                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            If p_message_type = ok Then
                sp_update_ofb_emp_exits(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_empno        => p_empno,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );

                If p_message_type = ok Then
                    Commit;
                    p_message_type := ok;
                    p_message_text := 'Procedure executed successfully.';
                    Return;
                Else
                    Rollback;
                    p_message_type := p_message_type;
                    p_message_text := p_message_text;
                    Return;
                End If;
            Else
                Rollback;
                p_message_type := p_message_type;
                p_message_text := p_message_text;
                Return;
            End If;
        Else
            Select
                is_approved
            Into
                v_is_approved
            From
                ofb_emp_exit_approvals
            Where
                empno               = Trim(p_empno)
                And apprl_action_id = Trim(p_apprl_action_id);

            If v_is_approved = ok Then
                p_message_type := not_ok;
                p_message_text := 'Already approved. Cannot approve again !!!';
                Return;
            End If;

            Begin
                Select
                    oeea.is_approved
                Into
                    v_is_approved
                From
                    ofb_emp_exit_approvals oeea
                Where
                    oeea.empno               = Trim(p_empno)
                    And oeea.apprl_action_id = Trim(p_apprl_action_id)
                    And Exists (
                        Select
                            *
                        From
                            ofb_vu_module_user_role_actions ovmura
                        Where
                            ovmura.action_id     = oeea.apprl_action_id
                            And ovmura.empno     = Trim(v_empno)
                            And ovmura.module_id = c_module_id
                    );

            Exception
                When Others Then
                    p_message_type := not_ok;
                    p_message_text := 'Unauthorized access for approval !!! .';
                    Return;
            End;

        End If;

    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End prc_ofb_approve;

    Procedure sp_ofb_approve(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_remarks          Varchar2 Default Null,
        p_apprl_action_id  Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        prc_ofb_approve(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,

            p_empno           => p_empno,
            p_remarks         => p_remarks,
            p_apprl_action_id => p_apprl_action_id,
            p_is_hold         => not_ok,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

    End sp_ofb_approve;

    Procedure sp_ofb_hold(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_remarks          Varchar2 Default Null,
        p_apprl_action_id  Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        prc_ofb_approve(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,

            p_empno           => p_empno,
            p_remarks         => p_remarks,
            p_apprl_action_id => p_apprl_action_id,
            p_is_hold         => ok,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );
    End sp_ofb_hold;

    Function fn_is_approval_complete(
        p_ofb_empno Varchar2
    ) Return Varchar2 As
        v_count Number;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            ofb_emp_exit_approvals
        Where
            empno                        = p_ofb_empno
            And nvl(is_approved, not_ok) = not_ok;
        If v_count = 0 Then
            Return ok;
        Else
            Return not_ok;
        End If;
    Exception
        When Others Then
            Return not_ok;
    End;

    Function fn_is_approval_due(
        p_ofb_empno       Varchar2,
        p_apprl_action_id Varchar2
    ) Return Varchar2 As
        rec_exit_approvals ofb_emp_exit_approvals%rowtype;
        v_count            Number;
    Begin
        Begin
            Select
                *
            Into
                rec_exit_approvals
            From
                ofb_emp_exit_approvals
            Where
                empno                        = p_ofb_empno
                And apprl_action_id          = p_apprl_action_id
                And nvl(is_approved, not_ok) != ok;

        Exception
            When Others Then
                Return not_ok;
        End;
        
        /*
        Select
            Count(*)
        Into
            v_count
        From
            ofb_emp_exit_approvals
        Where
            empno                        = p_ofb_empno
            And nvl(is_approved, not_ok) = not_ok
            And ((tg_key_id              = rec_exit_approvals.tg_key_id
                    And apprl_action_step < rec_exit_approvals.apprl_action_step)
                Or apprl_group_step < rec_exit_approvals.apprl_group_step);
                */

        Select
            Count(*)
        Into
            v_count
        From
            (

                With
                    data As(
                        Select
                            a.tm_key_id,
                            a.apprl_action_id,
                            b.action_name,
                            nvl(a.parent_apprl_action_id, 'XXXX') parent_apprl_action_id,
                            nvl(is_approved, not_ok)              is_ofb_approved
                        From
                            ofb_emp_exit_approvals     a,
                            ofb_apprl_template_details b
                        Where
                            a.tm_key_id           = b.tm_key_id
                            And a.apprl_action_id = b.apprl_action_id
                            And a.empno           = p_ofb_empno
                        Union
                        Select
                            'NULL', 'XXXX', 'BLANK', Null, Null
                        From
                            dual
                    )
                --select a.*, lpad('-',(rev_level*2)-1) ||  a.action_name from (
                Select
                    tm_key_id,
                    apprl_action_id,
                    action_name,
                    is_ofb_approved                is_approved,
                    level,
                    lpad('|', (level * 2) - 1) || '<-' || action_name,
                    Max(level) Over () + 1 - level rev_level,
                    Connect_By_Isleaf              As leaf,
                    Rownum                         As row_num
                From
                    data
                Connect By Prior apprl_action_id = parent_apprl_action_id
                Start
                With
                    apprl_action_id = p_apprl_action_id
            )
        Where
            apprl_action_id <> p_apprl_action_id
            And is_approved In (not_ok, 'OO');

        If v_count > 0 Then
            Return not_ok;
        Else
            Return ok;
        End If;

    End;

    Function fn_ofb_emp_apprl_status_all(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_empno       Varchar2,

        p_row_number  Number Default Null,
        p_page_length Number Default Null
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        oeea.empno,
                        oeea.apprl_action_id,
                        pkg_ofb_common.fn_get_action_desc(oeea.apprl_action_id) action_desc,
                        oeea.remarks                                            remarks,
                        oeea.is_approved,
                        Case nvl(oeea.is_approved, not_ok)
                            When ok Then
                                'Approved'
                            When 'OO' Then
                                'OnHold'
                            Else
                                'Pending'
                        End                                                     approval_status,
                        oeea.approval_date,
                        to_char(oeea.approval_date, 'DD-Mon-YYYY')              approval_date_string,
                        oeea.approved_by,
                        Case
                            When oeea.approved_by Is Not Null Then
                                pkg_ofb_common.fn_get_employee_name(oeea.approved_by)
                            Else
                                pkg_ofb_common.fn_get_emp_for_apprl_action(oeea.empno, oeea.apprl_action_id)
                        End                                                     approver_name,
                        oeea.sort_order
                    From
                        ofb_emp_exit_approvals oeea,
                        ofb_vu_emplmast        ove
                    Where
                        ove.empno      = oeea.empno
                        And oeea.empno = Trim(p_empno)
                )
            Order By
                sort_order;
        Return c;
    End;

    Function fn_ofb_emp_apprl_status(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_empno       Varchar2,

        p_row_number  Number Default Null,
        p_page_length Number Default Null
    ) Return Sys_Refcursor As
        v_by_empno           Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_by_empno := get_empno_from_meta_id(p_meta_id);
        If v_by_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        *
                    From
                        (
                            With
                                data As(
                                    Select
                                        a.tm_key_id,
                                        a.apprl_action_id,
                                        b.action_name,
                                        nvl(a.parent_apprl_action_id, 'XXXX') parent_apprl_action_id,
                                        nvl(is_approved, not_ok)              is_ofb_approved,

                                        a.remarks                             remarks,

                                        Case nvl(a.is_approved, not_ok)
                                            When ok Then
                                                'Approved'
                                            When 'OO' Then
                                                'OnHold'
                                            Else
                                                'Pending'
                                        End                                   approval_status,
                                        a.approval_date,

                                        a.approved_by,
                                        Case
                                            When a.approved_by Is Not Null Then
                                                pkg_ofb_common.fn_get_employee_name(a.approved_by)
                                            Else
                                                pkg_ofb_common.fn_get_emp_for_apprl_action(a.empno, a.apprl_action_id)
                                        End                                   approver_name,
                                        a.sort_order

                                    From
                                        ofb_emp_exit_approvals     a,
                                        ofb_apprl_template_details b
                                    Where
                                        a.tm_key_id           = b.tm_key_id
                                        And a.apprl_action_id = b.apprl_action_id
                                        And a.empno           = p_empno
                                    Union
                                    Select
                                        'NULL', 'XXXX', 'BLANK', Null, Null, Null, Null, Null, Null, Null, Null
                                    From
                                        dual
                                )
                            Select
                            Distinct
                                b.tm_key_id,
                                b.apprl_action_id,
                                b.action_name,
                                pkg_ofb_common.fn_get_action_desc(b.apprl_action_id) action_desc,
                                b.is_ofb_approved                                    is_approved,
                                remarks,
                                approval_status,
                                approved_by,
                                approval_date,
                                approver_name,
                                sort_order--,
                            --level,
                            --lpad('|', (level * 2) - 1) || '<-' || action_name,
                            --Max(level) Over () + 1 - level rev_level,
                            --Connect_By_Isleaf              As leaf,
                            --Rownum                         As row_num
                            From
                                data b

                            Connect By Prior b.apprl_action_id = b.parent_apprl_action_id
                            Start
                            With
                                b.apprl_action_id In (
                                    Select
                                        action_id
                                    From
                                        ofb_vu_module_user_role_actions
                                    Where
                                        empno = v_by_empno
                                )
                        )
                    Order By sort_order
                )
            Order By
                sort_order;
        Return c;
    End;

    Procedure sp_action_approval_details(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_empno                Varchar2,
        p_apprl_action_id      Varchar2,
        p_approval_remarks Out Varchar2,
        p_is_approval_due  Out Varchar2,

        p_message_type     Out Varchar2,
        p_message_text     Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_is_approved  ofb_emp_exit_approvals.is_approved%Type;
        v_approval_due Varchar2(2);
        v_apprl_type   Varchar2(2);
    Begin
        v_empno           := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        p_is_approval_due := fn_is_approval_due(
                                 p_ofb_empno       => p_empno,
                                 p_apprl_action_id => p_apprl_action_id
                             );
        p_is_approval_due := nvl(p_is_approval_due, not_ok);
        Select
            remarks
        Into
            p_approval_remarks
        From
            ofb_emp_exit_approvals
        Where
            empno               = p_empno
            And apprl_action_id = p_apprl_action_id;

        p_message_type    := ok;
        p_message_text    := p_message_type;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;
End pkg_ofb_approval;