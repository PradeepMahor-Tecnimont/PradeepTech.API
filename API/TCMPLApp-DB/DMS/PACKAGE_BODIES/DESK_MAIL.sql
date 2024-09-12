--------------------------------------------------------
--  DDL for Package Body DESK_MAIL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "DESK_MAIL" as

  procedure send_mail
  (
    param_recipient in varchar2,
    param_sender in varchar2,
    param_cc in varchar2,
    param_subject varchar2,
    param_body varchar2
  ) as
  
  mail_conn   UTL_SMTP.connection;
  l_boundary    VARCHAR2(50) := '----=*#abc1234321cba#*=';
  
  begin 
  
    If trim(param_recipient) is Null or trim(param_sender) is Null Then
      return;
    End If;

    mail_conn := UTL_SMTP.open_connection(c_smtp_mail_server, 25);
    UTL_SMTP.helo(mail_conn, c_smtp_mail_server);
    UTL_SMTP.mail(mail_conn, param_sender);
    utl_smtp.rcpt(mail_conn, param_recipient);
    UTL_SMTP.open_data(mail_conn);
    UTL_SMTP.write_data(mail_conn, 'Date: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.crlf);
    UTL_SMTP.write_data(mail_conn, 'To: ' || param_recipient || UTL_TCP.crlf);    
    UTL_SMTP.write_data(mail_conn, 'From: ' || param_sender || UTL_TCP.crlf);
    UTL_SMTP.write_data(mail_conn, 'Subject: ' || param_subject || UTL_TCP.crlf);
    UTL_SMTP.write_data(mail_conn, 'MIME-Version: 1.0' || UTL_TCP.crlf);
    UTL_SMTP.write_data(mail_conn, 'Content-Type: multipart/alternative; boundary="' || l_boundary || '"' || UTL_TCP.crlf || UTL_TCP.crlf);    
    UTL_SMTP.write_data(mail_conn, '--' || l_boundary || UTL_TCP.crlf);
    UTL_SMTP.write_data(mail_conn, 'Content-Type: text/plain; charset="iso-8859-1"' || UTL_TCP.crlf || UTL_TCP.crlf);    
    UTL_SMTP.write_data(mail_conn, param_body);
    UTL_SMTP.write_data(mail_conn, UTL_TCP.crlf || UTL_TCP.crlf);    
    UTL_SMTP.write_data(mail_conn, '--' || l_boundary || '--' || UTL_TCP.crlf);
    UTL_SMTP.close_data(mail_conn);    
    UTL_SMTP.quit(mail_conn);

  end send_mail;
end desk_mail;

/
