--------------------------------------------------------
--  DDL for Function GETLASTDAYOFWEEK1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GETLASTDAYOFWEEK1" (p_EmpNo IN Varchar2, p_PDate IN Date) RETURN Date IS
		v_RetVal Date;
		v_ExitLoop Number := 0;
		v_NextDate Date;
		isLDOW Number;
BEGIN
		v_NextDate := p_PDate + 1;
		While v_ExitLoop < 1 Loop
  			Select isLastWorkDay1(p_EmpNo,v_NextDate) InTo isLDOW from dual;
	  		If isLDOW = 1 Then
	  				v_ExitLoop := 10;
	  				v_RetVal := v_NextDate;
	  		Else
	  				v_NextDate := v_NextDate + 1;
	  		End If;
		End Loop;
		Return v_RetVal;
END 
;


/
