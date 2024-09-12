--------------------------------------------------------
--  DDL for Function ISSLEAVEAPP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."ISSLEAVEAPP" (I_EmpNo IN Varchar2, I_Date IN Date) RETURN Number IS 
		RetVal Number;
		VCount Number;
BEGIN
  	RetVal := 0;
  	Select Count(*) Into VCount from SS_OnDuty 
  		where EmpNo = Trim(I_EmpNO) And PDate = I_Date 
  		And Type='SL';
  	If VCount > 0 Then
  			RetVal := 1;
  	End If;
  	Return RetVal;
END;


/
