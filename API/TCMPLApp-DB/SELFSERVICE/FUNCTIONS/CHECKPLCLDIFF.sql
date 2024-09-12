--------------------------------------------------------
--  DDL for Function CHECKPLCLDIFF
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."CHECKPLCLDIFF" (P_EMPNO IN VARCHAR2,p_lvtype varchar2,S_DATE IN DATE,E_DATE IN DATE) RETURN Number IS
v_count number := 0;
BEGIN
  select count(*) into v_count from ss_leaveledg where empno = trim(p_empno) AND DB_CR ='D'
  and leavetype = p_lvtype AND Bdate between (s_date-1) and (e_Date+1) 
  OR Edate between (s_date-1) and (e_date+1);
  if v_count = 0 then
  	select count(*) into v_count from ss_leaveapp where empno = trim(p_empno) and leavetype = p_lvtype 
  	and Bdate between (s_date-1) and (e_Date+1) OR Edate between (s_date-1) and (e_date+1); 
  end if;
	if v_count = 0 then
  	return v_count;
  else
  	return 1;
  end if;
END;


/
