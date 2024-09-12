--------------------------------------------------------
--  DDL for Function CFWDDELTAHRSTEST1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."CFWDDELTAHRSTEST1" (p_EmpNo IN Varchar2, p_PDate IN Date) RETURN Number IS
  
		Cursor C1 (c_EmpNo IN Varchar2, c_Date IN Date) Is
				Select c_EmpNo As EmpNo, Days, LateCome1(c_EmpNo,To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS LCome,
						To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy')) AS PDate, 
						GetShift1(c_EmpNo, To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS SCode,
						Get_Holiday(To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) As isSunday,
						EarlyGo1(c_EmpNo,To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS EGo,
						isLComeEGoApp(c_EmpNo,To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS LC_App,
						isSLeaveApp(c_EmpNo,To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS SL_App,
						--isLastDayOfMonth(To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS isLDM,
						isLastWorkDay1(c_EmpNo, To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS isLWD
				From SS_Days, SS_Muster 
				Where EmpNo = c_EmpNo 
				And MnTh = To_Char(c_Date,'yyyymm')
				And Days <= To_Number(To_Char(Last_Day(c_Date),'dd'))
				Order by Days;

		LC_AppCntr Number := 0;
		SL_AppCntr Number := 0;
		v_OpenLC_Cntr Number := 0;
		v_OpenMM Number :=0;
		v_SDate Date;
		v_Count Number :=0;
		v_DHrs Number :=0;
		v_SumDHrs Number :=0;
		v_CFwdHrs Number :=0;
		v_RetVal Number := 0;

BEGIN
		If To_Number(To_Char(p_PDate,'dd')) = 1 Then
				Select Count(*) InTo v_Count From SS_DeltaHrsBal Where PDate < p_PDate And EmpNo = Trim(p_EmpNo);
				If v_Count = 0 Then
						v_SDate := To_Date('30-nov-2001');
				Else
						Select PDate, MM, LC_AppCntr InTo v_SDate, v_OpenMM, v_OpenLC_Cntr From SS_DeltaHrsBal 
							Where PDate < p_PDate 
							And EmpNo = Trim(p_EmpNo)
							And PDate = (Select Max(PDate) From SS_DeltaHrsBal Where PDate < p_PDate And EmpNo = Trim(p_EmpNo) Group By EmpNo);
				End If;
				v_SDate := v_SDate + 1;
				If v_SDate <> p_PDate Then
						For C2 IN C1(p_EmpNo,v_SDate) Loop
								LC_AppCntr := LC_AppCntr + C2.LC_App;
								SL_AppCntr := SL_AppCntr + C2.SL_App;
								Select DeltaHrs1(C2.EmpNo,C2.PDate,C2.SCode,PenaltyLeave1(C2.LCome,C2.EGo,C2.isLWD,LC_AppCntr,SL_AppCntr,C2.LC_App,C2.SL_App)) InTo v_DHrs From Dual;
								v_SumDHrs := v_SumDHrs + v_DHrs;
								If C2.isLWD = 1 And C2.PDate <> Last_Day(v_SDate) Then
										Select CFwd_DHRs_Week(LastDay_CFwd_DHrs1(v_DHrs, C2.EGo, C2.SL_App, SL_AppCntr, C2.isLWD), C2.isLWD, v_SumDHRs) InTo v_CFwdHrs From Dual;
										Select Least(Greatest(v_SumDHrs,v_CFwdHrs),0) InTo v_SumDHrs From Dual;
								End If;
								/*If C2.isLDM = 1 And C2.isLWD = 0 Then
										Null;
								End If;*/
								If C2.isSunday = 2 Then
										LC_AppCntr := 0;
								End If;
						End Loop;
						v_RetVal := v_SumDHrs;
						LC_AppCntr := 0;
				Else
						v_RetVal := v_OpenMM;
				End If;
				Return v_RetVal;
		End If;
END
;


/
