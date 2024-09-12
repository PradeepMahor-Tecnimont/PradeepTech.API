--------------------------------------------------------
--  DDL for Procedure DEL_OD_APP
--------------------------------------------------------
Set Define Off;

Create Or Replace Procedure "SELFSERVICE"."DEL_OD_APP"(
    p_app_no    In Varchar2,
    p_tab_from  In Varchar2,
    p_force_del In Varchar2 Default 'KO'
) As
    v_empno Char(5);
    v_pdate Date;
Begin
    If trim(p_tab_from) = 'DP' Then
        Delete
            From ss_depu
        Where
            app_no = p_app_no;
            
        If p_force_del = 'OK' Then
            Delete
                From ss_depu_rejected
            Where
                Trim(app_no) = Trim(p_app_no);
        End If;
        
    Elsif trim(p_tab_from) = 'OD' Then
        Select
        Distinct empno, pdate
        Into
            v_empno, v_pdate
        From
            (
                Select
                Distinct empno, pdate
                From
                    ss_ondutyapp
                Where
                    Trim(app_no) = Trim(p_app_no)
            )
        Where
            Rownum = 1;
        Delete
            From ss_ondutyapp
        Where
            Trim(app_no) = Trim(p_app_no);

        If p_force_del = 'OK' Then
            Delete
                From ss_ondutyapp_rejected
            Where
                Trim(app_no) = Trim(p_app_no);

        End If;

        Delete
            From ss_onduty
        Where
            Trim(app_no) = Trim(p_app_no);
        generate_auto_punch(v_empno, v_pdate);
    End If;
End del_od_app;
/