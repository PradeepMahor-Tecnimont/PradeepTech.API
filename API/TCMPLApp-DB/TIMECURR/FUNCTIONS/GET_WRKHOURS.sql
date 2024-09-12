--------------------------------------------------------
--  DDL for Function GET_WRKHOURS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_WRKHOURS" 
(
 param_yymm in varchar2
) return number as 
    v_count number;
begin
       v_count := 0;
      select (nvl(working_hrs,0)) into v_count from wrkhours where office = 'BO' and yymm = param_yymm;
      
      --If v_count > 0 Then
       --   return -1;
     -- else
      --    return 1;
     -- End if;
     return v_count;
end get_wrkhours;

/
