--------------------------------------------------------
--  DDL for Function DM_IS_NU_USER
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DM_IS_NU_USER" 
(
  param_empno in varchar2 
, param_bdate in date 
, param_flag in varchar2
) return number as 
    v_count number;
begin
  if param_flag = 'D' then
    return -1;
  end if;
      select count(*) into v_count from DM_VU_EMP_MOVE_LOG where empno = param_empno
        and history_date < param_bdate and flag = 'I';
      If v_count > 0 Then
          return -1;
      else
          return 1;
      End if;
end dm_is_nu_user;

/
