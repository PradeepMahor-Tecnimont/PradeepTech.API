--------------------------------------------------------
--  DDL for Function DELTAHRS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."DELTAHRS" (p_EmpNo IN Varchar2, p_PDate IN Date, p_ShiftCode In Varchar2) RETURN Number IS
		v_Count Number := 0;
		v_RetVal Number := 0;
		v_WrkHrs Number :=0;
		v_PLevHrs Number :=0;
		v_EstHrs Number :=0;
		--v_ShiftCode Varchar2(3000):='';
		v_ITimeHH Number := 0; 
		v_ITimeMn Number := 0;
		v_OTimeHH Number := 0;
		v_OTimeMn Number := 0;
		v_ITime Number := 0;
		x number;
BEGIN
		If Get_Holiday(p_PDate) = 0 Then
				v_ITime:=0;
				Select TimeIn_HH,TimeIn_Mn,TimeOut_HH,TimeOut_Mn InTo v_ITimeHH, v_ITimeMn, v_OTimeHH, v_OTimeMn
						From SS_ShiftMast Where ShiftCode = Trim(p_ShiftCode); 

				v_ITime := v_ITimeHH * 60 + v_ITimeMn ;
				Select 	EstimatedLunchTime(p_EmpNo,p_PDate,p_ShiftCode),
								WorkedHrs2(lpad(trim(p_EmpNo),5,'0'), p_PDate,p_ShiftCode),
								PenaltyLeave(p_EmpNo, p_PDate)
					InTo v_EstHrs,v_WrkHrs,v_PLevHrs From Dual;
				Select Count(*) InTo v_Count From SS_IntegratedPunch 
						Where EmpNo = Trim(p_EmpNo) 
						And PDate = p_PDate;
				If v_Count > 0 Then
						v_EstHrs := ((v_OTimeHH*60) + v_OTimeMn) - ((v_ITimeHH * 60) + v_ITimeMn) - v_EstHrs;
				Else
						v_EstHrs := 0;
				End If;
				v_RetVal := v_WrkHrs + (v_PLevHrs * 60) - v_EstHrs;
		End If;
		--dbms_output.put_line('WrkHrs :- ' || v_WrkHrs);
		--dbms_output.put_line('PLevhr :- ' || v_PLevHrs);
		--dbms_output.put_line('EstHrs :- ' || v_EstHrs); 
		Return v_RetVal;
END;


/
