--------------------------------------------------------
--  DDL for Function LATECOME1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."LATECOME1" (EmpNum IN Varchar2, V_PDate IN Date) RETURN Number IS
	getDate		  Varchar2(2);
	ITime  			Number;
	LCome 			Number;
	SCode 			Varchar2(2);
	VCount 			Number;
	PunchNos 		Number;
	FirstPunch 	Number;
	IsHoliday   Number;
	V_AvailedLunchTime  Number;
	V_EstimatedLunchTime Number;
	v_Count Number;
	v_isLeave Number;
BEGIN		
		ITime := 0;
		LCome := 0;
		SCode := GetShift1(EmpNum,v_PDate);

		Select count(*) InTo v_Count from ss_depu where bdate <= v_PDate
			and edate >= v_PDate and EmpNo = EmpNum And HOD_Apprl = 1 And HRD_Apprl=1;

		Select Count(*) InTo v_isLeave From SS_LeaveLedg Where EmpNo= Ltrim(Rtrim(EmpNum))
			and BDate <= v_PDate and Nvl(EDate,BDate) >= v_PDate 
      And (HD_Date is Null or (HD_part = 1 and hd_date <> v_PDate) )
			and (Adj_Type = 'LA' Or Adj_Type='LC');

		If v_Count > 0 Or v_isLeave > 0 Then
				LCome := 0;
		Else
				If Ltrim(RTrim(SCode)) = 'HH' Or LTrim(RTrim(SCode)) = 'OO' Then
						Return LCome;
				Else
						Select 
								GetShiftInTime(EmpNum,V_PDate,SCode)
							InTo
								ITime
						From Dual;

				End If;
				select count(*) into PunchNos from SS_IntegratedPunch where empno = lpad(trim(EmpNum),5,'0') and PDate = V_PDate and falseflag = 1 Order By PDate, HHSort, MMSort ;
				If PunchNos > 1 then
                    if V_PDate < to_date('29-Oct-2018','dd-Mon-yyyy') then
						FirstPunch := FirstLastPunch1(lpad(trim(EmpNum),5,'0'),V_PDate,0);
                    else
                        FirstPunch := Get_Punch_Num(lpad(EmpNum,5,'0'),V_PDate,'OK','LC');
                    end if;
						--V_AvailedLunchTime := AvailedLunchTime(EmpNum, V_PDate ,SCode);
						--LCome := FirstPunch - ITime - V_AvailedLunchTime; 
						LCome := FirstPunch - ITime ; 
						If LCome < 1 then
							LCome := 0;
						End If;
				ElsIf PunchNos = 1 Then
						LCome := 8 * 60;
				End if;
		End If;
		Return LCome;
Exception 
	When Others Then
		Return 0;		
END;


/
