--------------------------------------------------------
--  DDL for Function ISLASTWORKDAY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."ISLASTWORKDAY" (V_Date IN Date) RETURN Number IS 
	isHoliday Number;
BEGIN
  isHoliday := Get_Holiday(V_Date+1);
  If isHoliday = 0 Then
  	Return 0;
  ElsIf isHoliday = 1 Then
  	Return 1;
  Else
  	return isLastWorkDay(V_Date + 1);
  End If;
END;


/
