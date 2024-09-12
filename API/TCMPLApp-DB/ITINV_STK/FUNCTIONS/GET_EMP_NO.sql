--------------------------------------------------------
--  DDL for Function GET_EMP_NO
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "ITINV_STK"."GET_EMP_NO" 
(
  param_user_name varchar2 
) return varchar2 as 
  v_empno varchar2(5);
begin
  select emp_no into v_empno from stk_user_information where Upper(Trim(domain)) || Upper(trim(user_ID)) = Upper(Trim(Replace(param_user_name,'\')));
  return v_empno;
Exception
  When Others then return 'ERRER';
end get_emp_no;

/
