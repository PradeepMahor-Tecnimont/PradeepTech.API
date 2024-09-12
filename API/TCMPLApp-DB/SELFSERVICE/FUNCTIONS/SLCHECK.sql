--------------------------------------------------------
--  DDL for Function SLCHECK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."SLCHECK" (P_EMPNO IN VARCHAR2,p_lvtype varchar2,NO_DAYS IN NUMBER,S_DATE IN DATE,E_DATE IN DATE) RETURN Number IS
	v_lvprd number(8,1) := 0;
	startdate date;
	enddate date;
	Prev_date Date;
	Next_date Date;
BEGIN
startdate := s_Date;	
enddate := e_date;
-- FIRST CHECK IF LEAVE AVAILED ON PREVIOUS WORKING DAY 
Prev_date := GetLastWorkingDay(S_DATE,'-');
--IF Startdate -  Prev_Date <> 1 then -- this checks if there is holiday between 2 dates
	select COUNT(*) into v_lvprd 
	from ss_leaveledg 
	where (bdate = Prev_Date 
	OR edate = Prev_date ) 
	AND DB_CR = 'D' 
	AND EMPNO = ltrim(Rtrim(P_EMPNO)) And leaveType = 'SL'
        And Adj_Type <> 'PN';
--End if;
-- IF NO SL IS AVAILED ON PREVIOUS WORKING DAY WHICH IS NOT A HOLIDAY THEN
-- CHECK IF SL IS AVAILED ON NEXT WORKING DAY 
if v_lvprd = 0 then	
		Next_Date := GetLastWorkingDay(e_Date,'+');
		--IF Next_Date -  Startdate <> 1 then -- this checks if there is holiday between 2 dates
			select COUNT(*) into v_lvprd 
			from ss_leaveledg 
			where (bdate = Next_Date 
			OR edate = Next_date)  
			AND DB_CR = 'D' 
			AND EMPNO = ltrim(Rtrim(P_EMPNO)) And leaveType = 'SL'
                        And Adj_Type <> 'PN';
		--End if;
end if;
--The above check was in leaveledger, the below check is in leaveapp

-- FIRST CHECK IF LEAVE AVAILED ON PREVIOUS WORKING DAY 
if v_lvprd = 0 then
	--IF Startdate -  Prev_Date <> 1 then -- this checks if there is holiday between 2 dates	
		select COUNT(*) into v_lvprd 
		from ss_leaveapp
		where (bdate = Prev_Date 
		OR edate = Prev_date)  
		AND EMPNO = ltrim(Rtrim(P_EMPNO)) And leaveType = 'SL';

	--end if;
end if;
-- IF NO SL IS AVAILED ON PREVIOUS WORKING DAY WHICH IS NOT A HOLIDAY THEN
-- CHECK IF SL IS AVAILED ON NEXT WORKING DAY 
if v_lvprd = 0 then	
	--IF Next_Date -  Startdate <> 1 then -- this checks if there is holiday between 2 dates
		select COUNT(*) into v_lvprd 
		from ss_leaveapp 
		where (bdate = Next_Date 
		OR edate = Next_date ) 
		AND EMPNO = ltrim(Rtrim(P_EMPNO)) And leaveType = 'SL';

	--End if;
end if;
return v_lvprd;	
END;


/
