--------------------------------------------------------
--  DDL for Function GET_MOVEMENT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_MOVEMENT" (P_COSTCODE  COSTMAST.COSTCODE%type,p_yymm timetran.yymm%type) return number is
   p_hours timetran.hours%type;
   vnoof number(7);
begin
   vnoof := 0;
   select  nvl(MOVEMENT,0)+nvl(MOVETOTCM,0)+nvl(MOVETOSITE,0)+nvl(MOVETOOTHERS,0)+nvl(FUT_RECRUIT,0)+nvl(INT_DEPT,0) into vnoof from MOVEMAST where COSTCODE = P_COSTCODE AND  yymm = p_yymm;
   p_hours := get_ehm(p_yymm) * vnoof;
   return p_hours;
exception   
   when no_data_found then
        p_hours := 0;
        return p_hours;
end;

/
