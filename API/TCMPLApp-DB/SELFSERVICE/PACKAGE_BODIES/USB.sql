--------------------------------------------------------
--  DDL for Package Body USB
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."USB" As
    Procedure add_request (
        param_empno       Varchar2,
        param_reason      Varchar2,
        param_end_date    Varchar2,
        param_comp_name   Varchar2,
        param_success     Out Varchar2,
        param_message     Out Varchar2
    ) As
        v_count      Number;
        v_end_date   Date;
    Begin
        Select Count (*) Into
            v_count
        From ss_usb_request Where empno = Trim (param_empno) And nvl (apprl, ss.pending) = ss.pending;
        If v_count > 0 Then
            param_success := 'FAILURE';
            param_message := 'Error - Requests still pending for approval. Cannot create request.';
            return;
        End If;
        Begin
            v_end_date := To_Date (param_end_date, 'dd/mm/yyyy');
        Exception
            When others Then
                param_success := 'FAILURE';
                param_message := 'Error - incorrect "End Date" specified.' || param_end_date;
                return;
        End;
        Insert Into ss_usb_request field (
            key_id,
            empno,
            reason,
            entry_date,
            access_end_date,
            comp_name,
            req_access_edate
        ) Values (
            dbms_random.string ('X', 8),
            param_empno,
            param_reason,
            Sysdate,
            v_end_date,
            param_comp_name,
            v_end_date
        );
        Commit;
        param_success := 'SUCCESS';
    Exception
        When others Then
            param_success := 'FAILURE';
            param_message := 'Error - ' ||sqlcode ||' - ' ||sqlerrm;
    End add_request;
    Procedure del_request (
        param_empno     Varchar2,
        param_key       Varchar2,
        param_success   Out Varchar2,
        param_message   Out Varchar2
    )
        As
    Begin
        Delete From ss_usb_request Where empno = param_empno And key_id = param_key And nvl (apprl, ss.pending) = ss.pending;
        If sql%rowcount > 0 Then
            Commit;
            param_success := 'SUCCESS';
        Else
            param_success := 'FAILURE';
            param_message := 'Error - Could not delete specified record.';
        End If;
    Exception
        When others Then
            param_success := 'FAILURE';
            param_message := 'Error - ' ||sqlcode ||' - ' ||sqlerrm;
    End del_request;
    Procedure approve_request (
        param_key        Varchar2,
        param_approver   Varchar2,
        param_end_date   Varchar2,
        param_remarks    Varchar2,
        param_success    Out Varchar2,
        param_message    Out Varchar2
    ) As
        v_end_date   Date;
    Begin
    -- TODO: Implementation required for procedure USB.approve_request

        Begin
            v_end_date := To_Date (param_end_date, 'dd/mm/yyyy');
        Exception
            When others Then
                param_success := 'FAILURE';
                param_message := 'Error - incorrect "End Date" specified.' || param_end_date;
                return;
        End;
        Update ss_usb_request
            Set
                apprl = ss.approved,
                apprl_by = param_approver,
                apprl_dt = Sysdate,
                access_end_date = v_end_date,
                apprl_remarks = param_remarks
        Where
            key_id = param_key;
        Commit;
        param_success := 'SUCCESS';
    Exception
        When others Then
            param_success := 'FAILURE';
            param_message := 'Error - ' ||sqlcode ||' - ' ||sqlerrm;
    End approve_request;
    Function employee_approver (
        param_empno   Varchar2
    ) Return Varchar2 As
        v_approver   Varchar2 (5);
    Begin
        Begin
            Select approver Into
                v_approver
            From
                ( Select
                        empno,
                        mngr_col approver,
                        level approver_level
                    From
                        ( Select
                                empno,
                                name,
                                parent,
                                empno empno_1,
                                    Case When empno = mngr
                                    Then
                                        Null
                                    Else
                                        mngr
                                    End
                                mngr_col
                            From ss_emplmast Where status = 1 )
                    Start With empno = param_empno Connect By Prior mngr_col = empno )
            Where approver_level = 2 And approver <> ( c_exclude_mngr );
        Exception
            When others Then
                Null;
        End;
        If v_approver Is Null Then
            Begin
                Select mngr Into
                    v_approver
                From ss_emplmast Where empno = param_empno And mngr Not In (
                        c_exclude_mngr
                    );
            Exception
                When others Then
                    Null;
            End;
        End If;
        Return v_approver;
    End;
    Procedure reject_request (
        param_key        Varchar2,
        param_approver   Varchar2,
        param_remarks    Varchar2,
        param_success    Out Varchar2,
        param_message    Out Varchar2
    )
        As
    Begin
        Update ss_usb_request
            Set
                apprl = ss.rejected,
                apprl_by = param_approver,
                apprl_dt = Sysdate,
                apprl_remarks = param_remarks
        Where
            key_id = param_key;
        Commit;
        param_success := 'SUCCESS';
    Exception
        When others Then
            param_success := 'FAILURE';
            param_message := 'Error - ' ||sqlcode ||' - ' ||sqlerrm;
    End;
    Procedure it_approve (
        param_key        Varchar2,
        param_approver   Varchar2,
        param_success    Out Varchar2,
        param_message    Out Varchar2
    )
        As
    Begin
        Update ss_usb_request
            Set
                it_apprl = ss.approved,
                it_apprl_by = param_approver,
                it_apprl_date = Sysdate
        Where
            key_id = Trim (param_key);
        Commit;
        param_success := 'SUCCESS';
        --param_message := 'Error - ' || param_key || ' - ' || param_approver;

    Exception
        When others Then
            param_success := 'FAILURE';
            param_message := 'Error - ' ||sqlcode ||' - ' ||sqlerrm;
    End;
    Procedure it_reject (
        param_key        Varchar2,
        param_approver   Varchar2,
        param_success    Out Varchar2,
        param_message    Out Varchar2
    )
        As
    Begin
        Update ss_usb_request
            Set
                it_apprl = ss.rejected,
                it_apprl_by = param_approver,
                it_apprl_date = Sysdate
        Where
            key_id = param_key;
        Commit;
        param_success := 'SUCCESS';
    Exception
        When others Then
            param_success := 'FAILURE';
            param_message := 'Error - ' ||sqlcode ||' - ' ||sqlerrm;
    End;
    Procedure it_terminate_by_date (
        param_key        Varchar2,
        param_approver   Varchar2,
        param_success    Out Varchar2,
        param_message    Out Varchar2
    )
        As
    Begin
        Update ss_usb_request
            Set
                it_apprl = usb.termination_by_date,
                it_apprl_by = param_approver,
                it_apprl_date = Sysdate
        Where
            key_id = param_key;
        Commit;
        param_success := 'SUCCESS';
    Exception
        When others Then
            param_success := 'FAILURE';
            param_message := 'Error - ' ||sqlcode ||' - ' ||sqlerrm;
    End;
    Procedure it_terminate_by_force (
        param_key        Varchar2,
        param_approver   Varchar2,
        param_success    Out Varchar2,
        param_message    Out Varchar2
    )
        As
    Begin
        Update ss_usb_request
            Set
                it_apprl = usb.termination_by_force,
                it_apprl_by = param_approver,
                it_apprl_date = Sysdate
        Where
            key_id = param_key;
        Commit;
        param_success := 'SUCCESS';
    Exception
        When others Then
            param_success := 'FAILURE';
            param_message := 'Error - ' ||sqlcode ||' - ' ||sqlerrm;
    End;
    Procedure it_mis_match_rectify (
        param_key        Varchar2,
        param_approver   Varchar2,
        param_success    Out Varchar2,
        param_message    Out Varchar2
    ) As
        v_count   Number;
        v_empno   Varchar2 (5);
    Begin
        Select empno Into
            v_empno
        From ss_usb_request Where key_id = param_key;
        Select Count (*) Into
            v_count
        From ss_usb_request Where key_id = Trim (param_key) And Trim (comp_name) <> usb.get_comp_name (v_empno);
        If v_count > 0 Then
            Update ss_usb_request
                Set
                    comp_name = trim (usb.get_comp_name (v_empno) ),
                    it_apprl_by = param_approver,
                    it_apprl_date = Sysdate
            Where
                key_id = param_key;
            Commit;
        End If;
        Select Count (*) Into
            v_count
        From ss_usb_request Where key_id = param_key And trunc (nvl (access_end_date, Sysdate + 1) ) <= trunc (Sysdate);
        If v_count > 0 Then
            Update ss_usb_request
                Set
                    it_apprl = usb.termination_by_date,
                    it_apprl_by = param_approver,
                    it_apprl_date = Sysdate
            Where
                key_id = param_key;
            Commit;
        End If;
        param_success := 'SUCCESS';
    Exception
        When others Then
            param_success := 'FAILURE';
            param_message := 'Error - ' ||sqlcode ||' - ' ||sqlerrm;
    End;
    Procedure it_mach_replaced (
        param_key        Varchar2,
        param_approver   Varchar2,
        param_success    Out Varchar2,
        param_message    Out Varchar2
    )
        As
    Begin
  /*
    update ss_usb_request set 
        it_apprl = USB.TERMINATION_BY_FORCE, it_apprl_by = param_approver, it_apprl_date = sysdate
      where key_id = param_key;
    commit;
    */
        param_success := 'SUCCESS';
    Exception
        When others Then
            param_success := 'FAILURE';
            param_message := 'Error - ' ||sqlcode ||' - ' ||sqlerrm;
    End;
    Function approved Return Number
        Is
    Begin
        Return n_approved;
    End;
    Function rejected Return Number
        Is
    Begin
        Return n_rejected;
    End;
    Function pending Return Number
        Is
    Begin
        Return n_pending;
    End;
    Function termination_by_force Return Number
        Is
    Begin
        Return n_termination_by_force;
    End;
    Function termination_by_date Return Number
        Is
    Begin
        Return n_termination_by_date;
    End;
    Function approval_text (
        param_status   Number
    ) Return Varchar2 Is
        v_status    Number;
        v_ret_val   Varchar2 (30);
    Begin
        v_status := nvl (param_status, ss.pending);
        Case When v_status = usb.pending
        Then
            v_ret_val := 'Pending';
        When v_status = usb.approved
        Then
            v_ret_val := 'Approved';
        When v_status = usb.rejected
        Then
            v_ret_val := 'Rejected';
        When v_status = usb.termination_by_force
        Then
            v_ret_val := 'Forceful Termination';
        When v_status = usb.termination_by_date
        Then
            v_ret_val := 'Termination by Request';
        Else
            v_status := '';
        End Case;
        Return v_ret_val;
    End;
    Function get_comp_name (
        param_empno   Varchar2
    ) Return Varchar2 Is
        v_comp_name   Varchar2 (60);
    Begin
        If param_empno = 'ALLSS' Then
            Return 'PC9584';
        End If;
        Select a.compname Into
            v_comp_name
        From
            dm_vu_user_desk_pc a
        Where a.empno = Trim (param_empno) ;
        Return v_comp_name;
    Exception
        When others Then
            Return 'ERRRRR';
    End;
End usb;


/
