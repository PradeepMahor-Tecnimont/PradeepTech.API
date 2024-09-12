--------------------------------------------------------
--  DDL for Function GETABSENTDATE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GETABSENTDATE" (EmpNum In Varchar2, TheDate In Date) RETURN Number IS
	v_holiday Number;
	v_count Number;
	IsAbsent Number;
	v_onleave Number;
	dateofjoin Date;
BEGIN		
  IsAbsent := 0;
  v_holiday := Get_Holiday(TheDate);

  If v_holiday = 0 Then
  	 Select Count(empno) Into v_count From ss_integratedpunch
  	 	  Where empno = Trim(EmpNum) And pdate = TheDate;
	  	 	  If v_count = 0 Then
				 	  	v_onleave := IsLeaveDepuTour(TheDate, EmpNum);
				 	  	If v_onleave = 0 Then
								Select Nvl(doj, TheDate) Into dateofjoin From ss_emplmast
									Where empno = Trim(EmpNum);			 	  		
									If TheDate < dateofjoin Then
										IsAbsent := 0;										 	  			
									Else	
					 	  			IsAbsent := 1;	
					 	  		End If;	  		
				 	  	ElsIf v_onleave = 1 Then
				 	  		IsAbsent := 2;	
				 	  	Else
				 	  		IsAbsent := 3;	
				 	  	End If;				 	  		
	  	 	  End If; 	
  End If;	 	  
  Return IsAbsent;
END


;


/
