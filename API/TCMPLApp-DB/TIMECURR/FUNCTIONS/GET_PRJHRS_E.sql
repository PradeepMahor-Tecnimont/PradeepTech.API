--------------------------------------------------------
--  DDL for Function GET_PRJHRS_E
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_PRJHRS_E" 
(
 param_empno in varchar2,
 param_yymm in varchar2

) return number as 
    v_count number;
begin
v_count:=0;
 
      select sum(nvl(hours,0)) into v_count from timetran_combine where empno = param_empno and yymm = param_yymm and 
      (projno not like '11114%' and projno not like '22224%' and projno not like '33334%' and projno not like '55554%' and projno not like '66664%'   )
       and grp = 'E' and wpcode <> '4';
 
     return v_count;
     exception
     when no_data_found then
     v_count := 0;
     return v_count;
end  get_prjhrs_E ;

/
