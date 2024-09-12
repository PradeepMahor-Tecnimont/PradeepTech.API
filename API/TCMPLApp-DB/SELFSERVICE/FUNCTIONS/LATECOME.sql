--------------------------------------------------------
--  DDL for Function LATECOME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."LATECOME" (EmpNum IN Varchar2, V_PDate IN Date) RETURN Number IS
	getDate		  Varchar2(2);
	ITime  			Number;
	LCome 			Number;
	SCode 			Varchar2(2);
	IsHoliday 	Number;	
	VCount 			Number;
	ITimeHH 		Number;
	ITimeMn 		Number;
	OTimeHH 		Number;
	OTimeMn 		Number;	
	PunchNos 		Number;
	FirstPunch 	Number;
	V_AvailedLunchTime  Number;
	V_EstimatedLunchTime Number;
BEGIN		
		ITime := 0;
		LCome := 0;
		IsHoliday := CheckHoliday(V_PDate);
		If IsHoliday = 3 then
			SCode := 'HH';
		ElsIf IsHoliday = 0 then
			getDate := To_Char(V_Pdate, 'dd');						

			Select Substr(s_mrk, ((To_number(getDate) * 2) - 1), 2) Into SCode From ss_muster
				Where empno = lpad(trim(EmpNum),5,'0') And mnth = Trim(To_Char(V_Pdate, 'yyyymm'));

			select TimeIn_HH,TimeIn_Mn,TimeOut_HH,TimeOut_Mn into ITimeHH, ITimeMn, OTimeHH, OTimeMn
				from SS_ShiftMast where ShiftCode = Trim(SCode); 
			ITime := ITimeHH * 60 + ITimeMn;
		End If;
		select count(*) into PunchNos from SS_IntegratedPunch where empno = lpad(trim(EmpNum),5,'0') and PDate = V_PDate Order By PDate, HHSort, MMSort;
		If PunchNos > 1 then
				FirstPunch := FirstLastPunch1(lpad(trim(EmpNum),5,'0'),V_PDate,0);
				If IsHoliday = 0 then
					V_AvailedLunchTime := AvailedLunchTime(EmpNum, V_PDate ,SCode);
					V_EstimatedLunchTime := EstimatedLunchTime(EmpNum, V_PDate ,SCode);
					LCome := FirstPunch - ITime - (V_EstimatedLunchTime - V_AvailedLunchTime);
					If LCome < 1 then
						LCome := 0;
					End If;
				End If;
		End if;
		Return LCome;
Exception 
	When Others Then
		Return -1;		
END;


/
