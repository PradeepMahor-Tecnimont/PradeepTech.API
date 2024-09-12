create or replace Package Body LC_EMAIL As

   Procedure send_email(
      param_to_mail_id In Varchar2
   ) As
      l_mail_conn utl_smtp.connection;
      l_boundary  Varchar2(50) := '----=*#abc1234321cba#*=';
   Begin

      If Trim(param_to_mail_id) Is Null Then
         Return;
      End If;

      l_mail_conn := utl_smtp.open_connection(c_smtp_mail_server, 25);
      utl_smtp.helo(l_mail_conn, c_smtp_mail_server);
      utl_smtp.mail(l_mail_conn, c_sender_mail_id);
      utl_smtp.rcpt(l_mail_conn, param_to_mail_id);
      utl_smtp.open_data(l_mail_conn);
      utl_smtp.write_data(l_mail_conn, 'Date: '
         || to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS')
         || utl_tcp.crlf);
      utl_smtp.write_data(l_mail_conn, 'To: '
         || param_to_mail_id
         || utl_tcp.crlf);
      utl_smtp.write_data(l_mail_conn, 'From: '
         || c_sender_mail_id
         || utl_tcp.crlf);
      utl_smtp.write_data(l_mail_conn, 'Subject: '
         || pkg_var_sub
         || utl_tcp.crlf);

      utl_smtp.write_data(l_mail_conn, 'MIME-Version: 1.0' || utl_tcp.crlf);
      utl_smtp.write_data(l_mail_conn, 'Content-Type: multipart/alternative; boundary="'
         || l_boundary
         || '"'
         || utl_tcp.crlf
         || utl_tcp.crlf);

      utl_smtp.write_data(l_mail_conn, '--'
         || l_boundary
         || utl_tcp.crlf);
      utl_smtp.write_data(l_mail_conn, 'Content-Type: text/plain; charset="iso-8859-1"'
         || utl_tcp.crlf
         || utl_tcp.crlf);

      utl_smtp.write_data(l_mail_conn, pkg_var_sub);
      utl_smtp.write_data(l_mail_conn, utl_tcp.crlf || utl_tcp.crlf);

      utl_smtp.write_data(l_mail_conn, '--'
         || l_boundary
         || '--'
         || utl_tcp.crlf);
      utl_smtp.close_data(l_mail_conn);

      utl_smtp.quit(l_mail_conn);

   End send_email;

 Procedure send_mail_from_api(
      p_mail_to      Varchar2,
      p_mail_cc      Varchar2,
      p_mail_bcc     Varchar2,
      p_mail_subject Varchar2,
      p_mail_body    Varchar2,
      p_mail_profile Varchar2,
      p_success Out  Varchar2,
      p_message Out  Varchar2
   ) As
   Begin
      --return;
      /*
      commonmasters.pkg_mail.send_api_mail(
          p_mail_to        => p_mail_to,
          p_mail_cc        => p_mail_cc,
          p_mail_bcc       => p_mail_bcc,
          p_mail_subject   => p_mail_subject,
          p_mail_body      => p_mail_body,
          p_mail_profile   => 'REMOTEWORK',
          p_success        => p_success,
          p_message        => p_message
      );
      */
      commonmasters.pkg_mail.send_api_mail(
         p_mail_to      => 'p.mahor@tecnimont.in',
         p_mail_cc      => 'p.mahor@tecnimont.in',
         p_mail_bcc     => '',
         p_mail_subject => p_mail_subject,
         p_mail_body    => p_mail_body,
         p_mail_profile => c_mail_profile,
         p_success      => p_success,
         p_message      => p_message
      );
    
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
   
End LC_EMAIL;