--------------------------------------------------------
--  DDL for Procedure OPENBALSPECIFIC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "OPENBALSPECIFIC" (V_EmpNo IN Varchar2, V_OpBalDtFrom IN Date, V_OpenBal IN Number,
												V_PL Out Number, V_Tot OUT Number) IS
	VCount number;
	VCount1 number;
	VCount2 number;
	VCount3 number;
	VCount4 number;
	VCount5 number;
	VCount6 number;
	V_OpBalDtFetched date;
BEGIN
	V_PL := 0;
	V_Tot := 0;
	V_OpBalDtFetched := '1-jan-1900';

  		--Check if there are any record pertaining to the emp
	  	Select count(*) into VCount1 from SS_LeaveBal 
	  		where EmpNo = trim(V_EmpNo);

		-- Opening bal From date is null
  	If V_OpBalDtFrom is null then
	  	If VCount1 > 0 then
	  		-- Get date and 4 leave balances from LeaveBal Table  and return OpBalDtFetched and 4 LeaveBals
				select  BalDate,nvl(PL_Bal,0)
				into V_OpBalDtFetched,V_PL
				from ss_leavebal where baldate = (select max(BalDate) from SS_LeaveBal
				where EmpNo = trim(V_EmpNo) group by empno) and empno = trim(V_EmpNo);
			End If;
  	Else
	  	-- If Opening Bal From Date is Not null
	  	-- Check if there are any records pertaining to the emp and on or prior to Op Bal From Date
	  	Select count(*) into VCount2 from SS_LeaveBal 
	  		where EmpNo = trim(V_EmpNo)
	  		and BalDate <= V_OpBalDtFrom;
	  		
	  	If VCount2 > 0 then
	  		-- Get the Greatest bal date and balances on that date which is <= to Op Baldatefrom from LeaveBal Table
				select  BalDate, nvl(PL_Bal,0)
					into V_OpBalDtFetched,V_PL
					from ss_leavebal where baldate = (select max(BalDate) from SS_LeaveBal
					where EmpNo = trim(V_EmpNo) and BalDate <= V_OpBalDtFrom group by empno) and empno = trim(V_EmpNo);
	  	End if;
	  End If;
	  If V_OpenBal = 0 then
				-- Check If there are any records between OpBalDtFetched from above and OpBalDtFrom
--				select count(*) into VCount3 from ss_leaveledg where empno = V_Empno 
--					and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype = 'CL';
--					If VCount3 > 0 then
						-- Return (Opening balances retrieved + (sum of leaves from OpBalDtRetrieved to OpBalDtFrom from LeaveLedg table))
--						Select V_CL + Sum(LeavePeriod) into V_CL from SS_LeaveLedg 
--							where empno = trim(V_EmpNo) and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype='CL' 
--							group by leavetype;
--					End If;
				select count(*) into VCount4 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype = 'PL';
					If VCount4 > 0 then
						Select V_PL + Sum(LeavePeriod) into V_PL from SS_LeaveLedg 
							where empno = trim(V_EmpNo) and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype='PL' 
							group by leavetype;
					End If;
--				select count(*) into VCount5 from ss_leaveledg where empno = V_Empno 
--					and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype = 'SL';
--					If VCount5 > 0 then
--						Select V_SL + Sum(LeavePeriod) into V_SL from SS_LeaveLedg 
--							where empno = trim(V_EmpNo) and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype='SL' 
--							group by leavetype;
--					End If;
--				select count(*) into VCount6 from ss_leaveledg where empno = V_Empno 
--					and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype = 'EX';
--					If VCount6 > 0 then
--						Select V_EX + Sum(LeavePeriod) into V_EX from SS_LeaveLedg 
--							where empno = trim(V_EmpNo) and BDate >= V_OpBalDtFetched and BDate <= V_OpBalDtFrom and leavetype='EX' 
--							group by leavetype;
--					End If;
		Elsif V_OpenBal = 1 then
				-- Check If there are any records between OpBalDtFetched from above and OpBalDtFrom
--				select count(*) into VCount3 from ss_leaveledg where empno = V_Empno 
--					and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype = 'CL';
--					If VCount3 > 0 then
						-- Return (Opening balances retrieved + (sum of leaves from OpBalDtRetrieved to OpBalDtFrom from LeaveLedg table))
--						Select V_CL + Sum(LeavePeriod) into V_CL from SS_LeaveLedg 
--							where empno = trim(V_EmpNo) and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype='CL' 
--							group by leavetype;
--					End If;
				select count(*) into VCount4 from ss_leaveledg where empno = V_Empno 
					and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype = 'PL';
					If VCount4 > 0 then
						Select V_PL + Sum(LeavePeriod) into V_PL from SS_LeaveLedg 
							where empno = trim(V_EmpNo) and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype='PL' 
							group by leavetype;
					End If;
--				select count(*) into VCount5 from ss_leaveledg where empno = V_Empno 
--					and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype = 'SL';
--					If VCount5 > 0 then
--						Select V_SL + Sum(LeavePeriod) into V_SL from SS_LeaveLedg 
--							where empno = trim(V_EmpNo) and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype='SL' 
--							group by leavetype;
--					End If;
--				select count(*) into VCount6 from ss_leaveledg where empno = V_Empno 
--					and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype = 'EX';
--					If VCount6 > 0 then
--						Select V_EX + Sum(LeavePeriod) into V_EX from SS_LeaveLedg 
--							where empno = trim(V_EmpNo) and BDate >= V_OpBalDtFetched and BDate < V_OpBalDtFrom and leavetype='EX' 
--							group by leavetype;
--					End If;
		End If;
		V_Tot := V_PL;
END;

/
