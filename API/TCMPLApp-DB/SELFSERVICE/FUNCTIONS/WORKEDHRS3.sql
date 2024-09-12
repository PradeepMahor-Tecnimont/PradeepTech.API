--------------------------------------------------------
--  DDL for Function WORKEDHRS3
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."WORKEDHRS3" (V_Code IN Varchar2, V_PDate IN Date, V_ShiftCode IN Varchar2) Return Number IS
		Cursor C1 is select * from SS_IntegratedPunch 
			where EmpNo = ltrim(rtrim(V_Code))
			and PDate = V_PDate Order By PDate,hhsort,mmsort,hh,mm;
		Type TabHrs  is table of Number index by Binary_Integer;
		V_TabHrs TabHrs;
		Cntr Number;
		THrs Varchar2(10);
		TotalHrs Number;
		v_I_HH Number;
		v_I_MM Number;
		v_O_HH Number;
		v_O_MM Number;
		V_InTime Number;
		V_OutTime Number;
		v_Count Number;
		V_AvailedLunchTime Number := 0;
BEGIN
		If V_ShiftCode = 'OO' Or V_ShiftCode = 'HH' Then
				Return 0;
		End If;

--	New


			Select TimeIn_HH,TimeIn_Mn,TimeOut_HH,TimeOut_Mn InTo v_I_HH, v_I_MM ,v_O_HH, v_O_MM From SS_ShiftMast 
				Where ShiftCode = Ltrim(Rtrim(v_ShiftCode));
				v_InTime := (v_I_HH*60) + v_I_MM;
				v_OutTime := (v_O_HH*60) + v_O_MM;

  	Select Count(*) InTo v_Count From SS_BusLate_LayOff_Detail 
  			Where EmpNo=Ltrim(Rtrim(v_Code)) And PDate = v_PDate;
  	If v_Count = 1 Then
  			Select TimeIn_HH,TimeIn_MM,TimeOut_HH,TimeOut_MM InTo v_I_HH, v_I_MM ,v_O_HH, v_O_MM 
					From SS_BusLate_LayOff_Mast
					Where PDate=v_PDate 
					And Code = (Select Code From SS_BusLate_LayOff_Detail Where EmpNo=Ltrim(Rtrim(v_Code)) And PDate = v_PDate);
				v_InTime := (v_I_HH*60) + v_I_MM;
				v_OutTime := (v_O_HH*60) + v_O_MM;
  	End If;

-- End Of New

/*		Select 
					GetShiftInTime(v_Code,v_PDate,v_ShiftCode ),
					GetShiftOutTime(v_Code,v_PDate,v_ShiftCode )
				InTo 
					V_InTime, 
					V_OutTime
		From SS_ShiftMast Where ShiftCode = LTrim(Rtrim(V_ShiftCode));
*/			
		TotalHrs := 0;
		Cntr := 1;
		For C2 in C1 Loop
				If ((C2.HH * 60) + C2.MM) > V_OutTime + 60 Then
						V_TabHrs(Cntr) := V_OutTime  + 60;
						Cntr := Cntr + 1;
						Exit;
				Else
						If ((C2.HH * 60) + C2.MM)  < (V_InTime - 15) And Cntr = 1 Then
								V_TabHrs(Cntr) := (V_InTime -15);
								Cntr := Cntr + 1;
						ElsIf ((C2.HH * 60) + C2.MM)  >= (V_InTime - 15) Then
								If Cntr > 1 Then
										If v_TabHrs(Cntr-1) >= ((C2.HH * 60) + C2.MM) Then
												V_TabHrs(Cntr) := V_TabHrs(Cntr-1);
										ElsIf (((C2.HH * 60) + C2.MM) - v_TabHrs(Cntr-1)) <= 60 And Mod(CNtr,2)=1 Then
												V_TabHrs(Cntr) := v_TabHrs(Cntr-1);
										Else 
												V_TabHrs(Cntr) := (C2.HH * 60) + C2.MM;
										End If;
								Else
										V_TabHrs(Cntr) := (C2.HH * 60) + C2.MM;
								End If;
								Cntr := Cntr + 1;
						End If;
				End If;
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
		  	V_AvailedLunchTime := AvailedLunchTime1(V_Code, V_PDate ,V_ShiftCode );
		  	TotalHrs := TotalHrs - V_AvailedLunchTime;
	  End If;
	  Return TotalHrs ;
Exception
  	when others then return 0;
END
;


/
