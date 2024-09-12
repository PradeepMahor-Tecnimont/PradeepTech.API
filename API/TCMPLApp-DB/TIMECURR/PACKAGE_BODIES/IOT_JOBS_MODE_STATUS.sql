Create Or Replace Package Body timecurr.iot_jobs_mode_status As

    Function fn_under_revision Return Varchar2 As
    Begin
        Return 'M1';
    End;

    Function fn_approvals_pending_all Return Varchar2 As
    Begin
        Return 'M2';
    End;

    Function fn_approvals_pending_partial Return Varchar2 As
    Begin
        Return 'M3';
    End;

    Function fn_approved_and_open Return Varchar2 As
    Begin
        Return 'O1';
    End;

    Function fn_ts_booking_blocked Return Varchar2 As
    Begin
        Return 'O2';
    End;

    Function fn_closure_approvals_pending_all Return Varchar2 As
    Begin
        Return 'C2';
    End;
    
    Function fn_closure_approvals_pending_partial Return Varchar2 As
    Begin
        Return 'C3';
    End;
    
    Function fn_closed Return Varchar2 As
    Begin
        Return 'CC';
    End;

End;