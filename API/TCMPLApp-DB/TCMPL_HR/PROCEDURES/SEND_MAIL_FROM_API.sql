--------------------------------------------------------
--  DDL for Procedure SEND_MAIL_FROM_API
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "TCMPL_HR"."SEND_MAIL_FROM_API" (
    p_mail_to      Varchar2,
    p_mail_cc      Varchar2,
    p_mail_bcc     Varchar2,
    p_mail_subject Varchar2,
    p_mail_body    Varchar2,
    p_mail_profile Varchar2,
    p_mail_format  Varchar2,
    p_success      Out Varchar2,
    p_message      Out Varchar2
) As
    v_mail_to  Varchar2(2000);
    v_mail_cc  Varchar2(2000);
    v_mail_bcc Varchar2(2000);
Begin
    --return;

    If Trim(p_mail_to) Is Not Null Then
        v_mail_to := replace(
                            lower(p_mail_to),
                            lower('S.Gopalsamy@tecnimont.it,'),
                            ''
                     );
    End If;

    If Trim(p_mail_cc) Is Not Null Then
        v_mail_cc := replace(
                            lower(p_mail_cc),
                            lower('S.Gopalsamy@tecnimont.it,'),
                            ''
                     );
    End If;

    If Trim(p_mail_bcc) Is Not Null Then
        v_mail_bcc := replace(
                             lower(p_mail_bcc),
                             lower('S.Gopalsamy@tecnimont.it,'),
                             ''
                      );
    End If;

    tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
        p_person_id    => Null,
        p_meta_id      => Null,
        p_mail_to      => v_mail_to,
        p_mail_cc      => v_mail_cc,
        p_mail_bcc     => v_mail_bcc,
        p_mail_subject => p_mail_subject,
        p_mail_body1   => p_mail_body,
        p_mail_body2   => Null,
        p_mail_type    => p_mail_format,
        p_mail_from    => 'OFF-Boarding',
        p_message_type => p_success,
        p_message_text => p_message
    );
    
    Return;
    
    /*
    commonmasters.pkg_mail.send_api_mail(
        p_mail_to        => 's.kanakath@tecnimont.in',
        p_mail_cc        => 'p.mahor@tecnimont.in',
        p_mail_bcc       => 'd.bhavsar@tecnimont.in',
        p_mail_subject   => p_mail_subject,
        p_mail_body      => p_mail_body,
        p_mail_profile   => 'REMOTEWORK',
        p_success        => p_success,
        p_message        => p_message
    );
    */
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

  GRANT EXECUTE ON "TCMPL_HR"."SEND_MAIL_FROM_API" TO "TCMPL_APP_CONFIG";
