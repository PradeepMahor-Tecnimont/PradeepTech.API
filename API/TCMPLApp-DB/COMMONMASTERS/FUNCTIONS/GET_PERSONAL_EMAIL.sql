--------------------------------------------------------
--  DDL for Function GET_PERSONAL_EMAIL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "COMMONMASTERS"."GET_PERSONAL_EMAIL" (p_empno in varchar2) return varchar2 as
    vPerEmail varchar2(150) := '';
  begin
    select personal_email into vPerEmail from emp_details
      where empno = p_empno;
    return vPerEmail;
end get_personal_email;

/
