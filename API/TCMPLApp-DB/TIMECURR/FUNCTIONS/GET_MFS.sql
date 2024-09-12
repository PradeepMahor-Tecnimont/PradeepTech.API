--------------------------------------------------------
--  DDL for Function GET_MFS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_MFS" (P_COSTCODE  COSTMAST.COSTCODE%type,p_yymm timetran.yymm%type) return number is
   p_hours COSTMAST.NOOFEMPS%type;
begin
   select  MOVETOOTHERS into p_hours from MOVEMAST where COSTCODE = P_COSTCODE AND  yymm = p_yymm;
   return p_hours;
exception   
   when no_data_found then
        p_hours := 0;
        return p_hours;
end;

/
