--------------------------------------------------------
--  DDL for Function ISLCOMEEGOAPP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."ISLCOMEEGOAPP" (I_EmpNo IN Varchar2, I_Date IN Date) RETURN Number IS 
		RetVal Number;
		VCount Number;
BEGIN
  	RetVal := 0;
  	Select Count(*) Into VCount from SS_OnDuty 
  		where EmpNo = lpad(trim(I_EmpNo),5,'0') And PDate = I_Date
  		And Type = 'LE';
  	If VCount > 0 Then
  			RetVal := 1;
  	End If;
  	Return RetVal;
END;


/
