--------------------------------------------------------
--  DDL for Function EARLYGO
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."EARLYGO" (EmpNum IN Varchar2, V_PDate IN Date) Return Number IS
	getDate Varchar2(2);
	VCount number;
	ITimeHH number;
	ITimeMn number;
	OTimeHH number;
	OTimeMn number;	
	PunchNos number;
	LastPunch number;
	EGo Number;
	IsHoliday Varchar2(2);
	SCode Varchar2(10);
	OTime Number;
	V_AvailedLunchTime Number;
	V_EstimatedLunchTime Number;
BEGIN			
		EGo := 0;
		IsHoliday := CheckHoliday(V_PDate);
		If IsHoliday = 3 then
			SCode := 'HH';
		ElsIf IsHoliday = 0 then
			getDate := To_Char(V_Pdate, 'dd');			

			Select Substr(s_mrk, ((To_number(getDate) * 2) - 1), 2) Into SCode From ss_muster
				Where empno = Trim(lpad(EmpNum,5,'0')) And mnth = Trim(To_Char(V_Pdate, 'yyyymm'));

			select TimeIn_HH,TimeIn_Mn,TimeOut_HH,TimeOut_Mn into ITimeHH, ITimeMn, OTimeHH, OTimeMn
				from SS_ShiftMast where ShiftCode = Trim(SCode); 
			OTime := ((OTimeHH*60) + OTimeMn);
		End If;
		select count(*) into PunchNos from SS_IntegratedPunch where empno = ltrim(rtrim(lpad(EmpNum,5,'0'))) and PDate = V_PDate Order By PDate, HHSort, MMSort;
		If PunchNos > 1 then
				LastPunch := FirstLastPunch1(lpad(EmpNum,5,'0'),V_PDate,1);
				If IsHoliday = 0 then
					V_AvailedLunchTime := AvailedLunchTime(lpad(EmpNum,5,'0'), V_PDate ,SCode);
					V_EstimatedLunchTime := EstimatedLunchTime(lpad(EmpNum,5,'0'), V_PDate ,SCode);
					EGo := OTime - LastPunch - (V_EstimatedLunchTime - V_AvailedLunchTime);
					If EGo < 1 then
						EGo := 0;
					End If;
				End If; 
		End if;
		Return EGo;
END;


/
