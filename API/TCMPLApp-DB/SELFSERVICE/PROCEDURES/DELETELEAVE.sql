--------------------------------------------------------
--  DDL for Procedure DELETELEAVE
--------------------------------------------------------
Set Define Off;

Create Or Replace Procedure "SELFSERVICE"."DELETELEAVE"(
    appnum      In Varchar2,
    p_force_del In Varchar2 Default 'KO'
) Is
    v_count Number := 0;
Begin  
    --check in ss_leaveapp table
    Select
        Count(app_no)
    Into
        v_count
    From
        ss_leaveapp
    Where
        app_no = Trim(appnum);
    If v_count > 0 Then
        Delete
            From ss_leaveapp
        Where
            app_no = Trim(appnum);
    End If;

    If p_force_del = 'OK' Then
        Select
            Count(app_no)
        Into
            v_count
        From
            ss_leaveapp_rejected
        Where
            trim(app_no) = Trim(appnum);
            
        If v_count > 0 Then
            Delete
                From ss_leaveapp_rejected
            Where
                app_no = Trim(appnum);
        End If;
    End If;
    --check in ss_leaveledg table
    Select
        Count(app_no)
    Into
        v_count
    From
        ss_leaveledg
    Where
        app_no = Trim(appnum);
    If v_count > 0 Then
        Delete
            From ss_leaveledg
        Where
            app_no = Trim(appnum);
    End If;	

    --check in ss_leave_adj table
    Select
        Count(adj_no)
    Into
        v_count
    From
        ss_leave_adj
    Where
        adj_no = Trim(appnum);
    If v_count > 0 Then
        Delete
            From ss_leave_adj
        Where
            adj_no = Trim(appnum);
    End If;

    Select
        Count(new_app_no)
    Into
        v_count
    From
        ss_pl_revision_mast
    Where
        Trim(new_app_no) = Trim(appnum);
    If v_count > 0 Then
        Delete
            From ss_pl_revision_mast
        Where
            Trim(new_app_no) = Trim(appnum);
    End If;

End;
/