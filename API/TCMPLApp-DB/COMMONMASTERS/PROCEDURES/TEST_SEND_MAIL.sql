--------------------------------------------------------
--  DDL for Procedure TEST_SEND_MAIL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "COMMONMASTERS"."TEST_SEND_MAIL" As

    req             utl_http.req;
    res             utl_http.resp;
    rest_api_url    Varchar2(4000) := 'http://tplapps02.ticb.comp/SendMailAPI/api/SendEMailMethod';
    name            Varchar2(4000);
    buffer          Varchar2(4000);
    req_content     Varchar2(4000);
    status_code     Number;
    reason_phrase   Varchar2(256);
    http_version    Varchar2(64);
Begin
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
    req             := utl_http.begin_request(
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
    utl_http.set_header(
        req,
        'Content-Length',
        Length(req_content)
    );
    utl_http.set_header(
        req,
        'Accept',
        '*/*'
    );
    utl_http.write_raw(
        req,
        utl_raw.cast_to_raw(req_content)
    );
    res             := utl_http.get_response(req);
    status_code     := res.status_code;
    reason_phrase   := res.reason_phrase;
    http_version    := res.http_version;
  -- process the response from the HTTP call
    Begin
        Loop
            utl_http.read_line(
                res,
                buffer
            );
            dbms_output.put_line(buffer);
        End Loop;

        utl_http.end_response(res);
    Exception
        When utl_http.end_of_body Then
            utl_http.end_response(res);
    End;

End test_send_mail;

/
