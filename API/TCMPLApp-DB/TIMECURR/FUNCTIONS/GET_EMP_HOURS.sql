--------------------------------------------------------
--  DDL for Function GET_EMP_HOURS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_EMP_HOURS" 
(
 param_empno in varchar2
, param_byymm in varchar2
,  param_eyymm in varchar2
) return number as 
    v_count number;
begin

  
      select sum(nvl(hours,0)) into v_count from timetran where empno = param_empno
      and yymm >= param_byymm
        and  yymm <= param_eyymm ;
      --If v_count > 0 Then
       --   return -1;
     -- else
      --    return 1;
     -- End if;
     return v_count;
end get_emp_hours;

/
