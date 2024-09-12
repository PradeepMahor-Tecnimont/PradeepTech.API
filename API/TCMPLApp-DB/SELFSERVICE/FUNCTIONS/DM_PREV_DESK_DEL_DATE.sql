--------------------------------------------------------
--  DDL for Function DM_PREV_DESK_DEL_DATE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."DM_PREV_DESK_DEL_DATE" 
(
  param_empno in varchar2 
, param_bdate in date
) return date as 
  v_date date;
begin
select distinct last_date_value into v_date from (
  select  LAST_VALUE(history_date) over (partition by empno order by history_date  RANGE BETWEEN
           UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) last_date_value from DM_VU_EMP_MOVE_LOG 
    where history_date < param_bdate and empno = param_empno and FLAG = 'D' order by history_date, row_id ) ;
  return v_date;
  exception
    when others then return null;
end dm_prev_desk_del_date;


/
