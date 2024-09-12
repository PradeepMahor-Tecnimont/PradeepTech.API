Create Or Replace Package Body tcmpl_app_config.pkg_app_mail_queue As
    c_mail_status_pending Constant Number(1) := 0;
    c_mail_status_hold    Constant Number(1) := 2;
    c_mail_status_sent    Constant Number(1) := 1;
    c_mail_status_error   Constant Number(1) := -1;

    Procedure sp_add(
        p_person_id                    Varchar2,
        p_meta_id                      Varchar2,
        p_mail_to                      Varchar2,
        p_mail_cc                      Varchar2,
        p_mail_bcc                     Varchar2,
        p_mail_subject                 Varchar2,
        p_mail_body1                   Varchar2,
        p_mail_body2                   Varchar2,
        p_mail_type                    Varchar2,
        p_mail_from                    Varchar2,
        p_mail_queue_status            Number,
        p_mail_attachments_os_nm       Varchar2 Default Null,
        p_mail_attachments_business_nm Varchar2 Default Null,
        p_message_type Out             Varchar2,
        p_message_text Out             Varchar2
    ) As
        v_key_id           Varchar2(8);
        v_sysdate          Date;
        v_queue_status_msg Varchar2(20);
    Begin
        v_sysdate      := sysdate;
        v_key_id       := dbms_random.string('X', 8);
        If p_mail_queue_status = c_mail_status_pending Then
            v_queue_status_msg := 'Pending';
        Elsif p_mail_queue_status = c_mail_status_hold Then
            v_queue_status_msg := 'OnHold';
        Else
            v_queue_status_msg := '--';
        End If;
        
        --Check Mail To/CC/BCC exists
        If p_mail_to Is Null And p_mail_bcc Is Null Then
            p_message_type := 'KO';
            p_message_text := 'Err - MailTo or MailBcc address is required.';
            Return;
        End If;
        
        --Check Mail Body
        If p_mail_body1 Is Null Then
            p_message_type := 'KO';
            p_message_text := 'Err - MailBody is required.';
            Return;
        End If;

        Insert Into app_mail_queue(
            key_id,
            entry_date,
            modified_on,
            status_code,
            status_message,
            mail_to,
            mail_cc,
            mail_bcc,
            mail_subject,
            mail_body1,
            mail_body2,
            mail_type,
            mail_from,
            mail_attachments_os_name,
            mail_attachments_business_name,
            mail_send_attempt
        )
        Values(
            v_key_id,
            v_sysdate,
            v_sysdate,
            p_mail_queue_status,
            v_queue_status_msg,
            p_mail_to,
            p_mail_cc,
            p_mail_bcc,
            p_mail_subject,
            p_mail_body1,
            p_mail_body2,
            p_mail_type,
            p_mail_from,
            p_mail_attachments_os_nm,
            p_mail_attachments_business_nm,
            1
        );
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_add_to_queue(
        p_person_id                    Varchar2,
        p_meta_id                      Varchar2,
        p_mail_to                      Varchar2 Default Null,
        p_mail_cc                      Varchar2 Default Null,
        p_mail_bcc                     Varchar2 Default Null,
        p_mail_subject                 Varchar2,
        p_mail_body1                   Varchar2,
        p_mail_body2                   Varchar2 Default Null,
        p_mail_type                    Varchar2 Default 'HTML',
        p_mail_from                    Varchar2 Default Null,
        p_mail_attachments_os_nm       Varchar2 Default Null,
        p_mail_attachments_business_nm Varchar2 Default Null,
        p_message_type Out             Varchar2,
        p_message_text Out             Varchar2
    ) As
    Begin
        sp_add(
            p_person_id                    => p_person_id,
            p_meta_id                      => p_meta_id,
            p_mail_to                      => p_mail_to,
            p_mail_cc                      => p_mail_cc,
            p_mail_bcc                     => p_mail_bcc,
            p_mail_subject                 => p_mail_subject,
            p_mail_body1                   => p_mail_body1,
            p_mail_body2                   => p_mail_body2,
            p_mail_type                    => p_mail_type,
            p_mail_from                    => p_mail_from,
            p_mail_queue_status            => c_mail_status_pending,
            p_mail_attachments_os_nm       => p_mail_attachments_os_nm,
            p_mail_attachments_business_nm => p_mail_attachments_business_nm,
            p_message_type                 => p_message_type,
            p_message_text                 => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_add_to_hold_queue(
        p_person_id                    Varchar2,
        p_meta_id                      Varchar2,
        p_mail_to                      Varchar2 Default Null,
        p_mail_cc                      Varchar2 Default Null,
        p_mail_bcc                     Varchar2 Default Null,
        p_mail_subject                 Varchar2,
        p_mail_body1                   Varchar2,
        p_mail_body2                   Varchar2 Default Null,
        p_mail_type                    Varchar2 Default 'HTML',
        p_mail_from                    Varchar2 Default Null,
        p_mail_attachments_os_nm       Varchar2 Default Null,
        p_mail_attachments_business_nm Varchar2 Default Null,
        p_message_type Out             Varchar2,
        p_message_text Out             Varchar2
    ) As
    Begin
        sp_add(
            p_person_id                    => p_person_id,
            p_meta_id                      => p_meta_id,
            p_mail_to                      => p_mail_to,
            p_mail_cc                      => p_mail_cc,
            p_mail_bcc                     => p_mail_bcc,
            p_mail_subject                 => p_mail_subject,
            p_mail_body1                   => p_mail_body1,
            p_mail_body2                   => p_mail_body2,
            p_mail_type                    => p_mail_type,
            p_mail_from                    => p_mail_from,
            p_mail_queue_status            => c_mail_status_hold,
            p_mail_attachments_os_nm       => p_mail_attachments_os_nm,
            p_mail_attachments_business_nm => p_mail_attachments_business_nm,
            p_message_type                 => p_message_type,
            p_message_text                 => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_update_mail_status_success(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_queue_key_id     Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Update
            app_mail_queue
        Set
            status_code = c_mail_status_sent,
            status_message = 'Sent',
            modified_on = sysdate
        Where
            key_id = p_queue_key_id;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_update_mail_status_error(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_queue_key_id     Varchar2,
        p_log_message      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Update
            app_mail_queue
        Set
            status_code = c_mail_status_error,
            status_message = p_log_message,
            modified_on = sysdate
        Where
            key_id = p_queue_key_id;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Function fn_mails_pending(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor
    Is
        c Sys_Refcursor;
    Begin

        -- Move sent mail and error mail to log table
        Insert Into app_mail_sent
        Select
            *
        From
            app_mail_queue
        Where
            status_code In (c_mail_status_sent, c_mail_status_error);

        Delete
            From app_mail_queue
        Where
            status_code = c_mail_status_sent;

        Delete
            From app_mail_queue
        Where
            status_code           = c_mail_status_error
            And mail_send_attempt = 2;
        --XXX--

        Commit;

        --Set on Hold error email for 1 Hour
        Update
            app_mail_queue
        Set
            status_code = c_mail_status_hold,
            status_message = 'Retry-Hold',
            mail_send_attempt = 2
        Where
            status_code           = c_mail_status_error
            And mail_send_attempt = 1;
        --XXX--

        --Retry error mail put on hold after 1 hour          
        Update
            app_mail_queue
        Set
            status_code = c_mail_status_pending,
            status_message = 'Retry-Pending'
        Where
            status_code           = c_mail_status_hold
            And mail_send_attempt = 2
            And modified_on <= (sysdate - (1 / 24)); --Sysdate -1Hour
        
        --XXX--
        
        Commit;
        
        Open c For
            Select
                *
            From
                app_mail_queue
            Where
                status_code = c_mail_status_pending
                And Rownum <= p_page_length
                and entry_date > (trunc(sysdate)-1)
            Order By
                entry_date;
        Return c;
    End;

End pkg_app_mail_queue;