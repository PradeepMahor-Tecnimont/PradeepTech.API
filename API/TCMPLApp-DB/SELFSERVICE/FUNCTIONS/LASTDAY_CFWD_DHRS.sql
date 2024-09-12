--------------------------------------------------------
--  DDL for Function LASTDAY_CFWD_DHRS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."LASTDAY_CFWD_DHRS" (p_EmpNo IN Varchar2, p_PDate IN Date) RETURN Number IS
		v_RetVal Number := 0;
		v_EGo Number;
		isLastWrkDy Number;
		v_SLAppCntr Number;
		v_SLApp Number;
		v_ShiftCode Varchar2(10);
		v_DeltaHrs Number;
BEGIN
		Select GetShift1(p_EmpNo,p_PDate) InTo v_ShiftCode From Dual;
		Select 	EarlyGo(p_EmpNo, p_PDate),
						GetSLeaveAppCntr(p_EmpNo,p_PDate),
						IsSLeaveApp(p_EmpNo,p_PDate),
						DeltaHrs(p_EmpNo,p_PDate,v_ShiftCode)
				InTo v_EGo,v_SLAppCntr,v_SLApp,v_DeltaHrs
				From Dual;

		If v_EGo > 0 And v_DeltaHrs < 0 Then
			If (v_EGo <= 60) Then
					Select Greatest(v_EGo,v_DeltaHrs) InTo v_RetVal From Dual;
	  			v_RetVal := v_EGo;
			ElsIf (v_SLApp = 1 And v_SLAppCntr <= 2) And (v_EGo > 60 And v_EGo <= 240) Then
					Select Greatest(v_EGo,v_DeltaHrs) InTo v_RetVal From Dual;
	  			v_RetVal := v_EGo;
			End If;
		End If;
  	Return v_RetVal * -1;
END
;


/
