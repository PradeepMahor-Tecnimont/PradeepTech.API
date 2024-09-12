--------------------------------------------------------
--  DDL for Procedure SEND_MAIL_FROM_API
--------------------------------------------------------
Set Define Off;

Create Or Replace Procedure "SELFSERVICE"."SEND_MAIL_FROM_API"(
    p_mail_to      Varchar2 Default Null,
    p_mail_cc      Varchar2 Default Null,
    p_mail_bcc     Varchar2 Default Null,
    p_mail_subject Varchar2,
    p_mail_body    Varchar2,
    p_mail_profile Varchar2 Default Null,
    p_mail_format  Varchar2 Default Null,
    p_success Out  Varchar2,
    p_message Out  Varchar2
) As
    v_mail_profile Varchar2(20);
    v_mail_format  Varchar2(20);
Begin
    --return;
    If Trim(p_mail_profile) Is Null Then
        v_mail_profile := 'SELFSERVICE';
    Else
        v_mail_profile := p_mail_profile;
    End If;

    If Trim(p_mail_format) Is Null Then
        v_mail_format := 'Text';
    Else
        v_mail_format := p_mail_format;
    End If;

    tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
        p_person_id    => Null,
        p_meta_id      => Null,
        p_mail_to      => p_mail_to,
        p_mail_cc      => p_mail_cc,
        p_mail_bcc     => p_mail_bcc,
        p_mail_subject => p_mail_subject,
        p_mail_body1   => p_mail_body,
        p_mail_body2   => Null,
        p_mail_type    => v_mail_format,
        p_mail_from    => v_mail_profile,
        p_message_type => p_success,
        p_message_text => p_message
    );

    Return;
    /*
        commonmasters.pkg_mail.send_api_mail(
            p_mail_to      => p_mail_to,
            p_mail_cc      => p_mail_cc,
            p_mail_bcc     => p_mail_bcc,
            p_mail_subject => p_mail_subject,
            p_mail_body    => p_mail_body,
            p_mail_profile => v_mail_profile,
            p_mail_format  => v_mail_format,
            p_success      => p_success,
            p_message      => p_message
        );
        /*
        Example
    
        send_mail_from_api (
            p_mail_to        => 'abc.yahoo.com, def.yahoo.com, ghy123.hotmail.com',
            p_mail_cc        => 'abc.yahoo.com, def.yahoo.com, ghy123.hotmail.com',
            p_mail_bcc       => p_mail_bcc,
            p_mail_subject   => 'This is a Subject of Sample mail',
            p_mail_body      => 'This is Body of Sample mail',
            p_mail_profile   => 'TIMESHEET',   (example --> SQSI, OSD, ALHR, etc...)
            p_success        => p_success,
            p_message        => p_message
        );
    
        */

End send_mail_from_api;
/

Grant Execute On "SELFSERVICE"."SEND_MAIL_FROM_API" To "TCMPL_APP_CONFIG";