--------------------------------------------------------
--  DDL for Package Body PKG_SENDMAIL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."PKG_SENDMAIL" AS 

  procedure send_mail_2_user  (
          param_to_mail_id IN VARCHAR2 ,
          param_emp_type in varchar2
        ) AS 
          l_mail_conn   UTL_SMTP.connection;
          l_boundary    VARCHAR2(50) := '----=*#abc1234321cba#*=';
    BEGIN
         -- param_to_mail_id := 'A.kalaskar@ticb.com';
            If trim(param_to_mail_id) is Null Then
                return;
            End If;
            
            l_mail_conn := UTL_SMTP.open_connection(c_smtp_mail_server, 25);
            UTL_SMTP.helo(l_mail_conn, c_smtp_mail_server);
            UTL_SMTP.mail(l_mail_conn, c_sender_mail_id);
            
            if param_emp_type = 'S' then
              utl_smtp.rcpt(l_mail_conn, param_to_mail_id);
              utl_smtp.rcpt(l_mail_conn,'A.kalaskar@ticb.com');
              utl_smtp.rcpt(l_mail_conn,'D.Desai@ticb.com');
              utl_smtp.rcpt(l_mail_conn,'S.Poojary@ticb.com');
              utl_smtp.rcpt(l_mail_conn,'S.Mistry@ticb.com');
              utl_smtp.rcpt(l_mail_conn,'S.B.Salvi@ticb.com');
              
            else
              --utl_smtp.rcpt(l_mail_conn,'A.kalaskar@ticb.com');
              utl_smtp.rcpt(l_mail_conn,'D.Desai@ticb.com');
              --utl_smtp.rcpt(l_mail_conn,'S.Poojary@ticb.com');
              --utl_smtp.rcpt(l_mail_conn,'S.Mistry@ticb.com');
              --utl_smtp.rcpt(l_mail_conn,'S.B.Salvi@ticb.com');
              utl_smtp.rcpt(l_mail_conn,'d.bhavsar@ticb.com');
            end if;
            
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
        
            
    END SEND_MAIL_2_USER;


  procedure send_mail_2_users   AS 
          l_mail_conn   UTL_SMTP.connection;
          l_boundary    VARCHAR2(50) := '----=*#abc1234321cba#*=';
          type t_nm is table of varchar2(60) index by PLS_INTEGER;
          var_array t_nm;
          l_email_to    varchar2(60);
    begin 

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



  procedure compose_mail as
  begin
      pkg_var_msg := c_msg;
      pkg_var_sub := c_subject;
      
      pkg_var_msg := replace(pkg_var_msg , c_empno,                      pkg_var_empno);
      pkg_var_msg := replace(pkg_var_msg , c_lastname,                   pkg_var_lastname);
      pkg_var_msg := replace(pkg_var_msg , c_firstname,                  pkg_var_firstname);
      pkg_var_msg := replace(pkg_var_msg , c_middlename,                 pkg_var_middlename);
      pkg_var_msg := replace(pkg_var_msg , c_doj,                        to_char(pkg_var_doj,'dd-Mon-yyyy'));
      If pkg_var_contract_end_date is not null Then
        pkg_var_msg := replace(pkg_var_msg , c_contract_end_date,          to_char(pkg_var_contract_end_date,'dd-Mon-yyyy'));
      else
        pkg_var_msg := replace(pkg_var_msg , c_contract_end_date,          ' ');
      end if;
      pkg_var_msg := replace(pkg_var_msg , c_parent,                     pkg_var_parent);
      pkg_var_msg := replace(pkg_var_msg , c_assign,                     pkg_var_assign);
      pkg_var_msg := replace(pkg_var_msg , c_location,                   pkg_var_location);
      pkg_var_msg := replace(pkg_var_msg , c_emptype,                    pkg_var_emptype);
      
      
      pkg_var_sub := replace(pkg_var_sub, c_empno,                      pkg_var_empno);
      pkg_var_sub := replace(pkg_var_sub, c_name,                       pkg_var_name);
      if trim(pkg_var_emptype) = 'SUBCONTRACT' then
          pkg_var_sub := replace(pkg_var_sub,'Step 1/3','Step 1/1');
      end if;
  end;



  procedure send_new_employee_mail as 
      cursor c1 is 
         SELECT EMPNO, LASTNAME, FIRSTNAME, MIDDLENAME, DOJ, CONTRACT_END_DATE, PARENT, ASSIGN,
          case  LOCATION 
            when 'I' THEN 'INDIAN SITES'
            WHEN 'H' THEN 'HEAD OFFICE'
            WHEN 'A' THEN 'ABROAD SITES'
            WHEN 'E' THEN ' '
            ELSE ' ' END  AS LOCATION,
          CASE EMPTYPE
            WHEN 'R' THEN 'REGULAR'
            WHEN 'S' THEN 'SUBCONTRACT'
            WHEN 'C' THEN 'CONTRACT'
            ELSE '' END EMPTYPE,
          MODIFIED_ON,  MAIL_SENT, LOG_KEY, NAME
          FROM EMPLMAST_NEW_EMP_LOG WHERE  nvl(mail_sent,0) = 0;

      --select * from emplmast_new_emp_log where nvl(mail_sent,0) = 0;
  begin
        
        for c2 in c1 loop
            pkg_var_empno                   := c2.empno;
            pkg_var_name                    := c2.name;
            pkg_var_lastname                := c2.lastname;
            pkg_var_firstname               := c2.firstname;
            pkg_var_middlename              := c2.middlename;
            pkg_var_doj                     := c2.doj;
            pkg_var_contract_end_date       := c2.contract_end_date;
            pkg_var_parent                  := c2.parent;
            pkg_var_assign                  := c2.assign;
            pkg_var_location                := c2.location;
            pkg_var_emptype                 := c2.emptype;
            
            compose_mail;
            
              if trim(pkg_var_emptype) = 'SUBCONTRACT' then
                  pkg_var_email_id_list   := --'a.kalaskar@ticb.com,' 
                                            --'n.pereira@ticb.com'  || ','
                                            'r.kamtekar@tecnimont.in' || ','
                                          ||  'd.desai@tecnimont.in'    || ','
                                          ||  's.poojary@tecnimont.in'  || ','
                                          --||  'd.bhavsar@ticb.com'  || ','
                                          ||  'HelpDeskIT@tecnimont.in' || ','
                                          ||  's.mistry@tecnimont.in'   ;
                                      --    ||  's.b.salvi@tecnimont.in' ;
              else
                  pkg_var_email_id_list   :=  --'a.kalaskar@ticb.com,'
                                          'd.desai@tecnimont.in';--    || ','
                                          --||  'HelpDeskIT@ticb.com' || ','
                                          --||  'n.pereira@ticb.com'  || ','
                                          --||  'd.bhavsar@ticb.com'  ;
              end if;
              send_mail_2_users;
              UPDATE EMPLMAST_NEW_EMP_LOG SET MAIL_SENT = 1 WHERE trim(LOG_KEY) = trim(C2.LOG_KEY);
              commit;
        end loop;
    
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

    function smtp_mail_server return varchar2 as
    begin
      return c_smtp_mail_server;
    end;
    
    function sender_mail_id return varchar2 as
    begin
      return c_sender_mail_id;
    end;


END PKG_SENDMAIL;

/
