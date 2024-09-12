--------------------------------------------------------
--  DDL for Procedure OTPERIODS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."OTPERIODS" (V_Code IN Varchar2, V_PDate IN Date, SCode IN Varchar2, TotalHrs Out Number,
		TimeInHrs Out Varchar2, ActualHrs Out Number, ActualTimeInHrs Out varchar2) IS	
	Cursor C1(OHrs IN Number, OMn IN Number) is select * from SS_IntegratedPunch 
		where EmpNo = ltrim(rtrim(V_Code))
		and PDate = V_PDate and ((HH * 60) + MM) > ((OHrs * 60) + OMn) order by PDate,hhsort,mmsort,hh,mm;
	Type TabHrsRec is record (TabHrs number, TabMns number);
	Type TabHrs  is table of TabHrsRec index by Binary_Integer;
	V_TabHrs TabHrs;

	Cntr Number;
	THrs Varchar2(10);

	V_ShiftOutHH Number;
	V_ShiftOutMN Number;
	V_Cntr Number;	
	V_Minutes Number;
	V_Min VarChar2(2);
BEGIN
	Select Count(*) into V_Cntr from SS_ShiftMast Where ShiftCode = Trim(SCode);
	If V_Cntr > 0 Then
		Select TimeOut_HH, TimeOUt_MN InTo V_ShiftOutHH, V_ShiftOUtMN From SS_ShiftMast Where ShiftCode = Trim(SCode);
		V_TabHrs(1).TabHrs := V_ShiftOutHH + 1;
		V_TabHrs(1).TabMns := V_ShiftOutMN;
		Cntr := 2;
	Else
		V_ShiftOutHH := 0;
		V_ShiftOutMN := 0;
		Cntr := 1;
	End If;

	TotalHrs := 0;
	ActualHrs := 0;
	For C2 in C1(V_ShiftOutHH + 1, V_ShiftOutMN) Loop
		V_TabHrs(Cntr).TabHrs := C2.HH;
		V_TabHrs(Cntr).TabMns := C2.MM;
		Cntr := Cntr + 1;
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
  	TimeInHrs := Floor(TotalHrs/60) || ':' || Lpad(Mod(TotalHrs,60),2,'0');

  	V_Minutes := Mod(TotalHrs,60);
  	If V_Minutes < 30 Then
  		V_Min := '00';	
  	Elsif V_Minutes >= 30 Then
  		V_Min := '30';
  	End If;	  	  	
  	ActualHrs := (Floor(TotalHrs/60) * 60) + To_Number(V_Min);
  	ActualTimeInHrs := Floor(TotalHrs/60) || ':' || V_Min;
  	--TotalHrs := (((V_TabHrs(Cntr).TabHrs * 60) + V_TabHrs(Cntr).TabMns) - ((V_TabHrs(1).TabHrs * 60) + V_TabHrs(1).TabMns));
  End If;  

END;


/
