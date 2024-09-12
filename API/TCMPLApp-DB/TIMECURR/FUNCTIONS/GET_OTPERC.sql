--------------------------------------------------------
--  DDL for Function GET_OTPERC
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_OTPERC" (P_COSTCODE TIMETRAN.COSTCODE%type,p_yymm timetran.yymm%type) return number is
   p_otperc OTMAST.OT%type;
   v_noof number(5);
begin
   select  OT   into p_otperc from OTMAST WHERE COSTCODE = P_COSTCODE AND YYMM = p_yymm  ;
 --  p_hours := v_noof * get_ehm(p_yymm);
   return p_otperc;
exception   
   when no_data_found then
        p_otperc := 0;
        return p_otperc;
end;

/
