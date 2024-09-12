--------------------------------------------------------
--  DDL for Function GETSLEAVEAPPCNTR
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GETSLEAVEAPPCNTR" (p_EmpNo IN Varchar2, p_PDate IN Date) Return Number IS
		v_RetVal Number:= 0;
		v_EndDy Number;
		v_Mon varchar2(30);

BEGIN
		v_EndDy := To_Number(To_Char(p_PDate,'dd'));
		For i In 1 .. v_EndDy Loop
				v_RetVal := v_RetVal + SL_AppCount(p_EmpNo, To_Date(i||to_Char(p_PDate,'-mm-yyyy'),'dd-mm-yyyy'));
		End Loop;
  	return v_RetVal;
END;


/
