--------------------------------------------------------
--  DDL for Package Body PKG_MAIL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "COMMONMASTERS"."PKG_MAIL" As

    Function format_mail_addr (
        p_mail_addr Varchar2
    ) Return Varchar2 As
        v_ret_val Varchar2(4000);
    Begin
        Select
            '"' ||
                Listagg(val,
                        '","') Within Group(
                    Order By
                        val
                )
            || '"' csv
        Into v_ret_val
        From
            (
                Select Distinct
                    val
                From
                    (
                        Select
                            Trim(Regexp_Substr(p_mail_addr, '[^,]+', 1, Level)) val
                        From
                            dual
                        Connect By
                            Regexp_Substr(p_mail_addr, '[^,]+', 1, Level) Is Not Null
                        Order By
                            Level
                    )
            );

        Return v_ret_val;
    Exception
        When Others Then
            Return 'ERR';
    End;

    Procedure send_api_mail_1 (
        p_mail_to        Varchar2,
        p_mail_cc        Varchar2,
        p_mail_bcc       Varchar2,
        p_mail_subject   Varchar2,
        p_mail_body      Varchar2,
        p_mail_profile   Varchar2,
        p_success        Out              Varchar2,
        p_message        Out              Varchar2
    ) As

        req                utl_http.req;
        res                utl_http.resp;
        rest_api_url       Varchar2(4000) := 'http://tplapps02.ticb.comp/SendMailAPI/api/SendEMailMethod';
        buffer             Varchar2(4000);
        req_content        Varchar2(4000);
        status_code        Number;
        reason_phrase      Varchar2(256);
        http_version       Varchar2(64);
        --
        v_mail_to          Varchar2(4000);
        v_mail_cc          Varchar2(4000);
        v_mail_bcc         Varchar2(4000);
        v_mail_subject     Varchar2(300);
        v_mail_body        Varchar2(4000);
        v_content_length   Number;
        v_out_msg          Varchar2(4000);
    Begin
        /* SAMPLE REQUEST */
        /*
        req_content     := '{
                                "mailTo": ["d_bhavsar@hotmail.com","devendra.g.bhavsar@tecnimont.in"],
                                "mailCC": ["d.bhavsar@tecnimont.in"],
                                "mailBCC": [],
                                "mailSubject": "TEST",
                                "mailBody": "This is mail body",
                                "mailType": "Text",
                                "mailFrom": "ALHR"
                            }'
        ;
        */
        If Trim(p_mail_to) Is Null And Trim(p_mail_bcc) Is Null Then
            p_success   := 'KO';
            p_message   := 'Err - Mail-To / Mail-bcc is blank. Cannot proceed.';
            return;
        End If;

        req_content        := '{
                                "mailTo": [!!MAILTO!!],
                                "mailCC": [!!MAILCC!!],
                                "mailBCC": [!!MAILCC!!],
                                "mailSubject": "!!SUBJECT!!",
                                "mailBody": "!!BODY!!",
                                "mailType": "Text",
                                "mailFrom": "!!MAILPROFILE!!"
                            }'
        ;
        If Trim(p_mail_to) Is Not Null Then
            v_mail_to := format_mail_addr(p_mail_to);
        End If;

        If Trim(p_mail_cc) Is Not Null Then
            v_mail_cc := format_mail_addr(p_mail_cc);
        End If;

        If Trim(p_mail_bcc) Is Not Null Then
            v_mail_bcc := format_mail_addr(p_mail_bcc);
        End If;

        req                := utl_http.begin_request(
            url      => rest_api_url,
            method   => 'POST'
        );
        utl_http.set_header(
            req,
            'user-agent',
            'mozilla/4.0'
        );
        utl_http.set_header(
            req,
            'content-type',
            'application/json'
        );
        v_content_length   := Length('{
                                "mailTo": [' || v_mail_to || '],
                                "mailCC": ['
        || v_mail_cc || '],
                                "mailBCC": [' || v_mail_bcc || '],
                                "mailSubject": "'
        || p_mail_subject || '",
                                "mailBody": "' || p_mail_body || '",
                                "mailType": "Text",
                                "mailFrom": "'
        || p_mail_profile || '"
                            }');

        utl_http.set_header(
            req,
            'Content-Length',
            v_content_length
        );
        utl_http.set_header(
            req,
            'Accept',
            '*/*'
        );
        utl_http.write_raw(
            req,
            utl_raw.cast_to_raw('{
                                "mailTo": [' || v_mail_to || '],
                                "mailCC": ['
            || v_mail_cc || '],
                                "mailBCC": [' || v_mail_bcc || '],
                                "mailSubject": "'
            || p_mail_subject || '",
                                "mailBody": "' || p_mail_body || '",
                                "mailType": "Text",
                                "mailFrom": "'
            || p_mail_profile || '"
                            }')
        );

        res                := utl_http.get_response(req);
        status_code        := res.status_code;
        reason_phrase      := res.reason_phrase;
        http_version       := res.http_version;
  -- process the response from the HTTP call
        Begin
            Loop
                utl_http.read_line(
                    res,
                    buffer
                );
                dbms_output.put_line(buffer);
                If Length(v_out_msg || buffer) < 4000 Then
                    v_out_msg := v_out_msg || buffer;
                End If;

            End Loop;

            utl_http.end_response(res);
        Exception
            When utl_http.end_of_body Then
                utl_http.end_response(res);
        End;

        If Trim(v_out_msg) Is Null Then
            p_success   := 'KO';
            p_message   := 'Error - Unknown error while executing command.';
            return;
        End If;

        v_out_msg          := Replace(v_out_msg, '"', '');
        v_out_msg          := Substr(v_out_msg, 2, Length(v_out_msg) - 2);
        v_out_msg          := Substr(v_out_msg, 1, Instr(v_out_msg, ',', -1) - 1);

        p_success          := Substr(v_out_msg, -2);
        p_message          := Substr(v_out_msg, Instr(v_out_msg, ':') + 1);
        p_message          := Substr(p_message, 1, Instr(p_message, ',') - 1);

    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End send_api_mail_1;

    Procedure send_api_mail (
        p_mail_to        Varchar2,
        p_mail_cc        Varchar2,
        p_mail_bcc       Varchar2,
        p_mail_subject   Varchar2,
        p_mail_body      Varchar2,
        p_mail_body_2    Varchar2 Default '',
        p_mail_body_3    Varchar2 Default '',
        p_mail_profile   Varchar2,
        p_mail_format    Varchar2 Default 'Text',
        p_success        Out              Varchar2,
        p_message        Out              Varchar2
    ) As

        req                utl_http.req;
        res                utl_http.resp;
        rest_api_url       Varchar2(4000) := 'http://tplapps02.ticb.comp/SendMailAPI/api/SendEMailMethod';
        buffer             Varchar2(4000);
        req_content        Varchar2(4000);
        status_code        Number;
        reason_phrase      Varchar2(256);
        http_version       Varchar2(64);
        --
        v_mail_to          Varchar2(4000);
        v_mail_cc          Varchar2(4000);
        v_mail_bcc         Varchar2(4000);
        v_mail_subject     Varchar2(300);
        v_mail_body        Varchar2(4000);
        v_mail_type        Varchar2(10);
        v_content_length   Number;
        v_out_msg          Varchar2(4000);
    Begin
        /* SAMPLE REQUEST */
        /*
        req_content     := '{
                                "mailTo": ["d_bhavsar@hotmail.com","devendra.g.bhavsar@tecnimont.in"],
                                "mailCC": ["d.bhavsar@tecnimont.in"],
                                "mailBCC": [],
                                "mailSubject": "TEST",
                                "mailBody": "This is mail body",
                                "mailType": "Text",
                                "mailFrom": "ALHR"
                            }'
        ;
        */
        If Trim(p_mail_to) Is Null And Trim(p_mail_bcc) Is Null Then
            p_success   := 'KO';
            p_message   := 'Err - Mail-To / Mail-bcc is blank. Cannot proceed.';
            return;
        End If;

        If Upper(p_mail_format) = 'TEXT' Then
            v_mail_type := 'Text';
        Else
            v_mail_type := 'HTML';
        End If;

        req_content        := '{
                                "mailTo": [!!MAILTO!!],
                                "mailCC": [!!MAILCC!!],
                                "mailBCC": [!!MAILCC!!],
                                "mailSubject": "!!SUBJECT!!",
                                "mailBody": "!!BODY!!",
                                "mailType": "!!MAILTYPE!!",
                                "mailFrom": "!!MAILPROFILE!!"
                            }'
        ;
        If Trim(p_mail_to) Is Not Null Then
            v_mail_to := format_mail_addr(p_mail_to);
        End If;

        If Trim(p_mail_cc) Is Not Null Then
            v_mail_cc := format_mail_addr(p_mail_cc);
        End If;

        If Trim(p_mail_bcc) Is Not Null Then
            v_mail_bcc := format_mail_addr(p_mail_bcc);
        End If;

        req                := utl_http.begin_request(
            url      => rest_api_url,
            method   => 'POST'
        );
        utl_http.set_header(
            req,
            'user-agent',
            'mozilla/4.0'
        );
        utl_http.set_header(
            req,
            'content-type',
            'application/json'
        );
        v_content_length   := Length('{
                                "mailTo": [' || v_mail_to || '],
                                "mailCC": ['
        || v_mail_cc || '],
                                "mailBCC": [' || v_mail_bcc || '],
                                "mailSubject": "'
        || p_mail_subject || '",
                                "mailBody": "' || p_mail_body || p_mail_body_2 || p_mail_body_3
        || '",
                                "mailType": "' || v_mail_type || '",
                                "mailFrom": "'
        || p_mail_profile || '"
                            }');

        utl_http.set_header(
            req,
            'Content-Length',
            v_content_length
        );
        utl_http.set_header(
            req,
            'Accept',
            '*/*'
        );
        utl_http.write_raw(
            req,
            utl_raw.cast_to_raw('{
                                "mailTo": [' || v_mail_to || '],
                                "mailCC": ['
            || v_mail_cc || '],
                                "mailBCC": [' || v_mail_bcc || '],
                                "mailSubject": "'
            || p_mail_subject || '",
                                "mailBody": "' || p_mail_body || p_mail_body_2 || p_mail_body_3
            || '",
                                "mailType": "' || v_mail_type || '",
                                "mailFrom": "'
            || p_mail_profile || '"
                            }')
        );

        res                := utl_http.get_response(req);
        status_code        := res.status_code;
        reason_phrase      := res.reason_phrase;
        http_version       := res.http_version;
  -- process the response from the HTTP call
        Begin
            Loop
                utl_http.read_line(
                    res,
                    buffer
                );
                dbms_output.put_line(buffer);
                If Length(v_out_msg || buffer) < 4000 Then
                    v_out_msg := v_out_msg || buffer;
                End If;

            End Loop;

            utl_http.end_response(res);
        Exception
            When utl_http.end_of_body Then
                utl_http.end_response(res);
        End;

        If Trim(v_out_msg) Is Null Then
            p_success   := 'KO';
            p_message   := 'Error - Unknown error while executing command.';
            return;
        End If;

        v_out_msg          := Replace(v_out_msg, '"', '');
        v_out_msg          := Substr(v_out_msg, 2, Length(v_out_msg) - 2);
        v_out_msg          := Substr(v_out_msg, 1, Instr(v_out_msg, ',', -1) - 1);

        p_success          := Substr(v_out_msg, -2);
        p_message          := Substr(v_out_msg, Instr(v_out_msg, ':') + 1);
        p_message          := Substr(p_message, 1, Instr(p_message, ',') - 1);

    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End send_api_mail;

End pkg_mail;

/

  GRANT EXECUTE ON "COMMONMASTERS"."PKG_MAIL" TO "TCMPL_AFC" WITH GRANT OPTION;
  GRANT EXECUTE ON "COMMONMASTERS"."PKG_MAIL" TO "ITINV_STK" WITH GRANT OPTION;
  GRANT EXECUTE ON "COMMONMASTERS"."PKG_MAIL" TO "AMS" WITH GRANT OPTION;
  GRANT EXECUTE ON "COMMONMASTERS"."PKG_MAIL" TO "DMS" WITH GRANT OPTION;
  GRANT EXECUTE ON "COMMONMASTERS"."PKG_MAIL" TO "IOT_TCMPL" WITH GRANT OPTION;
  GRANT EXECUTE ON "COMMONMASTERS"."PKG_MAIL" TO "STATIONERY" WITH GRANT OPTION;
  GRANT EXECUTE ON "COMMONMASTERS"."PKG_MAIL" TO "TCMPL_APP_CONFIG" WITH GRANT OPTION;
  GRANT EXECUTE ON "COMMONMASTERS"."PKG_MAIL" TO "TCMPL_HR";
  GRANT EXECUTE ON "COMMONMASTERS"."PKG_MAIL" TO "SELFSERVICE";
  GRANT EXECUTE ON "COMMONMASTERS"."PKG_MAIL" TO "RWM3";
  GRANT EXECUTE ON "COMMONMASTERS"."PKG_MAIL" TO "REMOTEWORKING";
