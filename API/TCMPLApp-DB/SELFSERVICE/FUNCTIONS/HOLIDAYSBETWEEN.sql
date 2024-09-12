--------------------------------------------------------
--  DDL for Function HOLIDAYSBETWEEN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."HOLIDAYSBETWEEN" (PStartDate IN Date, PEndDate in Date )RETURN number is
	VCount number;
BEGIN
	Select count(*) into VCount from SS_Holidays where Holiday between PStartDate and PEndDate;
	If VCount > 0 then
  		return VCount;
	Else
			return 0;
  End If;
END;


/
