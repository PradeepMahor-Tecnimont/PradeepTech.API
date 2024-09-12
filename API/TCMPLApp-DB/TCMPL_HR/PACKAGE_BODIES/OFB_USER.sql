--------------------------------------------------------
--  DDL for Package Body OFB_USER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TCMPL_HR"."OFB_USER" As

    Function has_role_action(
        p_empno   Varchar2,
        p_role_id Varchar2
    ) Return Varchar2 As
        v_count Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ofb_role_actions
        Where
            action_id In (
                Select
                    action_id
                From
                    ofb_user_actions
                Where
                    empno = p_empno
            )
            And role_id = p_role_id;

        If v_count > 0 Then
            Return 'OK';
        Else
            Return 'KO';
        End If;
    Exception
        When Others Then
            Return 'KO';
    End;

    Function get_empno_from_win_uid(
        p_win_uid Varchar2
    ) Return Varchar2 As
        v_user_domain Varchar2(60);
        v_user_id     Varchar2(60);
        v_empno       Varchar2(5);
    Begin
        v_user_domain := substr(p_win_uid, 1, instr(p_win_uid, '\') - 1);

        v_user_id     := substr(p_win_uid, instr(p_win_uid, '\') + 1);
        Select
            a.empno
        Into
            v_empno
        From
            ofb_vu_userids  a,
            ofb_vu_emplmast b
        Where
            a.empno             = b.empno
            And upper(a.userid) = upper(v_user_id)
            And upper(a.domain) = upper(v_user_domain)
            And b.status        = 1;

        If v_empno = '02320' Then
            v_empno := '02640';
            Null;
        End If;
        Return v_empno;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_roles_csv_from_win_uid(
        p_win_uid Varchar2
    ) Return Varchar2 As
        v_empno     Char(5);
        v_count     Number;
        v_roles_csv Varchar2(200);
    Begin
        v_empno     := get_empno_from_win_uid(p_win_uid);
        If v_empno Is Null Then
            Return 'NONE';
        End If;
        Select
            Listagg(role_id, ',') Within
                Group (Order By
                    role_id) roles_csv
        Into
            v_roles_csv
        From
            ofb_vu_user_roles_actions
        Where
            empno = v_empno;
        /*
        --R02	HOD
        Select
            Count(*)
        Into v_count
        From
            ofb_vu_costmast
        Where
            hod = v_empno;

        If v_count > 0 Then
            v_roles_csv := v_roles_csv || ',R02';
        End If;
        --R02	HOD************************

        --R11	TCMPL_USER
        Select
            Count(*)
        Into v_count
        From
            ofb_emp_exit_approvals
        Where
            empno = v_empno;

        If v_count > 0 Then
            v_roles_csv := v_roles_csv || ',R11';
        End If;
        --R11	TCMPL_USER ****************

        --R03	MAKER
        If has_role_action(
            v_empno,
            'R03'
        ) = 'OK' Then
            v_roles_csv := v_roles_csv || ',R03';
        End If;

        --R03	MAKER**********************

        --R04	CHECKER

        If has_role_action(
            v_empno,
            'R04'
        ) = 'OK' Then
            v_roles_csv := v_roles_csv || ',R04';
        End If;
        --R04	CHCKER**********************


        --R05	OFFBOARDING_INITIATOR

        If has_role_action(
            v_empno,
            'R05'
        ) = 'OK' Then
            v_roles_csv := v_roles_csv || ',R05';
        End If;
        --R05	OFFBOARDING_INITIATOR**************


        --R06	OFFBOARDING_APPROVER

        If has_role_action(
            v_empno,
            'R06'
        ) = 'OK' Then
            v_roles_csv := v_roles_csv || ',R06';
        End If;
        --R06	OFFBOARDING_APPROVER****************
        */

        v_roles_csv := trim(Both ',' From v_roles_csv);
        Return nvl(trim(v_roles_csv), 'NONE');
    Exception
        When Others Then
            Return 'NONE';
    End get_roles_csv_from_win_uid;

    Function get_name_from_empno(
        p_empno Varchar2
    ) Return Varchar2 As
        v_name Varchar2(100);
    Begin
        Select
            name
        Into
            v_name
        From
            ofb_vu_emplmast
        Where
            empno = p_empno;

        Return v_name;
    Exception
        When Others Then
            Return Null;
    End;

    Procedure add_user_access(
        p_empno          Varchar2,
        p_role_action_id Varchar2,
        p_success Out    Varchar2,
        p_message Out    Varchar2
    ) As
        v_duplicate_record Varchar2(2) := 'KO';
        v_count            Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ofb_role_actions
        Where
            action_id = p_role_action_id;

        If v_count = 1 Then
            Select
                Count(*)
            Into
                v_count
            From
                ofb_user_actions
            Where
                empno         = p_empno
                And action_id = p_role_action_id;

            If v_count = 1 Then
                p_success := 'KO';
                p_message := 'Err - Record already exists.';
                Return;
            Else
                Insert Into ofb_user_actions (
                    empno,
                    action_id
                )
                Values (
                    p_empno,
                    p_role_action_id
                );

                p_success := 'OK';
                Return;
            End If;

        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ofb_roles
        Where
            role_id = p_role_action_id;

        If v_count = 1 Then
            Select
                Count(*)
            Into
                v_count
            From
                ofb_user_roles
            Where
                empno       = p_empno
                And role_id = p_role_action_id;

            If v_count = 1 Then
                p_success := 'KO';
                p_message := 'Err - Record already exists.';
                Return;
            Else
                Insert Into ofb_user_roles (
                    empno,
                    role_id
                )
                Values (
                    p_empno,
                    p_role_action_id
                );

                p_success := 'OK';
                Return;
            End If;

        End If;

        p_success := 'KO';
        p_message := 'Err - Error while processing your request.';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure remove_user_role_action(
        p_empno          Varchar2,
        p_role_id        Varchar2,
        p_action_id      Varchar2,
        p_entry_by_empno Varchar2,
        p_success Out    Varchar2,
        p_message Out    Varchar2
    ) As
        v_count Number;
    Begin
        If p_entry_by_empno = p_empno And p_role_id = '' Then
            p_success := 'KO';
            p_message := 'Err - Cannot remove self User Management Access rights.';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ofb_user_actions
        Where
            empno         = p_empno
            And action_id = p_action_id;

        If v_count > 0 Then
            Delete
                From ofb_user_actions
            Where
                empno         = p_empno
                And action_id = p_action_id;

            Commit;
            p_success := 'OK';
            p_message := 'User access removed successfully.';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ofb_user_roles
        Where
            empno = p_empno;

        If v_count > 0 Then
            Delete
                From ofb_user_roles
            Where
                empno       = p_empno
                And role_id = p_role_id;

            Commit;
            p_message := 'User access removed successfully.';
            p_success := 'OK';
            Return;
        End If;

        p_success := 'KO';
        p_message := 'Error while processing your request.';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Function get_hod_email_id(p_empno Varchar2) Return Varchar2 As
        v_parent Varchar2(4);
        v_email  Varchar2(100);
    Begin

        Select
            parent
        Into
            v_parent
        From
            ofb_vu_emplmast
        Where
            empno = p_empno;

        Select
            email
        Into
            v_email
        From
            ofb_vu_emplmast
        Where
            empno In (
                Select
                    hod
                From
                    ofb_vu_costmast
                Where
                    costcode = v_parent
            );
        Return v_email;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_emp_name_csv_for_action_id(p_action_id Varchar2) Return Varchar2 As
        v_approver_names_csv Varchar2(300);
    Begin

        Select
            Listagg(approver_name, ' / ') Within
                Group (Order By
                    approver_name) approvers
        Into
            v_approver_names_csv
        From
            (
                Select
                    approver_name
                From
                    (
                        Select
                            ofb_user.get_name_from_empno(empno) As approver_name
                        From
                            ofb_vu_user_roles_actions
                        Where
                            action_id = Case
                                When p_action_id = ofb.actionid_hod_of_emp Then
                                    Null
                                Else
                                    p_action_id
                            End
                    )
            );
        Return v_approver_names_csv;
    Exception
        When Others Then
            Return '';
    End;

End ofb_user;

/

  GRANT EXECUTE ON "TCMPL_HR"."OFB_USER" TO "TCMPL_APP_CONFIG";
