--------------------------------------------------------
--  DDL for Function GET_EMP_COMP_NAME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "ITINV_STK"."GET_EMP_COMP_NAME" (param_empno varchar2) return varchar2 is
      v_comp_name varchar2(60);
  begin
    If param_empno = 'ALLSS' Then
      Return 'PC9584';
    End If;
    select a.compname into v_comp_name from dm_vu_user_desk_pc a where a.empno = trim(param_empno) ;
    --or a.empno2 = trim(param_empno);
    return Trim(v_comp_name);
  exception 
      when others then return 'ERRRRR';
  end;

/
