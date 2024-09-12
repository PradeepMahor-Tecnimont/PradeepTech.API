--------------------------------------------------------
--  DDL for Function AVAILEDLUNCHTIME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."AVAILEDLUNCHTIME" (I_EmpNo IN Varchar2, I_PDate IN Date, I_SCode IN Varchar2) Return Number IS 
	v_RetVal			Number := 0;
	vParent 			Varchar2(4);
	vStartHH 			Number := 0;
	vStartMN 			Number := 0;
	vEndHH 				Number := 0;
	vEndMN 				Number := 0;
	vFirstPunch 	Number := 0;
	vLastPunch 		Number := 0;
	vIsHoliday		Number := 0;
BEGIN
  v_RetVal := AVAILEDLUNCHTIME1(i_empno,i_pdate,i_scode);
  return v_retval;
/*
	If I_SCode = 'OO' Or I_SCode = 'HH' Then
			Return 0;
	End If;
	Select Assign InTo vParent From SS_EmplMast Where EmpNo = Trim(I_EmpNo);

	Select Get_HOliday(I_PDate), FirstLastPunch1(I_EmpNo,I_PDate,0), FirstLastPunch1(I_EmpNo,I_PDate,1), StartHH, StartMN, EndHH, EndMN 
		InTo vIsHoliday, vFirstPunch, vLastPunch, vStartHH, vStartMN, vEndHH, vEndMN 
		From SS_LunchMast Where ShiftCode = Trim(I_SCode) And Parent = Trim(vParent);

	If vFirstPunch >= (vEndHH * 60) + vEndMN And vIsHoliday = 0 Then
			Return 0;
	ElsIf vLastPunch <= (vStartHH * 60) + vStartMN And vIsHoliday = 0 Then
			Return 0;
	ElsIf vFirstPunch <= (vStartHH * 60) + vStartMN And vIsHoliday = 0 And vLastPunch >= ((vEndHH * 60) + vEndMN) Then
			Return ((vEndHH * 60) + vEndMN) - ((vStartHH * 60) + vStartMN);
	ElsIf (vFirstPunch > (vStartHH * 60) + vStartMN) And (vFirstPunch < (vEndHH * 60) + vEndMN) And vIsHoliday = 0 Then
			Return ((vEndHH * 60) + vEndMN) - vFirstPunch;
	ElsIf NVL(Trim(vFirstPunch),0) = 0 And vIsHoliday = 0 Then
			Return 0;
	ElsIf vIsHoliday > 0 Or IsLeaveDepuTour(I_PDate, I_EmpNo) > 0 Then
			Return 0;
	Else
			Return 30;
	End If;

Exception
	When Others Then
		Return 30;
    */
END;


/
