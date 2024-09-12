--------------------------------------------------------
--  DDL for Function GETLCOMEAPPCNTR
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GETLCOMEAPPCNTR" (p_EmpNo IN Varchar2, p_PDate IN Date) RETURN Number IS
		v_RetVal Number:= 0;
		v_WeekDy Number;
		v_StartDate Date;
		v_loopCntr Number := 0;
BEGIN
  	v_WeekDy := To_Number(To_Char(p_PDate,'d'));
  	If v_WeekDy > 1 And v_WeekDy < 7 Then
  			For i In 2 .. v_WeekDy Loop
  					v_RetVal := v_RetVal + LC_AppCount(p_EmpNo, (v_StartDate - v_WeekDy + i));
  			End Loop;
  	End If;
  	Return v_RetVal;
END
;


/
