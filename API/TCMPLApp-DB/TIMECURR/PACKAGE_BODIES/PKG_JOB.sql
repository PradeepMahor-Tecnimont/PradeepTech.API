--------------------------------------------------------
--  DDL for Package Body PKG_JOB
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."PKG_JOB" AS

    function rep_srv_nm return varchar2 AS
  BEGIN
    -- TODO: Implementation required for function PKG_ITDL.rep_srv_nm
    RETURN c_rep_srv_nm;
  END rep_srv_nm;

  function rep_srv_url return varchar2 AS
  BEGIN
    -- TODO: Implementation required for function PKG_ITDL.rep_srv_url
    RETURN c_rep_srv_url;
  END rep_srv_url;

  function rep_env_id return varchar2 AS
  BEGIN
    -- TODO: Implementation required for function PKG_ITDL.rep_env_id
    RETURN c_rep_env_id;
  END rep_env_id;
  
  function apps_server return varchar2 AS
    BEGIN
    -- TODO: Implementation required for function PKG_ITDL.rep_env_id
    RETURN c_apps_server;
  END apps_server;
  
  PROCEDURE SEND_TEST_EMAIL_2_USER
        (
          param_to_mail_id IN VARCHAR2 
        ) AS 
          l_mail_conn   UTL_SMTP.connection;
          l_boundary    VARCHAR2(50) := '----=*#abc1234321cba#*=';
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
            UTL_SMTP.write_data(l_mail_conn, 'Subject: ' || 'Test by Anita' || UTL_TCP.crlf);
          
            UTL_SMTP.write_data(l_mail_conn, 'MIME-Version: 1.0' || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'Content-Type: multipart/alternative; boundary="' || l_boundary || '"' || UTL_TCP.crlf || UTL_TCP.crlf);
          
          
            UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'Content-Type: text/plain; charset="iso-8859-1"' || UTL_TCP.crlf || UTL_TCP.crlf);
        
            UTL_SMTP.write_data(l_mail_conn, 'Test By Anita');
            UTL_SMTP.write_data(l_mail_conn, UTL_TCP.crlf || UTL_TCP.crlf);
        
            UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || '--' || UTL_TCP.crlf);
            UTL_SMTP.close_data(l_mail_conn);
          
            UTL_SMTP.quit(l_mail_conn);
        
            
    END SEND_TEST_EMAIL_2_USER;
    
    
  procedure send_mail_2_users   AS 
          l_mail_conn   UTL_SMTP.connection;
          l_boundary    VARCHAR2(50) := '----=*#abc1234321cba#*=';
          type t_nm is table of varchar2(60) index by PLS_INTEGER;
          var_array t_nm;
          l_email_to    varchar2(60);
    begin 

pkg_var_email_id_list := 'a.kalaskar@ticb.com';
pkg_var_sub := 'sub';

 pkg_var_msg := 'msg';

            l_mail_conn := UTL_SMTP.open_connection(c_smtp_mail_server, 25);
            UTL_SMTP.helo(l_mail_conn, c_smtp_mail_server);
            UTL_SMTP.mail(l_mail_conn, c_sender_mail_id);
            pkg_var_email_id_list := trim(trailing ',' from pkg_var_email_id_list ) || ',';
            
            select REGEXP_SUBSTR(pkg_var_email_id_list,'[^,]+',1,level) BULK COLLECT into var_array from dual
              connect by level <= (select regexp_count(pkg_var_email_id_list,',') from dual);
 
            for i in 1..var_array.last loop
                if var_array(i) is not null then
                    if i = 1 then
                        l_email_to := var_array(i);
                    end if;
                    utl_smtp.rcpt(l_mail_conn,var_array(i));
                end if;
            end loop;

            UTL_SMTP.open_data(l_mail_conn);
            UTL_SMTP.write_data(l_mail_conn, 'Date: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'To: ' || l_email_to || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'From: ' || c_sender_mail_id || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'Subject: ' || pkg_var_sub || UTL_TCP.crlf);
          
            UTL_SMTP.write_data(l_mail_conn, 'MIME-Version: 1.0' || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'Content-Type: multipart/alternative; boundary="' || l_boundary || '"' || UTL_TCP.crlf || UTL_TCP.crlf);
          
          
            UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'Content-Type: text/plain; charset="iso-8859-1"' || UTL_TCP.crlf || UTL_TCP.crlf);
        
            UTL_SMTP.write_data(l_mail_conn, pkg_var_msg);
            UTL_SMTP.write_data(l_mail_conn, UTL_TCP.crlf || UTL_TCP.crlf);
        
            UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || '--' || UTL_TCP.crlf);
            UTL_SMTP.close_data(l_mail_conn);
          
            UTL_SMTP.quit(l_mail_conn);
        
            
    END SEND_MAIL_2_USERS;


END PKG_JOB;

/
