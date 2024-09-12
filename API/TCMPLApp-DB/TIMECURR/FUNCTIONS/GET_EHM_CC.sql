--------------------------------------------------------
--  DDL for Function GET_EHM_CC
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_EHM_CC" (P_COSTCODE TIMETRAN.COSTCODE%type,p_yymm timetran.yymm%type) return number is
   p_hours COSTMAST.NOOFEMPS%type;
   v_noof number(5);
begin
   v_noof := 0;
   select  GET_STRENGTH(p_costcode)  into v_noof from dual ;
   p_hours := v_noof * get_ehm(p_yymm);
   return p_hours;
exception   
   when no_data_found then
        p_hours := 0;
        return p_hours;
end;

/
