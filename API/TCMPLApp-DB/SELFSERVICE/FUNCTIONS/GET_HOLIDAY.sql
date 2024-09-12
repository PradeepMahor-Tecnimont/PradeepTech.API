--------------------------------------------------------
--  DDL for Function GET_HOLIDAY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GET_HOLIDAY" (PDATE IN DATE)  RETURN NUMBER IS
	VCount number;
BEGIN
	Select count(*) into VCount from SS_Holidays where Holiday = PDate;
	If VCount > 0 then
  	If ltrim(rtrim(To_Char(PDate,'day'))) = 'sunday' then
  		return 2;
  	ElsIf ltrim(rtrim(To_Char(PDate,'day'))) = 'saturday' then
	  	return 1;
  	Else
	  	return 3;
	  End If;
  Else return 0;
  End If;
END;


/
