--------------------------------------------------------
--  DDL for Function GET_strength
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_strength" (p_costcode costmast.costcode%type) return number is
   p_strength costmast.noofemps%type;
begin
   select   nvl(noofemps,0) + nvl(NOOFCONS,0) into p_strength from costmast where costcode = p_costcode;
   return p_strength;
exception   
   when no_data_found then
        p_strength := 0;
        return p_strength;
end;

/
