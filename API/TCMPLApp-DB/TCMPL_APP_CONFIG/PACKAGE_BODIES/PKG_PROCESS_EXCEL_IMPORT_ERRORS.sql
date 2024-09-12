Create Or Replace Package Body "TCMPL_APP_CONFIG"."PKG_PROCESS_EXCEL_IMPORT_ERRORS" As

    Procedure sp_insert_errors(p_person_id         Varchar2,
                               p_meta_id           Varchar2,

                               p_id                Number,
                               p_section           Varchar2,
                               p_excel_row_number  Number,
                               p_field_name        Varchar2,
                               p_error_type        Number,
                               p_error_type_string Varchar2,
                               p_message           Varchar2,

                               p_message_type Out  Varchar2,
                               p_message_text Out  Varchar2) As
        v_empno Varchar2(5);
    Begin
        v_empno        := selfservice.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Employee not found';
            Return;
        End If;

        Insert Into sec_module_gtt_import_excel_errors(
            id,
            section,
            excel_row_number,
            field_name,
            error_type,
            error_type_string,
            message)
        Values (
            p_id,
            p_section,
            p_excel_row_number,
            p_field_name,
            p_error_type,
            p_error_type_string,
            p_message);

        p_message_type := ok;
        p_message_text := 'Success';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := sqlcode || ' - ' || sqlerrm;

    End;

    Function fn_read_error_list(p_person_id Varchar2,
                                p_meta_id   Varchar2) Return Sys_Refcursor Is
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        v_empno := selfservice.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                sec_module_gtt_import_excel_errors
            Order By
                excel_row_number;

        Return c;

    End;

    Procedure sp_delete_errors(p_person_id         Varchar2,
                               p_meta_id           Varchar2,

                               p_message_type Out  Varchar2,
                               p_message_text Out  Varchar2) As
        v_empno Varchar2(5);
    Begin
        v_empno        := selfservice.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Employee not found';
            Return;
        End If;

        Delete From sec_module_gtt_import_excel_errors;

        p_message_type := ok;
        p_message_text := 'Success';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := sqlcode || ' - ' || sqlerrm;

    End;
End pkg_process_excel_import_errors;