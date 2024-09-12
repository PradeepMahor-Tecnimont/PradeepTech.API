--------------------------------------------------------
--  DDL for Function OTPERIOD1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."OTPERIOD1" (V_Code IN Varchar2, V_PDate IN Date, SCode IN Varchar2) RETURN number IS
		TotalHrs number;
		Cursor C1(OHrs IN Number, OMn IN Number) is select * from SS_IntegratedPunch 
			where EmpNo = ltrim(rtrim(V_Code))
			and PDate = V_PDate and ((HH * 60) + MM) > ((OHrs * 60) + OMn) order by PDate,hhsort,mmsort,hh,mm;
		Type TabHrs  is table of Number index by Binary_Integer;
		V_TabHrs TabHrs;

		Cntr Number;
		THrs Varchar2(10);

		V_ShiftOutHH Number;
		V_ShiftOutMN Number;
		V_Cntr Number;
BEGIN
		Select Count(*) into V_Cntr from SS_ShiftMast Where ShiftCode = Trim(SCode);
		If V_Cntr > 0 Then
				Select TimeOut_HH, TimeOUt_MN InTo V_ShiftOutHH, V_ShiftOUtMN From SS_ShiftMast Where ShiftCode = Trim(SCode);
				V_TabHrs(1) := (V_ShiftOutHH * 60) + V_ShiftOutMN + 60;
				Cntr := 2;
		Else
				V_ShiftOutHH := 0;
				V_ShiftOutMN := 0;
				Cntr := 1;
		End If;

		TotalHrs := 0;
		For C2 in C1(V_ShiftOutHH + 1, V_ShiftOutMN) Loop
				If Cntr > 1 Then
						If (V_TabHrs(Cntr-1) > (C2.HH * 60) + C2.MM) Or (((C2.HH * 60) + C2.MM) - v_TabHrs(Cntr-1) <= 60) Then
								V_TabHrs(Cntr) := V_TabHrs(Cntr-1);
						Else
								V_TabHrs(Cntr) := (C2.HH * 60) + C2.MM;
						End If;
				Else
						V_TabHrs(Cntr) := (C2.HH * 60) + C2.MM;
				End If;
				Cntr := Cntr + 1;
		End Loop;
		Cntr := Cntr - 1;
	  If Cntr > 1 Then
		  	For i in 1..Cntr Loop
			  		If Mod(i,2) <>0 then
				  			If i = Cntr Then
						  			TotalHrs := TotalHrs - (V_TabHrs(i-1) - V_TabHrs(i-2));
						  			TotalHrs := TotalHrs + (V_TabHrs(i) - V_TabHrs(i-2));
				  			ElsIf i < Cntr Then
						  			TotalHrs := TotalHrs + (V_TabHrs(i+1) - V_TabHrs(i));
				  			End If;
			  		End If;
		  	End Loop;
		  	--TotalHrs := (((V_TabHrs(Cntr).TabHrs * 60) + V_TabHrs(Cntr).TabMns) - ((V_TabHrs(1).TabHrs * 60) + V_TabHrs(1).TabMns));
	  End If;
	  Return TotalHrs;
END;


/
