--------------------------------------------------------
--  DDL for Procedure SET_OD_ORDER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SET_OD_ORDER" (p_PDate Date) IS
		Type t_EmpNo Is Table Of Varchar2(5) Index By Binary_Integer;
		v_EmpNoTab t_EmpNo;

		Type v_Punch Is Table Of Number Index By Binary_Integer;
		v_PunchTab v_Punch;

		Type v_AppNo Is Table Of Varchar2(100) Index By Binary_Integer;
		v_AppNoTab v_AppNo;
		
		v_ODTab v_Punch;
		Cursor C1(c_EmpNo IN Varchar2, c_PDate IN Date) Is Select * From SS_IntegratedPunch
				Where EmpNo = c_EmpNo And PDate = c_PDate 
				And ODType <> 2 Order By HHSort, MMSort,hh,mm;
		Cursor C2(c_EmpNo IN Varchar2, c_PDate IN Date) Is Select * From SS_OnDuty
				Where EmpNO = c_EmpNo And PDate = c_PDate And Type='OD' Order By HHSort, MMSort, HH,MM;
		v_Count Number;
		Cursor CEmpNo Is Select Distinct(EmpNo) As EmpNo From SS_OnDuty 
				Where App_No In (Select App_No From SS_OnDutyApp 
						Where PDate = p_PDate And ODType = 2);
		v_Cntr Number;
		v_PCntr Number;
		v_ODCntr Number;
		v_CntrCalc Number;
BEGIN
		v_Cntr := 0;
		For v_CEmpNo In CEmpNo Loop
				v_Cntr := v_Cntr + 1;
				v_EmpNoTab(v_Cntr) := v_CEmpNo.EmpNo;
		End Loop;
		If v_Cntr > 0 Then
				For i In 1 .. v_Cntr Loop
						v_PCntr := 0;
						For v_C1 In C1(v_EmpNoTab(i), p_PDate) Loop
								v_PCntr := v_PCntr + 1;
								v_PunchTab(v_PCntr) := (v_C1.HH * 60) + v_C1.MM;
						End Loop;
						v_ODCntr := 0;
						For v_C2 In C2(v_EmpNoTab(i), p_PDate) Loop
								v_ODCntr := v_ODCntr + 1;
								v_ODTab(v_ODCntr) := (v_C2.HH * 60) + v_C2.MM;
						End Loop;
				End Loop;
				v_CntrCalc := 1;
				If v_PCntr > 3 And v_ODCntr > 1 Then
						While v_CntrCalc <= v_PCntr Loop
								v_CntrCalc := v_CntrCalc + 2;
								If (v_ODTab(v_CntrCalc-2) <= v_PunchTab(v_CntrCalc) And v_ODTab(v_CntrCalc-1) > v_PunchTab(v_CntrCalc)) Or
										(v_ODTab(v_CntrCalc-2) > v_PunchTab(v_CntrCalc) And v_ODTab(v_CntrCalc-2) <= v_PunchTab(v_CntrCalc+1)) Then
										
										UpDate SS_OnDuty Set HHSort=Floor((v_PunchTab(v_CntrCalc)+1)/60),
													MMSort=Mod(v_PunchTab(v_CntrCalc)+1,60)
												Where App_No = Ltrim(Rtrim(v_AppNoTab(v_CntrCalc-2)));
										Commit;
								End If;
						End Loop;
				End If;
		End If;
		
END;

/
