--------------------------------------------------------
--  DDL for Procedure OPENBALPL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "OPENBALPL" (V_EmpNo IN Varchar2, V_OpBalDtFrom IN Date, V_OpenBal IN Number,
												V_CL Out Number, V_PL Out Number, V_SL Out Number, V_EX Out Number, V_CO Out Number, V_OH Out Number, V_Tot OUT Number) IS
	VCount number;
	VCount1 number;
	VCount2 number;
	VCount3 number;
	VCount4 number;
	VCount5 number;
	VCount6 number;
	VCount7 number;
	VCount8 number;
	V_OpBalDtFetched date;
BEGIN
	V_CL := 0;
	V_PL := 0;
	V_SL := 0;
	V_EX := 0;
	V_CO := 0;
	V_OH := 0;
	V_Tot := 0;
	V_OpBalDtFetched := to_date('1-jan-1900','dd-mon-yyyy');

  		--Check if there are any record pertaining to the emp
	  	Select count(*) into VCount1 from SS_LeaveBal 
	  		where EmpNo = LTrim(Rtrim(V_EmpNo));

		-- Opening bal From date is null
  	If V_OpBalDtFrom is null then
	  	If VCount1 > 0 then
	  		-- Get date and 4 leave balances from LeaveBal Table  and return OpBalDtFetched and 4 LeaveBals
				select  BalDate, nvl(CL_Bal,0), nvl(PL_Bal,0), nvl(SL_Bal,0), nvl(EX_Bal,0),nvl(CO_Bal,0),nvl(OH_Bal,0)
				into V_OpBalDtFetched,V_CL, V_PL, V_SL, V_EX, V_CO, V_OH
				from ss_leavebal where baldate = (select max(BalDate) from SS_LeaveBal
				where EmpNo = LTrim(Rtrim(V_EmpNo)) group by empno) and empno = LTrim(Rtrim(V_EmpNo));
	  	End If;
	  	
				select count(*) into VCount3 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and leavetype = 'CL';
					If VCount3 > 0 then
						-- Return (Opening balances retrieved + (sum of leaves from OpBalDtRetrieved to OpBalDtFrom from LeaveLedg table))
						Select V_CL + Sum(LeavePeriod) into V_CL from SS_LeaveLedg 
							where empno = Ltrim(RTrim(V_EmpNo)) and BDate >= V_OpBalDtFetched and leavetype='CL' 
							group by leavetype;
					End If;
				select count(*) into VCount4 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and leavetype = 'PL';
					If VCount4 > 0 then
						Select V_PL + Sum(LeavePeriod) into V_PL from SS_LeaveLedg 
							where empno = Ltrim(RTrim(V_EmpNo)) and BDate >= V_OpBalDtFetched and leavetype='PL' 
							group by leavetype;
					End If;
				select count(*) into VCount5 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and leavetype = 'SL';
					If VCount5 > 0 then
						Select V_SL + Sum(LeavePeriod) into V_SL from SS_LeaveLedg 
							where empno = Ltrim(RTrim(V_EmpNo)) and BDate >= V_OpBalDtFetched and leavetype='SL' 
							group by leavetype;
					End If;
				select count(*) into VCount6 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and leavetype = 'EX';
					If VCount6 > 0 then
						Select V_EX + Sum(LeavePeriod) into V_EX from SS_LeaveLedg 
							where empno = Ltrim(RTrim(V_EmpNo)) and BDate >= V_OpBalDtFetched and leavetype='EX' 
							group by leavetype;
					End If;
				select count(*) into VCount7 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and leavetype = 'CO';
					If VCount7 > 0 then
						Select V_CO + Sum(LeavePeriod) into V_CO from SS_LeaveLedg 
							where empno = Ltrim(RTrim(V_EmpNo)) and BDate >= V_OpBalDtFetched and leavetype='CO' 
							group by leavetype;
					End If;
				select count(*) into VCount8 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and leavetype = 'OH';
					If VCount8 > 0 then
						Select V_OH + Sum(LeavePeriod) into V_OH from SS_LeaveLedg 
							where empno = Ltrim(RTrim(V_EmpNo)) and BDate >= V_OpBalDtFetched and leavetype='OH' 
							group by leavetype;
					End If;
  	Else
	  	-- If Opening Bal From Date is Not null
	  	-- Check if there are any records pertaining to the emp and on or prior to Op Bal From Date
	  	Select count(*) into VCount2 from SS_LeaveBal 
	  		where EmpNo = Ltrim(RTrim(V_EmpNo))
	  		and BalDate <= V_OpBalDtFrom;
	  		
	  	If VCount2 > 0 then
	  		-- Get the Greatest bal date and balances on that date which is <= to Op Baldatefrom from LeaveBal Table
				select  BalDate, nvl(CL_Bal,0), nvl(PL_Bal,0), nvl(SL_Bal,0), nvl(EX_Bal,0), nvl(CO_Bal,0), nvl(OH_Bal,0)
					into V_OpBalDtFetched, V_CL, V_PL, V_SL, V_EX, V_CO, V_OH
					from ss_leavebal where baldate = (select max(BalDate) from SS_LeaveBal
					where EmpNo = Ltrim(RTrim(V_EmpNo)) and BalDate <= V_OpBalDtFrom group by empno) and empno = Ltrim(RTrim(V_EmpNo));
	  	End if;
	  End If;
	  -- If closing bal is sought then	
	  If V_OpenBal = 0 and V_OpBalDtFrom is not null then
				-- Check If there are any records between OpBalDtFetched from above and OpBalDtFrom
				select count(*) into VCount3 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype = 'CL';
					If VCount3 > 0 then
						-- Return (Opening balances retrieved + (sum of leaves from OpBalDtRetrieved to OpBalDtFrom from LeaveLedg table))
						Select V_CL + Sum(LeavePeriod) into V_CL from SS_LeaveLedg 
							where empno = Ltrim(RTrim(V_EmpNo)) and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype='CL' 
							group by leavetype;
					End If;
				select count(*) into VCount4 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype = 'PL';
					If VCount4 > 0 then
						Select V_PL + Sum(LeavePeriod) into V_PL from SS_LeaveLedg 
							where empno = Ltrim(RTrim(V_EmpNo)) and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype='PL' 
							group by leavetype;
					End If;
				select count(*) into VCount5 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype = 'SL';
					If VCount5 > 0 then
						Select V_SL + Sum(LeavePeriod) into V_SL from SS_LeaveLedg 
							where empno = Ltrim(RTrim(V_EmpNo)) and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype='SL' 
							group by leavetype;
					End If;
				select count(*) into VCount6 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype = 'EX';
					If VCount6 > 0 then
						Select V_EX + Sum(LeavePeriod) into V_EX from SS_LeaveLedg 
							where empno = Ltrim(RTrim(V_EmpNo)) and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype='EX' 
							group by leavetype;
					End If;
				select count(*) into VCount7 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype = 'CO';
					If VCount7 > 0 then
						Select V_CO + Sum(LeavePeriod) into V_CO from SS_LeaveLedg 
							where empno = Ltrim(RTrim(V_EmpNo)) and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype='CO' 
							group by leavetype;
					End If;
				select count(*) into VCount8 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype = 'OH';
					If VCount8 > 0 then
						Select V_OH + Sum(LeavePeriod) into V_OH from SS_LeaveLedg 
							where empno = Ltrim(RTrim(V_EmpNo)) and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype='OH' 
							group by leavetype;
					End If;
		Elsif V_OpenBal = 1 and V_OpBalDtFrom is not null then
				-- Check If there are any records between OpBalDtFetched from above and OpBalDtFrom
				select count(*) into VCount3 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype = 'CL';
					If VCount3 > 0 then
						-- Return (Opening balances retrieved + (sum of leaves from OpBalDtRetrieved to OpBalDtFrom from LeaveLedg table))
						Select V_CL + Sum(LeavePeriod) into V_CL from SS_LeaveLedg 
							where empno = Ltrim(RTrim(V_EmpNo)) and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype='CL' 
							group by leavetype;
					End If;
				select count(*) into VCount4 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype = 'PL';
					If VCount4 > 0 then
						Select V_PL + Sum(LeavePeriod) into V_PL from SS_LeaveLedg 
							where empno = Ltrim(RTrim(V_EmpNo)) and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype='PL' 
							group by leavetype;
					End If;
				select count(*) into VCount5 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype = 'SL';
					If VCount5 > 0 then
						Select V_SL + Sum(LeavePeriod) into V_SL from SS_LeaveLedg 
							where empno = Ltrim(RTrim(V_EmpNo)) and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype='SL' 
							group by leavetype;
					End If;
				select count(*) into VCount6 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype = 'EX';
					If VCount6 > 0 then
						Select V_EX + Sum(LeavePeriod) into V_EX from SS_LeaveLedg 
							where empno = Ltrim(RTrim(V_EmpNo)) and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype='EX' 
							group by leavetype;
					End If;
				select count(*) into VCount7 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype = 'CO';
					If VCount7 > 0 then
						Select V_CO + Sum(LeavePeriod) into V_CO from SS_LeaveLedg 
							where empno = Ltrim(RTrim(V_EmpNo)) and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype='CO' 
							group by leavetype;
					End If;
				select count(*) into VCount8 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype = 'OH';
					If VCount8 > 0 then
						Select V_OH + Sum(LeavePeriod) into V_OH from SS_LeaveLedg 
							where empno = Ltrim(RTrim(V_EmpNo)) and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype='OH' 
							group by leavetype;
					End If;
		End If;
		V_Tot := V_CL + V_PL + V_SL + V_EX + V_CO + V_OH;
END;

/
