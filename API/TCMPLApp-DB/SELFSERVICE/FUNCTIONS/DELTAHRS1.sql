--------------------------------------------------------
--  DDL for Function DELTAHRS1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."DELTAHRS1" (p_EmpNo IN Varchar2, 
									 p_PDate IN Date, p_ShiftCode In Varchar2,
									 v_PLevHrs IN Number ) RETURN Number IS
									 
		v_Count Number := 0;
		v_RetVal Number := 0;
		v_WrkHrs Number :=0;
		--v_PLevHrs Number :=0;
		v_EstHrs Number :=0;
		--v_ShiftCode Varchar2(3000):='';
		v_OTime Number := 0;
		v_ITime Number := 0;
		x number;
		v_isLeave Number;
BEGIN
		If Ltrim(rtrim(p_ShiftCode)) = 'OO' Or Ltrim(Rtrim(p_ShiftCode)) = 'HH' Then
				Return v_RetVal;
		End If;


		Select count(*) InTo v_Count from ss_depu where bdate <= p_PDate
			and edate >= p_PDate and EmpNo = p_EmpNo And HOD_Apprl = 1 And HRD_Apprl=1;

		Select Count(*) InTo v_isLeave From SS_LeaveLedg Where EmpNo= Ltrim(Rtrim(p_EmpNo))
			and BDate <= p_PDate and Nvl(EDate,BDate) >= p_PDate And HD_Date is Null 
			and (Adj_Type = 'LA' Or Adj_Type='LC');

		If v_Count > 0 Or v_isLeave > 0 Then
				v_RetVal := 0;
		Else
				Select 
						GetShiftInTime(p_EmpNo,p_PDate,p_ShiftCode),
						GetShiftOutTime(p_EmpNo,p_PDate,p_ShiftCode)
					InTo 
						v_ITime, 
						v_OTime
					From SS_ShiftMast 
					Where ShiftCode = Trim(p_ShiftCode); 

				Select 	EstimatedLunchTime1(p_EmpNo,p_PDate,p_ShiftCode),
								WorkedHrs3(lpad(trim(p_EmpNo),5,'0'), p_PDate,p_ShiftCode) 
					InTo v_EstHrs,v_WrkHrs From Dual;
				Select Count(*) InTo v_Count From SS_IntegratedPunch 
						Where EmpNo = Trim(p_EmpNo) 
						And PDate = p_PDate;
				If v_Count > 0 Then
						v_EstHrs := v_OTime - v_ITime - v_EstHrs;
				Else
						v_EstHrs := 0;
				End If;
				v_RetVal := v_WrkHrs + (v_PLevHrs * 60) - v_EstHrs;
				--dbms_output.put_line('WrkHrs :- ' || v_WrkHrs);
				--dbms_output.put_line('PLevhr :- ' || v_PLevHrs);
				--dbms_output.put_line('EstHrs :- ' || v_EstHrs);
		End If;
		Return v_RetVal;
END;


/
