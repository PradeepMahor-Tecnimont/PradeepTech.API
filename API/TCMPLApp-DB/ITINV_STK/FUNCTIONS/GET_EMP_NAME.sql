--------------------------------------------------------
--  DDL for Function GET_EMP_NAME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "ITINV_STK"."GET_EMP_NAME" 
(
  param_empno in varchar2 
) return varchar2 as 
    vRetVal varchar2(80);
begin
  Select name into vRetVal from stk_empmaster Where empno = upper(trim(param_empno));
  return vRetVal;
Exception
    When Others then
        return null;
end get_emp_name;

/
