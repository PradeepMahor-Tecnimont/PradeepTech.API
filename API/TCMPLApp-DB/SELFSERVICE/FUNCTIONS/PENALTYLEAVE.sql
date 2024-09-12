--------------------------------------------------------
--  DDL for Function PENALTYLEAVE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."PENALTYLEAVE" (p_EmpNo IN Varchar2, p_PDate IN Date)
											
											RETURN Number IS
											
		v_RetVal Number := 0;
		v_LateCome Number;
		v_EGo Number;
		isLastWrkDy Number;
		v_LCAppCntr Number;
		v_SLAppCntr Number;
		v_LCApp Number;
		v_SLApp Number;
BEGIN

		v_LateCome := LateCome1(p_EmpNo, p_PDate); 
		v_EGo := EarlyGo1(p_EmpNo, p_PDate);
		isLastWrkDy := isLastWorkDay1(p_EmpNo,p_PDate);
		v_LCAppCntr := GetLComeAppCntr(p_EmpNo,p_PDate);
		v_SLAppCntr := GetSLeaveAppCntr(p_EmpNo,p_PDate);
		v_LCApp := IsLComeEGoApp(p_EmpNo,p_PDate);
		v_SLApp := IsSLeaveApp(p_EmpNo,p_PDate);

  	If v_LateCome > 210 Then 
  			v_RetVal := v_RetVal + Floor((v_LateCome-30) / 60);
  			If Floor((v_LateCome-30) / 60) < (v_LateCome-30) / 60 Then
  					v_RetVal := v_RetVal + 1;
  			End If;
  	ElsIf (v_LateCome > 30 And v_LateCome <= 90) Then
		  	If v_LCApp = 0 Or v_LCAppCntr > 2 Then
		  			v_RetVal := v_RetVal + Floor((v_LateCome-30) / 60);
		  			If Floor((v_LateCome-30) / 60) < (v_LateCome-30) / 60 Then
		  					v_RetVal := v_RetVal + 1;
		  			End If;
		  	End If;
  	ElsIf (v_LateCome > 90) Then
		  	If v_SLApp = 0 Or v_SLAppCntr > 2 Then
		  			v_RetVal := v_RetVal + Floor((v_LateCome-30) / 60);
		  			If Floor((v_LateCome-30) / 60) < (v_LateCome-30) / 60 Then
		  					v_RetVal := v_RetVal + 1;
		  			End If;
		  	End If;
  	End If;


		If (v_EGo > 240 And isLastWrkDy = 1) Or (v_EGo > 180 And isLastWrkDy = 0) Then
  			v_RetVal := v_RetVal + Floor((v_EGo) / 60);
  			If Floor((v_EGo) / 60) < (v_EGo) / 60 Then
  					v_RetVal := v_RetVal + 1;
  			End If;
		End If;
		If (isLastWrkDy = 1) And (v_SLApp = 0 Or v_SLAppCntr > 2) And (v_EGo > 60 And v_EGo <= 240) Then
  			v_RetVal := v_RetVal + Floor((v_EGo) / 60);
  			If Floor((v_EGo) / 60) < (v_EGo) / 60 Then
  					v_RetVal := v_RetVal + 1;
  			End If;
		ElsIf (isLastWrkDy = 0) And (v_SLApp = 0 Or v_SLAppCntr > 2) And (v_EGo > 0 And v_EGo <= 180) Then
  			v_RetVal := v_RetVal + Floor((v_EGo) / 60);
  			If Floor((v_EGo) / 60) < (v_EGo) / 60 Then
  					v_RetVal := v_RetVal + 1;
  			End If;
  	End If;
  	Return v_RetVal;
END;


/
