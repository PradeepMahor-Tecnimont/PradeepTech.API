--------------------------------------------------------
--  DDL for Function PENALTYLEAVE1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."PENALTYLEAVE1" (v_LateCome IN Number, v_EGo IN Number,
v_isLastWrkDy IN Number, v_LCAppCntr IN Number,
v_SLAppCntr IN Number, v_LCApp IN Number,
v_SLApp IN Number)
RETURN Number IS
											
		v_RetVal Number := 0;
		PunchNos Number;
BEGIN
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


		If (v_EGo > 240 And v_isLastWrkDy = 1) Or (v_EGo > 180 And v_isLastWrkDy = 0) Then
  			v_RetVal := v_RetVal + Floor((v_EGo) / 60);
  			If Floor((v_EGo) / 60) < (v_EGo) / 60 Then
  					v_RetVal := v_RetVal + 1;
  			End If;
		End If;
		If (v_isLastWrkDy = 1) And (v_SLApp = 0 Or v_SLAppCntr > 2) And (v_EGo > 60 And v_EGo <= 240) Then
  			v_RetVal := v_RetVal + Floor((v_EGo) / 60);
  			If Floor((v_EGo) / 60) < (v_EGo) / 60 Then
  					v_RetVal := v_RetVal + 1;
  			End If;
		ElsIf (v_isLastWrkDy = 0) And (v_SLApp = 0 Or v_SLAppCntr > 2) And (v_EGo > 0 And v_EGo <= 180) Then
  			v_RetVal := v_RetVal + Floor((v_EGo) / 60);
  			If Floor((v_EGo) / 60) < (v_EGo) / 60 Then
  					v_RetVal := v_RetVal + 1;
  			End If;
		End If;
  	Return v_RetVal;
END;


/
