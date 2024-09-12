--------------------------------------------------------
--  DDL for Function CHECKAPP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."CHECKAPP" (p_EmpNo In Varchar2, p_Mon In Varchar2, p_YYYY In Varchar2) RETURN Number IS 
		v_Count Number;
		v_StartDt Date;
		v_EndDt Date;
BEGIN
		v_Count := 0;
		v_StartDt := To_Date('01-' || p_Mon || '-' || p_YYYY,'dd-mm-yyyy');
		v_EndDt := Last_Day(v_StartDt);
  	Select count(*) InTo v_Count From SS_LeaveApp 
  		Where ((BDate >= v_StartDt And BDate <= v_EndDt) 
  		Or (EDate >= v_StartDt And EDate <= v_EndDt)) And (Nvl(HOD_Apprl,0) = 0
  		Or (Nvl(HRD_Apprl,0) = 0 And Nvl(HOD_Apprl,0) <> 2)) And EmpNo = Trim(p_EmpNo);

  	If v_Count > 0 Then
  		Return 1;
  	End If;
  	Select Count(*) InTo v_Count From SS_OnDutyApp
  		Where (PDate >= v_StartDt And PDate <= v_EndDt) And (Nvl(HOD_Apprl,0) = 0
  		Or (Nvl(HRD_Apprl,0) = 0 And Nvl(HOD_Apprl,0) <> 2)) And EmpNo = Trim(p_EmpNo);
  	If v_Count > 0 Then
  		Return 1;
  	End If;

  	Select count(*) InTo v_Count From SS_Depu 
  		Where ((BDate >= v_StartDt And BDate <= v_EndDt) 
  		Or (EDate >= v_StartDt And EDate <= v_EndDt)) And (Nvl(HOD_Apprl,0) = 0
  		Or (Nvl(HRD_Apprl,0) = 0 And Nvl(HOD_Apprl,0) <> 2)) And EmpNo = Trim(p_EmpNo);

  	If v_Count > 0 Then
  		Return 1;
  	End If;

  	Return 0;
 Exception
		when others then
			return 0;
 END;


/
