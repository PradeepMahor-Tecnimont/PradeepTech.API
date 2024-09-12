--------------------------------------------------------
--  DDL for Function DM_IS_USER_REJOIN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."DM_IS_USER_REJOIN" 
(
  param_empno in varchar2 
, param_bdate in date 
, param_flag in varchar2 
) return numeric as 
  v_count number;
  v_date date;
  v_flag varchar2(1);
begin
    if param_flag = 'D' then 
        return -1;
    end if;
  begin
    select distinct last_date, last_flag into v_date, v_flag from (
      select  LAST_VALUE(history_date) over (partition by empno order by history_date  RANGE BETWEEN
               UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) last_date,
              LAST_VALUE(flag) over (partition by empno order by history_date  RANGE BETWEEN
               UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) last_flag  from DM_VU_EMP_MOVE_LOG 
        where history_date < param_bdate and empno = param_empno order by history_date, row_id )  ;
        if v_flag = 'D' and param_bdate - nvl(v_date,sysdate) > 30 then
            return 1;
        else
            return -1;
        end if;
  exception
      when others then return -1;
  end;
end dm_is_user_rejoin;


/
