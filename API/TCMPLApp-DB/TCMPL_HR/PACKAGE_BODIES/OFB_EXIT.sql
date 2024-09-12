--------------------------------------------------------
--  DDL for Package Body OFB_EXIT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TCMPL_HR"."OFB_EXIT" As

    Procedure add_exit(
        p_empno            Varchar2,
        p_end_by_date      Date,
        p_relieve_date     Date,
        p_resign_date      Date,
        p_remarks          Varchar2,
        p_address          Varchar2,
        p_primary_mobile   Varchar2,
        p_alternate_mobile Varchar2,
        p_email_id         Varchar2,
        p_entry_by_empno   Varchar2,
        p_success Out      Varchar2,
        p_message Out      Varchar2
    ) As
        v_emp_parent      Char(4);
        v_approval_status Varchar2(20);
    Begin
        Select
            parent
        Into
            v_emp_parent
        From
            ofb_vu_emplmast
        Where
            empno = p_empno;

        Insert Into ofb_emp_exits (
            empno,
            parent,
            end_by_date,
            relieving_date,
            resignation_date,
            remarks,
            address,
            mobile_primary,
            alternate_number,
            email_id,
            created_by,
            created_on
        )
        Values (
            p_empno,
            v_emp_parent,
            p_end_by_date,
            p_relieve_date,
            p_resign_date,
            p_remarks,
            p_address,
            p_primary_mobile,
            p_alternate_mobile,
            p_email_id,
            p_entry_by_empno,
            sysdate
        );

        Insert Into ofb_emp_exit_approvals (
            empno,
            action_id,
            role_id
        )
        Select
            p_empno,
            action_id,
            role_id
        From
            ofb_role_actions;

        Commit;
        ofb_send_mail.send_mail_nu_ofb(p_empno);
        p_success := 'OK';
    Exception
        When Others Then
            Rollback;
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End add_exit;

    Procedure mod_exit(
        p_empno            Varchar2,
        p_end_by_date      Date,
        p_relieve_date     Date,
        p_resign_date      Date,
        p_remarks          Varchar2,
        p_address          Varchar2,
        p_primary_mobile   Varchar2,
        p_alternate_mobile Varchar2,
        p_email_id         Varchar2,
        p_entry_by_empno   Varchar2,
        p_success Out      Varchar2,
        p_message Out      Varchar2
    ) As
        v_emp_parent           Char(4);
        v_hr_mngr_apprl_status Varchar2(2);
    Begin
        v_hr_mngr_apprl_status := ofb_approval_status.check_hr_manager_approval(p_empno);
        If v_hr_mngr_apprl_status = 'OK' Then
            p_success := 'KO';
            p_message := 'Err - HR Manager exit approval done. Cannot not modify record.';
            Return;
        End If;

        Update
            ofb_emp_exits
        Set
            end_by_date = p_end_by_date,
            relieving_date = p_relieve_date,
            resignation_date = p_resign_date,
            remarks = p_remarks,
            address = p_address,
            mobile_primary = p_primary_mobile,
            alternate_number = p_alternate_mobile,
            email_id = p_email_id,
            modified_by = p_entry_by_empno,
            modified_on = sysdate
        Where
            empno = p_empno;

        Commit;
        p_success              := 'OK';
    Exception
        When Others Then
            Rollback;
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End mod_exit;

    Procedure approve_level_first(
        p_empno             Varchar2,
        p_remarks           Varchar2,
        p_approved_by_empno Varchar2,
        p_is_approval_hold  Varchar2,
        p_success Out       Varchar2,
        p_message Out       Varchar2
    ) As
        v_action_id     ofb_role_actions.action_id%Type;
        v_count         Number;
        v_approval_type Varchar2(2);
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ofb_vu_user_roles_actions
        Where
            empno       = p_approved_by_empno
            And role_id = ofb.roleid_first_approver;

        If v_count <> 1 Then
            p_success := 'KO';
            p_message := 'Err - Incorrect approver id.';
            Return;
        End If;

        Select
            action_id
        Into
            v_action_id
        From
            ofb_vu_user_roles_actions
        Where
            empno       = p_approved_by_empno
            And role_id = ofb.roleid_first_approver;

        Select
            Count(*)
        Into
            v_count
        From
            ofb_emp_exit_approvals
        Where
            empno         = p_empno
            And action_id = v_action_id
            And (is_approved Is Null
                Or is_approved != 'OK');

        If v_count = 0 Then
            p_success := 'KO';
            p_message := 'Err - User OffBoarding already approved.';
            Return;
        End If;

        If p_is_approval_hold = 'OK' Then
            v_approval_type := 'OO';
        Else
            v_approval_type := 'OK';
        End If;

        Update
            ofb_emp_exit_approvals
        Set
            is_approved = v_approval_type,
            remarks = p_remarks,
            approved_by = p_approved_by_empno,
            approval_date = sysdate
        Where
            empno         = p_empno
            And action_id = v_action_id;

        Commit;
        p_success := 'OK';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure approve_level_second(
        p_empno             Varchar2,
        p_remarks           Varchar2,
        p_approved_by_empno Varchar2,
        p_is_approval_hold  Varchar2,
        p_success Out       Varchar2,
        p_message Out       Varchar2
    ) As

        v_action_id             ofb_role_actions.action_id%Type;
        v_count                 Number;
        v_first_approval_status Varchar2(20);
        v_approval_type         Varchar2(2);
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ofb_vu_user_roles_actions
        Where
            empno       = p_approved_by_empno
            And role_id = ofb.roleid_second_approver;

        If v_count <> 1 Then
            p_success := 'KO';
            p_message := 'Err - Incorrect approved id.';
            Return;
        End If;

        Select
            action_id
        Into
            v_action_id
        From
            ofb_vu_user_roles_actions
        Where
            empno       = p_approved_by_empno
            And role_id = ofb.roleid_second_approver;

        v_first_approval_status := ofb_approval_status.check_child_approvals(p_ofb_empno => p_empno, p_second_approver_empno =>
        p_approved_by_empno,
                                                                             p_action_id => v_action_id);

        If v_first_approval_status <> 'Approved' Then
            p_success := 'KO';
            p_message := 'Err - First approvals not yet approved. Cannot proceed.';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ofb_emp_exit_approvals
        Where
            empno         = p_empno
            And action_id = v_action_id
            And (is_approved Is Null
                Or is_approved != 'OK');

        If v_count = 0 Then
            p_success := 'KO';
            p_message := 'Err - User OffBoarding already approved.';
            Return;
        End If;

        If p_is_approval_hold = 'OK' Then
            v_approval_type := 'OO';
        Else
            v_approval_type := 'OK';
        End If;

        Update
            ofb_emp_exit_approvals
        Set
            is_approved = v_approval_type,
            remarks = p_remarks,
            approved_by = p_approved_by_empno,
            approval_date = sysdate
        Where
            empno         = p_empno
            And action_id = v_action_id;

        Commit;
        p_success               := 'OK';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure approve_hod(
        p_empno             Varchar2,
        p_remarks           Varchar2,
        p_approved_by_empno Varchar2,
        p_is_approval_hold  Varchar2,
        p_success Out       Varchar2,
        p_message Out       Varchar2
    ) As
        v_action_id     ofb_role_actions.action_id%Type;
        v_count         Number;
        v_approval_type Varchar2(2);
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ofb_vu_user_roles_actions
        Where
            empno       = p_approved_by_empno
            And role_id = ofb.roleid_hod;

        If v_count = 0 Then
            p_success := 'KO';
            p_message := 'Err - Incorrect approved id.';
            Return;
        End If;

        Select
        Distinct
            action_id
        Into
            v_action_id
        From
            ofb_vu_user_roles_actions
        Where
            empno       = p_approved_by_empno
            And role_id = ofb.roleid_hod;

        Select
            Count(*)
        Into
            v_count
        From
            ofb_emp_exit_approvals
        Where
            empno         = p_empno
            And action_id = v_action_id
            And (is_approved Is Null
                Or is_approved != 'OK');

        If v_count = 0 Then
            p_success := 'KO';
            p_message := 'Err - User OffBoarding already approved.';
            Return;
        End If;

        If p_is_approval_hold = 'OK' Then
            v_approval_type := 'OO';
        Else
            v_approval_type := 'OK';
        End If;

        Update
            ofb_emp_exit_approvals
        Set
            is_approved = v_approval_type,
            remarks = p_remarks,
            approved_by = p_approved_by_empno,
            approval_date = sysdate
        Where
            empno         = p_empno
            And action_id = v_action_id;

        Commit;
        p_success := 'OK';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure approve_hr_manager(
        p_empno             Varchar2,
        p_remarks           Varchar2,
        p_approved_by_empno Varchar2,
        p_is_approval_hold  Varchar2,
        p_success Out       Varchar2,
        p_message Out       Varchar2
    ) As
        v_action_id     ofb_role_actions.action_id%Type;
        v_count         Number;
        v_approval_type Varchar2(2);
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ofb_vu_user_roles_actions
        Where
            empno       = p_approved_by_empno
            And role_id = ofb.roleid_hr_manager;

        If v_count = 0 Then
            p_success := 'KO';
            p_message := 'Err - Incorrect approved id.';
            Return;
        End If;

        Select
        Distinct
            action_id
        Into
            v_action_id
        From
            ofb_vu_user_roles_actions
        Where
            empno       = p_approved_by_empno
            And role_id = ofb.roleid_hr_manager;

        --Check HR Manager Approval already done.

        Select
            Count(*)
        Into
            v_count
        From
            ofb_emp_exit_approvals
        Where
            empno         = p_empno
            And action_id = v_action_id
            And (is_approved Is Null
                Or is_approved != 'OK');

        If v_count = 0 Then
            p_success := 'KO';
            p_message := 'Err - User OffBoarding already approved.';
            Return;
        End If;

        --Check All approvals have been done.

        Select
            Count(*)
        Into
            v_count
        From
            ofb_emp_exit_approvals
        Where
            empno = p_empno
            And (is_approved Is Null
                Or is_approved != 'OK');

        If v_count = 0 Then
            p_success := 'KO';
            p_message := 'Err - Descendant approval pending. Cannot proceed.';
            Return;
        End If;

        If p_is_approval_hold = 'OK' Then
            v_approval_type := 'OO';
        Else
            v_approval_type := 'OK';
        End If;

        Update
            ofb_emp_exit_approvals
        Set
            is_approved = v_approval_type,
            remarks = p_remarks,
            approved_by = p_approved_by_empno,
            approval_date = sysdate
        Where
            empno         = p_empno
            And action_id = v_action_id;

        Commit;
        p_success := 'OK';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure update_user_contact_info(
        p_empno            Varchar2,
        p_address          Varchar2,
        p_mobile_primary   Varchar2,
        p_alternate_number Varchar2,
        p_success Out      Varchar2,
        p_message Out      Varchar2
    ) As
        v_count Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ofb_emp_exits
        Where
            empno = p_empno;

        If v_count = 0 Then
            p_success := 'KO';
            p_message := 'Err - Offboarding process not initiated for the employee.';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ofb_emp_contact_info
        Where
            empno = p_empno;

        If v_count > 0 Then
            Delete
                From ofb_emp_contact_info
            Where
                empno = p_empno;

        End If;
        Insert Into ofb_emp_contact_info (
            empno,
            address,
            mobile_primary,
            alternate_number,
            modified_on
        )
        Values (
            p_empno,
            p_address,
            p_mobile_primary,
            p_alternate_number,
            sysdate
        );

        Commit;
        p_success := 'OK';
    Exception
        When Others Then
            Rollback;
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure reset_approval(
        p_ofb_empno      Varchar2,
        p_action_id      Varchar2,
        p_reset_by_empno Varchar2,
        p_success Out    Varchar2,
        p_message Out    Varchar2
    ) As
    Begin
        Update
            ofb_emp_exit_approvals
        Set
            is_approved = Null,
            remarks = Null,
            approval_date = Null,
            approved_by = Null
        Where
            empno         = p_ofb_empno
            And action_id = p_action_id;

        Insert Into ofb_exit_approval_reset_log (
            empno,
            action_id,
            reset_by,
            reset_date
        )
        Values (
            p_ofb_empno,
            p_action_id,
            p_reset_by_empno,
            sysdate
        );

        Commit;
        p_success := 'OK';
    Exception
        When Others Then
            Rollback;
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure rollback_exit(
        p_empno       Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
    Begin

        Delete
            From ofb_exit_approvals_log
        Where
            empno = p_empno;

        Delete
            From ofb_emp_exit_approvals
        Where
            empno = p_empno;

        Delete
            From ofb_files
        Where
            empno = p_empno;

        Delete
            From ofb_emp_exits
        Where
            empno = p_empno;

        Commit;

        p_success := 'OK';
        p_message := 'Rollback successful.';

    Exception
        When Others Then
            Rollback;
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

End ofb_exit;

/

  GRANT EXECUTE ON "TCMPL_HR"."OFB_EXIT" TO "TCMPL_APP_CONFIG";
