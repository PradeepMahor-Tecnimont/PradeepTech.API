--------------------------------------------------------
--  DDL for Function GETPLLEAVECOUNT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GETPLLEAVECOUNT" (p_empno IN VARCHAR2) RETURN NUMBER IS
	v_count number;
	v_count1 number;
BEGIN
	select count(*) into v_count from ss_leaveledg where leavetype = 'PL' 
		and empno = trim(p_empno) and DB_CR = 'D' 
		and to_char(bdate,'rrrr') >= to_char(sysdate,'rrrr') 
		and to_char(bDate,'rrrr') <= to_char(sysdate,'rrrr') and Adj_Type ='LA';
/*	select count(*) into v_count1 from ss_leaveledg where leavetype = 'PL' 
		and trim(empno) = trim(p_empno) and DB_CR = 'D' 
		and to_char(bdate,'rrrr') >= to_char(sysdate,'rrrr') 
		and to_char(bDate,'rrrr') <= to_char(sysdate,'rrrr');
		*/
	--v_count := v_count + v_count1;

	if v_count > 3 then
		return v_count;
	else
		Select count(*) into v_count from ss_leaveapp where leavetype = 'PL' 
			and empno = trim(p_empno) and to_char(bdate,'rrrr') >= to_char(sysdate,'rrrr') 			
			and to_char(bDate,'rrrr') <= to_char(sysdate,'rrrr') and hod_apprl <> 2 
			and hrd_apprl <> 2; 
		return v_count;
	end if;
END;


/
