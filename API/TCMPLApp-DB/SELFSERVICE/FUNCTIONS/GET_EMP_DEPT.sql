--------------------------------------------------------
--  DDL for Function GET_EMP_DEPT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GET_EMP_DEPT" 
(
  param_empno in varchar2 
) return varchar2 as 
  v_parent varchar2(4);
  v_cost_desc varchar2(60);
begin
  if param_empno = 'ALLSS' Then
    return 'All Services';
  End If;
  Select parent into v_parent from ss_Emplmast where empno=param_empno;
  select name into v_cost_desc from ss_costmast where costcode = v_parent;
  return v_cost_desc;
Exception
  When Others then
    return 'ERRRRR';
end get_emp_dept;


/
