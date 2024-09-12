--------------------------------------------------------
--  File created - Friday-September-09-2022   
--------------------------------------------------------
---------------------------
--Changed PACKAGE
--IMPORT_PUNCH
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IMPORT_PUNCH" As 

    /* TODO enter package declarations (types, exceptions, methods etc) here */
    Procedure replace_sr_no_with_empno;

    Procedure insert_punch_2_prod_tab;

    Procedure upload_blob(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_blob             Blob,
        p_clint_file_name  Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure upload_blob(
        param_blob        Blob,
        param_file_name   Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2
    );

    Type typ_txt_row Is Record(
            text_rec Varchar2(100)
        );
    Type typ_tab_txt_row Is
        Table Of Varchar2(200);

    Procedure normalize_blob_into_punch_data(
        param_key_id Varchar2
    );

End import_punch;
/
---------------------------
--Changed PACKAGE BODY
--IMPORT_PUNCH
---------------------------
--------------------------------------------------------
--  DDL for Package Body IMPORT_PUNCH
--------------------------------------------------------

Set Define Off;

Create Or Replace Package Body "SELFSERVICE"."IMPORT_PUNCH" As

    ok     Constant Varchar2(2) := 'OK';
    not_ok Constant Varchar2(2) := 'KO';
    Procedure insert_2_temp_tab(
        param_text Varchar2
    ) As

        v_mach  Varchar2(4);
        v_hh    Varchar2(2);
        v_mn    Varchar2(2);
        v_ss    Varchar2(2);
        v_dd    Varchar2(2);
        v_mon   Varchar2(2);
        v_yyyy  Varchar2(4);
        v_empno Varchar2(5);
    Begin
        v_mach  := substr(param_text, 1, 4);
        v_hh    := substr(param_text, 5, 2);
        v_mn    := substr(param_text, 7, 2);
        v_ss    := substr(param_text, 9, 2);
        v_dd    := substr(param_text, 11, 2);
        v_mon   := substr(param_text, 13, 2);
        v_yyyy  := substr(param_text, 15, 4);
        v_empno := substr(trim(substr(param_text, 19, 8)), -5);

        Insert Into ss_importpunch (
            empno,
            hh,
            mm,
            ss,
            dd,
            mon,
            yyyy,
            mach
        )
        Values (
            v_empno,
            v_hh,
            v_mn,
            v_ss,
            v_dd,
            v_mon,
            v_yyyy,
            v_mach
        );

        Commit;
    End;

    Procedure update_status(
        param_key_id  Varchar2,
        param_success Varchar2,
        param_message Varchar2
    ) As
    Begin
        Update
            ss_punch_upload_blob
        Set
            process_status = param_success,
            process_message = param_message
        Where
            key_id = param_key_id;

        Commit;
    End;

    Procedure normalize_blob_2_rows(
        param_key_id      Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) As

        l_str1      Varchar2(4000);
        l_str2      Varchar2(4000);
        l_leftover  Varchar2(4000);
        l_chunksize Number      := 3000;
        l_offset    Number      := 1;
        l_linebreak Varchar2(2) := chr(13) || chr(10);
        l_length    Number;
        v_blob      Blob;
        l_row       Varchar2(200);
    Begin
        --empty import_punch tble
        Delete
            From ss_importpunch;
        --

        Select
            file_blob
        Into
            v_blob
        From
            ss_punch_upload_blob
        Where
            key_id = param_key_id;

        l_length      := dbms_lob.getlength(v_blob);
        dbms_output.put_line(l_length);
        While l_offset < l_length
        Loop
            l_str1     := l_leftover || utl_raw.cast_to_varchar2(dbms_lob.substr(v_blob, l_chunksize, l_offset));

            l_leftover := Null;
            l_str2     := l_str1;
            While l_str2 Is Not Null
            Loop
                If instr(l_str2, l_linebreak) <= 0 Then
                    l_leftover := l_str2;
                    l_str2     := Null;
                Else
                    l_row  := (substr(l_str2, 1, instr(l_str2, l_linebreak) - 1));

                    --Insert into table

                    --Pipe Row ( l_row );

                    insert_2_temp_tab(l_row);
                    --
                    l_str2 := substr(l_str2, instr(l_str2, l_linebreak) + 2);
                End If;
            End Loop;

            l_offset   := l_offset + l_chunksize;
        End Loop;

        If l_leftover Is Not Null Then
            l_row := substr(l_leftover, 1, 200);
            --Insert into table
            insert_2_temp_tab(l_row);
            --

            --Pipe Row ( l_row );
            --dbms_output.put_line(l_leftover);
        End If;

        param_success := 'OK';
        param_message := 'Blob normalized to rows';
        Return;
    End;

    Procedure normalize_blob_into_punch_data(
        param_key_id      Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) As
    Begin
        Update
            ss_punch_upload_blob
        Set
            process_status = 'WP'
        Where
            key_id = param_key_id;

        Commit;

        --*****--
        normalize_blob_2_rows(
            param_key_id,
            param_success,
            param_message
        );
        update_status(
            param_key_id,
            Case param_success
                When 'OK' Then
                    'WP'
                Else
                    param_success
            End,
            param_message
        );

        --*****--
        If param_success = 'KO' Then
            Return;
        End If;

        --*****--
        insert_punch_2_prod_tab;

        --*****--
        param_success := 'OK';
        param_message := 'Data successfully uploaded to Database';
        update_status(param_key_id, param_success, param_message);
        Commit;
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            update_status(param_key_id, param_success, param_message);
            Commit;
    End;

    Procedure proc_normalize_async(
        param_key_id Varchar2
    ) As
        v_job_name Varchar2(30);
        v_job_no   Varchar2(5);
    Begin
        v_job_no   := dbms_random.string('X', 5);
        v_job_name := 'NORMALIZE_PUNCH_' || v_job_no;
        dbms_scheduler.create_job(
            job_name            => v_job_name,
            job_type            => 'STORED_PROCEDURE',
            job_action          => 'import_punch.normalize_blob_into_punch_data',
            number_of_arguments => 1,
            enabled             => false,
            job_class           => 'TCMPL_JOB_CLASS',
            comments            => 'To Normalize Punch Data'
        );

        dbms_scheduler.set_job_argument_value(
            job_name          => v_job_name,
            argument_position => 1,
            argument_value    => param_key_id
        );

        dbms_scheduler.enable(v_job_name);
    End;

    Procedure write_blob_to_table(
        p_new_key_id      Varchar2,
        p_blob            Blob,
        p_clint_file_name Varchar2
    ) As
        v_count Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_punch_upload_blob
        Where
            Trim(process_status) = 'WP';

        If v_count > 0 Then
            raise_application_error(
                -20002,
                'Previous file upload process not completed. Try after sometime.'
            );
            Return;
        End If;
        Delete
            From ss_punch_upload_blob;

        Commit;
        Insert Into ss_punch_upload_blob (
            key_id,
            modified_on,
            file_blob,
            file_type,
            process_status,
            file_name
        )
        Values (
            p_new_key_id,
            sysdate,
            p_blob,
            'PUNCH_DATA',
            'UP',
            p_clint_file_name
        );

        Commit;

    End;

    Procedure upload_blob(
        param_blob        Blob,
        param_file_name   Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) Is

        v_key_id  Varchar2(5);
        v_count   Number;
        ex_custom Exception;
        Pragma exception_init(ex_custom, -20001);
    Begin
        v_key_id      := dbms_random.string('X', 5);
        param_success := 'OK';

        write_blob_to_table(
            p_new_key_id      => v_key_id,
            p_blob            => param_blob,
            p_clint_file_name => param_file_name
        );

        proc_normalize_async(v_key_id);
        param_success := 'OK';
        param_message := 'Punch Upload & Normalization has been scheduled.';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure insert_into_punch_all Is
        Cursor cur_4all_punch Is
            Select
                *
            From
                ss_ipformat;

        Type typ_tab_punch Is
            Table Of cur_4all_punch%rowtype;
        tab_punch typ_tab_punch;
    Begin
        Open cur_4all_punch;
        Loop
            Fetch cur_4all_punch Bulk Collect Into tab_punch Limit 100;
            For i In 1..tab_punch.count
            Loop
                Begin
                    Insert Into ss_punch_all (
                        empno,
                        hh,
                        mm,
                        ss,
                        pdate,
                        falseflag,
                        dd,
                        mon,
                        yyyy,
                        mach
                    )
                    Values (
                        tab_punch(i).empno,
                        tab_punch(i).hh,
                        tab_punch(i).mm,
                        tab_punch(i).ss,
                        tab_punch(i).pdate,
                        1,
                        tab_punch(i).dd,
                        tab_punch(i).mon,
                        tab_punch(i).yyyy,
                        tab_punch(i).mach
                    );

                    Commit;
                Exception
                    When Others Then
                        Null;
                End;
            End Loop;

            Exit When cur_4all_punch%notfound;
        End Loop;

        Null;
    End;

    Procedure insert_into_punch Is

        Cursor cur_punch Is
            Select
                *
            From
                ss_ipformat
            Where
                mach In (
                    Select
                        mach_name
                    From
                        ss_swipe_mach_mast
                    Where
                        valid_4_in_out = 1
                );

        Type typ_tab_punch Is
            Table Of cur_punch%rowtype;
        tab_punch typ_tab_punch;
    Begin
        Open cur_punch;
        Loop
            Fetch cur_punch Bulk Collect Into tab_punch Limit 100;
            For i In 1..tab_punch.count
            Loop
                Begin
                    Insert Into ss_punch (
                        empno,
                        hh,
                        mm,
                        ss,
                        pdate,
                        falseflag,
                        dd,
                        mon,
                        yyyy,
                        mach
                    )
                    Values (
                        tab_punch(i).empno,
                        tab_punch(i).hh,
                        tab_punch(i).mm,
                        tab_punch(i).ss,
                        tab_punch(i).pdate,
                        1,
                        tab_punch(i).dd,
                        tab_punch(i).mon,
                        tab_punch(i).yyyy,
                        tab_punch(i).mach
                    );

                    Commit;
                Exception
                    When Others Then
                        Null;
                End;
            End Loop;

            Exit When cur_punch%notfound;
        End Loop;

        Commit;
    End;

    Procedure replace_sr_no_with_empno As
    Begin
        Update
            ss_importpunch a
        Set
            empno = (
                Select
                    empno
                From
                    ss_vu_contmast
                Where
                    punchno = a.empno
            )
        Where
            empno In (
                Select
                    punchno
                From
                    ss_vu_contmast
            );

        Commit;
    End replace_sr_no_with_empno;

    Procedure insert_punch_2_prod_tab Is
    Begin
        -- Insert into Punch All Table
        insert_into_punch_all;
        --

        --Delete unwanted Punch
        Delete
            From ss_importpunch
        Where
            mach Not In (
                Select
                    mach_name
                From
                    ss_swipe_mach_mast
                Where
                    valid_4_in_out = 1
            );

        Commit;
        --Delete unwanted Punch

        --Replace Serial Number with EmpNo
        replace_sr_no_with_empno;
        --Replace Serial Number with Empno

        --Insert into Punch Table
        insert_into_punch;
        --
        Declare
            Cursor cur_uploaded_punch_data Is
                Select
                Distinct
                    empno,
                    pdate
                From
                    ss_ipformat;

            v_status Varchar2(10);
            v_msg    Varchar2(1000);
        Begin
            For c1 In cur_uploaded_punch_data
            Loop
                generate_auto_punch(c1.empno, c1.pdate);
                wfh_attendance.rem_wfh_n_keep_card_swipe(
                    param_empno => c1.empno,
                    param_pdate => c1.pdate
                );

                itinv_stk.attend_plan.create_attend_act_punch(
                    p_punch_date => trunc(c1.pdate),
                    p_empno      => c1.empno,
                    p_status     => v_status,
                    p_msg        => v_msg
                );

            End Loop;
        End;
        --

    End;

    Procedure normalize_blob_into_punch_data(
        param_key_id Varchar2
    ) As
        v_success Varchar2(10);
        v_message Varchar2(2000);
    Begin
        normalize_blob_into_punch_data(
            param_key_id,
            v_success,
            v_message
        );
    End;

    --Upload PUNCH BLOB procedure for WINServic
    Procedure upload_blob(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_blob             Blob,
        p_clint_file_name  Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_key_id             Varchar2(5);
        v_count              Number;
        ex_custom            Exception;
        Pragma exception_init(ex_custom, -20002);
    Begin
        If commonmasters.pkg_environment.is_production = not_ok Then
            p_message_type := ok;
            p_message_text := 'WARNING - This utility is available in Production only';
            Return;
        End If;
        v_key_id := dbms_random.string('X', 5);
        v_empno  := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;

        write_blob_to_table(
            p_new_key_id      => v_key_id,
            p_blob            => p_blob,
            p_clint_file_name => p_clint_file_name
        );

        normalize_blob_into_punch_data(
            param_key_id  => v_key_id,
            param_success => p_message_type,
            param_message => p_message_text
        );
    End;
    --XXXXXXXXXX

End import_punch;
/

grant execute on selfservice.import_punch to tcmpl_app_config;
/