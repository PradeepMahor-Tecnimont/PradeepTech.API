--------------------------------------------------------
--  DDL for Function MISSEDPUNCH
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."MISSEDPUNCH" (EmpNum IN Varchar2, PunchDate IN Date) RETURN number IS
	Cursor C1 is select * from SS_IntegratedPunch 
		where EmpNo = ltrim(rtrim(EmpNum))
		and PDate = PunchDate
		And FalseFlag=1;
	Cntr Number;
BEGIN
	Cntr := 1;
	For C2 in C1 Loop
		Cntr := Cntr + 1;
	End Loop;
	Cntr := Cntr - 1;
	Return Cntr;
end;


/
