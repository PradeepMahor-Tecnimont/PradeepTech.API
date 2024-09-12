--------------------------------------------------------
--  DDL for Function GET_SAP_CC
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_SAP_CC" (p_costcode costmast.costcode%type) return varchar2 is
   p_cc costmast.sapcc%type;
begin
   select sapcc into p_cc from costmast where costcode = p_costcode;
   return p_cc;
exception   
   when no_data_found then
        p_cc := 'NOTFND';
        return p_cc;
end;

/
