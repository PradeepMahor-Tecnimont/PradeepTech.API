--------------------------------------------------------
--  DDL for Function DM_IS_USER_DEPU
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."DM_IS_USER_DEPU" 
(
  param_empno in varchar2 
, param_bdate in date 
, param_flag in varchar2 
) return number as 
    v_count number;
begin
  if param_flag = 'I' then
      return -1;
  end if;
  select count(*) into v_Count from DM_VU_EMP_MOVE_LOG 
    where empno = param_empno and history_date > param_bdate;
  If v_count > 0 Then
    return -1;
  else
    --Check User has left TICB
    select count(*) into v_count from ss_emplmast where status = 1 and empno = param_empno;
    if v_count = 0 Then --IF user NOT left TICB
        return 1; -- User on Deputation
    else
        return -1; -- User Not on Deputation
    end if;
  end if;
end dm_is_user_depu;


/
