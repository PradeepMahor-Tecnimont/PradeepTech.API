--------------------------------------------------------
--  DDL for Package Body PKG_OFB_RESET_APPROVAL
--------------------------------------------------------

Create Or Replace Package Body "TCMPL_HR"."PKG_OFB_RESET_APPROVAL" As

    Procedure prc_validate_rollback_ofb(
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
            p_message_text := 'Reset of approval failed. Rollback initiated !!!';
            Return;
        End If;
        p_message_type := ok;
        p_message_text := p_message_type;
    End;

    Procedure prc_insert_ofb_exit_approvals_reset_log(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_apprl_action_id  Varchar2,

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

        Insert Into ofb_exit_approval_reset_log
        (
            empno,
            action_id,
            reset_by,
            reset_date
        )
        Values
        (
            p_empno,
            p_apprl_action_id,
            v_empno,
            sysdate
        );

        p_message_type := ok;
        p_message_text := p_message_type;
    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure prc_update_ofb_emp_exits(
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
            is_approval_complete = not_ok            
        Where            
            empno            = Trim(p_empno);

        p_message_type := ok;
        p_message_text := p_message_type;
    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_ofb_reset_approve(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_apprl_action_id  Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno                 Varchar2(5);
        v_is_approved           ofb_emp_exit_approvals.is_approved%Type;
        v_count                 Number;
        v_is_rollback_initiated Char(2);
        v_approval_reset_valid  Varchar2(2);
    Begin
        v_empno                := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        prc_validate_rollback_ofb(
            p_empno        => p_empno,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;

        v_approval_reset_valid := fnc_is_approval_reset_valid(
                                      p_ofb_empno       => p_empno,
                                      p_apprl_action_id => p_apprl_action_id
                                  );

        If v_approval_reset_valid = not_ok Then
            p_message_type := not_ok;
            p_message_text := 'Reset of approval failed. Approval is already reset !!! ';
            Return;
        End If;

        Update
            ofb_emp_exit_approvals oeea
        Set
            oeea.is_approved = not_ok,
            oeea.approval_date = sysdate,
            oeea.approved_by = Trim(v_empno)
        Where
            nvl(oeea.is_approved, not_ok) = ok
            And oeea.empno                = Trim(p_empno)
            And oeea.apprl_action_id      = Trim(p_apprl_action_id);

        If Sql%found Then
            prc_insert_ofb_exit_approvals_reset_log(
                p_person_id       => p_person_id,
                p_meta_id         => p_meta_id,

                p_empno           => p_empno,
                p_apprl_action_id => p_apprl_action_id,

                p_message_type    => p_message_type,
                p_message_text    => p_message_text
            );
            If p_message_type = ok Then
                prc_update_ofb_emp_exits(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_empno        => p_empno,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );

                If p_message_type = ok Then
                    Commit;
                    p_message_type := ok;
                    p_message_text := 'Approval reset successfully.';
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
            Begin
                Select
                    oeea.is_approved
                Into
                    v_is_approved
                From
                    ofb_emp_exit_approvals oeea
                Where
                    oeea.empno               = Trim(p_empno)
                    And oeea.apprl_action_id = Trim(p_apprl_action_id);

                If v_is_approved = not_ok Then
                    Rollback;
                    p_message_type := not_ok;
                    p_message_text := 'Approval has been already reset !!!';
                    Return;
                End If;
            Exception
                When Others Then
                    Rollback;
                    p_message_type := not_ok;
                    p_message_text := 'Unauthorized access for reseting approval !!! .';
                    Return;
            End;
        End If;
    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_ofb_reset_approve;

    Function fnc_is_approval_reset_valid(
        p_ofb_empno       Varchar2,
        p_apprl_action_id Varchar2
    ) Return Varchar2 As
        rec_exit_approvals ofb_emp_exit_approvals%rowtype;
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
            And nvl(is_approved, not_ok) = ok;

        Return ok;
    Exception
        When Others Then
            Return not_ok;
    End;

End pkg_ofb_reset_approval;