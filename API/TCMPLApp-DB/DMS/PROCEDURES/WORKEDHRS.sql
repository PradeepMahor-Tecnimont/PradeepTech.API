--------------------------------------------------------
--  DDL for Procedure WORKEDHRS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "WORKEDHRS" (V_Code IN Varchar2, V_PDate IN Date, TotalHrs OUT Number,
										V_TotHrs OUT Varchar2) Is
	Cursor C1 is select * from SS_Punch 
		where EmpNo = ltrim(rtrim(V_Code))
		and PDate = V_PDate;
	Type TabHrsRec is record (TabHrs number, TabMns number);
	Type TabHrs  is table of TabHrsRec index by Binary_Integer;
	V_TabHrs TabHrs;
	Cntr Number;
	THrs Varchar2(10);
BEGIN
	TotalHrs := 0;
	Cntr := 1;
	For C2 in C1 Loop
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
  End If;
  If TotalHrs > 0 Then
		V_TotHrs := lpad(to_char(Floor(TotalHrs/60)),2,'0')|| ':' || lpad(to_char(Mod(TotalHrs,60)),2,'0');
  Else
  	V_TotHrs := ' ';
  End If;
Exception
  	when others then null;
END;

/
