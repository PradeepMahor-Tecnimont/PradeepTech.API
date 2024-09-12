--------------------------------------------------------
--  DDL for Function GETCOSTNAME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GETCOSTNAME" (p_costcode costmast.costcode%type) return varchar2 is
   p_name costmast.name%type;
begin
   select name into p_name from costmast where costcode = p_costcode;
   return p_name;
exception   
   when no_data_found then
        p_name := 'NOT FOUND';
        return p_name;
end;

/
