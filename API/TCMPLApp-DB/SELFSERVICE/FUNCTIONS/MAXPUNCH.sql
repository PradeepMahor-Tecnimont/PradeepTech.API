--------------------------------------------------------
--  DDL for Function MAXPUNCH
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."MAXPUNCH" (V_Code IN Varchar2, V_MM IN Varchar2, V_YYYY IN Varchar2)RETURN Number IS
	RetVal Number;
BEGIN
	RetVal := 0;
	Select Max(PunchNos) into RetVal from
		(Select Count(*) PunchNos from SS_Punch
			where EmpNo = ltrim(rtrim(V_Code))
			and Mon = ltrim(rtrim(V_MM))
			and YYYY = ltrim(rtrim(V_YYYY))
			group by DD);
  Return RetVal;
Exception
	when others then
		return RetVal;
END;


/
