--------------------------------------------------------
--  DDL for Function FIND_PICKUP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "COMMONMASTERS"."FIND_PICKUP" (pick_up IN varchar2)  RETURN char IS
Cursor C1 is select PICK_UP_POINT,BUS_code from BUS_PICKUP;
BEGIN 
  	 FOR C2 IN C1 Loop
	     IF Instr(Upper(pick_up),Upper(Trim(c2.PICK_UP_POINT))) >= 1 then
	     	  Return C2.BUS_code;
	     End If;
	 end loop;
	 Return ' ' ;	
END;





/
