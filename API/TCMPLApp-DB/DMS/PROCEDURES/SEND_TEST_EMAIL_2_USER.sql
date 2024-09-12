--------------------------------------------------------
--  DDL for Procedure SEND_TEST_EMAIL_2_USER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SEND_TEST_EMAIL_2_USER" 
        (
          param_to_mail_id IN VARCHAR2 
        ) AS 
          l_mail_conn   UTL_SMTP.connection;
          l_boundary    VARCHAR2(50) := '----=*#abc1234321cba#*=';
        c_smtp_mail_server constant varchar2(60) := 'ticbexhcn1.ticb.comp';
        c_sender_mail_id constant varchar2(60) := 'selfservice@ticb.com';
        c_web_server constant varchar2(60) :=  'http://ticbapps.ticb.comp:80';
    BEGIN
            
            If trim(param_to_mail_id) is Null Then
                return;
            End If;
        
            l_mail_conn := UTL_SMTP.open_connection(c_smtp_mail_server, 25);
            UTL_SMTP.helo(l_mail_conn, c_smtp_mail_server);
            UTL_SMTP.mail(l_mail_conn, c_sender_mail_id);
            utl_smtp.rcpt(l_mail_conn, param_to_mail_id);
            UTL_SMTP.open_data(l_mail_conn);
            UTL_SMTP.write_data(l_mail_conn, 'Date: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'To: ' || param_to_mail_id || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'From: ' || c_sender_mail_id || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'Subject: ' || 'Test by Deven' || UTL_TCP.crlf);
          
            UTL_SMTP.write_data(l_mail_conn, 'MIME-Version: 1.0' || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'Content-Type: multipart/alternative; boundary="' || l_boundary || '"' || UTL_TCP.crlf || UTL_TCP.crlf);
          
          
            UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'Content-Type: text/plain; charset="iso-8859-1"' || UTL_TCP.crlf || UTL_TCP.crlf);
        
            UTL_SMTP.write_data(l_mail_conn, 'Test By Deven');
            UTL_SMTP.write_data(l_mail_conn, UTL_TCP.crlf || UTL_TCP.crlf);
        
            UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || '--' || UTL_TCP.crlf);
            UTL_SMTP.close_data(l_mail_conn);
          
            UTL_SMTP.quit(l_mail_conn);
        
            
    END SEND_TEST_EMAIL_2_USER;

/
