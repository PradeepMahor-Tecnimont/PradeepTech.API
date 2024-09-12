--------------------------------------------------------
--  DDL for Procedure SEND_MAIL_EMPLOYEE_ADDED
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "TIMECURR"."SEND_MAIL_EMPLOYEE_ADDED" as 
begin
  null;
  pkg_sendmail.send_new_employee_mail;
  Selfservice.Nu_Emp.Assign_Shift_2_Nu_Emp;
end send_mail_employee_added;

/
