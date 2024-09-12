--------------------------------------------------------
--  DDL for Function N_MAXPUNCH
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."N_MAXPUNCH" (V_Code IN Varchar2, p_StartDate IN Date, v_EndDate IN Date)RETURN Number IS
	RetVal Number;
BEGIN
	RetVal := 0;
	Select Max(PunchNos) into RetVal from
		(Select Count(*) PunchNos from SS_IntegratedPunch
			where EmpNo = ltrim(rtrim(V_Code))
			group by PDate Having PDate >= p_StartDate
			and PDate <= v_EndDate);
  Return RetVal;
Exception
	when others then
		return RetVal;
END
;


/
