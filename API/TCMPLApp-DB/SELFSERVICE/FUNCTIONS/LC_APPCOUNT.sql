--------------------------------------------------------
--  DDL for Function LC_APPCOUNT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."LC_APPCOUNT" (p_EmpNo IN Varchar2, p_PDate IN Date) RETURN Number IS
		v_RetVal Number := 0;
		v_LCome Number := 0;
		v_LComeApp Number := 0;
BEGIN
  	--v_LComeApp := IsLComeEGoApp(lpad(trim(p_EmpNo),5,'0'),p_PDate);
  	--v_LCome := LateCome(p_EmpNo,p_PDate);

  	Select IsLComeEGoApp(lpad(trim(p_EmpNo),5,'0'),p_PDate), LateCome1(p_EmpNo,p_PDate) 
  			InTo v_LComeApp, v_LCome From Dual;

  	If v_LComeApp = 1 And v_LCome > 30 And v_LCome <= 90 Then
  			v_RetVal := 1;
  	End If;
  	return v_RetVal;
END;


/
