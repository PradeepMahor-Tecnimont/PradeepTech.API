create or replace Package Body tcmpl_app_config.pkg_app_mail_process_status As

    Procedure sp_add_mail_process_status(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_process_mail     Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_exists       Number;
        v_message_type Number := 0;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            app_mail_process_status;

        If v_exists = 0 Then
            Insert Into app_mail_process_status (
                process_mail,
                modified_by,
                modified_on
            )
            Values (
                p_process_mail,
                v_empno,
                sysdate
            );

            Commit;
            p_message_type := ok;
            p_message_text := 'Mail process status update successfully..';
        Else
            Update
                app_mail_process_status
            Set
                process_mail = p_process_mail,
                modified_by = v_empno,
                modified_on = sysdate;
            
            p_message_type := ok;
            p_message_text := 'Mail Process Status changed successfully..';
        End If;

        Insert Into app_mail_process_status_log (
            process_mail,
            modified_by,
            modified_on
        )
        Values (
            p_process_mail,
            v_empno,
            sysdate
        );
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;
End;