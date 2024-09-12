--------------------------------------------------------
--  DDL for Package Body PKG_MAIL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."PKG_MAIL" As

    g_crlf Char(2) Default chr(13) || chr(10);

    Function csv_to_table (
        p_list In Varchar2
    ) Return typ_str_tab
        Pipelined
    As
        l_string        Long := p_list || ',';
        l_comma_index   Pls_Integer;
        l_index         Pls_Integer := 1;
    Begin
        Loop
            l_comma_index   := instr(l_string, ',', l_index);
            Exit When l_comma_index = 0;
            Pipe Row ( trim(substr(l_string, l_index, l_comma_index - l_index)) );
            l_index         := l_comma_index + 1;
        End Loop;

        return;
    End csv_to_table;

    Procedure send_mail (
        param_recipient   In   Varchar2,
        param_sender      In   Varchar2,
        param_cc          In   Varchar2,
        param_subject     Varchar2,
        param_body        Varchar2
    ) As

        mail_conn    utl_smtp.connection;
        l_boundary   Varchar2(50) := '----=*#abc1234321cba#*=';
        l_input      Varchar2(4000) := '1,2,3';
        l_count      Binary_Integer;
        l_array      dbms_utility.lname_array;
        Cursor c1 Is
        Select
            column_value email
        From
            Table ( csv_to_table(param_recipient) );

        Type typ_tab Is
            Table Of c1%rowtype;
        v_tab        typ_tab;
        v_email      Varchar2(100);
        v_emails     Varchar2(9000);
    Begin
        If Trim(param_recipient) Is Null Or Trim(param_sender) Is Null Then
            return;
        End If;

        mail_conn   := utl_smtp.open_connection(c_smtp_mail_server, 25);
        utl_smtp.helo(mail_conn, c_smtp_mail_server);
        utl_smtp.mail(mail_conn, param_sender);
        --utl_smtp.rcpt(mail_conn,param_recipient);
        Open c1;
        Fetch c1 Bulk Collect Into v_tab Limit 100;
        For i In 1..v_tab.count Loop
            v_email    := v_tab(i).email;
            utl_smtp.rcpt(mail_conn, v_email);
            v_emails   := v_emails || v_email || ';';
        End Loop;

        utl_smtp.open_data(mail_conn);
        utl_smtp.write_data(mail_conn, 'Date: ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') || utl_tcp.crlf);

        utl_smtp.write_data(mail_conn, 'From: ' || param_sender || utl_tcp.crlf);
        v_emails    := trim(Both ';' From v_emails);
        utl_smtp.write_data(mail_conn, 'To: ' || v_emails || utl_tcp.crlf);
        utl_smtp.write_data(mail_conn, 'Subject: ' || param_subject || utl_tcp.crlf);
        utl_smtp.write_data(mail_conn, 'MIME-Version: 1.0' || utl_tcp.crlf);
        utl_smtp.write_data(mail_conn, 'Content-Type: multipart/alternative; boundary="' || l_boundary || '"' || utl_tcp.crlf || utl_tcp
        .crlf);

        utl_smtp.write_data(mail_conn, '--' || l_boundary || utl_tcp.crlf);
        utl_smtp.write_data(mail_conn, 'Content-Type: text/plain; charset="iso-8859-1"' || utl_tcp.crlf || utl_tcp.crlf);

        utl_smtp.write_data(mail_conn, param_body);
        utl_smtp.write_data(mail_conn, utl_tcp.crlf || utl_tcp.crlf);
        utl_smtp.write_data(mail_conn, '--' || l_boundary || '--' || utl_tcp.crlf);

        utl_smtp.close_data(mail_conn);
        utl_smtp.quit(mail_conn);
    End;

End;

/
