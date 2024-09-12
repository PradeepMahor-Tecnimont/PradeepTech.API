--------------------------------------------------------
--  DDL for Function CASUALLEAVECHECK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."CASUALLEAVECHECK" (P_EMPNO IN VARCHAR2, p_lvtype varchar2, NO_DAYS IN NUMBER,
													 S_DATE IN DATE, E_DATE IN DATE) RETURN number IS
	counter_hday number := 0;													 
 	v_Counter number :=0;
	v_count number := 0;
	v_lvprd number(8,1) := 0;
	v_nodays number:=0;
	ret_hday number;
	v_lvprdtot  number :=0;
	v_Date date;
	Prev_date date;
	Next_Date date;
BEGIN
   Select Nvl(SUM(leaveperiod),0)/8 Into v_count From ss_leaveapp
 		Where empno = ltrim(rTrim(P_EMPNO)) And 
 		((S_DATE Between bdate And edate Or E_DATE Between bdate And edate)
		or
		(bdate between S_DATE and E_DATE or edate between S_DATE and E_DATE));

	 If v_count = 0	Then
			Prev_date := GetLastWorkingDay(S_DATE,'-');
			Next_Date := GetLastWorkingDay(E_DATE,'+');
			if  (S_Date - Prev_date  > 1)   then
				select (nvl(sum(leaveperiod),0))/8 into v_lvprd from ss_leaveapp 
				where (Bdate = Prev_Date) and EMPNO = ltrim(Rtrim(P_EMPNO)) 
				and leavetype = ltrim(rtrim(p_lvtype));
					if v_lvprd = 0 then
										select (nvl(sum(leaveperiod),0))/8 into v_lvprd from ss_leaveapp 
										where (Edate = Prev_Date) and EMPNO = ltrim(Rtrim(P_EMPNO)) 
										and leavetype = ltrim(rtrim(p_lvtype));
					end if;
					if (NEXT_DATE -E_DATE > 1) and v_lvprd = 0 then
							select (nvl(sum(leaveperiod),0))/8 into v_lvprd from ss_leaveapp 
							where (Edate = Next_Date) and EMPNO = ltrim(Rtrim(P_EMPNO)) 
							and leavetype = ltrim(rtrim(p_lvtype));
						if v_lvprd = 0 then
							select (nvl(sum(leaveperiod),0))/8 into v_lvprd from ss_leaveapp 
							where (Bdate = Next_Date) and EMPNO = ltrim(Rtrim(P_EMPNO)) 
							and leavetype = ltrim(rtrim(p_lvtype));
						end if;
					end if;
					if v_lvprd <> 0 then
						counter_hday:=1;
					end if;
			Else
						select (nvl(sum(leaveperiod),0))/8 into v_lvprd from ss_leaveapp 
							where (Bdate = Prev_Date) and EMPNO = ltrim(Rtrim(P_EMPNO)) 
							and leavetype = ltrim(rtrim(p_lvtype));
						  v_lvprdtot:=v_lvprdtot+v_lvprd;
									--6
									if v_lvprdtot<= 3 then
											select (nvl(sum(leaveperiod),0))/8 into v_lvprd from ss_leaveapp 
											where (Bdate = Next_Date)
										  and EMPNO = ltrim(Rtrim(P_EMPNO)) and leavetype = ltrim(rtrim(p_lvtype)) ;
										  v_lvprdtot:=v_lvprdtot+v_lvprd;
									end if;

									--7
									if v_lvprdtot <=3 then
											select (nvl(sum(leaveperiod),0))/8 into v_lvprd from ss_leaveapp 
											where (Edate = Prev_Date and Edate <> Bdate)
										  and EMPNO = ltrim(Rtrim(P_EMPNO)) and leavetype = ltrim(rtrim(p_lvtype)) ;
										  v_lvprdtot:=v_lvprdtot+v_lvprd;
									end if;
									--8
									if v_lvprdtot<= 3 then
											select (nvl(sum(leaveperiod),0))/8 into v_lvprd from ss_leaveapp 
											where (Edate = Next_Date and Edate <> BDate)
										  and EMPNO = ltrim(Rtrim(P_EMPNO)) and leavetype = ltrim(rtrim(p_lvtype)) ;
										  v_lvprdtot:=v_lvprdtot+v_lvprd;
									end if;

							if v_lvprdtot > 3 then
								return 7; --prefix/suffix encountered		  	
							else
								return 0;
							end if;
			end if;
						if counter_hday = 1	then
							return 2;
						else 
							return 0;
						end if;							

	Else
		Return 1;						
	End If;	

END;


/
