--------------------------------------------------------
--  DDL for Procedure CALCALL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "CALCALL" (EmpNum IN Varchar2, V_PDate IN Date, ITime OUT Number, V_ITime OUT Varchar2,
									LCome OUT Number, V_LCome OUT Varchar2, EGo OUT Number, V_EGo OUT varchar2,
									OTHrs OUT Number, V_OTHrs OUT varchar2, SCode IN OUT varchar2,
									IsHoliday OUT number,EstHrs OUT number)  IS
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
		select count(*) into PunchNos from SS_Punch where empno = ltrim(rtrim(EmpNum)) and PDate = V_PDate;
		If PunchNos > 1 then
				FirstPunch := FirstLastPunch(EmpNum,V_PDate,0);
				LastPunch := FirstLastPunch(EmpNum,V_PDate,1);
				If IsHoliday = 0 then
					LCome := FirstPunch - ITime;
					ECome := ITime - FirstPunch;
					V_LCome := lpad(to_char(Floor(LCome/60)),2,'0')|| ':' || lpad(to_char(Mod(LCome,60)),2,'0');
					If LCome < 0 then
						LCome := 0;
						V_LCome := ' ';
					End If;
					EGo := ((OTimeHH*60) + OTimeMn) - LastPunch;
					LGo := LastPunch - ((OTimeHH*60) + OTimeMn);
					V_EGo := lpad(to_char(Floor(EGo/60)),2,'0')|| ':' || lpad(to_char(Mod(EGo,60)),2,'0');
					If EGo < 0 then
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
--					OTHrs := OTPeriod(EmpNum,V_Pdate,OTimeHH,OTimeMn);
					OTHrs := ECome + LGo;
					V_OTHrs := lpad(to_char(Floor(OTHrs/60)),2,'0')|| ':' || lpad(to_char(Mod(OTHrs,60)),2,'0');
				End If;
		End if;
END
;

/
