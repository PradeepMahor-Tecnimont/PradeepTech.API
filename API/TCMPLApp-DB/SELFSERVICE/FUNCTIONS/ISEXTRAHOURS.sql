--------------------------------------------------------
--  DDL for Function ISEXTRAHOURS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."ISEXTRAHOURS" (p_EmpNo Varchar2, p_Month Varchar2, p_Year Varchar2) RETURN Number IS
		v_Cntr Number;
BEGIN
  	Select Count(*) InTo v_Cntr From (Select N_WorkedHrs(p_EmpNo, D_Date,GetShift1(p_EmpNo,D_Date)) - EstimatedWrkHrs(p_EmpNo, D_Date) 
  		 As ExtraHrs From SS_Days_Details
  		Where D_Date >= N_GetStartDate(p_Month, p_Year) And D_Date <= N_GetEndDate(p_Month, p_Year)) Where ExtraHrs >= 30 ;
  	IF v_Cntr > 0 Then
  		 Return 1;
  	Else
  		Return 0;
  	End If;
Exception
		When Others Then
			Return 0;  			
END;


/
