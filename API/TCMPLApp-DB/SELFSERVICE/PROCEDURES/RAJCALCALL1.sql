--------------------------------------------------------
--  DDL for Procedure RAJCALCALL1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."RAJCALCALL1" (EmpNum IN Varchar2, V_PDate IN Date, ITime OUT Number, V_ITime OUT Varchar2,
									LCome OUT Number, V_LCome OUT Varchar2, EGo OUT Number, V_EGo OUT varchar2,
									OTHrs OUT Number, V_OTHrs OUT varchar2, SCode IN OUT varchar2,
									IsHoliday OUT number,EstHrs OUT number, V_Absent OUT Number)  IS
	VCount number;
	ITimeHH number;
	ITimeMn number;
	OTimeHH number;
	OTimeMn number;
	EHrs number;
	PunchNos number;
	FirstPunch number;
	LastPunch number;
	ECome number;
	LGo number;
	GVar number;
BEGIN
		V_Absent := 0;
		OTHrs := 0;
		ITime := 0;
		V_ITime := ' ';
		LCome := 0;
		V_LCome := ' ';
		EGo := 0;
		V_EGo := ' ';
		EstHrs := 0;
		IsHoliday := CheckHoliday(V_PDate);
		If IsHoliday = 3 then
			SCode := 'HH';
		ElsIf IsHoliday =0 then
			select TimeIn_HH,TimeIn_Mn,TimeOut_HH,TimeOut_Mn into ITimeHH, ITimeMn, OTimeHH, OTimeMn
				from SS_ShiftMast where ShiftCode = SCode; 
			ITime := ITimeHH * 60 + ITimeMn;
			V_ITime := lpad(to_char(ITimeHH),2,'0')||':'||lpad(to_char(ITimeMn),2,'0');
			EstHrs := ((OTimeHH*60) + OTimeMn) - ((ITimeHH * 60) + ITimeMn);
		End If;
		select count(*) into PunchNos from SS_IntegratedPunch where empno = ltrim(rtrim(EmpNum)) and PDate = V_PDate Order by PDate, HHSort, MMSort;
		If PunchNos > 1 then
				FirstPunch := FirstLastPunch1(EmpNum,V_PDate,0);
				LastPunch := FirstLastPunch1(EmpNum,V_PDate,1);
				If IsHoliday = 0 then
					LCome := FirstPunch - ITime;
					ECome := ITime - FirstPunch;
					V_LCome := lpad(to_char(Floor(LCome/60)),2,'0')|| ':' || lpad(to_char(Mod(LCome,60)),2,'0');
					If LCome < 1 then
						LCome := 0;
						V_LCome := ' ';
					End If;
					EGo := ((OTimeHH*60) + OTimeMn) - LastPunch;
					LGo := LastPunch - ((OTimeHH*60) + OTimeMn);
					V_EGo := lpad(to_char(Floor(EGo/60)),2,'0')|| ':' || lpad(to_char(Mod(EGo,60)),2,'0');
					If EGo < 1 then
						EGo := 0;
						V_EGo := ' ';
					End If;
				End If;
				If IsHoliday > 0 then
					OTHrs := OTPeriod(EmpNum,V_Pdate,SCode);
					V_OTHrs := lpad(to_char(Floor(OTHrs/60)),2,'0')|| ':' || lpad(to_char(Mod(OTHrs,60)),2,'0');
				Else
					If Ecome < 0 then
						ECome := 0;
					End If;
					If LGo < 0 then
						LGo := 0;
					End if;
					If LCome + EGo > 2 * 60 Then
						EStHrs := EStHrs / 2;
						V_Absent := 0.5;
						OTHrs := WorkedHrs1(trim(EmpNum),V_PDate, SCode) - EStHrs;
					ElsIF LCome + EGo > 4 * 60 Then
						EStHrs := 0;
						V_Absent := 1;
						OTHrs := WorkedHrs1(trim(EmpNum),V_PDate, SCode) - EStHrs;
					Else
						OTHrs := ECome + LGo;
					End If;
					If OTHrs > 0 Then
						V_OTHrs := lpad(to_char(Floor(OTHrs/60)),2,'0')|| ':' || lpad(to_char(Mod(OTHrs,60)),2,'0');
					ElsIf OTHrs < 1 Then
						OTHrs := 0;
						V_OTHrs := ' ';
					End If;
				End If;
		End if;

END
;


/
