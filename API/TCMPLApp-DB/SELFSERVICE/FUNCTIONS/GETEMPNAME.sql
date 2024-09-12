--------------------------------------------------------
--  DDL for Function GETEMPNAME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GETEMPNAME" (I_EmpNo IN Varchar2) RETURN Varchar2 IS
		vEmpName Varchar2(80);
		vEmpNo Varchar2(10) := LPad(Trim(I_EmpNo),5);
BEGIN
  	vEmpName := ' ';
  	Select Name InTo vEmpName From SS_EmplMast Where EmpNo = Trim(vEmpNo);
		return vEmpName;
Exception
		When Others Then
			return vEmpName;
END;

/
