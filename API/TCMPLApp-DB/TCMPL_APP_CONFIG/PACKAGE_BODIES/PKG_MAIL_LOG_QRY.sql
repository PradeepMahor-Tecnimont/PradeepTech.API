Create Or Replace Package Body pkg_mail_log_qry As

    Function fn_mail_sent(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_start_date     Date     Default Null,
        p_end_date       Date     Default Null,
        p_mail_from      Varchar2 Default Null,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        key_id                                           key_id,
                        entry_date                                       As entry_date_for_sort,
                        to_char(entry_date, 'dd-Mon-yyyy : HH24:MI:SS')  As entry_date,
                        to_char(modified_on, 'dd-Mon-yyyy : HH24:MI:SS') As modified_on,
                        to_char(status_code)                             status_code,
                        (
                            Select
                                app_process_status.status_desc
                            From
                                app_process_status
                            Where
                                status_code = app_process_status.status
                        )                                                status_desc,
                        status_message                                   status_message,
                        mail_to                                          mail_to,
                        mail_cc                                          mail_cc,
                        mail_bcc                                         mail_bcc,
                        mail_subject                                     mail_subject,
                        mail_body1                                       mail_body1,
                        mail_body2                                       mail_body2,
                        mail_type                                        mail_type,
                        mail_from                                        mail_from,
                        mail_attachments_os_name                         mail_attach_os,
                        mail_attachments_business_name                   mail_attach_business,
                        Row_Number() Over (Order By entry_date Desc)     row_number,
                        Count(*) Over ()                                 total_row
                    From
                        app_mail_sent mail_log
                    Where
                        trunc(entry_date) = trunc(nvl(p_start_date, entry_date))
                        And mail_from     = nvl(p_mail_from, mail_from)
                        And (
                            upper(mail_from) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(mail_to) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(mail_subject) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                entry_date_for_sort Desc;
        Return c;
    End fn_mail_sent;

    Function fn_mail_queue(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_start_date     Date     Default Null,
        p_end_date       Date     Default Null,
        p_mail_from      Varchar2 Default Null,

        p_generic_search Varchar2 Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        key_id                                           key_id,
                        entry_date                                       As entry_date_for_sort,
                        to_char(entry_date, 'dd-Mon-yyyy : HH24:MI:SS')  As entry_date,
                        to_char(modified_on, 'dd-Mon-yyyy : HH24:MI:SS') As modified_on,
                        to_char(status_code)                             status_code,
                        (
                            Select
                                app_process_status.status_desc
                            From
                                app_process_status
                            Where
                                status_code = app_process_status.status
                        )                                                status_desc,
                        status_message                                   status_message,
                        mail_to                                          mail_to,
                        mail_cc                                          mail_cc,
                        mail_bcc                                         mail_bcc,
                        mail_subject                                     mail_subject,
                        mail_body1                                       mail_body1,
                        mail_body2                                       mail_body2,
                        mail_type                                        mail_type,
                        mail_from                                        mail_from,
                        mail_attachments_os_name                         mail_attach_os,
                        mail_attachments_business_name                   mail_attach_business,
                        Row_Number() Over (Order By entry_date Desc)     row_number,
                        Count(*) Over ()                                 total_row
                    From
                        app_mail_queue mail_log
                    Where
                        trunc(entry_date)       = trunc(nvl(p_start_date, entry_date))
                        And nvl(mail_from, '-') = nvl(p_mail_from, nvl(mail_from, '-'))
                        And (
                            upper(nvl(mail_from, '-')) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(nvl(mail_to, '-')) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(mail_subject) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                entry_date_for_sort Desc;
        Return c;
    End fn_mail_queue;

    Procedure sp_queue_mail_detail(
        p_person_id                Varchar2,
        p_meta_id                  Varchar2,

        p_key_id                   Varchar2,
        p_entry_date           Out Varchar2,
        p_modified_on          Out Varchar2,
        p_status_code          Out Varchar2,
        p_status_desc          Out Varchar2,
        p_status_message       Out Varchar2,
        p_mail_to              Out Varchar2,
        p_mail_cc              Out Varchar2,
        p_mail_bcc             Out Varchar2,
        p_mail_subject         Out Varchar2,
        p_mail_body1           Out Varchar2,
        p_mail_body2           Out Varchar2,
        p_mail_type            Out Varchar2,
        p_mail_from            Out Varchar2,
        p_mail_attach_os       Out Varchar2,
        p_mail_attach_business Out Varchar2,

        p_message_type         Out Varchar2,
        p_message_text         Out Varchar2
    ) As
        v_empno Varchar2(5);

    Begin
        v_empno        := app_users.get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            to_char(entry_date, 'dd-Mon-yyyy : HH24:MI:SS')  As entry_date,
            to_char(modified_on, 'dd-Mon-yyyy : HH24:MI:SS') As modified_on,
            status_code,
            (
                Select
                    app_process_status.status_desc
                From
                    app_process_status
                Where
                    status_code = app_process_status.status
            ),
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
            mail_attachments_business_name
        Into
            p_entry_date,
            p_modified_on,
            p_status_code,
            p_status_desc,
            p_status_message,
            p_mail_to,
            p_mail_cc,
            p_mail_bcc,
            p_mail_subject,
            p_mail_body1,
            p_mail_body2,
            p_mail_type,
            p_mail_from,
            p_mail_attach_os,
            p_mail_attach_business
        From
            app_mail_queue mail_log
        Where
            key_id = p_key_id;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_queue_mail_detail;

    Procedure sp_sent_mail_detail(
        p_person_id                Varchar2,
        p_meta_id                  Varchar2,

        p_key_id                   Varchar2,
        p_entry_date           Out Varchar2,
        p_modified_on          Out Varchar2,
        p_status_code          Out Varchar2,
        p_status_desc          Out Varchar2,
        p_status_message       Out Varchar2,
        p_mail_to              Out Varchar2,
        p_mail_cc              Out Varchar2,
        p_mail_bcc             Out Varchar2,
        p_mail_subject         Out Varchar2,
        p_mail_body1           Out Varchar2,
        p_mail_body2           Out Varchar2,
        p_mail_type            Out Varchar2,
        p_mail_from            Out Varchar2,
        p_mail_attach_os       Out Varchar2,
        p_mail_attach_business Out Varchar2,

        p_message_type         Out Varchar2,
        p_message_text         Out Varchar2
    ) As
        v_empno Varchar2(5);

    Begin
        v_empno        := app_users.get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            to_char(entry_date, 'dd-Mon-yyyy : HH24:MI:SS')  As entry_date,
            to_char(modified_on, 'dd-Mon-yyyy : HH24:MI:SS') As modified_on,
            status_code,
            (
                Select
                    app_process_status.status_desc
                From
                    app_process_status
                Where
                    status_code = app_process_status.status
            )                                                status_desc,
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
            mail_attachments_business_name
        Into
            p_entry_date,
            p_modified_on,
            p_status_code,
            p_status_desc,
            p_status_message,
            p_mail_to,
            p_mail_cc,
            p_mail_bcc,
            p_mail_subject,
            p_mail_body1,
            p_mail_body2,
            p_mail_type,
            p_mail_from,
            p_mail_attach_os,
            p_mail_attach_business
        From
            app_mail_sent mail_log
        Where
            key_id = p_key_id;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_sent_mail_detail;

End pkg_mail_log_qry;