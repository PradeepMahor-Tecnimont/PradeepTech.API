--------------------------------------------------------
--  DDL for Function CLOSINGSLBAL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."CLOSINGSLBAL" (V_EmpNo  In Varchar2, V_OpBalDtFrom IN Date, V_OpenBal IN Number) Return Number IS
	VCount number;
	VCount1 number;
	VCount2 number;
	V_OpBalDtFetched date;
	V_SL Number;
BEGIN
	V_SL := 0;	
	V_OpBalDtFetched := to_date('1-jan-1900','dd-mon-yyyy');
		--Check if there are any record pertaining to the emp
  	Select count(*) into VCount1 from SS_LeaveBal 
  		where EmpNo = trim(V_EmpNo);

		-- Opening bal From date is null
  	If V_OpBalDtFrom is null then
	  	If VCount1 > 0 then
	  		-- Get date and 4 leave balances from LeaveBal Table  and return OpBalDtFetched and 4 LeaveBals
				select  BalDate, nvl(SL_Bal,0)
				into V_OpBalDtFetched ,V_SL 
				from ss_leavebal where baldate = (select max(BalDate) from SS_LeaveBal
				where EmpNo = trim(V_EmpNo) group by empno) and empno = trim(V_EmpNo);
	  	End If;

				select count(*) into VCount2 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and leavetype = 'SL';
					If VCount2 > 0 then
						Select V_SL + Sum(LeavePeriod) into V_SL from SS_LeaveLedg 
							where empno = trim(V_EmpNo) and BDate >= V_OpBalDtFetched and leavetype='SL' 
							group by leavetype;
					End If;
  	Else
	  	-- If Opening Bal From Date is Not null
	  	-- Check if there are any records pertaining to the emp and on or prior to Op Bal From Date
	  	Select count(*) into VCount2 from SS_LeaveBal 
	  		where EmpNo = trim(V_EmpNo)
	  		and BalDate <= V_OpBalDtFrom;

	  	If VCount2 > 0 then
	  		-- Get the Greatest bal date and balances on that date which is <= to Op Baldatefrom from LeaveBal Table
				select  BalDate, nvl(SL_Bal,0)
					into V_OpBalDtFetched, V_SL
					from ss_leavebal where baldate = (select max(BalDate) from SS_LeaveBal
					where EmpNo = trim(V_EmpNo) and BalDate <= V_OpBalDtFrom group by empno) 
					and empno = trim(V_EmpNo);
	  	End if;
	  End If;

	  -- If closing bal is sought then		
	  If V_OpenBal = 0 and V_OpBalDtFrom is not null then
				-- Check If there are any records between OpBalDtFetched from above and OpBalDtFrom
				select count(*) into VCount2 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype = 'SL';
					If VCount2 > 0 then
						Select V_SL + Sum(LeavePeriod) into V_SL from SS_LeaveLedg 
							where empno = trim(V_EmpNo) and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype='SL' 
							group by leavetype;
					End If;
		Elsif V_OpenBal = 1 and V_OpBalDtFrom is not null then
				-- Check If there are any records between OpBalDtFetched from above and OpBalDtFrom
				select count(*) into VCount2 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype = 'SL';
					If VCount2 > 0 then
						Select V_SL + Sum(LeavePeriod) into V_SL from SS_LeaveLedg 
							where empno = trim(V_EmpNo) and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype='SL' 
							group by leavetype;
					End If;
		End If;
		V_SL := V_SL/8;
		Return V_SL;
END;



/
