--------------------------------------------------------
--  DDL for Function GETSHIFTINTIME1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GETSHIFTINTIME1" (p_EmpNo In Varchar2, p_PDate In Date,
												p_ShiftCode In Varchar2) RETURN Number IS
		v_Cntr Number := 0;
		v_Count Number := 0;
		v_HDPart Number := 0;
		v_RetVal Number := 0;
		v_HH Number :=0;
		v_MM Number :=0;
		v_HH1 Number :=0;
		v_MM1 Number :=0;
BEGIN
  	Select Count(*) InTo v_Cntr From SS_LeaveLedg 
  		Where EmpNo=Ltrim(Rtrim(p_EmpNo)) And HD_Date = p_PDate;

		  	If v_Cntr = 1 Then
		  			Select Nvl(HD_Part,0) InTo v_HDPart From SS_LeaveLedg 
		  				Where EmpNo=Ltrim(Rtrim(p_EmpNo)) And HD_Date = p_PDate;
		  	End If;
		  	If v_HDPart = 0 Then
		  			Select TimeIn_HH,TimeIn_Mn InTo v_HH,v_MM From SS_ShiftMast 
		  				Where ShiftCode = Ltrim(Rtrim(p_ShiftCode));
		  			v_RetVal := (v_HH*60) + v_MM;
		  	ElsIf v_HDPart = 2 Then
		  			Select HDay1_StartHH,HDay1_StartMM InTo v_HH, v_MM From SS_HalfDayMast 
		  				Where ShiftCode = Ltrim(Rtrim(p_ShiftCode)) And Parent = (Select Parent From SS_EmplMast Where EmpNo = Ltrim(Rtrim(p_EmpNo)));
		  			v_RetVal := (v_HH*60) + v_MM;
		  	ElsIf v_HDPart = 1 Then
		  			Select HDay2_StartHH,HDay2_StartMM InTo v_HH, v_MM From SS_HalfDayMast 
		  				Where ShiftCode = Ltrim(Rtrim(p_ShiftCode)) And Parent = (Select Parent From SS_EmplMast Where EmpNo = Ltrim(Rtrim(p_EmpNo)));
		  			v_RetVal := (v_HH*60) + v_MM;
		  	End If;
  	Select Count(*) InTo v_Count From SS_BusLate_LayOff_Detail 
  			Where EmpNo=Ltrim(Rtrim(p_EmpNo)) And PDate = p_PDate;
  	If v_Count = 1 Then

  			Select TimeIn_HH,TimeIn_MM InTo v_HH1, v_MM1
					From SS_BusLate_LayOff_Mast
					Where PDate=p_PDate 
					And Code = (Select Code From SS_BusLate_LayOff_Detail Where EmpNo=Ltrim(Rtrim(p_EmpNo)) And PDate = p_PDate);
  			If v_RetVal < ((v_HH1 * 60) + v_MM1) Then

  					v_RetVal := ((v_HH1 * 60) + v_MM1);
  			End If;
  	End If;
  	Return v_RetVal;

Exception
  	When Others Then
  			return 0;
END
;


/
