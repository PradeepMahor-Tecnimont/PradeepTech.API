--------------------------------------------------------
--  DDL for Package Body SS_MAIL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SS_MAIL" as

  procedure set_msg(param_obj_id varchar2, param_apprl_desc varchar2, param_obj_name varchar2 ) as
  begin
  --Discard
        --pkg_var_sub := replace(c_subject,'null' || chr(38) || '',c_obj_nm_tr);
        --pkg_var_msg := replace(c_message,'null' || chr(38) || '',c_obj_nm_tr);
    
    pkg_var_sub := replace(pkg_var_sub,'null' || chr(38) || '',param_apprl_desc);
    pkg_var_msg := replace(pkg_var_msg,'null' || chr(38) || '',param_apprl_desc);
    
    --pkg_var_msg := replace(pkg_var_msg,'null' || chr(38) || '',param_tr_id);
    --pkg_var_sub := replace(pkg_var_sub,'null' || chr(38) || '',param_tr_id);
  End;


  procedure set_new_leave_app_subject(param_empno in varchar2, param_emp_name in varchar2) as
  begin
     pkg_var_sub := replace(c_leave_app_subject,c_empno,param_empno);
     pkg_var_sub := replace(pkg_var_sub ,c_emp_name,param_emp_name);
  end;
  
  procedure set_new_leave_app_body
      (
        param_empno varchar2,
        param_emp_name varchar2,
        param_leave_period number,
        param_app_no varchar2
      ) 
  as
        v_leave_period number;
  begin
        v_leave_period := param_leave_period / 8;
        pkg_var_msg := replace(c_leave_app_msg,'');
        pkg_var_msg := replace(pkg_var_msg, c_app_no,param_app_no);
        pkg_var_msg := replace(pkg_var_msg, c_emp_name,param_emp_name);
        pkg_var_msg := replace(pkg_var_msg, c_empno, param_empno);
        pkg_var_msg := replace(pkg_var_msg, c_leave_period, param_leave_period);
  end;


    PROCEDURE SEND_EMAIL_2_USER
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
        
            
    END SEND_EMAIL_2_USER;


  procedure send_msg as
  begin
    /* TODO implementation required */
    null;
  end send_msg;

  procedure send_msg_new_leave_app(param_app_no varchar2, param_success out number, param_message out varchar2) as
      v_empno varchar2(5);
      v_mngr varchar2(5);
      v_mngr_email varchar2(60);
      v_lead_empno varchar2(5);
      v_emp_name varchar2(60);
      v_leave_period number;
  begin
      Select empno, leaveperiod/8, LEAD_APPRL_EMPNO into v_empno, v_leave_period, v_lead_empno from ss_leaveapp where app_no = param_app_no;
      
      select name, mngr  into v_emp_name, v_mngr from ss_emplmast where empno = v_empno;
      if v_lead_empno <> 'None' Then
          v_mngr := v_lead_empno;
          --v_mngr := '02320';
      End if;
      
      select email into v_mngr_email from ss_emplmast where empno = v_mngr;
      set_new_leave_app_subject(v_empno,v_emp_name);
      set_new_leave_app_body(v_empno, v_emp_name, v_leave_period, param_app_no );
      send_email_2_user(v_mngr_email);
  exception
      when others then
          param_success := ss.failure;
          param_message := 'Error : ' || sqlcode || ' - ' || sqlerrm;
  end;


    procedure send_mail(param_to_mail_id varchar2, param_subject varchar2, param_body varchar2,
          param_success out number, param_message out varchar2) as
          
          l_mail_conn   UTL_SMTP.connection;
          l_boundary    VARCHAR2(50) := '----=*#abc1234321cba#*=';
      begin
            

            l_mail_conn := UTL_SMTP.open_connection(c_smtp_mail_server, 25);
            UTL_SMTP.helo(l_mail_conn, c_smtp_mail_server);
            UTL_SMTP.mail(l_mail_conn, c_sender_mail_id);
            utl_smtp.rcpt(l_mail_conn, param_to_mail_id);
            UTL_SMTP.open_data(l_mail_conn);
            UTL_SMTP.write_data(l_mail_conn, 'Date: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'To: ' || param_to_mail_id || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'From: ' || c_sender_mail_id || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'Subject: ' || param_subject || UTL_TCP.crlf);
          
            UTL_SMTP.write_data(l_mail_conn, 'MIME-Version: 1.0' || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'Content-Type: multipart/alternative; boundary="' || l_boundary || '"' || UTL_TCP.crlf || UTL_TCP.crlf);
          
          
            UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'Content-Type: text/plain; charset="iso-8859-1"' || UTL_TCP.crlf || UTL_TCP.crlf);
        
            UTL_SMTP.write_data(l_mail_conn, replace(param_body, '!nuLine!',UTL_TCP.crlf));
            UTL_SMTP.write_data(l_mail_conn, UTL_TCP.crlf || UTL_TCP.crlf);
        
            UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || '--' || UTL_TCP.crlf);
            UTL_SMTP.close_data(l_mail_conn);
          
            UTL_SMTP.quit(l_mail_conn);
            param_success := ss.success;
            param_message := 'Email was successfully sent.';
    /*exception
        when others then
            param_success := ss.failure;
            param_message := 'Error : ' || sqlcode || ' - ' || sqlerrm;*/
      end;
      


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



    procedure send_html_mail(param_to_mail_id varchar2, param_subject varchar2, param_body varchar2,
          param_success out number, param_message out varchar2) as
          
          l_mail_conn   UTL_SMTP.connection;
          l_boundary    VARCHAR2(50) := '----=*#abc1234321cba#*=';
      begin
            

            l_mail_conn := UTL_SMTP.open_connection(c_smtp_mail_server, 25);
            UTL_SMTP.helo(l_mail_conn, c_smtp_mail_server);
            UTL_SMTP.mail(l_mail_conn, c_sender_mail_id);
            utl_smtp.rcpt(l_mail_conn, param_to_mail_id);
            UTL_SMTP.open_data(l_mail_conn);
            UTL_SMTP.write_data(l_mail_conn, 'Date: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'To: ' || param_to_mail_id || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'From: ' || c_sender_mail_id || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'Subject: ' || param_subject || UTL_TCP.crlf);
          
            UTL_SMTP.write_data(l_mail_conn, 'MIME-Version: 1.0' || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'Content-Type: multipart/alternative; boundary="' || l_boundary || '"' || UTL_TCP.crlf || UTL_TCP.crlf);
          
          
            UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || UTL_TCP.crlf);
            UTL_SMTP.write_data(l_mail_conn, 'Content-Type: text/html; charset="iso-8859-1"' || UTL_TCP.crlf || UTL_TCP.crlf);
        
            UTL_SMTP.write_data(l_mail_conn, replace(param_body, '!nuLine!',UTL_TCP.crlf));
            UTL_SMTP.write_data(l_mail_conn, UTL_TCP.crlf || UTL_TCP.crlf);
        
            UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || '--' || UTL_TCP.crlf);
            UTL_SMTP.close_data(l_mail_conn);
          
            UTL_SMTP.quit(l_mail_conn);
            param_success := ss.success;
            param_message := 'Email was successfully sent.';
    exception
        when others then
            param_success := ss.failure;
            param_message := 'Error : ' || sqlcode || ' - ' || sqlerrm;
      end;
      

end ss_mail;

/
