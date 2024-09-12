--------------------------------------------------------
--  DDL for Function WORKEDHRS11
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."WORKEDHRS11" (V_Code IN Varchar2, V_PDate IN Date, V_ShiftCode IN Varchar2) Return Number IS
	Cursor C1 is select * from SS_IntegratedPunch 
		where EmpNo = ltrim(rtrim(V_Code))
		and PDate = V_PDate Order By PDate,hhsort,mmsort,hh,mm;
	Type TabHrsRec is record (TabHrs number, TabMns number);
	Type TabHrs  is table of TabHrsRec index by Binary_Integer;
	V_TabHrs TabHrs;
	Cntr Number;
	THrs Varchar2(10);
	TotalHrs Number;
	V_InTimeHH Number;
	V_InTimeMN Number;
	V_OutTimeHH Number;
	V_OutTimeMN Number;
	v_AvailedLunchTime Number := 0;
BEGIN
	Select TimeIn_HH, TimeIn_Mn, TimeOut_HH, TimeOut_Mn InTo V_InTimeHH, V_InTimeMN, V_OutTimeHH, V_OutTimeMN From SS_ShiftMast Where ShiftCode = Trim(V_ShiftCode);
	TotalHrs := 0;
	Cntr := 1;
	For C2 in C1 Loop
		If ((C2.HH * 60) + C2.MM) > (((V_OutTimeHH * 60) + V_OutTimeMN) + 60) Then
				V_TabHrs(Cntr).TabHrs := FLoor(((V_OutTimeHH * 60) + V_OutTimeMN + 60)/60);
				V_TabHrs(Cntr).TabMns := Mod(((V_OutTimeHH * 60) + V_OutTimeMN + 60),60);
				Cntr := Cntr + 1;
				Exit;
		Else
			If ((C2.HH * 60) + C2.MM  < (V_InTimeHH * 60) + V_InTimeMN - 15) And Cntr = 1 Then
				V_TabHrs(Cntr).TabHrs := FLoor(((V_InTimeHH * 60) + V_InTimeMN - 15)/60);
				V_TabHrs(Cntr).TabMns := Mod(((V_InTimeHH * 60) + V_InTimeMN - 15),60);
				Cntr := Cntr + 1;
			ElsIf ((C2.HH * 60) + C2.MM  >= (V_InTimeHH * 60) + V_InTimeMN - 15) Then
				V_TabHrs(Cntr).TabHrs := C2.HH;
				V_TabHrs(Cntr).TabMns := C2.MM;
				Cntr := Cntr + 1;
			End If;
		End If;
	End Loop;
	Cntr := Cntr - 1;
  If Cntr > 1 Then
  	For i in 1..Cntr Loop
  		If Mod(i,2) <>0 then
  			If i = Cntr Then
	  			TotalHrs := TotalHrs - (((V_TabHrs(i-1).TabHrs * 60) + V_TabHrs(i-1).TabMns) - ((V_TabHrs(i-2).TabHrs * 60) + V_TabHrs(i-2).TabMns));
	  			TotalHrs := TotalHrs + (((V_TabHrs(i).TabHrs * 60) + V_TabHrs(i).TabMns) - ((V_TabHrs(i-2).TabHrs * 60) + V_TabHrs(i-2).TabMns));
  			ElsIf i < Cntr Then
	  			TotalHrs := TotalHrs + (((V_TabHrs(i+1).TabHrs * 60) + V_TabHrs(i+1).TabMns) - ((V_TabHrs(i).TabHrs * 60) + V_TabHrs(i).TabMns));
  			End If;
  		End If;
  	End Loop;
  	v_AvailedLunchTime := AvailedLunchTime(V_Code, V_PDate, V_ShiftCode);
  	TotalHrs := TotalHrs - v_AvailedLunchTime;
  End If;
  Return TotalHrs;
Exception
  	when others then return 0;
END
;


/
