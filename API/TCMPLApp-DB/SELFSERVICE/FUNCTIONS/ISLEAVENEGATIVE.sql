--------------------------------------------------------
--  DDL for Function ISLEAVENEGATIVE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."ISLEAVENEGATIVE" (p_EmpNo IN Varchar2) RETURN Number IS 
		v_RetVal Number :=0;
		v_CL Number := 0;
		v_SL Number := 0;
		v_PL Number := 0;
		v_EX Number := 0;
		v_CO Number := 0;
		v_OH Number := 0;
		v_Tot Number := 0;
BEGIN
  	OpenBal(Trim(p_EmpNo), null,0,v_CL,v_PL,v_SL,v_EX,v_CO,v_OH,v_Tot);
  	If v_CL < 1 Then
  			v_RetVal := 1;
  	End If;
  	If v_SL < 1 Then
  			v_RetVal := 1;
  	End If;
  	If v_PL < 1 Then
  			v_RetVal := 1;
  	End If;
  	If v_EX < 1 Then
  			v_RetVal := 1;
  	End If;
  	If v_CO < 1 Then
  			v_RetVal := 1;
  	End If;
  	If v_OH < 1 Then
  			v_RetVal := 1;
  	End If;
  	Return v_RetVal;
END
;


/
