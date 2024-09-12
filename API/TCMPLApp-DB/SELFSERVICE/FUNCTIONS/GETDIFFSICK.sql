--------------------------------------------------------
--  DDL for Function GETDIFFSICK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GETDIFFSICK" (P_EMPNO IN VARCHAR2,p_lvtype varchar2,NO_DAYS IN NUMBER,S_DATE IN DATE,E_DATE IN DATE) RETURN Number IS
v_lvprd number(8,1) := 0;
v_lvprd1 number(8,1) := 0;
ret_hday number := 0;
startdate date;
enddate date;
ctr number := 0;
i number := 1;
BEGIN
startdate := s_Date;	
enddate := e_date;
select (nvl(sum(DECODE(leavetype,'CL',leaveperiod,0)),0) * -1/8) into v_lvprd from ss_leaveledg where bdate between S_DATE and E_date and E_Date between S_Date and E_Date AND DB_CR = 'D' AND EMPNO = ltrim(Rtrim(P_EMPNO));
--get preceeding day which is not a holiday

if v_lvprd = 0 then

	while ctr <> 1 loop
		ret_hday := get_holiday(startdate - i);
		ret_hday := get_holiday(enddate + i);
		if ret_hday = 1 or ret_hday = 2 or ret_hday = 3 then
			i := i+1;
		else 
			ctr := 1;
		end if;			
	end loop;
begin
			--first check if CL availed on preceeding days	
			select (nvl(sum(DECODE(leavetype,'CL',leaveperiod,0)),0) * -1/8) into v_lvprd from ss_leaveledg where bdate = startdate - i  AND DB_CR = 'D' AND EMPNO = ltrim(Rtrim(P_EMPNO));

			if v_lvprd = 0 then 
			--check if CL availed on succeeding days
				select (nvl(sum(DECODE(leavetype,'CL',leaveperiod,0)),0) * -1/8)  into v_lvprd from ss_leaveledg where edate = enddate - i  AND DB_CR = 'D' AND EMPNO = ltrim(Rtrim(P_EMPNO));
			end if;
end;	
end if;	
if v_lvprd = 0 then			
			--check in Application table
		select (nvl(sum(DECODE(leavetype,'CL',leaveperiod,0)),0) * -1/8)  into v_lvprd from ss_leaveapp where bdate between S_DATE and E_date and E_Date between S_Date and E_Date AND  EMPNO = ltrim(Rtrim(P_EMPNO)) and (hod_apprl <> 2 or hrd_apprl <> 2);			
		if v_lvprd = 0 then
				begin
						--first check if CL availed on preceeding days	
						select (nvl(sum(DECODE(leavetype,'CL',leaveperiod,0)),0) * -1/8) into v_lvprd from ss_leaveapp where bdate = startdate - i  AND EMPNO = ltrim(Rtrim(P_EMPNO)) and (hod_apprl <> 2 or hrd_apprl <> 2) ;
						if v_lvprd = 0 then 
						--check if CL availed on succeeding days
							select (nvl(sum(DECODE(leavetype,'CL',leaveperiod,0)),0) * -1/8) into v_lvprd from ss_leaveapp where edate = enddate - i  AND EMPNO = ltrim(Rtrim(P_EMPNO)) and (hod_apprl <> 2 or hrd_apprl <> 2); 

						end if;
				end;	
		end if;	
end if;
if v_lvprd = 0 then
	return 0;-- valid  
else			
	return 6;-- CL availed one day before/after  SL
end if;
END;


/
