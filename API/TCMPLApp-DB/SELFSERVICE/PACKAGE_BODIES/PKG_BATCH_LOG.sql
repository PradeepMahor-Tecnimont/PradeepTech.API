--------------------------------------------------------
--  DDL for Package Body PKG_BATCH_LOG
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."PKG_BATCH_LOG" As
--GET ID for last batch process--

    Function get_id_4_last_batch_process (
        param_log_type Varchar2
    ) Return Varchar2 Is
        v_batch_ref_id   Varchar2(20);
        v_batch_key_id   Varchar2(5);
    Begin
        Select
            batch_key_id
        Into v_batch_key_id
        From
            ss_batch_log_mast
        Where
            batch_type_code = param_log_type
            And batch_created_on = (
                Select
                    Max(batch_created_on)
                From
                    ss_batch_log_mast
                Where
                    batch_type_code = param_log_type
            );

        Return v_batch_key_id;
    Exception
        When Others Then
            Return 'EXEPTION';
    End;
/*******************/
--------------------



--Log Type Monthly Leave Credit--

    Function log_type_mthly_leave_cr Return Varchar2 As
    Begin
        Return c_monthly_credit_leave;
    End log_type_mthly_leave_cr;
/*******************/
--------------------



--START LOG--

    Procedure do_start_log (
        param_batch_id     Varchar2,
        param_batch_type   Varchar2,
        param_success      Out                Varchar2,
        param_message      Out                Varchar2
    ) As
    Begin
        --Clear Old LOG
        Delete From ss_batch_log_details
        Where
            batch_key_id In (
                Select
                    batch_key_id
                From
                    ss_batch_log_mast
                Where
                    Trunc(batch_created_on) < Trunc(Sysdate - 1)
            );

        Delete From ss_batch_log_mast
        Where
            Trunc(batch_created_on) < Trunc(Sysdate - 1);
        --Clear OLD LOG
        --XXX--

        Insert Into ss_batch_log_mast (
            batch_key_id,
            batch_type_code,
            batch_status_code,
            batch_created_on
        ) Values (
            param_batch_id,
            param_batch_type,
            'ST',
            Sysdate
        );

        Commit;
        param_success := 'OK';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;
/*******************/
--------------------


--End Log with Success--

    Procedure do_end_log_with_success (
        param_batch_id   Varchar2,
        param_log_msg    Varchar2,
        param_success    Out              Varchar2,
        param_message    Out              Varchar2
    ) As
    Begin
        Insert Into ss_batch_log_details (
            batch_key_id,
            item_ref,
            log_desc
        ) Values (
            param_batch_id,
            'FINISHED',
            param_log_msg
        );

        Update ss_batch_log_mast
        Set
            batch_status_code = 'OK'
        Where
            batch_key_id = param_batch_id;

        Commit;
        param_success := 'OK';
    Exception
        When Others Then
            param_success := 'KO';
    End;
/*******************/
--------------------


--End Log with Success--

    Procedure do_end_log_with_error (
        param_batch_id   Varchar2,
        param_log_msg    Varchar2,
        param_success    Out              Varchar2,
        param_message    Out              Varchar2
    ) As
    Begin
        Insert Into ss_batch_log_details (
            batch_key_id,
            item_ref,
            log_desc
        ) Values (
            param_batch_id,
            'FAILURE',
            param_log_msg
        );

        Update ss_batch_log_mast
        Set
            batch_status_code = 'KO'
        Where
            batch_key_id = param_batch_id;

        param_success := 'OK';
    Exception
        When Others Then
            param_success := 'KO';
    End;
/*******************/
--------------------


--WRITE LOG--

    Procedure do_write_log (
        param_batch_id   Varchar2,
        param_log_msg    Varchar2,
        param_success    Out              Varchar2,
        param_message    Out              Varchar2
    ) As
    Begin
        Insert Into ss_batch_log_details (
            batch_key_id,
            log_desc
        ) Values (
            param_batch_id,
            param_log_msg
        );

        param_success := 'OK';
    Exception
        When Others Then
            param_success := 'KO';
    End;
/*******************/
--------------------


--DELETE a particular LOG

    Procedure delete_log (
        param_log_id    Varchar2,
        param_success   Out             Varchar2,
        param_message   Out             Varchar2
    ) As
    Begin
        Delete From ss_batch_log_details
        Where
            batch_key_id = param_log_id;

        Delete From ss_batch_log_mast
        Where
            batch_key_id = param_log_id;

        Commit;
        param_success := 'OK';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;
/*******************/
--------------------

End pkg_batch_log;


/
