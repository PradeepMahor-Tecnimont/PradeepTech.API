Create Or Replace Package Body tcmpl_app_config.pkg_app_user_master As

    Procedure prc_create(
        p_by_empno         Varchar2,
        p_for_empno        Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_key_id Varchar2(8);
        v_count  Number;
    Begin

        --Check employee is valid.
        Select
            Count(*)
        Into
            v_count
        From
            vu_emplmast
        Where
            empno = p_for_empno;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Incorrect EMPNO.';
            Return;
        End If;

        Insert Into app_user_master (
            empno,
            status,
            modified_on,
            modified_by
        )
        Values (
            p_for_empno,
            c_active,
            sysdate,
            p_by_empno
        );

        Commit;
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_import_empno_json(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno_json       Blob,

        p_empno_errors Out Sys_Refcursor,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno          Varchar2(5);
        v_err_num        Number;
        v_is_empno_valid Number;
        v_invalid_msg    Varchar2(9000);
        v_section        Varchar2(2000);
        v_xl_row_number  Number := 0;
        is_error_in_row  Boolean;

        Cursor cur_json Is
            Select
                jt.*
            From
                Json_Table (p_empno_json Format Json, '$[*]'
                    Columns (
                        empno Varchar2 (5) Path '$.Empno'
                    )
                )
                As jt;
    Begin
        v_err_num      := 0;
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        For c1 In cur_json
        Loop
            Begin
                is_error_in_row := False;
                v_xl_row_number := v_xl_row_number + 1;

                Select
                    Count(*)
                Into
                    v_is_empno_valid
                From
                    app_user_master
                Where
                    empno = c1.empno;

                If v_is_empno_valid > 0 Then
                    p_message_type := not_ok;
                    p_message_text := 'Employee Already Insert';
                Else
                    prc_create(
                        p_by_empno     => v_empno,
                        p_for_empno    => c1.empno,
                        p_message_type => p_message_type,
                        p_message_text => p_message_text
                    );
                End If;

                If p_message_type = not_ok Then
                    v_err_num       := v_err_num + 1;
                    is_error_in_row := True;
                    pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Empno : ' || c1.empno,
                        p_error_type        => 1,
                        p_error_type_string => 'Warning',
                        p_message           => 'Error message : ' || p_message_text,
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                Else
                    is_error_in_row := False;
                    pkg_process_excel_import_errors.sp_insert_errors(
                        p_person_id         => p_person_id,
                        p_meta_id           => p_meta_id,
                        p_id                => v_err_num,
                        p_section           => '',
                        p_excel_row_number  => v_xl_row_number,
                        p_field_name        => 'Empno : ' || c1.empno,
                        p_error_type        => 2,
                        p_error_type_string => 'Success',
                        p_message           => 'Success.',
                        p_message_type      => p_message_type,
                        p_message_text      => p_message_text
                    );
                End If;

            Exception
                When Others Then
                    p_message_type := 'KO';
                    p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
            End;
        End Loop;
        p_empno_errors := pkg_process_excel_import_errors.fn_read_error_list(
                              p_person_id => p_person_id,
                              p_meta_id   => p_meta_id
                          );
        Commit;
        If (v_err_num = 0) Then
            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Procedure executed successfully.';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_import_empno_json;

    Procedure sp_activate_empno(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_parameter_json   Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count         Number := 0;
        v_empno         Varchar2(5);
        v_err_num       Number;
        v_xl_row_number Number := 0;
        is_error_in_row Boolean;
        Cursor cur_json Is
            Select
                jt.*
            From
                Json_Table (p_parameter_json Format Json, '$[*]'
                    Columns (
                        empno Varchar2 (5) Path '$.Empno'
                    )
                )
                As jt;
    Begin
        v_err_num      := 0;
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        For c1 In cur_json
        Loop
            Begin
                Update
                    app_user_master
                Set
                    status = c_active
                Where
                    empno = Trim(upper(c1.empno));

            Exception
                When Others Then
                    p_message_type := 'KO';
                    p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
            End;
        End Loop;

        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_activate_empno;

    Procedure sp_deactivate_empno(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_parameter_json   Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count         Number := 0;
        v_empno         Varchar2(5);
        v_err_num       Number;
        v_xl_row_number Number := 0;
        is_error_in_row Boolean;
        Cursor cur_json Is
            Select
                jt.*
            From
                Json_Table (p_parameter_json Format Json, '$[*]'
                    Columns (
                        empno Varchar2 (5) Path '$.Empno'
                    )
                )
                As jt;
    Begin
        v_err_num      := 0;
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        For c1 In cur_json
        Loop
            Begin
                Delete
                    From app_user_master
                Where
                    empno = Trim(upper(c1.empno));

            Exception
                When Others Then
                    p_message_type := 'KO';
                    p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
            End;
        End Loop;

        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_deactivate_empno;
End;