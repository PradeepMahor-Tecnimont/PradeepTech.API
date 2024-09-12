--------------------------------------------------------
--  DDL for Function GET_PROJ_NAME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "ITINV_STK"."GET_PROJ_NAME" 
(
  param_proj_no_5 in varchar2 
) return varchar2 as
  cursor cur1 is select projno, proj_no_5, name from st_vu_projmast where proj_no_5 = param_proj_no_5 order by projno;
begin
    for c2 in cur1 loop
        return c2.name;
    end loop;
    return 'Nnnnn';
exception when others then return 'Errr';
end get_proj_name;

/
