--------------------------------------------------------
--  DDL for Function GET_EHM
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_EHM" (p_yymm timetran.yymm%type) return number is
   p_hours COSTMAST.NOOFEMPS%type;
   v_yymm char(6);
begin
   select  working_hr  into p_hours from raphours where yymm = p_yymm;
   --select  working_hrs  into p_hours from wrkhours where yymm = p_yymm;
   return p_hours;
exception   
   when no_data_found then
        select max(yymm) into v_yymm from raphours ;
        select  working_hr  into p_hours from raphours where yymm = v_yymm;
        return p_hours ;
end;

/
