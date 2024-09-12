--------------------------------------------------------
--  DDL for Function EXCHECK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."EXCHECK" (P_EMPNO IN VARCHAR2,p_lvtype varchar2,NO_DAYS IN NUMBER,S_DATE IN DATE,E_DATE IN DATE) RETURN Number IS
	v_lvprd number(8,1) := 0;
	v_lvprd1 number(8,1) := 0;
	v_lvprd2 number(8,1) := 0;
	ret_hday number := 0;
	startdate date;
	enddate date;
	ctr number := 0;
	i number := 1;
BEGIN
startdate := s_Date;	
enddate := e_date;
	select (nvl(sum(DECODE(leavetype,'PL',leaveperiod,0)),0) * -1/8),(nvl(sum(DECODE(leavetype,'CL',leaveperiod,0)),0) * -1/8),(nvl(sum(DECODE(leavetype,'SL',leaveperiod,0)),0) * -1/8) into v_lvprd,v_lvprd1,v_lvprd2 from ss_leaveledg where bdate 
	between S_DATE and E_date and E_Date between S_Date and E_Date AND DB_CR = 'D' 
	AND	EMPNO = ltrim(Rtrim(P_EMPNO));
v_lvprd := v_lvprd+v_lvprd1+v_lvprd2;
--get preceeding day which is not a holiday
if v_lvprd = 0 then
	select (nvl(sum(DECODE(leavetype,'PL',leaveperiod,0)),0)  /8),(nvl(sum(DECODE(leavetype,'CL',leaveperiod,0)),0)  /8),(nvl(sum(DECODE(leavetype,'SL',leaveperiod,0)),0) /8) into v_lvprd,v_lvprd1,v_lvprd2 from ss_leaveapp where bdate 
	between S_DATE and E_date and E_Date between S_Date and E_Date AND EMPNO = ltrim(Rtrim(P_EMPNO));
	v_lvprd := v_lvprd+v_lvprd1+v_lvprd2;
--check if CL availed on succeeding day
end if;

if v_lvprd = 0 then
	return 0;-- valid  
else			
	return 1;-- EX availed with PL/SL/CL
end if;
END;


/
