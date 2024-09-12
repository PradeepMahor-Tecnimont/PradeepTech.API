--------------------------------------------------------
--  DDL for Function GET_ADJ_YYMM
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_ADJ_YYMM" (
 param_yymm in varchar2
) return char  as 
    v_yymm varchar2(6);
    v_yy int(4);
    v_mm int;
    x_yy varchar2(4);
    x_mm varchar2(2);
begin
-- Returns 1 when successful  Closing date = sysdate
-- Returns - 1 when Closing date is not null 
-- Returns -2 when Job not available in system
     x_mm  := substr(param_yymm,5,2);
     x_yy  := substr(param_yymm,1,4);
     
     v_mm  := substr(param_yymm,5,2);
     v_yy  := substr(param_yymm,1,4);
     
     
      v_mm := v_mm - 1;
      if v_mm = 0 then
         x_mm := '12';
         x_yy := v_yy -1;
      else
         x_mm := v_mm;
         --x_yy :='';
      end if;

      v_yymm := x_yy || x_mm;
      return v_yymm;
    
end Get_Adj_YYMM;

/
