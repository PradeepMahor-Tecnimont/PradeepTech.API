--------------------------------------------------------
--  DDL for Function GET_AVLBL_CC
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_AVLBL_CC" (P_COSTCODE TIMETRAN.COSTCODE%type,p_yymm timetran.yymm%type) return number is
   p_hours COSTMAST.NOOFEMPS%type;
  -- v_noof number(5);
begin
   select  GET_EHM_CC(p_costcode,P_YYMM)  into P_HOURS from dual ;
 --  p_hours := v_noof * get_ehm(p_yymm);
   return p_hours;
exception   
   when no_data_found then
        p_hours := 0;
        return p_hours;
end;

/
