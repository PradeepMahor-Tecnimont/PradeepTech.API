--------------------------------------------------------
--  DDL for Function GETABSENT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GETABSENT" (EmpNum In Varchar2, TheDate In Date)
	 RETURN Number IS
	 Cursor c1 Is Select bdate, edate From ss_leaveledg
	 		Where empno = Trim(EmpNum);	 		
	 IsAbsent Number;
BEGIN
	 IsAbsent := 1;
   For c2 In c1 Loop
   		If TheDate >= c2.bdate And TheDate <= Nvl(c2.edate, c2.bdate) Then
   			 IsAbsent := 0;
   			 Exit;
   		End If;
   End Loop;		
	 Return IsAbsent;
END;


/
