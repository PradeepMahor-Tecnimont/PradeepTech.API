--------------------------------------------------------
--  DDL for Package Body DIST_HEADSET
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "ITINV_STK"."DIST_HEADSET" As

    Procedure remove_assignment (
        p_empno       Varchar2,
        p_mfg_sr_no   Varchar2,
        p_success     Out           Varchar2,
        p_message     Out           Varchar2
    ) As
        v_count Number;
    Begin
        Delete From dist_headset_issued
        Where
            assigned_to_empno = p_empno
            And mfg_sr_no = p_mfg_sr_no;

        If Sql%rowcount = 0 Then
            p_success   := 'KO';
            p_message   := 'Err - No record found for the selected criteria.';
            return;
        End If;

        Commit;
        p_success   := 'OK';
        p_message   := 'Record delete successfully.';
    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := Sqlcode || ' - ' || Sqlerrm;
    End remove_assignment;

    Procedure add_assignment (
        p_empno       Varchar2,
        p_mfg_sr_no   Varchar2,
        p_success     Out           Varchar2,
        p_message     Out           Varchar2
    ) As
    Begin
        Insert Into dist_headset_issued (
            assigned_to_empno,
            mfg_sr_no
        ) Values (
            p_empno,
            p_mfg_sr_no
        );

        If Sql%rowcount > 0 Then
            Commit;
            p_success   := 'OK';
            p_message   := 'Record added successfully.';
        Else
            p_success   := 'KO';
            p_message   := 'Err - Record could not be added.';
        End If;

        return;
    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := Sqlcode || ' - ' || Sqlerrm;
    End add_assignment;

End dist_headset;

/
