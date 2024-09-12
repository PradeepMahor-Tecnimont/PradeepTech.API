--------------------------------------------------------
--  DDL for Function CHECKHOLIDAY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."CHECKHOLIDAY" (PDate IN Date) RETURN number IS 
	VCount number;
BEGIN
	Select count(*) into VCount from SS_Holidays where Holiday = PDate;
	If VCount > 0 then
  	If trim(To_Char(PDate,'day')) = 'sunday' then
  		return 2;
  	ElsIf trim(To_Char(PDate,'day')) = 'saturday' then
	  	return 1;
  	Else
	  	return 3;
	  End If;
  Else return 0;
  End If;
END;


/
