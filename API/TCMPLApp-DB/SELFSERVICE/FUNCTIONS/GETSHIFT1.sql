--------------------------------------------------------
--  DDL for Function GETSHIFT1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GETSHIFT1" (EmpNum In Varchar2, V_PDate In Date) RETURN Char IS
	getDate 		Char(2);	
	SCode				Char(2);
	IsHoliday 	Number;
BEGIN
		getDate := To_Char(V_Pdate, 'dd');									
		Select Substr(s_mrk, ((To_number(getDate) * 2) - 1), 2) Into SCode From ss_muster
			Where empno = Trim(EmpNum) And mnth = Ltrim(Rtrim(To_Char(V_PDate, 'yyyymm')));  
		Return SCode;	
Exception
		When others then
			return 'NA';
END;


/

  GRANT EXECUTE ON "SELFSERVICE"."GETSHIFT1" TO "DMS" WITH GRANT OPTION;
