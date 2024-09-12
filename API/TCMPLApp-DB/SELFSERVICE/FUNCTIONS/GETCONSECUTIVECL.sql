--------------------------------------------------------
--  DDL for Function GETCONSECUTIVECL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GETCONSECUTIVECL" (P_EMPNO IN VARCHAR2, p_lvtype varchar2, NO_DAYS IN NUMBER,
													 S_DATE IN DATE, E_DATE IN DATE) RETURN Number IS
	v_count number := 0;
	v_lvprd number(8,1) := 0;
	v_nodays number:=0;
	ret_hday number;
BEGIN
	--Program is not being used
	ret_hday := get_holiday(S_DATE - 1);
	if ret_hday = 1 or ret_hday = 2 or ret_hday = 3 then
		ret_hday := get_holiday(E_Date +1);
	end if;
		if ret_hday = 0 then 
			select (nvl(sum(leaveperiod),0) * -1)/8 into v_lvprd from ss_leaveledg 
				where bdate between S_DATE and E_date and E_Date between S_Date and E_Date 
				AND DB_CR = 'D' AND EMPNO = ltrim(Rtrim(P_EMPNO)) 
				and leavetype = ltrim(rtrim(p_lvtype));

				v_nodays := NO_DAYS + v_lvprd;
				if v_nodays <=3 then
					begin
						for i in 1..3 loop
							select (nvl(sum(leaveperiod),0) * -1)/8 into v_lvprd from ss_leaveledg where bdate = S_DATE - i AND DB_CR = 'D' AND EMPNO = ltrim(Rtrim(P_EMPNO)) and leavetype = ltrim(rtrim(p_lvtype));
							v_nodays := v_nodays + v_lvprd;
							if v_nodays > 3 then
								null;
							end if;
						end loop;
					exception 
						when others then
							v_lvprd := 0;
					end;
				end if;
				if v_nodays <=3 then
					begin
						for i in 1..3 loop
							select (nvl(sum(leaveperiod),0) * -1/8) into v_lvprd from ss_leaveledg where edate = E_DATE + i AND DB_CR = 'D' AND EMPNO = ltrim(Rtrim(P_EMPNO)) and leavetype = ltrim(rtrim(p_lvtype)) ;
							v_nodays := v_nodays + v_lvprd;
							if v_nodays > 3 then
								null;
							end if;
						end loop;
					exception 
						when others then
							v_lvprd := 0;
					end;
				end if;	 


				if v_nodays <=3 then
						select (nvl(sum(leaveperiod),0)/8) into v_lvprd from ss_leaveapp where bdate between S_DATE and E_date and E_Date between S_Date and E_Date and EMPNO = ltrim(Rtrim(P_EMPNO)) and leavetype = ltrim(rtrim(p_lvtype)) and (hod_apprl <> 2 or hrd_apprl <> 2) ;
						v_nodays := NO_DAYS + v_lvprd;
				end if;
				if v_nodays <=3 then
						begin
						for i in 1..3 loop
							select (nvl(sum(leaveperiod),0)/8) into v_lvprd from ss_leaveapp where bdate = S_DATE - i  AND EMPNO = ltrim(Rtrim(P_EMPNO)) and leavetype = ltrim(rtrim(p_lvtype)) and (hod_apprl <> 2 or hrd_apprl <> 2);
							v_nodays := v_nodays + v_lvprd;
							if v_nodays > 3 then
								null;
							end if;
							end loop;
						exception 
							when others then
							v_lvprd := 0;
						end;
				end if;
				if v_nodays <=3 then
						begin
						for i in 1..3 loop
							select (nvl(sum(leaveperiod),0)/8) into v_lvprd from ss_leaveapp where edate = E_DATE + i AND EMPNO = ltrim(Rtrim(P_EMPNO)) and leavetype = ltrim(rtrim(p_lvtype))  and (hod_apprl <> 2 or hrd_apprl <> 2);
							v_nodays := v_nodays + v_lvprd;
							if v_nodays > 3 then
								null;
							end if;
							end loop;
						exception 
							when others then
							v_lvprd := 0;
						end;
				end if;	 
				  if v_nodays <= 3 then
				  	return 4; --valid
				  else
				  	return 5; --no. of days of consecutive leave exceeds 3
				  end if;
		else
					return 7;	--prefix/suffix encountered		  	
		end if;				  
END
;


/
