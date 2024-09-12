--------------------------------------------------------
--  DDL for Package Body LEAVE_MONTHLY_CREDIT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."LEAVE_MONTHLY_CREDIT" As

    Procedure rollback_monthly_credit_old (
        p_from_date   Date,
        p_success     Out           Varchar2,
        p_message     Out           Varchar2
    ) As
        v_rec_monthly_cr_mast ss_monthly_credit_mast%rowtype;
    Begin
        Select
            *
        Into v_rec_monthly_cr_mast
        From
            ss_monthly_credit_mast
        Where
            from_date = Trunc(p_from_date);

        Delete From ss_monthly_credit_exception
        Where
            key_id = v_rec_monthly_cr_mast.key_id;

        Delete From ss_monthly_credit_mast
        Where
            key_id = v_rec_monthly_cr_mast.key_id;

        Delete From ss_leave_adj
        Where
            leavetype = c_cr_leave_type
            And adj_type  = c_cr_adjustment_type
            And bdate     = Trunc(p_from_date);

        Delete From ss_leaveledg
        Where
            leavetype = c_cr_leave_type
            And adj_type  = c_cr_adjustment_type
            And bdate     = Trunc(p_from_date);

        Delete From ss_batch_log_details
        Where
            batch_key_id = v_rec_monthly_cr_mast.key_id;

        Delete From ss_batch_log_mast
        Where
            batch_key_id = v_rec_monthly_cr_mast.key_id;

        Commit;
    Exception
        When no_data_found Then
            p_success := 'OK';
            Rollback;
        When Others Then
            Rollback;
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;

    Procedure schedule_batch (
        p_key_id    Varchar2,
        p_success   Out         Varchar2,
        p_message   Out         Varchar2
    ) As
        v_job_name   Varchar2(30) := 'MONTHLY_LEAVE_CREDIT_';
        v_count      Number;
    Begin
        If p_key_id Is Null Then
            p_success   := 'KO';
            p_message   := 'Err - KeyId  not found while shceduling the job.';
            return;
        End If;

        Select
            Count(*)
        Into v_count
        From
            user_scheduler_running_jobs
        Where
            job_name Like v_job_name || '%';

        If v_count <> 0 Then
            p_success   := 'KO';
            p_message   := 'Err - Previously scheduled job is already running. Cannot proceed.';
            return;
        End If;

        v_job_name   := v_job_name || p_key_id;
        dbms_scheduler.create_job(
            job_name              => v_job_name,
            job_type              => 'STORED_PROCEDURE',
            job_action            => 'leave_monthly_credit.do_batch_process',
            number_of_arguments   => 1,
            enabled               => false,
            job_class             => 'TCMPL_JOB_CLASS',
            comments              => 'To credit monthly leave to Employee Account.'
        );

        dbms_scheduler.set_job_argument_value(
            job_name            => v_job_name,
            argument_position   => 1,
            argument_value      => p_key_id
        );

        dbms_scheduler.enable(v_job_name);
        p_success    := 'OK';
    End schedule_batch;
    --*******XXXXXXXXX**********


    --*******PUT DATA in PROD TAB**********

    Procedure put_xl_data_in_prod_table (
        p_key_id Varchar2,
        p_success Out Varchar
    ) As

        v_now                    Date;
        v_success                Varchar2(10);
        v_message                Varchar2(1000);
        v_sheet_1                Number(1) := 1;
        Cursor cur_unique_rows Is
        Select Distinct
            row_nr
        From
            ss_xl_blob_data
        Where
            key_id = p_key_id
            And sheet_nr = v_sheet_1
            And row_nr Not In (
                Select
                    row_nr
                From
                    ss_xl_blob_data
                Where
                    key_id = p_key_id
                    And sheet_nr = v_sheet_1
                    And err_code Is Not Null
            );

        Cursor cur_row_data (
            pc_row_nr Number
        ) Is
        Select
            *
        From
            ss_xl_blob_data
        Where
            key_id = p_key_id
            And sheet_nr  = v_sheet_1
            And row_nr    = pc_row_nr;

        Type typ_tab_row Is
            Table Of cur_unique_rows%rowtype;
        tab_rows                 typ_tab_row;
        Type typ_tab_xl_data Is
            Table Of ss_xl_blob_data%rowtype;
        tab_xl_data              typ_tab_xl_data;
        v_count                  Number;
        v_row_monthly_cr_excep   ss_monthly_credit_exception%rowtype;
        v_row_monthly_cr_mast    ss_monthly_credit_mast%rowtype;
    Begin
        v_now       := Sysdate;
        Begin
            Select
                *
            Into v_row_monthly_cr_mast
            From
                ss_monthly_credit_mast
            Where
                key_id = p_key_id;

        Exception
            When Others Then
                pkg_batch_log.do_write_log(
                    param_batch_id   => p_key_id,
                    param_log_msg    => 'Err - Master Data not found',
                    param_success    => v_success,
                    param_message    => v_message
                );
        End;

        Open cur_unique_rows;
        Loop
            Fetch cur_unique_rows Bulk Collect Into tab_rows Limit 50;
            For i In 1..tab_rows.count Loop
                Open cur_row_data(tab_rows(i).row_nr);
                Fetch cur_row_data Bulk Collect Into tab_xl_data Limit 100;
                Close cur_row_data;
                For cntr In 1..tab_xl_data.count Loop
                    If tab_rows(i).row_nr = 164 Then
                        v_count := 0;
                    End If;
                    v_row_monthly_cr_excep.key_id        := p_key_id;
                    v_row_monthly_cr_excep.from_date     := v_row_monthly_cr_mast.from_date;
                    v_row_monthly_cr_excep.modified_on   := v_now;
                    v_row_monthly_cr_excep.xl_row_nr     := tab_rows(i).row_nr;
                    If tab_xl_data(cntr).col_nr = c_col_no_empno Then
                        v_row_monthly_cr_excep.empno := Nvl(Trim(tab_xl_data(cntr).string_val), tab_xl_data(cntr).number_val);
                    End If;

                    If tab_xl_data(cntr).col_nr = c_col_no_leaveperiod Then
                        v_row_monthly_cr_excep.leave_period := Nvl(tab_xl_data(cntr).string_val, tab_xl_data(cntr).number_val);
                    End If;

                End Loop;

                Insert Into ss_monthly_credit_exception Values v_row_monthly_cr_excep;

                v_row_monthly_cr_excep := Null;
            End Loop;

            Exit When cur_unique_rows%notfound;
        End Loop;

        Close cur_unique_rows;
        Commit;
        p_success   := 'OK';
    Exception
        When Others Then
            pkg_batch_log.do_end_log_with_error(
                param_batch_id   => p_key_id,
                param_log_msg    => 'Err - TRNSFR2PROD1 - ' || Sqlcode || ' - ' || Sqlerrm,
                param_success    => v_success,
                param_message    => v_message
            );

            p_success := 'KO';
    End;
    --*******XXXXXXXXX**********


    --*******DELETE UNWANTED**********

    Procedure delete_unwanted_data (
        p_key_id    Varchar2,
        p_success   Out         Varchar,
        p_message   Out         Varchar2
    ) As
        v_count Number;
    Begin
        Select
            Count(*)
        Into v_count
        From
            ss_xl_blob_data
        Where
            key_id = p_key_id;

        If v_count = 0 Then
            pkg_batch_log.do_end_log_with_error(
                param_batch_id   => p_key_id,
                param_log_msg    => 'Err - Data not found for normalization',
                param_success    => p_success,
                param_message    => p_message
            );

            return;
        End If;

        --Consider only Sheet 1 data

        Delete From ss_xl_blob_data
        Where
            key_id = p_key_id
            And sheet_nr <> 1;

        --Keep only Empno and Leave Period

        Delete From ss_xl_blob_data
        Where
            key_id = p_key_id
            And col_nr Not In (
                c_col_no_empno,
                c_col_no_leaveperiod
            );

        --Delete where Empno is null

        Delete From ss_xl_blob_data
        Where
            key_id = p_key_id
            And col_nr = c_col_no_empno
            And Nvl(Trim(string_val), number_val) Is Null;

        --Delete Header Row

        Delete From ss_xl_blob_data
        Where
            key_id = p_key_id
            And row_nr < 4;

        Commit;
        p_success := 'OK';
    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - NORMALIZE - ' || Sqlcode || ' - ' || Sqlerrm;
    End;
    --*******XXXXXXXXX**********


    --*******VALIDATE**********

    Procedure validate_data (
        p_key_id Varchar2,
        p_success Out Varchar2
    ) As

        v_col_empno         Number := 1;
        v_col_leaveperiod   Number := 5;
        v_success           Varchar2(10);
        v_message           Varchar2(1000);
        v_count             Number;
    Begin
        Update ss_xl_blob_data
        Set
            string_val = Lpad(Nvl(Trim(string_val), number_val), 5, '0')
        Where
            key_id = p_key_id
            And col_nr = v_col_empno;

        Update ss_xl_blob_data
        Set
            string_val = Nvl(string_val, number_val)
        Where
            key_id = p_key_id
            And col_nr = v_col_leaveperiod;

        Commit;

        --In correct EMPNO
        Update ss_xl_blob_data
        Set
            err_code = 'E0001'
        Where
            key_id = p_key_id
            And col_nr = v_col_empno
            And string_val Not In (
                Select
                    empno
                From
                    ss_emplmast
                Where
                    status = 1
                    And emptype In (
                        'R',
                        'F'
                    )
            );

        --Incorrect LeavePeriod

        Update ss_xl_blob_data
        Set
            err_code = 'E0002'
        Where
            key_id = p_key_id
            And col_nr = v_col_leaveperiod
            And string_val Is Not Null
            And Not Regexp_Like ( string_val,
                                  '^(\d*\.)?\d*$' )
            And row_nr In (
                Select
                    row_nr
                From
                    ss_xl_blob_data
                Where
                    key_id = p_key_id
                    And err_code Is Null
            );

        Insert Into ss_batch_log_details (
            batch_key_id,
            item_ref,
            log_desc
        )
            Select
                p_key_id,
                'SHT-' || sheet_nr || '-' || Lpad(row_nr, 4, '0'),
                err_desc
            From
                ss_xl_blob_data       a,
                ss_batch_error_mast   b
            Where
                a.err_code Is Not Null
                And a.err_code = b.err_code;

        Commit;
        Select
            Count(*)
        Into v_count
        From
            ss_xl_blob_data
        Where
            key_id = p_key_id
            And row_nr Not In (
                Select
                    row_nr
                From
                    ss_xl_blob_data
                Where
                    key_id = p_key_id
                    And err_code Is Not Null
            );

        If v_count = 0 Then
            pkg_batch_log.do_end_log_with_error(
                param_batch_id   => p_key_id,
                param_log_msg    => 'Err - No valid data to process',
                param_success    => v_success,
                param_message    => v_message
            );
            /*
            Delete From ss_xl_blob_data
            Where
                key_id = p_key_id;
            */

            Commit;
            p_success := 'KO';
        Else
            p_success := 'OK';
        End If;

    Exception
        When Others Then
            Rollback;
            pkg_batch_log.do_end_log_with_error(
                param_batch_id   => p_key_id,
                param_log_msg    => 'Err - TRNSFR2PROD1 - ' || Sqlcode || ' - ' || Sqlerrm,
                param_success    => v_success,
                param_message    => v_message
            );

            p_success := 'KO';
    End;
    --*******XXXXXXXXX**********


    --*******ADD LEAVE**********

    Procedure add_leave (
        p_key_id         Varchar2,
        p_cr_mast_rec    ss_monthly_credit_mast%rowtype,
        p_empno          Varchar2,
        p_leave_period   Number
    ) As
        v_success   Varchar2(10);
        v_message   Varchar2(1000);
        --v_now        Date;
        --v_adj_desc   Varchar2(30);
    Begin
        --v_now        := Sysdate;
        --v_adj_desc   := p_cr_mast_rec.narration;
        leave.add_leave_adj(
            param_empno        => p_empno,
            param_adj_date     => p_cr_mast_rec.from_date,
            param_adj_type     => c_cr_adjustment_type,
            param_leave_type   => c_cr_leave_type,
            param_adj_period   => p_leave_period,
            param_entry_by     => 'Sys',
            param_desc         => p_cr_mast_rec.narration,
            param_success      => v_success,
            param_message      => v_message,
            param_narration    => p_cr_mast_rec.narration
        );

        If v_success = 'KO' Then
            pkg_batch_log.do_write_log(
                param_batch_id   => p_key_id,
                param_log_msg    => p_empno || ' - ' || v_message,
                param_success    => v_success,
                param_message    => v_message
            );

        End If;

    End;
    --*******XXXXXXXXX**********



    --*******DO PROCESS**********

    Procedure do_credit_leave (
        p_key_id Varchar2,
        p_success Out Varchar2
    ) As

        v_success     Varchar2(10);
        v_message     Varchar2(1000);
        Cursor cur_exception Is
        Select
            *
        From
            ss_monthly_credit_exception
        Where
            key_id = p_key_id;

        Cursor cur_emplist Is
        Select
            empno
        From
            ss_emplmast
        Where
            status = 1
            And emptype In (
                'R',
                'F'
            )
            And empno Not In (
                Select
                    empno
                From
                    ss_monthly_credit_exception
                Where
                    key_id = p_key_id
            );

        Type typ_tab_excep Is
            Table Of cur_exception%rowtype;
        Type typ_tab_emplist Is
            Table Of cur_emplist%rowtype;
        tab_excep     typ_tab_excep;
        tab_emplist   typ_tab_emplist;
        v_now         Date;
        v_adj_desc    Varchar2(100);
        v_rec         ss_monthly_credit_mast%rowtype;
    Begin
        p_success    := 'OK';
        v_now        := Sysdate;
        Select
            *
        Into v_rec
        From
            ss_monthly_credit_mast
        Where
            key_id = p_key_id;

        v_adj_desc   := 'Monthly Leave credit for ' || To_Char(v_rec.from_date, 'Mon-yyyy');
        Open cur_exception;
        Loop
            Fetch cur_exception Bulk Collect Into tab_excep Limit 50;
            For i In 1..tab_excep.count Loop
                If Nvl(tab_excep(i).leave_period, 0) = 0 Then
                    Continue;
                End If;

                add_leave(
                    p_key_id         => p_key_id,
                    p_cr_mast_rec    => v_rec,
                    p_empno          => tab_excep(i).empno,
                    p_leave_period   => tab_excep(i).leave_period
                );

            End Loop;

            Exit When cur_exception%notfound;
        End Loop;

        Open cur_emplist;
        Loop
            Fetch cur_emplist Bulk Collect Into tab_emplist Limit 50;
            For i In 1..tab_emplist.count Loop add_leave(
                p_key_id         => p_key_id,
                p_cr_mast_rec    => v_rec,
                p_empno          => tab_emplist(i).empno,
                p_leave_period   => 1.5
            );
            End Loop;

            Exit When cur_emplist%notfound;
        End Loop;

        p_success    := 'OK';
    Exception
        When Others Then
            pkg_batch_log.do_end_log_with_error(
                param_batch_id   => p_key_id,
                param_log_msg    => 'Err - LEAVECREDIT - ' || Sqlcode || ' - ' || Sqlerrm,
                param_success    => v_success,
                param_message    => v_message
            );

            p_success := 'KO';
    End;
    --*******XXXXXXXXX**********



    --*******DO PROCESS**********

    Procedure do_batch_process (
        p_key_id Varchar2
    ) As
        v_success   Varchar2(10);
        v_message   Varchar2(1000);
        v_count     Number;
    Begin
        pkg_batch_log.do_start_log(
            param_batch_id     => p_key_id,
            param_batch_type   => pkg_batch_log.log_type_mthly_leave_cr,
            param_success      => v_success,
            param_message      => v_message
        );

        delete_unwanted_data(
            p_key_id    => p_key_id,
            p_success   => v_success,
            p_message   => v_message
        );
        If v_success = 'KO' Then
            return;
        End If;
        validate_data(
            p_key_id    => p_key_id,
            p_success   => v_success
        );
        If v_success = 'KO' Then
            return;
        End If;
        put_xl_data_in_prod_table(
            p_key_id    => p_key_id,
            p_success   => v_success
        );
        If v_success = 'KO' Then
            return;
        End If;
        do_credit_leave(
            p_key_id    => p_key_id,
            p_success   => v_success
        );
        If v_success = 'OK' Then
            pkg_batch_log.do_end_log_with_success(
                param_batch_id   => p_key_id,
                param_log_msg    => 'Process finished. Please check log.',
                param_success    => v_success,
                param_message    => v_message
            );
        Else
            pkg_batch_log.do_end_log_with_error(
                param_batch_id   => p_key_id,
                param_log_msg    => 'Process terminated with errors. Pls check log.',
                param_success    => v_success,
                param_message    => v_message
            );
        End If;

    End;
    --*******XXXXXXXXX**********

    --*******INIT**********

    Procedure init_process (
        p_xl_file     Blob,
        p_from_date   Date,
        p_narration   Varchar2,
        p_success     Out           Varchar2,
        p_message     Out           Varchar2
    ) As
        v_now                 Date;
        v_key_id              Varchar2(8);
        v_count               Number;
        v_from_date           Date;
        v_rec_mthly_cr_mast   ss_monthly_credit_mast%rowtype;
    Begin
        If p_xl_file Is Null Then
            p_success   := 'KO';
            p_message   := 'Excel file not found.';
            return;
        End If;

        v_now         := Sysdate;
        v_from_date   := Trunc(p_from_date);
        v_key_id      := dbms_random.string(
            'X',
            8
        );
        Begin
            Select
                *
            Into v_rec_mthly_cr_mast
            From
                ss_monthly_credit_mast
            Where
                from_date = v_from_date;

            If v_count <> 0 Then
                rollback_monthly_credit(
                    p_key_id    => v_rec_mthly_cr_mast.key_id,
                    p_success   => p_success,
                    p_message   => p_message
                );

                If p_success <> 'OK' Then
                    return;
                End If;
            End If;

        Exception
            When Others Then
                Null;
        End;

        Insert Into ss_monthly_credit_mast (
            key_id,
            from_date,
            narration,
            modified_on
        ) Values (
            v_key_id,
            v_from_date,
            p_narration,
            v_now
        );

        Commit;
        xl_blob.upload_file(
            p_blob      => p_xl_file,
            p_blob_id   => v_key_id,
            p_success   => p_success,
            p_message   => p_message
        );

        If p_success = 'KO' Then
            return;
        End If;
        Select
            Count(*)
        Into v_count
        From
            ss_xl_blob_data
        Where
            key_id = v_key_id;

        If v_count = 0 Then
            p_success   := 'KO';
            p_message   := 'Err - No data read into table.';
            return;
        End If;

        schedule_batch(
            p_key_id    => v_key_id,
            p_success   => p_success,
            p_message   => p_message
        );
        If p_success = 'OK' Then
            p_message := 'File uploaded and job scheduled successfully.';
        End If;
    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End init_process;
--*******XXXXXXXXX**********

    Procedure rollback_monthly_credit (
        p_key_id    Varchar2,
        p_success   Out         Varchar2,
        p_message   Out         Varchar2
    ) As
        v_row_mthly_cr_mast ss_monthly_credit_mast%rowtype;
    Begin
        If p_key_id Is Null Then
            p_success   := 'KO';
            p_message   := 'Invalid Id provided.';
            return;
        End If;

        Select
            *
        Into v_row_mthly_cr_mast
        From
            ss_monthly_credit_mast
        Where
            key_id = p_key_id;

        Delete From ss_monthly_credit_exception
        Where
            key_id = p_key_id;

        Delete From ss_monthly_credit_mast
        Where
            key_id = p_key_id;

        Delete From ss_leaveledg
        Where
            Trunc(bdate) = Trunc(v_row_mthly_cr_mast.from_date)
            And adj_type   = 'MC'
            And leavetype  = 'PL'
            And db_cr      = 'C';

        Delete From ss_leave_adj
        Where
            Trunc(bdate) = Trunc(v_row_mthly_cr_mast.from_date)
            And adj_type   = 'MC'
            And leavetype  = 'PL'
            And db_cr      = 'C';

        Delete From ss_xl_blob_data
        Where
            key_id = p_key_id;

        Delete From ss_batch_log_details
        Where
            batch_key_id = p_key_id;

        Delete From ss_batch_log_mast
        Where
            batch_key_id = p_key_id;

        Commit;
        p_success   := 'OK';
        p_message   := 'Procedure executed successfully.';
    Exception
        When Others Then
            Rollback;
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;

End leave_monthly_credit;


/
