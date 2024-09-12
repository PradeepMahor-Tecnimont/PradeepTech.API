--------------------------------------------------------
--  DDL for Procedure GET_LEAVE_BALANCE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GET_LEAVE_BALANCE" (param_EmpNo IN Varchar2, param_date IN Date, param_open_close IN Number,
                                                      param_leave_type in varchar2,param_leave_count Out Number ) IS
	v_Count number;
  v_cl number;
  v_pl number;
  v_sl number;
  v_ex number;
  v_co number;
  v_oh number;
  v_lv number;
	v_OpBalDtFetched date;
BEGIN
    param_leave_count := 0;
    V_OpBalDtFetched := to_date('1-jan-1900','dd-mon-yyyy');

  		--Check if there are any record pertaining to the emp
	  	Select count(*) into v_count from SS_LeaveBal where EmpNo = LTrim(Rtrim(param_EmpNo));
	  	If v_count > 0 and param_leave_type <> 'LV' then
	  		-- Get date and 4 leave balances from LeaveBal Table  and return OpBalDtFetched and 4 LeaveBals
				select  BalDate, nvl(CL_Bal,0), nvl(PL_Bal,0), nvl(SL_Bal,0), nvl(EX_Bal,0),nvl(CO_Bal,0),nvl(OH_Bal,0)
				into V_OpBalDtFetched,V_CL, V_PL, V_SL, V_EX, V_CO, V_OH
				from ss_leavebal where baldate = (select max(BalDate) from SS_LeaveBal
				where EmpNo = LTrim(Rtrim(param_EmpNo))  and baldate < param_date group by empno) and empno = LTrim(Rtrim(param_empno));

        param_leave_count := CASE param_leave_type
                                when 'CL' then v_cl
                                when 'SL' then v_sl
                                when 'PL' then v_pl
                                when 'EX' then v_ex
                                when 'CO' then v_co
                                when 'OH' then v_oh
                                when 'LV' then v_lv
                              end;

	  	End If;
    
    
	  -- If closing bal is sought then	
	  If param_open_close = ss.closing_bal and param_date is not null then
				-- Check If there are any records between OpBalDtFetched from above and OpBalDtFrom
				select count(*) into v_Count from ss_leaveledg where empno = param_EmpNo 
					and BDate >= V_OpBalDtFetched and BDate <= param_date and leavetype = param_leave_type;
					If v_Count > 0 then
						-- Return (Opening balances retrieved + (sum of leaves from OpBalDtRetrieved to OpBalDtFrom from LeaveLedg table))
						Select param_leave_count + Sum(LeavePeriod) into param_leave_count from SS_LeaveLedg 
							where empno = Ltrim(RTrim(param_EmpNo)) and BDate >= V_OpBalDtFetched and BDate <= param_date 
              and leavetype=param_leave_type group by leavetype;
					End If;
				select count(*) into v_count from ss_leaveledg where empno = param_EmpNo
					and BDate >= param_date and BDate <= param_date and leavetype = param_leave_type;
					If v_count > 0 then
						Select param_leave_count + Sum(LeavePeriod) into param_leave_count from SS_LeaveLedg 
							where empno = Ltrim(RTrim(param_empno)) and BDate >= param_date and BDate <= param_date 
              and leavetype = param_leave_type group by leavetype;
					End If;
		Elsif param_open_close = ss.opening_bal then
				-- Check If there are any records between OpBalDtFetched from above and OpBalDtFrom
				select count(*) into v_count from ss_leaveledg where empno = param_empno
					and BDate >= param_date and BDate < param_date and leavetype = param_leave_type;
					If v_count > 0 then
						-- Return (Opening balances retrieved + (sum of leaves from OpBalDtRetrieved to OpBalDtFrom from LeaveLedg table))
						Select param_leave_count + Sum(LeavePeriod) into param_leave_count from SS_LeaveLedg 
							where empno = Trim(param_empno) and BDate >= param_date and BDate < param_date 
              and leavetype = param_leave_type group by leavetype;
					End If;
				select count(*) into v_count from ss_leaveledg where empno = param_empno 
					and BDate >= param_date and BDate < param_date and leavetype = param_leave_type;
					If v_count > 0 then
						Select param_leave_count + Sum(LeavePeriod) into param_leave_count from SS_LeaveLedg 
							where empno = Trim(param_empno) and BDate >= param_date and BDate < param_date 
              and leavetype = param_leave_type group by leavetype;
					End If;
    end if;
END;

/
