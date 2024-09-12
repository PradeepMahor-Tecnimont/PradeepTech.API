--------------------------------------------------------
--  DDL for Function SL_APPCOUNT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."SL_APPCOUNT" (p_EmpNo IN Varchar2, p_PDate IN Date) RETURN Number IS
		v_RetVal Number := 0;
		v_isSLeaveApp Number :=0;
		v_EGo Number := 0;
		v_LCome Number := 0;
		v_LastWrkDay Number := 0;
		v_SCode Varchar2(2);
BEGIN
  	/*v_isSLeaveApp := IsSLeaveApp(p_EmpNo,p_PDate);
  	v_EGo := EarlyGo1(p_EmpNo,p_PDate);
  	v_LCome := LateCome1(p_EmpNo,p_PDate);
  	v_LastWrkDay := IsLastWorkDay1(p_EmpNo, p_Pdate);
  	v_SCode := GetShift1(p_EmpNo, p_PDate);*/

  	Select IsSLeaveApp(p_EmpNo,p_PDate),
  					EarlyGo1(p_EmpNo,p_PDate),
  					LateCome1(p_EmpNo,p_PDate),
  					IsLastWorkDay1(p_EmpNo, p_Pdate), 
  					GetShift1(p_EmpNo, p_PDate)
  			InTo
  					v_IsSLeaveApp,
  					v_EGo,
  					v_LCome,
  					v_LastWrkDay,
  					v_SCode
  			From Dual;

  	If v_SCode = 'HH' Or v_SCode = 'OO' Then
  			Return v_RetVal;
  	End If;
  	If v_isSLeaveApp = 1 Then
  			If v_LCome > 90 And v_LCome <= 210 Then 
  					v_RetVal :=v_RetVal + 1;
  			End If;
  			If v_EGo > 0 And v_EGo <= 60 And v_LastWrkDay =1 Then
  					Null;
  			Else
  					If v_EGo > 0 And v_EGo < 240 Then
  							If v_EGo < 240 And v_Ego > 60 And v_LastWrkDay =1 Then
  									v_RetVal := v_RetVal + 1;	
  							ElsIf v_EGo <= 180 And v_LastWrkDay = 0 Then
  									v_RetVal := v_RetVal + 1;	
  							End If;
  					End If;
  			End If;
  	End If;
  	Return v_RetVal;
END;


/
