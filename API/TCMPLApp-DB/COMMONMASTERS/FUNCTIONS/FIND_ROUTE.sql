--------------------------------------------------------
--  DDL for Function FIND_ROUTE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "COMMONMASTERS"."FIND_ROUTE" (pick_up IN varchar2)  RETURN char IS
Cursor C1 is select place,place_code from emp_place;
BEGIN
        --Open C1;
	 FOR C2 IN C1 Loop
	     IF Instr(Upper(pick_up),Upper(Trim(c2.Place))) >= 1 then
	     	  Return C2.Place_Code;
	     End If;
	 end loop;
	 Return ' ' ;	    
 
END;

/
