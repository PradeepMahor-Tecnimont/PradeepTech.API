--------------------------------------------------------
--  DDL for Function GETPROJNAME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GETPROJNAME" (p_projno projmast.projno%type) return varchar2 is
   p_name projmast.name%type;
begin
   select name into p_name from projmast where projno = p_projno;
   return p_name;
exception   
   when no_data_found then
        p_name := 'NOT FOUND';
        return p_name;
end;

/
