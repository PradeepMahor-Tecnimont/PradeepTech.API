--------------------------------------------------------
--  DDL for Package Body OFB_FILES_MANAGE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TCMPL_HR"."OFB_FILES_MANAGE" As

    Procedure add_file (
        p_empno              Varchar2,
        p_upload_by_group    Varchar2,
        p_upload_by_empno    Varchar2,
        p_client_file_name   Varchar2,
        p_server_file_name   Varchar2,
        p_success            Out                  Varchar2,
        p_message            Out                  Varchar2
    ) As
        v_key_id Varchar2(8);
    Begin
        v_key_id    := dbms_random.string('X', 8);
        Insert Into ofb_files (
            key_id,
            empno,
            upload_by_group,
            upload_by_empno,
            client_file_name,
            server_file_name,
            upload_date
        ) Values (
            v_key_id,
            p_empno,
            p_upload_by_group,
            p_upload_by_empno,
            p_client_file_name,
            p_server_file_name,
            Sysdate
        );

        Commit;
        p_success   := 'OK';
    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End add_file;

    Procedure remove_file (
        p_empno              Varchar2,
        p_key_id             Varchar2,
        p_server_file_name   Out                  Varchar2,
        p_success            Out                  Varchar2,
        p_message            Out                  Varchar2
    ) As
        v_file_details ofb_files%rowtype;
    Begin
        Select
            *
        Into v_file_details
        From
            ofb_files
        Where
            key_id = p_key_id;

        Delete From ofb_files
        Where
            key_id = p_key_id;

        p_server_file_name   := v_file_details.server_file_name;
        Commit;
        p_success            := 'OK';
    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;

End ofb_files_manage;


/

  GRANT EXECUTE ON "TCMPL_HR"."OFB_FILES_MANAGE" TO "TCMPL_APP_CONFIG";
