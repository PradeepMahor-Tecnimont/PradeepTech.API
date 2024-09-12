--------------------------------------------------------
--  DDL for Function EARLYGO1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."EARLYGO1" (EmpNum IN Varchar2, V_PDate IN Date) Return Number IS
		getDate Varchar2(2);
		VCount number;
		PunchNos number;
		LastPunch number;
		EGo Number;
		IsHoliday Varchar2(2);
		SCode Varchar2(10);
		OTime Number;
		V_AvailedLunchTime Number;
		V_EstimatedLunchTime Number;
		v_Count Number;
		v_isLeave Number;
		v_I_HH Number;
BEGIN			
			EGo := 0;
			getDate := To_Char(V_Pdate, 'dd');			

			Select count(*) InTo v_Count from ss_depu where bdate <= v_PDate
				and edate >= v_PDate and EmpNo = EmpNum And HOD_Apprl = 1 And HRD_Apprl=1;
			Select Count(*) InTo v_isLeave From SS_LeaveLedg Where EmpNo= Ltrim(Rtrim(EmpNum))
				and BDate <= v_PDate and Nvl(EDate,BDate) >= v_PDate 
        And (HD_Date is Null or (HD_part = 1 and hd_date <> v_PDate) )
				and (Adj_Type = 'LA' Or Adj_Type='LC');

			If v_Count > 0 Or v_isLeave > 0 Then
                    Return EGo;
			Else
					Select Substr(s_mrk, ((To_number(getDate) * 2) - 1), 2) Into SCode From ss_muster
						Where empno = Trim(lpad(EmpNum,5,'0')) And mnth = Trim(To_Char(V_Pdate, 'yyyymm'));
					If SCode = 'OO' Or SCode = 'HH' Then			
							Return EGo;
					End If;


    				Select TimeIn_HH*60+TimeIn_Mn InTo v_I_HH From SS_ShiftMast
    					Where ShiftCode = Trim(SCode);


					Select 
							GetShiftOutTime(EmpNum,V_PDate,SCode)
						InTo
							OTime
					From Dual;


					select count(*) into PunchNos from SS_IntegratedPunch where empno = ltrim(rtrim(lpad(EmpNum,5,'0'))) and PDate = V_PDate and falseflag=1 Order By PDate, HHSort, MMSort,hh,mm;

					If PunchNos > 1 then
                        if V_PDate < to_date('29-Oct-2018','dd-Mon-yyyy') then
							LastPunch := FirstLastPunch1(lpad(EmpNum,5,'0'),V_PDate,1);
                        else
                            LastPunch := Get_Punch_num(lpad(EmpNum,5,'0'),V_PDate,'KO','EGO');
                        end if;
							If LastPunch < v_I_HH Then
							     Return 0;
							End If;
							--V_AvailedLunchTime := AvailedLunchTime1(lpad(EmpNum,5,'0'), V_PDate ,SCode);
							--V_EstimatedLunchTime := EstimatedLunchTime(lpad(EmpNum,5,'0'), V_PDate ,SCode);
							--EGo := OTime - LastPunch - (V_EstimatedLunchTime - V_AvailedLunchTime);
              --EGo := OTime - LastPunch - V_AvailedLunchTime;
              EGo := OTime - LastPunch ;
							If EGo < 1 then
								EGo := 0;
							End If;
					End if;
			End If;
			Return EGo;
END;


/
