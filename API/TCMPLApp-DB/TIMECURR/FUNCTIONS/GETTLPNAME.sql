--------------------------------------------------------
--  DDL for Function GETTLPNAME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GETTLPNAME" (p_costcode tlp_mast.costcode%type,p_tlpcode tlp_mast.tlpcode%type) return varchar2 is
   p_name tlp_mast.name%type;
begin
   select name into p_name from tlp_mast where costcode = p_costcode and tlpcode = p_tlpcode;
   return p_name;
exception   
   when no_data_found then
        p_name := 'NOT FOUND';
        return p_name;
end;

/
