--------------------------------------------------------
--  DDL for Function PLCLCOMBINECHECK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."PLCLCOMBINECHECK" (P_EMPNO IN VARCHAR2,p_lvtype varchar2,NO_DAYS IN NUMBER,S_DATE IN DATE,E_DATE IN DATE) RETURN Number IS
		v_lvprd number(8,1) := 0;
		ret_hday number := 0;
		startdate date;
		enddate date;
		ctr number := 0;
		i number := 1;
		v_count number:=0;
		Prev_date DATE;
		Next_Date DATE;
BEGIN
		Prev_date := getlastworkingday(S_DATE,'-');
		Next_Date := getlastworkingday(E_DATE,'+');

   	Select Nvl(SUM(leaveperiod),0)/8 Into v_count From ss_leaveapp
 			Where empno = P_EMPNO  And
 			((S_DATE Between bdate And edate Or E_DATE Between bdate And edate)
			or
			(bdate between S_DATE and E_DATE or edate between S_DATE and E_DATE));

		If v_count = 0	Then

				startdate := s_Date;	
				enddate := e_date;
				select (nvl(sum(leaveperiod),0) * -1/8) into v_lvprd from ss_leaveledg 
					where (bdate between S_DATE and E_date Or EDate between S_Date and E_Date) 
					AND DB_CR = 'D' AND EMPNO = ltrim(Rtrim(P_EMPNO)) 
					and leavetype = 'CL' And Adj_Type <> 'PN';
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
								--first check if CL  availed on preceeding day
								select (nvl(sum(leaveperiod),0) * -1/8) into v_lvprd from ss_leaveledg where bdate = PREV_DATE  AND DB_CR = 'D' AND EMPNO = ltrim(Rtrim(P_EMPNO)) and leavetype = 'CL' And Adj_Type <> 'PN';

								if v_lvprd = 0 then 
										--check if CL availed on succeeding day
										select (nvl(sum(leaveperiod),0) * -1/8) into v_lvprd from ss_leaveledg where edate = NEXT_DATE  AND DB_CR = 'D' AND EMPNO = ltrim(Rtrim(P_EMPNO)) and leavetype = 'CL' And Adj_Type <> 'PN';
								end if;
						EXCEPTION WHEN OTHERS THEN
								v_lvprd := 0;				
						end;	
				end if;	
				if v_lvprd = 0 then			
						--check in Application table
						select (nvl(sum(leaveperiod),0)/8) into v_lvprd from ss_leaveapp where (bdate between S_DATE and E_date Or EDate between S_Date and E_Date) AND  EMPNO = ltrim(Rtrim(P_EMPNO)) and leavetype = 'CL' and (hod_apprl <> 2 or hrd_apprl <> 2);			
						if v_lvprd = 0 then
								begin
										--first check if CL availed on preceeding day	
										select (nvl(sum(leaveperiod),0)/8)  into v_lvprd from ss_leaveapp where 
											PREV_DATE Between BDate And EDate AND 
											EMPNO = ltrim(Rtrim(P_EMPNO)) and 
											leavetype = 'CL' and 
											(hod_apprl <> 2 or hrd_apprl <> 2) ;
										if v_lvprd = 0 then 
												--check if CL availed on succeeding day
												select (nvl(sum(leaveperiod),0)/8)  into v_lvprd from ss_leaveapp where 
													NEXT_DATE  Between BDate And EDate AND 
													EMPNO = ltrim(Rtrim(P_EMPNO)) and 
													leavetype = 'CL' and (hod_apprl <> 2 or hrd_apprl <> 2) ;
										end if;
								end;	
						end if;	
				end if;

				if v_lvprd = 0 then
						return 0;-- valid  
				else			
						return 6;-- CL availed one day before/after  PL/SL
				end if;
		else
				return 1; -- Leave already availed on same day
		end if;
END;


/
