--------------------------------------------------------
--  DDL for Function N_CFWDDELTAHRS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."N_CFWDDELTAHRS" (p_EmpNo IN Varchar2, p_PDate IN Date, p_SaveTot In Number) RETURN Number IS

-- p_SaveTot - if '1' Then totals of Last Complete Week of the month are stored in the database.
-- p_SaveTot - if '0' Then totals of Last Complete Week of the month are retrived from the database.
		
		Cursor C1 (c_EmpNo IN Varchar2, c_Date IN Date) Is
				Select c_EmpNo As EmpNo, To_Number(D_DD) As Days, 
						LateCome1(c_EmpNo,D_Date) AS LCome,
						D_Date AS PDate, 
						GetShift1(c_EmpNo, D_Date) AS SCode,
						Get_Holiday(D_Date) As isSunday,
						EarlyGo1(c_EmpNo,D_Date) AS EGo,
						isLComeEGoApp(c_EmpNo,D_Date) AS LC_App,
						isSLeaveApp(c_EmpNo,D_Date) AS SL_App,
						isLastWorkDay1(c_EmpNo, D_Date) AS isLWD,
						Wk_Of_Year
				From SS_Days_Details
				Where D_Date >= c_Date And D_Date <= Last_Day(c_Date)
				Order by D_Date;

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
		v_CFwdHrsOfLastWeek Number :=0;
		--v_CFwdSLAppCntr Number :=0;

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

								/*If To_Char(Last_Day(v_SDate),'Dy') <> 'Sun' Then
										If To_Number(To_Char(Last_Day(v_SDate),'IW')) <> To_Number(C2.Wk_Of_Year) Then
											v_CFwdSLAppCntr := 	v_CFwdSLAppCntr + C2.SL_App;
										End If;
								End If;*/

								Select N_DeltaHrs(C2.EmpNo,C2.PDate,C2.SCode,PenaltyLeave1(C2.LCome,C2.EGo,C2.isLWD,LC_AppCntr,SL_AppCntr,C2.LC_App,C2.SL_App)) InTo v_DHrs From Dual;
								v_SumDHrs := v_SumDHrs + v_DHrs;
								If C2.isLWD = 1 And C2.PDate <> Last_Day(v_SDate) Then
										Select CFwd_DHRs_Week(LastDay_CFwd_DHrs1(v_DHrs, C2.EGo, C2.SL_App, SL_AppCntr, C2.isLWD), C2.isLWD, v_SumDHRs) InTo v_CFwdHrs From Dual;
										Select Least(Greatest(v_SumDHrs,v_CFwdHrs),0) InTo v_SumDHrs From Dual;
								End If;
								/*If C2.isLDM = 1 And C2.isLWD = 0 Then
										Null;
								End If;*/
								If C2.isSunday = 2 Then
										v_CFwdHrsOfLastWeek := v_SumDHrs;
										LC_AppCntr := 0;
								End If;
						End Loop;
						If p_SaveTot = 1 Then
								Delete From SS_DeltaHrsBal_OT where EmpNo = p_EmpNo And Mon = To_Char(v_SDate,'MM') And YYYY = To_Char(v_SDate, 'yyyy');
								Insert InTo SS_DeltaHrsBal_OT (EmpNo,Mon,YYYY,DeltaHrs) Values (p_EmpNo,LPad(To_Char(v_SDate,'MM'),2,'0'),LPad(To_Char(v_SDate,'YYYY'),4,'0'),v_CFwdHrsOfLastWeek);
								Commit;
						End If;
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
