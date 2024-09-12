--------------------------------------------------------
--  DDL for Procedure TO_BE_DELETED_OD2RW
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."TO_BE_DELETED_OD2RW" (
    p_success   Out         Varchar2,
    p_message   Out         Varchar2
) As

    Cursor c1 Is
    Select
        *
    From
        ss_od2rw_list where update_msg like 'KO%'
    Order By
        empno,
        pdate;

    v_success   Varchar2(10);
    v_message   Varchar2(1000);
    v_counter   Number;
Begin
    v_counter   := 0;
    For c2 In c1 Loop
        v_counter := v_counter + 1;
        od.add_onduty_type_2(
            p_empno           => c2.empno,
            p_od_type         => 'RW',
            p_b_yyyymmdd      => To_Char(c2.pdate, 'yyyymmdd'),
            p_e_yyyymmdd      => To_Char(c2.pdate, 'yyyymmdd'),
            p_entry_by        => '02079',
            p_lead_approver   => 'None',
            p_user_ip         => 'OD2RW-TRANSFER',
            p_reason          => c2.reason,
            p_success         => v_success,
            p_message         => v_message
        );

        Update ss_od2rw_list
        Set
            update_msg = v_success || ' - ' || v_message
        Where
            Trim(app_no) = Trim(c2.app_no);

        Commit;
    End Loop;

    p_success   := 'OK';
Exception
    When Others Then
        p_message := 'Err - Counter - ' || v_counter || ' - ' || Sqlcode || ' - ' || Sqlerrm;
End to_be_deleted_od2rw;


/
