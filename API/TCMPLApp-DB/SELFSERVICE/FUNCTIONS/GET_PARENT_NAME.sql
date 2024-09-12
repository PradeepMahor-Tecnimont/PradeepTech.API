--------------------------------------------------------
--  DDL for Function GET_PARENT_NAME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GET_PARENT_NAME" 
(
  param_parent in varchar2 
) return varchar2 as 
  v_ret_val varchar2(60);
begin
  select name into v_ret_val from ss_costmast where costcode = trim(param_parent);
  return v_ret_val;
exception
  when others then return null;
end get_parent_name;


/
