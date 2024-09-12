--------------------------------------------------------
--  DDL for Function GETDIFFPLSLCL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GETDIFFPLSLCL" (P_EMPNO IN VARCHAR2,p_lvtype varchar2,NO_DAYS IN NUMBER,S_DATE IN DATE,E_DATE IN DATE) RETURN Number IS
v_lvprd number(8,1) := 0;
v_lvprd1 number(8,1) := 0;
v_lvprdex number(8,1) := 0; 
ret_hday number := 0;
startdate date;
enddate date;
ctr number := 0;
i number := 1;
Prev_date Date;
Next_date Date;
BEGIN
startdate := s_Date;	
enddate := e_date;
	if p_LvType = 'CL' THEN
			select (nvl(sum(DECODE(leavetype,'PL',leaveperiod,0)),0) * -1/8) ,(nvl(sum(DECODE(leavetype,'SL',leaveperiod,0)),0) * -1/8),(nvl(sum(DECODE(leavetype,'EX',leaveperiod,0)),0) * -1/8) into v_lvprd,v_lvprd1,v_lvprdex from ss_leaveledg where bdate between S_DATE and E_date and E_Date between S_Date and E_Date AND DB_CR = 'D' AND EMPNO = ltrim(Rtrim(P_EMPNO)) And Adj_Type<>'PN';
			v_lvprd := v_lvprd+v_lvprd1+v_lvprdex;
			--get preceeding day which is not a holiday

			if v_lvprd = 0 then
						Prev_date := GetLastWorkingDay(S_DATE,'-');
						Next_Date := GetLastWorkingDay(E_DATE,'+');
			begin
						--first check if PL or SL availed on preceeding days	
						select (nvl(sum(DECODE(leavetype,'PL',leaveperiod,0)),0) * -1/8) ,(nvl(sum(DECODE(leavetype,'SL',leaveperiod,0)),0) * -1/8),(nvl(sum(DECODE(leavetype,'EX',leaveperiod,0)),0) * -1/8) into v_lvprd,v_lvprd1,v_lvprdex from ss_leaveledg where bdate = startdate - i  AND DB_CR = 'D' AND EMPNO = ltrim(Rtrim(P_EMPNO)) And Adj_Type<>'PN';
						v_lvprd := v_lvprd+v_lvprd1+v_lvprdex;
						if v_lvprd = 0 then 
						--check if PL or SL availed on succeeding days
							select (nvl(sum(DECODE(leavetype,'PL',leaveperiod,0)),0) * -1/8) ,(nvl(sum(DECODE(leavetype,'SL',leaveperiod,0)),0) * -1/8),(nvl(sum(DECODE(leavetype,'EX',leaveperiod,0)),0) * -1/8) into v_lvprd,v_lvprd1,v_lvprdex from ss_leaveledg where edate = enddate - i  AND DB_CR = 'D' AND EMPNO = ltrim(Rtrim(P_EMPNO)) And Adj_Type<>'PN';
							v_lvprd := v_lvprd+v_lvprd1+v_lvprdex;
						end if;
			end;	
			end if;	
			if v_lvprd = 0 then			
						--check in Application table
					select (nvl(sum(DECODE(leavetype,'PL',leaveperiod,0)),0) * -1/8) ,(nvl(sum(DECODE(leavetype,'SL',leaveperiod,0)),0) * -1/8),(nvl(sum(DECODE(leavetype,'EX',leaveperiod,0)),0) * -1/8) into v_lvprd,v_lvprd1,v_lvprdex from ss_leaveapp where bdate between S_DATE and E_date and E_Date between S_Date and E_Date AND  EMPNO = ltrim(Rtrim(P_EMPNO)) and (hod_apprl <> 2 or hrd_apprl <> 2) ;
					v_lvprd := v_lvprd+v_lvprd1+v_lvprdex;
					if v_lvprd = 0 then
							begin
									--first check if PL or SL availed on preceeding days	
									select (nvl(sum(DECODE(leavetype,'PL',leaveperiod,0)),0) * -1/8) ,(nvl(sum(DECODE(leavetype,'SL',leaveperiod,0)),0) * -1/8),(nvl(sum(DECODE(leavetype,'EX',leaveperiod,0)),0) * -1/8) into v_lvprd,v_lvprd1,v_lvprdex from ss_leaveapp where bdate = Prev_Date  AND EMPNO = ltrim(Rtrim(P_EMPNO)) and (hod_apprl <> 2 or hrd_apprl <> 2) ;
									v_lvprd := v_lvprd+v_lvprd1+v_lvprdex;
									if v_lvprd = 0 then 
									--check if PL or SL availed on succeeding days
										select (nvl(sum(DECODE(leavetype,'PL',leaveperiod,0)),0) * -1/8) ,(nvl(sum(DECODE(leavetype,'SL',leaveperiod,0)),0) * -1/8),(nvl(sum(DECODE(leavetype,'EX',leaveperiod,0)),0) * -1/8) into v_lvprd,v_lvprd1,v_lvprdex from ss_leaveapp where edate = Next_Date  AND EMPNO = ltrim(Rtrim(P_EMPNO)) and (hod_apprl <> 2 or hrd_apprl <> 2) ;
										v_lvprd := v_lvprd+v_lvprd1+v_lvprdex;
									end if;
							end;	
					end if;	
			end if;
			if v_lvprd = 0 then
				return 0;-- valid  
			else			
				return 6;-- PL/SL availed one day before/after  CL
			end if;
    Else  -- leave not CL
			select (nvl(sum(DECODE(leavetype,'CL',leaveperiod,0)),0) * -1/8) into v_lvprd from ss_leaveledg where bdate between S_DATE and E_date and E_Date between S_Date and E_Date AND DB_CR = 'D' AND EMPNO = ltrim(Rtrim(P_EMPNO)) And Adj_Type<>'PN';
			--get preceeding day which is not a holiday

			if v_lvprd = 0 then
						Prev_date := GetLastWorkingDay(S_DATE,'-');
						Next_Date := GetLastWorkingDay(E_DATE,'+');
			begin
						--first check if CL availed on preceeding days	
						select (nvl(sum(DECODE(leavetype,'CL',leaveperiod,0)),0) * -1/8) into v_lvprd from ss_leaveledg where bdate = startdate - i  AND DB_CR = 'D' AND EMPNO = ltrim(Rtrim(P_EMPNO)) And Adj_Type<>'PN';
						if v_lvprd = 0 then 
						--check if CL 
							select (nvl(sum(DECODE(leavetype,'CL',leaveperiod,0)),0) * -1/8) into v_lvprd  from ss_leaveledg where edate = enddate - i  AND DB_CR = 'D' AND EMPNO = ltrim(Rtrim(P_EMPNO)) And Adj_Type<>'PN';
						end if;
			end;	
			end if;	
			if v_lvprd = 0 then			
						--check in Application table
					select (nvl(sum(DECODE(leavetype,'CL',leaveperiod,0)),0) * -1/8) into v_lvprd from ss_leaveapp where bdate between S_DATE and E_date and E_Date between S_Date and E_Date AND  EMPNO = ltrim(Rtrim(P_EMPNO)) and (hod_apprl <> 2 or hrd_apprl <> 2);
					if v_lvprd = 0 then
							begin
									--first check if CL availed on preceeding days	
									select (nvl(sum(DECODE(leavetype,'CL',leaveperiod,0)),0) * -1/8) into v_lvprd from ss_leaveapp where bdate = Prev_Date  AND EMPNO = ltrim(Rtrim(P_EMPNO)) and (hod_apprl <> 2 or hrd_apprl <> 2)  ;

									if v_lvprd = 0 then 
									--check if CL  availed on succeeding days
										select (nvl(sum(DECODE(leavetype,'CL',leaveperiod,0)),0) * -1/8) into v_lvprd from ss_leaveapp where edate = Next_Date  AND EMPNO = ltrim(Rtrim(P_EMPNO)) and (hod_apprl <> 2 or hrd_apprl <> 2) ;
									end if;
							end;	
					end if;	
			end if;
			if v_lvprd = 0 then
				return 0;-- valid  
			else			
				return 6;-- PL/SL availed one day before/after  CL
			end if;
	end if;			-- Main If
END;


/
