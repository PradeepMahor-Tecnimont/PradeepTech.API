--------------------------------------------------------
--  DDL for Package Body OFB_APPROVAL_STATUS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TCMPL_HR"."OFB_APPROVAL_STATUS" As

    --Check status of all First Level Approvers

    Function check_all_first_level(
        p_ofb_empno Varchar2
    ) Return Varchar2 As
        v_count Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ofb_emp_exits
        Where
            empno = p_ofb_empno;

        If v_count = 0 Then
            Return 'Error';
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ofb_emp_exit_approvals
        Where
            empno       = p_ofb_empno
            And role_id = c_first_approver_role_id
            And (is_approved Is Null
                Or is_approved != 'OK');

        If v_count = 0 Then
            Return 'Approved';
        Else
            Return 'Pending';
        End If;
    Exception
        When Others Then
            Return 'ER';
    End check_all_first_level;

    --Check status of all Second Level Approvers

    Function check_all_second_level(
        p_ofb_empno Varchar2
    ) Return Varchar2 As
        v_count Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ofb_emp_exits
        Where
            empno = p_ofb_empno;

        If v_count = 0 Then
            Return 'Error';
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ofb_emp_exit_approvals
        Where
            empno       = p_ofb_empno
            And role_id = c_second_approver_role_id
            And (is_approved Is Null
                Or is_approved != 'OK');

        If v_count = 0 Then
            Return 'Approved';
        Else
            Return 'Pending';
        End If;
    Exception
        When Others Then
            Return 'Error';
    End check_all_second_level;

    --Check OFB-Fully approved

    Function overall_approval_status(
        p_ofb_empno Varchar2
    ) Return Varchar2 As
        v_count Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ofb_emp_exits
        Where
            empno = p_ofb_empno;

        If v_count = 0 Then
            Return 'Error';
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ofb_emp_exit_approvals
        Where
            empno = p_ofb_empno
            And (is_approved Is Null
                Or is_approved != 'OK');

        If v_count = 0 Then
            Return 'Approved';
        Else
            Return 'Pending';
        End If;
    Exception
        When Others Then
            Return 'Error';
    End overall_approval_status;

    --Check status of descendant approvals of Second Approver

    Function check_child_approvals(
        p_ofb_empno             Varchar2,
        p_second_approver_empno Varchar2,
        p_action_id             Varchar2
    ) Return Varchar2 As
        v_count Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ofb_emp_exits
        Where
            empno = p_ofb_empno;

        If v_count = 0 Then
            Return 'Error';
        End If;
        --check the action id is of Second Approver
        Select
            Count(*)
        Into
            v_count
        From
            ofb_role_actions
        Where
            action_id   = p_action_id
            And role_id = c_second_approver_role_id;

        If v_count = 0 Then
            Return 'Error';
        End If;

        --Check descendants have approved
        Select
            Count(*)
        Into
            v_count
        From
            ofb_emp_exit_approvals
        Where
            empno = p_ofb_empno
            And (is_approved Is Null
                Or is_approved != 'OK')
            And action_id In (
                Select
                    action_id
                From
                    ofb_role_actions
                Where
                    checker_action_id = p_action_id
            );

        If v_count = 0 Then
            Return 'Approved';
        Else
            Return 'Pending';
        End If;
    Exception
        When Others Then
            Return 'Error';
    End;

    Function hr_manager_can_approve(
        p_empno Varchar2
    ) Return Varchar2 As
        v_other_dept_pend_apprl_count Number;
        v_hr_manager_pend_apprl_count Number;
    Begin
        --Check other departments approved.
        Select
            Count(*)
        Into
            v_other_dept_pend_apprl_count
        From
            ofb_emp_exit_approvals
        Where
            empno = p_empno
            And (is_approved Is Null
                Or is_approved != 'OK')
            And role_id <> ofb.roleid_hr_manager;

        If v_other_dept_pend_apprl_count > 0 Then
            Return 'KO';
        End If;

        --Check HR Manager approved
        Select
            Count(*)
        Into
            v_hr_manager_pend_apprl_count
        From
            ofb_emp_exit_approvals
        Where
            empno       = p_empno
            And (is_approved Is Null
                Or is_approved != 'OK')
            And role_id = ofb.roleid_hr_manager;

        If v_hr_manager_pend_apprl_count <> 1 Then
            Return 'KO';
        End If;
        Return 'OK';
    Exception
        When Others Then
            Return 'ER';
    End;

    Function check_hr_manager_approval(
        p_empno Varchar2
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
            empno           = p_empno
            And action_id   = ofb.actionid_hr_mngr
            And is_approved = 'OK';

        If v_count > 0 Then
            Return 'OK';
        Else
            Return 'KO';
        End If;
    Exception
        When Others Then
            Return 'ER';
    End;

    Function get_approval_desc(
        p_empno          Varchar2,
        p_approver_empno Varchar2,
        p_role_id        Varchar2
    ) Return Varchar2 As
        v_approval_code Varchar2(2);
    Begin

        Select
            is_approved
        Into
            v_approval_code
        From
            ofb_emp_exit_approvals a,
            ofb_user_actions       ua
        Where
            a.role_id       = ua.role_id
            And a.action_id = ua.action_id
            And ua.role_id  = p_role_id
            And ua.empno    = p_approver_empno
            And a.empno     = p_empno;
        /*
            Select
                is_approved
            Into v_approval_code
            From
                ofb_emp_exit_approvals
            Where
                    empno = p_empno
                And trim(approved_by) = trim(p_approver_empno)
                And trim(role_id)     = trim(p_role_id);
*/
        If nvl(v_approval_code, 'KO') = 'KO' Then
            Return 'Pending';
        Elsif nvl(v_approval_code, 'KO') = 'OK' Then
            Return 'Approved';
        Elsif nvl(v_approval_code, 'KO') = 'OO' Then
            Return 'On Hold';
        Else
            Return Null;
        End If;

    Exception
        When Others Then
            --Return 'Err';
            Return sqlcode || ' - ' || sqlerrm;
    End;

End ofb_approval_status;

/

  GRANT EXECUTE ON "TCMPL_HR"."OFB_APPROVAL_STATUS" TO "TCMPL_APP_CONFIG";
