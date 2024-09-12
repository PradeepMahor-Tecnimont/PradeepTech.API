Create Or Replace Force View "TCMPL_APP_CONFIG"."VU_MAIL_LOGS" (
    "MAIL_TYPE_CODE",
    "MAIL_TYPE_DESC",
    "KEY_ID",
    "ENTRY_DATE",
    "MODIFIED_ON",
    "STATUS_CODE",
    "STATUS_DESC",
    "STATUS_MESSAGE",
    "MAIL_TO",
    "MAIL_CC",
    "MAIL_BCC",
    "MAIL_SUBJECT",
    "MAIL_BODY1",
    "MAIL_BODY2",
    "MAIL_TYPE",
    "MAIL_FROM",
    "MAIL_ATTACHMENTS_OS_NAME",
    "MAIL_ATTACHMENTS_BUSINESS_NAME"
) As
    Select
        1                                    mail_type_code,
        'Sent'                               mail_type_desc,
        mails.key_id                         key_id,
        mails.entry_date                     entry_date,
        mails.modified_on                    modified_on,
        mails.status_code                    status_code,
        (
            Select
                app_process_status.status_desc
            From
                app_process_status
            Where
                mails.status_code = app_process_status.status
        )                                    status_desc,
        mails.status_message                 status_message,
        mails.mail_to                        mail_to,
        mails.mail_cc                        mail_cc,
        mails.mail_bcc                       mail_bcc,
        mails.mail_subject                   mail_subject,
        mails.mail_body1                     mail_body1,
        mails.mail_body2                     mail_body2,
        mails.mail_type                      mail_type,
        mails.mail_from                      mail_from,
        mails.mail_attachments_os_name       mail_attachments_os_name,
        mails.mail_attachments_business_name mail_attachments_business_name
    From
        app_mail_sent mails
    Union All
    Select
        2                                    mail_type_code,
        'Queue'                              mail_type_desc,
        mails.key_id                         key_id,
        mails.entry_date                     entry_date,
        mails.modified_on                    modified_on,
        mails.status_code                    status_code,
        (
            Select
                app_process_status.status_desc
            From
                app_process_status
            Where
                mails.status_code = app_process_status.status
        )                                    status_desc,
        mails.status_message                 status_message,
        mails.mail_to                        mail_to,
        mails.mail_cc                        mail_cc,
        mails.mail_bcc                       mail_bcc,
        mails.mail_subject                   mail_subject,
        mails.mail_body1                     mail_body1,
        mails.mail_body2                     mail_body2,
        mails.mail_type                      mail_type,
        mails.mail_from                      mail_from,
        mails.mail_attachments_os_name       mail_attachments_os_name,
        mails.mail_attachments_business_name mail_attachments_business_name
    From
        app_mail_queue mails;