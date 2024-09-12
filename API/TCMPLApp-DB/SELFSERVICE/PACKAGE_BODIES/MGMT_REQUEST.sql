--------------------------------------------------------
--  DDL for Package Body MGMT_REQUEST
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."MGMT_REQUEST" As

    Procedure add_request (
        param_win_uid  Varchar2,
        param_empno    Varchar2,
        param_sw       Varchar2,
        param_success  Out  Varchar2,
        param_message  Out  Varchar2
    ) As
        v_req_by Char(5);
    Begin
        v_req_by       := mgmt_users.get_empno_from_win_uid(param_win_uid);
        If v_req_by Is Null Then
            param_success  := 'KO';
            param_message  := 'Err - Invalid WIN_UID';
            return;
        End If;

        Insert Into mgmt_laptop_request (
            empno,
            sw_required,
            windows_ver,
            req_date,
            req_by,
            it_action_code
        ) Values (
            param_empno,
            substr(
                param_sw,
                1,
                100
            ),
            '10',
            sysdate,
            v_req_by,
            'PP'
        );

        Commit;
        param_success  := 'OK';
        param_message  := 'Request successfully created';
    Exception
        When Others Then
            param_success  := 'KO';
            param_message  := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End add_request;

    Procedure it_action (
        param_win_uid           Varchar2,
        param_empno             Varchar2,
        param_it_rem            Varchar2,
        param_it_action_code    Varchar2,
        param_laptop_qrcode     Varchar2,
        param_headphone_qrcode  Varchar2,
        param_docking_qrcode    Varchar2,
        param_issue_date        Varchar2,
        param_success           Out  Varchar2,
        param_message           Out  Varchar2
    ) As
        v_approval_by  Char(5);
        v_issue_date   Date;
        v_count        Number;
    Begin
        Select
            Count(*)
        Into v_count
        From
            mgmt_req_status_mast
        Where
            status_code = param_it_action_code;

        If v_count = 0 Then
            param_success  := 'KO';
            param_message  := 'Err - Incorrect status assigned.';
            return;
        End If;

        v_approval_by  := mgmt_users.get_empno_from_win_uid(param_win_uid);
        If v_approval_by Is Null Then
            param_success  := 'KO';
            param_message  := 'Err - Invalid WIN_UID';
            return;
        End If;
--Issued

        If param_it_action_code = 'II' Then
            If param_issue_date Is Null Then
                param_success  := 'KO';
                param_message  := 'Issue date is required.';
                return;
            End If;

            Begin
                v_issue_date := to_date(
                    param_issue_date,
        'dd-Mon-yyyy'
                );
            Exception
                When Others Then
                    param_success  := 'KO';
                    param_message  := 'Incorrect date specified.';
                    return;
            End;

        End If;

        Update mgmt_laptop_request
        Set
            it_action_code = param_it_action_code,
            it_action_by = v_approval_by,
            it_action_date = sysdate,
            it_remarks = param_it_rem,
            laptop_ams_id = param_laptop_qrcode,
            headphone_qrcode = param_headphone_qrcode,
            docking_qrcode = param_docking_qrcode,
            issue_date = v_issue_date
        Where
            empno = param_empno;

        Commit;
        param_success  := 'OK';
        param_message  := 'Request successfully created';
    Exception
        When Others Then
            param_success  := 'KO';
            param_message  := 'Err - ' || sqlcode || ' - ' || sqlerrm;
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
            ss_emplmast
        Where
                parent = param_parent
            And status  = 1
            And grade   = 'A3'
            And assign Not In (
                '0232',
                '0236',
                '0238',
                '0245',
                '0289',
                '0290',
                '0291',
                '0292'
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
            mgmt_laptop_request
        Where
            empno In (
                Select
                    empno
                From
                    ss_emplmast
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
            mgmt_req_status_mast
        Where
            status_code = param_action_code;

        Return v_ret_val;
    Exception
        When Others Then
            Return '-';
            Return v_ret_val;
    End;

End mgmt_request;


/
