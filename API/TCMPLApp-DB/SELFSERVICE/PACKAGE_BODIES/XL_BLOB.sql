--------------------------------------------------------
--  DDL for Package Body XL_BLOB
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."XL_BLOB" As

    Procedure upload_file (
        p_blob      Blob,
        p_blob_id   In          Varchar2,
        p_success   Out         Varchar2,
        p_message   Out         Varchar2
    ) Is
        v_count Number;
        ex_custom Exception;
    Begin
        If p_blob_id Is Null Then
            p_message   := 'Incorrect Key ID provied. Cannot Proceed.';
            p_success   := 'KO';
            return;
        End If;

        p_success   := 'KO';
        Insert Into ss_xl_blob (
            key_id,
            modified_on,
            blob_field
        ) Values (
            p_blob_id,
            Sysdate,
            p_blob
        );

        If Sql%rowcount = 0 Then
            p_success   := 'KO';
            p_message   := 'Err - No data inserted as file Blob';
            return;
        End If;

        Commit;
        Insert Into ss_xl_blob_data (
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
                p_blob_id,
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
                    xlsx_read.get_blob(p_blob_id)
                ) );

        If Sql%rowcount > 0 Then
            Commit;
            Delete From ss_xl_blob
            Where
                key_id = p_blob_id;

            Commit;
        End If;

        p_success   := 'OK';
        p_message   := 'Excel file Upload';
    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;

    Procedure upload_blob_file (
        p_blob      Blob,
        p_blob_id   Out         Varchar2,
        p_success   Out         Varchar2,
        p_message   Out         Varchar2
    ) Is
    Begin
        p_blob_id := dbms_random.string('X', 8);
        upload_file(
            p_blob      => p_blob,
            p_blob_id   => p_blob_id,
            p_success   => p_success,
            p_message   => p_message
        );

    End;

End xl_blob;


/

  GRANT EXECUTE ON "SELFSERVICE"."XL_BLOB" TO "TCMPL_APP_CONFIG";
