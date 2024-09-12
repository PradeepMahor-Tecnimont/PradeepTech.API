--------------------------------------------------------
--  DDL for Package Body PKG_CV
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."PKG_CV" as
 PROCEDURE send_mail_with_Attach (p_to          IN VARCHAR2,
                                             p_from        IN VARCHAR2,
                                             p_subject     IN VARCHAR2,
                                             p_text_msg    IN VARCHAR2 DEFAULT NULL,
                                             p_attach_name IN VARCHAR2 DEFAULT NULL,
                                             p_attach_mime IN VARCHAR2 DEFAULT NULL,
                                             p_attach_clob IN CLOB DEFAULT NULL,
                                             p_smtp_host   IN VARCHAR2,
                                             p_smtp_port   IN NUMBER DEFAULT 25,
                                             p_success     OUT varchar2,
                                             p_message     OUT varchar2);
                                             
/*  procedure send_html_mail(param_to_mail_id varchar2, param_subject varchar2, param_body varchar2,
      param_success out varchar2, param_message out varchar2) ;*/
  procedure generate_html(param_mngr_empno varchar2, param_mngr_email varchar2) ;


 function rep_srv_nm return varchar2 as
  begin
    /* TODO implementation required */
    return c_rep_srv_nm;
  end rep_srv_nm;

  function rep_srv_url return varchar2 as
  begin
    /* TODO implementation required */
    return c_rep_srv_url;
  end rep_srv_url;

  function rep_env_id return varchar2 as
  begin
    /* TODO implementation required */
    return c_rep_env_id;
  end rep_env_id;


  procedure update_CV as 
      cursor c1 is select a.empno from cv_emplmast a, emplmast b
        where a.empno = b.empno and b.status = 1 and b.emptype = 'R';-- and a.empno in ('02320','02321') ;
      v_dob         date;
      v_doj         date;
      v_count       number;
  begin
      for c2 in c1 loop
          select dob, doj into v_dob, v_doj from emplmast where empno = c2.empno;
          select count(*) into v_count from commonmasters.emp_details where empno = c2.empno;
          If v_count = 0 then
            continue;
          end if;
          update cv_emplmast set 
          ( 
              birthdate		, joiningdate,
              per_add1 	, per_add2 	, per_add3 	, per_state ,	 per_pin		, per_telno	,
              
              res_add1 	, res_add2 	, res_add3 	, res_state ,	 res_pin 	,	 res_telno	,
              
              nationality 	,
              
              passportNo 	, passportIssueDate , PassportExpDate 	, PassportIssuePlace 	
          ) 
          =
          (
              Select v_dob, v_doj,
              p_add_1, p_add_2, p_add_3, p_add_4, p_pincode, p_phone, 
              R_ADD_1, R_ADD_2, R_ADD_3, R_ADD_4,  R_PINCODE, PHONE_RES,
              nationality, 
              PASSPORT_NO, ISSUE_DATE, EXPIRY_DATE, PASSPORT_ISSUED_AT 
              from commonmasters.emp_details 
              where empno = c2.empno 
          )
          Where empno = c2.empno ;
      end loop;
      commit;
  end update_CV;



      function cv_approved_by_hod return number is
      begin
        return n_cv_approved_by_hod;
      end;

      function cv_rejected_by_hod return number is
      begin
        return n_cv_rejected_by_hod;
      end;
      function cv_pending_by_hod return number is
      begin
        return n_cv_pending_by_hod;
      end;


        
      function cv_log_status(param_lock number, param_unlock number, param_hod_apprl number) return varchar2 is
        v_ret_val varchar2(60);
      begin
      If nvl(param_hod_apprl,n_cv_pending_by_hod ) <> n_cv_pending_by_hod Then
          v_ret_val := case param_hod_apprl
                    when n_cv_approved_by_hod then c_cv_approved_by_hod
                    when n_cv_rejected_by_hod then c_cv_rejected_by_hod
                    else 'ERROR'
                  end;
          return v_ret_val;
      ElsIf nvl(param_hod_apprl,n_cv_pending_by_hod ) = n_cv_pending_by_hod Then
          If nvl(param_lock,0) = 1 Then
              return c_cv_locked;
          Else
              return c_cv_unlocked;
          End If;
      end if;
      end;

      function cv_current_status(param_unlock_date date, param_lock_date date, param_approval_date date) return varchar2 is
          v_first_May date := add_months(trunc(add_months(sysdate,-3),'YYYY'),4);
      begin
        If param_unlock_date is null or 
              Greatest(nvl(param_unlock_date,sysdate-50000) , nvl(param_lock_date,sysdate-50000) , nvl(param_approval_date,sysdate-50000), v_first_may ) = v_first_may
            Then
            return 'CV Not Updated';
        End If;
        If param_unlock_date is not null or param_lock_date is not null or param_approval_date is not null then
          If Greatest(nvl(param_unlock_date,sysdate-50000) , nvl(param_lock_date,sysdate-50000) , nvl(param_approval_date,sysdate-50000) ) = param_approval_date Then
              return 'Approved';
          End If;
          If Greatest(nvl(param_unlock_date,sysdate-50000) , nvl(param_lock_date,sysdate-50000) , nvl(param_approval_date,sysdate-50000) ) = param_lock_date Then
              return 'Pending For Approval';
          End If;
          If Greatest(nvl(param_unlock_date,sysdate-50000) , nvl(param_lock_date,sysdate-50000) , nvl(param_approval_date,sysdate-50000) ) = param_unlock_date Then
              return 'CV Not Posted';
          End If;
        End If;
        /*
        If param_unlock_date is not null and param_lock_date is null and param_approval_date is null then
          return 'CV Not Posted';
        End If;
        */
        exception
          when others then return '';
      end;
      
      procedure send_notification as
          cursor cur_mngr is 
            select empno,name, email from emplmast where status = 1 and empno in 
            (
                Select emp_hod from emplmast where status=1 union select mngr from emplmast
                WHERE status = 1 
            );
      begin
          for c1 in cur_mngr loop
            generate_html(c1.empno,c1.email);
          end loop;

      End;
      
      procedure test_notificaton as
      begin
        generate_html('01412','d.bhavsar@ticb.com');
      end;
      
      
      
        procedure generate_html(param_mngr_empno varchar2, param_mngr_email varchar2) as
          l_xmltype XMLTYPE;
          lHTMLOutput xmltype;
          lXSL         CLOB;
          lRetVal      CLOB;
          param_success varchar2(60);
          param_message varchar2(200);
          v_subject varchar2(200) := 'CV Status of Employees Reporting to you.';
        begin
          if param_mngr_email is null then
                      send_mail_with_Attach(p_to          => 'd.bhavsar@ticb.com',
                                            p_from        => pkg_sendmail.sender_mail_id,
                                            p_subject     => 'CV Notification Error',
                                            p_text_msg    => 'CV Email Notification not send to -- ' || param_mngr_empno,
                                            p_attach_name => '',
                                            p_attach_mime => 'text/plain',
                                            p_attach_clob => null,
                                            p_smtp_host   => pkg_sendmail.smtp_mail_server,
                                            p_smtp_port   => 25,
                                            p_success     => param_success,
                                            p_message     => param_message);
            return;
          End If;
          l_xmltype := dbms_xmlgen.getxmltype(
              'select empno,name,pkg_cv.cv_current_status(nvl(Last_Unlocked,nvl(last_locked,last_hod_approval))  , 
                  nvl(last_locked,last_hod_approval) ,Last_Hod_Approval) Current_Status,
                  nvl(Last_Unlocked,nvl(last_locked,last_hod_approval)) last_unlocked , 
                  nvl(last_locked,last_hod_approval) last_locked,Last_Hod_Approval, Emp_Status from ( 
                select * from (
                  with emp_list as
                    (SELECT EMPNO, name,
                        case
                        when parent = ''' || '0232' || ''' Then ''' || 'On Deputation' || '''
                        when parent = ''' || '0289' || ''' Then ''' || 'On Deputation' || '''
                        when parent = ''' || '0290' || ''' Then ''' || 'On Deputation' || '''
                        when assign = ''' || '0245' || ''' Then ''' || 'On Deputation' || ''' 
                        when assign = ''' || '0198' || ''' Then ''' || 'On Deputation' || ''' 
                        when assign = ''' || '0232' || ''' Then ''' || 'On Deputation' || ''' 
                        when assign = ''' || '0236' || ''' Then ''' || 'On Deputation' || ''' 
                        when assign = ''' || '0238' || ''' Then ''' || 'On Deputation' || ''' 
                        when assign = ''' || '0289' || ''' Then ''' || 'On Deputation' || ''' 
                        when assign = ''' || '0290' || ''' Then ''' || 'On Deputation' || ''' 
                        when assign = ''' || '0291' || ''' Then ''' || 'On Deputation' || ''' 
                        when assign = ''' || '0292' || ''' Then ''' || 'On Deputation' || ''' 
                        Else null End Emp_Status
                    FROM EMPLMAST WHERE STATUS=1 AND (EMPTYPE=''' || 'R' || ''' Or EMPTYPE=''' || 'C' || ''' )
                                    AND PARENT <> ''' || '0187' || ''' and (mngr = ''' || Trim(param_mngr_empno) || ''' Or emp_hod =  ''' || trim(param_mngr_empno) || ''' )
                    )
                  SELECT b.EMPNO,b.name, PKG_CV.cv_log_status(CV_LOCK, CV_UNLOCK,CV_HOD_APPRL) CV_STATUS,MODIFIED_ON,Emp_Status FROM CV_LOG a, emp_list b
                  WHERE a.EMPNO(+) = b.empno
                ) pivot ( max(modified_on) 
                  for (cv_status) 
                  in (''' || 'UnLocked' || ''' as Last_Unlocked, ''' || 'Locked' || ''' as last_locked, ''' || 'Approved By HoD' || ''' as Last_Hod_Approval )
                  ) order by empno) '
                    );
          if l_xmlType is null Then
              return;
          End If;
          lXSL := lXSL || q'[<?xml version="1.0" encoding="ISO-8859-1"?>]';
          lXSL := lXSL || q'[<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">]';
          lXSL := lXSL || q'[ <xsl:output method="html"/>]';
          lXSL := lXSL || q'[ <xsl:template match="/">]';
          lXSL := lXSL || q'[ <html>]';
          lXSL := lXSL || q'[  <body>]';
          lXSL := lXSL || q'[  <h3>Status of employees reporting to you as given below:</h3>]';
          lXSL := lXSL || q'[   <table border="1">]';
          lXSL := lXSL || q'[    <tr bgcolor="Beige">]';
          lXSL := lXSL || q'[       <th>EmpNo</th>]';
          lXSL := lXSL || q'[       <th>Name</th>]';
          lXSL := lXSL || q'[       <th>Current_Status</th>]';
          lXSL := lXSL || q'[       <th>Last_Unlocked</th>]';
          lXSL := lXSL || q'[       <th>Last_Posted</th>]';
          lXSL := lXSL || q'[       <th>Last_HoD_Apprl</th>]';
          lXSL := lXSL || q'[       <th>Emp_Status</th>]';
          lXSL := lXSL || q'[     </tr>]';
          lXSL := lXSL || q'[     <xsl:for-each select="/ROWSET/*">]';
          lXSL := lXSL || q'[      <tr>    ]';
          lXSL := lXSL || q'[        <td><xsl:value-of select="EMPNO"/> </td>]';
          lXSL := lXSL || q'[        <td><xsl:value-of select="NAME"/> </td>]';
          lXSL := lXSL || q'[        <td><xsl:value-of select="CURRENT_STATUS"/> </td>]';
          lXSL := lXSL || q'[        <td><xsl:value-of select="LAST_UNLOCKED"/> </td>]';
          lXSL := lXSL || q'[        <td><xsl:value-of select="LAST_LOCKED"/> </td>]';
          lXSL := lXSL || q'[        <td><xsl:value-of select="LAST_HOD_APPROVAL"/> </td>]';
          lXSL := lXSL || q'[        <td><xsl:value-of select="EMP_STATUS"/> </td>]';
          lXSL := lXSL || q'[      </tr>]';
          lXSL := lXSL || q'[     </xsl:for-each>]';
          lXSL := lXSL || q'[   </table>]';
          lXSL := lXSL || q'[  </body>]';
          lXSL := lXSL || q'[ </html>]';
          lXSL := lXSL || q'[ </xsl:template>]';
          lXSL := lXSL || q'[</xsl:stylesheet>]';
          -- XSL transformation to convert XML to HTML --
          
          lHTMLOutput := l_xmltype.transform(XMLType(lXSL));
          -- convert XMLType to Clob --
          lRetVal := lHTMLOutput.getClobVal();
          --lRetVal := replace(lRetVal,'_x0027_','');
          --SEND_html_MAIL(param_mngr_email ,v_subject,lRetVal,PARAM_SUCCESS ,PARAM_MESSAGE );
          --send_html_mail_with_attachment(param_mngr_email ,v_subject,lRetVal,PARAM_SUCCESS ,PARAM_MESSAGE );
          
          
            
            send_mail_with_Attach(p_to          => param_mngr_email,
            --send_mail_with_Attach(p_to          => 'b.mhatre@ticb.com',
            --send_mail_with_Attach(p_to          => 'd.bhavsar@ticb.com',
            p_from        => pkg_sendmail.sender_mail_id,
            p_subject     => v_subject ,
            p_text_msg    => c_html_body,
            p_attach_name => 'EmployeeCVStatus.htm',
            p_attach_mime => 'text/html',
            p_attach_clob => lRetVal,
            p_smtp_host   => pkg_sendmail.smtp_mail_server,
            p_smtp_port   => 25,
            p_success     => param_success,
            p_message     => param_message);
          
          --send_html_mail_with_attachment('d.bhavsar@ticb.com' ,v_subject,lRetVal,PARAM_SUCCESS ,PARAM_MESSAGE );
          --SEND_html_MAIL('d.bhavsar@ticb.com',v_subject,lRetVal,PARAM_SUCCESS ,PARAM_MESSAGE );
          dbms_output.put_line(param_success);
          dbms_output.put_line(param_message);
      end generate_html;


       PROCEDURE send_mail_with_Attach (p_to          IN VARCHAR2,
                                             p_from        IN VARCHAR2,
                                             p_subject     IN VARCHAR2,
                                             p_text_msg    IN VARCHAR2 DEFAULT NULL,
                                             p_attach_name IN VARCHAR2 DEFAULT NULL,
                                             p_attach_mime IN VARCHAR2 DEFAULT NULL,
                                             p_attach_clob IN CLOB DEFAULT NULL,
                                             p_smtp_host   IN VARCHAR2,
                                             p_smtp_port   IN NUMBER DEFAULT 25,
                                             p_success     OUT varchar2,
                                             p_message     OUT varchar2)
      AS
        l_mail_conn   UTL_SMTP.connection;
        l_boundary    VARCHAR2(50) := '----=*#abc1234321cba#*=';
        l_step        PLS_INTEGER  := 12000; -- make sure you set a multiple of 3 not higher than 24573
      BEGIN
        l_mail_conn := UTL_SMTP.open_connection(p_smtp_host, p_smtp_port);
        UTL_SMTP.helo(l_mail_conn, p_smtp_host);
        UTL_SMTP.mail(l_mail_conn, p_from);
        UTL_SMTP.rcpt(l_mail_conn, p_to);
      
        UTL_SMTP.open_data(l_mail_conn);
        
        UTL_SMTP.write_data(l_mail_conn, 'Date: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.crlf);
        UTL_SMTP.write_data(l_mail_conn, 'To: ' || p_to || UTL_TCP.crlf);
        UTL_SMTP.write_data(l_mail_conn, 'From: ' || p_from || UTL_TCP.crlf);
        UTL_SMTP.write_data(l_mail_conn, 'Subject: ' || p_subject || UTL_TCP.crlf);
        UTL_SMTP.write_data(l_mail_conn, 'Reply-To: ' || p_from || UTL_TCP.crlf);
        UTL_SMTP.write_data(l_mail_conn, 'MIME-Version: 1.0' || UTL_TCP.crlf);
        UTL_SMTP.write_data(l_mail_conn, 'Content-Type: multipart/mixed; boundary="' || l_boundary || '"' || UTL_TCP.crlf || UTL_TCP.crlf);
        
        IF p_text_msg IS NOT NULL THEN
          UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || UTL_TCP.crlf);
          UTL_SMTP.write_data(l_mail_conn, 'Content-Type: text/html; charset="iso-8859-1"' || UTL_TCP.crlf || UTL_TCP.crlf);
      
          UTL_SMTP.write_data(l_mail_conn, p_text_msg);
          UTL_SMTP.write_data(l_mail_conn, UTL_TCP.crlf || UTL_TCP.crlf);
        END IF;
      
        IF p_attach_name IS NOT NULL THEN
          UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || UTL_TCP.crlf);
          UTL_SMTP.write_data(l_mail_conn, 'Content-Type: ' || p_attach_mime || '; name="' || p_attach_name || '"' || UTL_TCP.crlf);
          UTL_SMTP.write_data(l_mail_conn, 'Content-Disposition: attachment; filename="' || p_attach_name || '"' || UTL_TCP.crlf || UTL_TCP.crlf);
       
          FOR i IN 0 .. TRUNC((DBMS_LOB.getlength(p_attach_clob) - 1 )/l_step) LOOP
            UTL_SMTP.write_data(l_mail_conn, DBMS_LOB.substr(p_attach_clob, l_step, i * l_step + 1));
          END LOOP;
      
          UTL_SMTP.write_data(l_mail_conn, UTL_TCP.crlf || UTL_TCP.crlf);
        END IF;
        
        UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || '--' || UTL_TCP.crlf);
        UTL_SMTP.close_data(l_mail_conn);
      
        UTL_SMTP.quit(l_mail_conn);
      END;
 
end pkg_cv;

/
