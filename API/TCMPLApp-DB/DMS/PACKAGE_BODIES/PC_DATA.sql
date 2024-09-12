--------------------------------------------------------
--  DDL for Package Body PC_DATA
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PC_DATA" As
    Procedure populate_table (
        param_id Number
    ) As
    Begin
        Insert Into xl_blob_data (
            key_id,
            sheet_nr,
            sheet_name,
            row_nr,
            col_nr,
            cell,
            cell_type,
            string_val,
            number_val,
            date_val,
            formula
        )
            Select
                param_id,
                sheet_nr,
                sheet_name,
                row_nr,
                col_nr,
                cell,
                cell_type,
                string_val,
                number_val,
                date_val,
                formula
            From
                Table ( xlsx_read.read(
                    xlsx_read.get_blob(param_id)
                ) );
        If Sql%rowcount > 0 Then
            Commit;
        Else
            Null;
            --param_success   := 'KO';
            --param_message   := 'No Records found in Uploaded excel id - ' || param_id;
        End If;
        --param_success := 'OK';
    --Exception
        --When Others Then
            --param_success   := 'KO';
            --param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End populate_table;

-- UPLOAD BLOB--
    Procedure upload_blob (
        param_blob        Blob,
        param_file_name   Varchar2,
        param_success     Out               Varchar2,
        param_message     Out               Varchar2
    ) Is
        v_key_id   Number;
        v_count    Number;
        ex_custom Exception;
        Pragma exception_init ( ex_custom, -20001 );
    Begin
        v_key_id        := Trunc(dbms_random.Value(
            1,
            99999999
        ));
        param_success   := 'OK';
        
        Delete From xl_blob;
        delete from xl_blob_data;
        Commit;
        Insert Into xl_blob (
            key_id,
            modified_on,
            file_binary_content,
            file_name
        ) Values (
            v_key_id,
            Sysdate,
            param_blob,
            param_file_name
        );
        Commit;
        normalize_blob_async(
            v_key_id,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            return;
        End If;
        param_success   := 'OK';
        param_message   := 'PC Data Upload & Normalization has been scheduled.';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;
--XXXX--
--Delete UnWanted DATA
    Procedure delete_unwanted_data (
        param_key_id Number
    ) As
    Begin
        Delete From xl_blob_data
        Where
            sheet_nr <> 1
            And key_id = param_key_id;
        Delete From xl_blob_data
        Where
            row_nr <= 3
            And key_id = param_key_id;
        Delete From xl_blob_data
        Where
            row_nr In (
                Select
                    row_nr
                From
                    xl_blob_data
                Where
                    Trim(Upper(string_val)) <> 'SUCCESS'
                    And col_nr = 2
            )
            And key_id = param_key_id;
        Delete From xl_blob_data
        Where
            col_nr Not In (
                1,
                4,
                5,
                6,
                8,
                9,
                15,
                16,
                17,
                19,
                20,
                21,
                22,
                25,
                31
            )
            And key_id = param_key_id;
        Delete From dm_pc_details;
        Commit;
    End;
    
--XXXX--
    Procedure import_into_prod_tab (
        param_key_id Number
    ) As
    Begin
        Insert Into dm_pc_details (
            long_pc_name,
            short_pc_name,
            os,
            comp_model,
            service_pack,
            ip_address,
            mac_address,
            domain_update_days,
            no_of_processors,
            no_of_cores,
            cpu,
            sys_mem,
            video_card,
            video_card_mem,
            disk_size,
            machine_type
        )
            Select
                Upper(compname) long_comp_name,
                Upper(Replace(compname, '.ticb.comp')) short_comp_name,
                os,
                comp_model,
                servic_pack,
                ip_address,
                mac_address,
                domain_update_days,
                no_processors,
                no_cores,
                cpu,
                sys_mem,
                video_card,
                video_card_mem,
                disk_size,
                mach_type
            From
                (
                    Select
                        row_nr,
                        col_nr,
                        str_val compname,
                        Lead(str_val, 1) Over(
                            Order By row_nr, col_nr
                        ) comp_model,
                        Lead(str_val, 2) Over(
                            Order By row_nr, col_nr
                        ) os,
                        Lead(str_val, 3) Over(
                            Order By row_nr, col_nr
                        ) servic_pack,
                        Lead(str_val, 4) Over(
                            Order By row_nr, col_nr
                        ) ip_address,
                        Lead(str_val, 5) Over(
                            Order By row_nr, col_nr
                        ) mac_address,
                        Lead(str_val, 6) Over(
                            Order By row_nr, col_nr
                        ) domain_update_days,
                        Lead(str_val, 7) Over(
                            Order By row_nr, col_nr
                        ) no_processors,
                        Lead(str_val, 8) Over(
                            Order By row_nr, col_nr
                        ) no_cores,
                        Lead(str_val, 9) Over(
                            Order By row_nr, col_nr
                        ) cpu,
                        Lead(str_val, 10) Over(
                            Order By row_nr, col_nr
                        ) sys_mem,
                        Lead(str_val, 11) Over(
                            Order By row_nr, col_nr
                        ) video_card,
                        Lead(str_val, 12) Over(
                            Order By row_nr, col_nr
                        ) video_card_mem,
                        Lead(str_val, 13) Over(
                            Order By row_nr, col_nr
                        ) disk_size,
                        Lead(str_val, 14) Over(
                            Order By row_nr, col_nr
                        ) mach_type
                    From
                        (
                            Select
                                row_nr,
                                col_nr,
                                Nvl(string_val, To_Char(number_val)) str_val
                            From
                                xl_blob_data
                            Order By
                                row_nr,
                                col_nr
                        )
                )
            Where
                col_nr = 1;
        Commit;
    End;
--Normalize BLOB
    Procedure normalize_blob (
        param_key_id Number
    ) As
    Begin
        populate_table(param_key_id);
        delete_unwanted_data(param_key_id);
        import_into_prod_tab(param_key_id);
    End;
--
    Procedure normalize_blob_async (
        param_key_id    Number,
        param_success   Out             Varchar2,
        param_message   Out             Varchar2
    ) As
        v_job_name Varchar2(30);
    Begin
        v_job_name := 'UPDATE_PC_DETAILS_' || To_Char(param_key_id);
        dbms_scheduler.create_job(
            job_name              => v_job_name,
            job_type              => 'STORED_PROCEDURE',
            job_action            => 'pc_data.normalize_blob',
            number_of_arguments   => 1,
            enabled               => false,
            comments              => 'to update PC OS Details'
        );
        dbms_scheduler.set_job_argument_value(
            job_name            => v_job_name,
            argument_position   => 1,
            argument_value      => param_key_id
        );
        dbms_scheduler.enable(v_job_name);
    End;
--XXXX--
End pc_data;

/
