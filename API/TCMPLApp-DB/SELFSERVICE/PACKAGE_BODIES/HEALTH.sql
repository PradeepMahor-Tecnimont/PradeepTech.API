--------------------------------------------------------
--  DDL for Package Body HEALTH
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."HEALTH" as

procedure send_mail(p_from varchar2, p_to varchar2, p_subject varchar2,
                    p_body varchar2, p_success out number, p_message out varchar2) as
  l_mail_conn   UTL_SMTP.connection;
  l_boundary    VARCHAR2(50) := '----=*#abc1234321cba#*=';
  begin
      l_mail_conn := UTL_SMTP.open_connection(c_smtp_mail_server, 25);
      UTL_SMTP.helo(l_mail_conn, c_smtp_mail_server);
      UTL_SMTP.mail(l_mail_conn, p_from);
      utl_smtp.rcpt(l_mail_conn, p_to);
      UTL_SMTP.open_data(l_mail_conn);
      UTL_SMTP.write_data(l_mail_conn, 'Date: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.crlf);
      UTL_SMTP.write_data(l_mail_conn, 'To: ' || p_to || UTL_TCP.crlf);
      UTL_SMTP.write_data(l_mail_conn, 'From: ' || p_from || UTL_TCP.crlf);
      UTL_SMTP.write_data(l_mail_conn, 'Subject: ' || p_subject || UTL_TCP.crlf);

      UTL_SMTP.write_data(l_mail_conn, 'MIME-Version: 1.0' || UTL_TCP.crlf);
      UTL_SMTP.write_data(l_mail_conn, 'Content-Type: multipart/alternative; boundary="' || l_boundary || '"' || UTL_TCP.crlf || UTL_TCP.crlf);


      UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || UTL_TCP.crlf);
      UTL_SMTP.write_data(l_mail_conn, 'Content-Type: text/plain; charset="iso-8859-1"' || UTL_TCP.crlf || UTL_TCP.crlf);

      UTL_SMTP.write_data(l_mail_conn, replace(p_body, '!nuLine!',UTL_TCP.crlf));
      UTL_SMTP.write_data(l_mail_conn, UTL_TCP.crlf || UTL_TCP.crlf);

      UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || '--' || UTL_TCP.crlf);
      UTL_SMTP.close_data(l_mail_conn);

      UTL_SMTP.quit(l_mail_conn);
      p_success := ss.success;
      p_message := 'Email was successfully sent.';
    exception
        when others then
            p_success := ss.failure;
            p_message := 'Error : ' || sqlcode || ' - ' || sqlerrm;
  end send_mail;

  function get_parent(p_empno varchar2) return varchar2 as
    vParent Varchar2(4);
  begin
    select parent into vParent from ss_emplmast 
      where empno = p_empno;
    return vParent;
    exception
      when others then
      return '';
  end get_parent;

  function get_healthstatus(p_status number) return varchar2 as
    vStatus Varchar2(40);
  begin
    case p_status
        when 1 then
          vStatus := 'Medically Fit';
        when 2 then
          vStatus := 'Medically Fit with Recomm.';
        when 3 then
          vStatus := 'Medically Unfit';
        else
          vStatus := '0';
      end case;
    return vStatus;
    exception
      when others then
      return to_char(p_status);
  end get_healthstatus;

end health;


/
