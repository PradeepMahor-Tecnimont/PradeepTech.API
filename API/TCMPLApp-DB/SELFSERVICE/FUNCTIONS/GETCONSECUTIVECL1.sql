--------------------------------------------------------
--  DDL for Function GETCONSECUTIVECL1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GETCONSECUTIVECL1" (P_EMPNO IN VARCHAR2, p_lvtype varchar2, NO_DAYS IN NUMBER,
													 S_DATE IN DATE, E_DATE IN DATE) RETURN Number IS
	v_count number := 0;
	v_lvprd number(8,1) := 0;
	v_nodays number:=0;
	ret_hday number;
	v_lvprdtot number :=0;
	v_Date date;
	Prev_date date;
	Next_Date date;
BEGIN
	--This program is being used currently
	Prev_date := getlastworkingday(S_DATE,'-');
	Next_Date := getlastworkingday(E_DATE,'+');
	--1
/*		select (nvl(sum(leaveperiod/8),0) * -1) into v_lvprd 
		from ss_leaveledg where bdate = Prev_Date	AND DB_CR = 'D' 
		AND ltrim(rtrim(EMPNO)) = ltrim(Rtrim(P_EMPNO)) 
		and ltrim(rtrim(leavetype)) = ltrim(rtrim(p_lvtype)) ;

	--2
		if v_lvprd<=3 then
			select (nvl(sum(leaveperiod/8),0) * -1) into v_lvprd 
			from ss_leaveledg where bdate = Next_Date	AND DB_CR = 'D' 
			AND ltrim(rtrim(EMPNO)) = ltrim(Rtrim(P_EMPNO)) 
			and ltrim(rtrim(leavetype)) = ltrim(rtrim(p_lvtype)) ;
			v_lvprdtot:=v_lvprdtot+v_lvprd;
		end if;

	--3
		if v_lvprdtot<=3 then
			select (nvl(sum(leaveperiod/8),0) * -1) into v_lvprd 
			from ss_leaveledg where edate = Prev_Date	AND DB_CR = 'D' 
			AND ltrim(rtrim(EMPNO)) = ltrim(Rtrim(P_EMPNO)) 
			and ltrim(rtrim(leavetype)) = ltrim(rtrim(p_lvtype)) ;
			v_lvprdtot:=v_lvprdtot+v_lvprd;
		end if;

	--4
		if v_lvprdtot <=3 then
			select (nvl(sum(leaveperiod/8),0) * -1) into v_lvprd 
			from ss_leaveledg where edate = Next_Date	AND DB_CR = 'D' 
			AND ltrim(rtrim(EMPNO)) = ltrim(Rtrim(P_EMPNO)) 
			and ltrim(rtrim(leavetype)) = ltrim(rtrim(p_lvtype)) ;
			v_lvprdtot:=v_lvprdtot+v_lvprd;
		end if;
	*/	
		--5
		if v_lvprdtot <=3 then
				select (nvl(sum(leaveperiod),0))/8 into v_lvprd from ss_leaveapp 
				where (Bdate = Prev_Date)
			  and EMPNO = ltrim(Rtrim(P_EMPNO)) and ltrim(rtrim(leavetype)) = ltrim(rtrim(p_lvtype)) ;
			  v_lvprdtot:=v_lvprdtot+v_lvprd;
		end if;

		--6
		if v_lvprdtot<= 3 then
				select (nvl(sum(leaveperiod),0))/8 into v_lvprd from ss_leaveapp 
				where (Bdate = Next_Date)
			  and EMPNO = P_EMPNO and leavetype = ltrim(rtrim(p_lvtype)) ;
			  v_lvprdtot:=v_lvprdtot+v_lvprd;
		end if;

		--7
		if v_lvprdtot <=3 then
				select (nvl(sum(leaveperiod),0))/8 into v_lvprd from ss_leaveapp 
				where (Edate = Prev_Date)
			  and EMPNO = Ltrim(Rtrim(P_EMPNO)) and leavetype = ltrim(rtrim(p_lvtype)) ;
			  v_lvprdtot:=v_lvprdtot+v_lvprd;
		end if;
		--8
		if v_lvprdtot<= 3 then
				select (nvl(sum(leaveperiod),0))/8 into v_lvprd from ss_leaveapp 
				where (Edate = Next_Date)
			  and EMPNO = ltrim(Rtrim(P_EMPNO)) and leavetype = ltrim(rtrim(p_lvtype)) ;
			  v_lvprdtot:=v_lvprdtot+v_lvprd;
		end if;

if v_lvprd > 3 then
	return 7; --prefix/suffix encountered		  	
else
	return 0;
end if;

END
;


/
