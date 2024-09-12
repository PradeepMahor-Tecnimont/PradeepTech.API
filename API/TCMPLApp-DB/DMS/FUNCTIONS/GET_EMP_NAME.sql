create or replace function "DMS"."GET_EMP_NAME" (
   p_empno in varchar2
) return varchar2 as
   v_retval varchar2(60);
begin
   
   select name
     into v_retval
     from ss_emplmast
    where empno = trim(p_empno);

   return v_retval;
exception
   when others then
      return '';
end get_emp_name;