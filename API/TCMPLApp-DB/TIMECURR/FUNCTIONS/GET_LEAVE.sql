--------------------------------------------------------
--  DDL for Function GET_LEAVE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_LEAVE" 
(
 param_empno in varchar2,
 param_yymm in varchar2

) return number as 
    v_count number;
begin
v_count:=0;
 
      select sum(nvl(hours,0)) into v_count from timetran_combine where empno = param_empno and yymm = param_yymm and (projno like '11114%' or projno like '22224%' or projno like '33334%');
       
      --If v_count > 0 Then
       --   return -1;
     -- else
      --    return 1;
     -- End if;
     return v_count;
     exception  
     when no_data_found then
     v_count := 0;
     return v_count;
      end get_leave ;

/
