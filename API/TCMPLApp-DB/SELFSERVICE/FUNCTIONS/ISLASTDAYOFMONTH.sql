--------------------------------------------------------
--  DDL for Function ISLASTDAYOFMONTH
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."ISLASTDAYOFMONTH" (p_PDate In Date) RETURN Number IS
		v_RetVal Number := 0;
BEGIN
		If To_Number(To_Char(p_PDate,'dd')) = To_Number(To_Char(Last_Day(p_PDate),'dd')) Then
				v_RetVal := 1;
		End If;
  	Return v_RetVal;
END;


/
