--------------------------------------------------------
--  DDL for Function GET_MO
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_MO" (P_COSTCODE  COSTMAST.COSTCODE%type,p_yymm timetran.yymm%type) return number is
   p_hours COSTMAST.NOOFEMPS%type;
begin
   select  MOVEMENT into p_hours from MOVEMAST where COSTCODE = P_COSTCODE AND  yymm = p_yymm;
   return p_hours;
exception   
   when no_data_found then
        p_hours := 0;
        return p_hours;
end;



create or replace FUNCTION GET_MOVEMENT(P_COSTCODE  COSTMAST.COSTCODE%type,p_yymm timetran.yymm%type) return number is
   p_hours COSTMAST.NOOFEMPS%type;
   vnoof number(7);
begin
   vnoof := 0;
   select  nvl(MOVEMENT,0)+nvl(MOVETOTCM,0)+nvl(MOVETOSITE,0)+nvl(MOVETOOTHERS,0)+nvl(FUT_RECRUIT,0)+nvl(INT_DEPT,0) into vnoof from MOVEMAST where COSTCODE = P_COSTCODE AND  yymm = p_yymm;
   p_hours := get_ehm_cc(p_costcode,p_yymm) * vnoof;
   return p_hours;
exception   
   when no_data_found then
        p_hours := 0;
        return p_hours;
end;

/
