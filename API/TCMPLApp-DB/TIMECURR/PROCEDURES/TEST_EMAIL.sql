--------------------------------------------------------
--  DDL for Procedure TEST_EMAIL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "TIMECURR"."TEST_EMAIL" as 
begin
pkg_sendmail.pkg_var_msg := ' EmpNo : '
        || '02320' || UTL_TCP.crlf
        || ' LastName '
        || 'BHAVSAR' || UTL_TCP.crlf
        || ' FirstName '
        || 'DEVENDRA' || UTL_TCP.crlf
        || ' Middle Name '
        || ' ' || UTL_TCP.crlf
        || ' Date of Joining - '
        || ' D-O-J ' || UTL_TCP.crlf
        || ' Contract End Date- '
        || ' C-E-D ' || UTL_TCP.crlf
        || ' Parent Cost Code - '
        || ' C-C ' || UTL_TCP.crlf
        || ' Assign Cost Code -'
        || ' A-C ' || UTL_TCP.crlf
        || ' Location -'
        || ' LOC ' || UTL_TCP.crlf
        || ' Employee Type -'
        || ' EMP-TYPE ' || UTL_TCP.crlf || UTL_TCP.crlf || UTL_TCP.crlf || UTL_TCP.crlf
        || ' This is an automated email';
      pkg_sendmail.pkg_var_sub := 'New Employee Created In Desk Management/Timesheet  ' || 'EmpNo : ' || '02320' || ' Name : ' || 'DEVENDRA' ;
    --  pkg_sendmail.send_mail_2_user('a.kalaskar@ticb.com');
    --  pkg_sendmail.send_mail_2_user('S.poojary@ticb.com');
      pkg_sendmail.send_mail_2_user('d.bhavsar@ticb.com');
    --  pkg_sendmail.send_mail_2_user('S.B.Salvi@ticb.com');
    --  pkg_sendmail.send_mail_2_user('S.Mistry@ticb.com');
    --  pkg_sendmail.send_mail_2_user('D.Desai@ticb.com');
end test_email;

/
