--------------------------------------------------------
--  DDL for Function ESTIMATEDLUNCHTIME1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."ESTIMATEDLUNCHTIME1" (p_EmpNo IN Varchar2, p_PDate IN Date, p_SCode IN Varchar2) RETURN Number IS
		v_RetVal Number := 0;
		vStartHH Number := 0;
		vStartMN Number := 0;
		vEndHH Number := 0;
		vEndMN Number := 0;
		vParent Varchar2(10);
		vITime Number := 0;
		vOTime Number := 0;
BEGIN
  	If p_SCode= 'OO' Or p_SCode = 'HH' Then
  			Return v_RetVal;
  	Else
				Select Assign InTo vParent From SS_EmplMast Where EmpNo = Trim(p_EmpNo);
				Select 
						GetShiftInTime(p_EmpNo,p_PDate,p_SCode), 
						GetShiftOutTime(p_EmpNo,p_PDate,p_SCode)
					InTo
						vITime,
						vOTime
				From Dual;

				Select StartHH, StartMN, EndHH, EndMN 
						InTo vStartHH, vStartMN, vEndHH, vEndMN 
						From SS_LunchMast Where ShiftCode = Trim(p_SCode) And Parent = Trim(vParent);

				If vITime >= (vEndHH * 60) + vEndMN Then
						v_RetVal := 0;
				ElsIf vOTime <= (vStartHH * 60) + vStartMN Then
						v_RetVal := 0;
				ElsIf vOTime <= (vEndHH * 60) + vEndMN Then
						v_RetVal := vOTime - ((vStartHH * 60) + vStartMN);
				ElsIf vITime >= (vStartHH * 60) + vStartMN Then
						v_RetVal := vITime - ((vEndHH * 60) + vEndMN);
				ElsIf vOTime - vITime = 0 Then
				        v_RetVal := 0;
				Else
						v_RetVal := 30;
				End If;
  	End If;
  	return v_RetVal;
Exception
  	When Others Then
  		return 30;
END;


/
