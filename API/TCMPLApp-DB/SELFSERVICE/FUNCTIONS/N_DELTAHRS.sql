--------------------------------------------------------
--  DDL for Function N_DELTAHRS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."N_DELTAHRS" (p_EmpNo IN Varchar2, 
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
    vFirstPunch Number;
    vLastPunch Number;
		x number;
		v_isLeave Number;
    vLComeEGoHrs Number;
    vPunchCount Number;
BEGIN
    Select Count(*) InTo vPunchCount From SS_IntegratedPUnch Where EmpNo = Trim(P_Empno)
      and PDate = trunc(p_PDate) and falseflag=1;
		If Ltrim(rtrim(p_ShiftCode)) = 'OO' Or Ltrim(Rtrim(p_ShiftCode)) = 'HH' Or vPunchCount < 2 Then
				Return v_RetVal;
		End If;
    v_Count := 0;

		Select count(*) InTo v_Count from ss_depu where bdate <= p_PDate
			and edate >= p_PDate and EmpNo = p_EmpNo And HOD_Apprl = 1 And HRD_Apprl=1;

		Select Count(*) InTo v_isLeave From SS_LeaveLedg Where EmpNo= Ltrim(Rtrim(p_EmpNo))
			and BDate <= p_PDate and Nvl(EDate,BDate) >= p_PDate 
      And (HD_Date is Null or (HD_part = 1 and hd_date <> p_PDate) )
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
					From Dual;
if p_pdate < to_date('29-Oct-2018','dd-Mon-yyyy') then
				Select 	
            N_WorkedHrs(lpad(trim(p_EmpNo),5,'0'), p_PDate,p_ShiftCode) ,
            FirstLastPunch1(p_empno,p_pdate,0),
            FirstLastPunch1(p_empno,p_pdate,1)
					InTo 
            v_WrkHrs,
            vFirstPunch,
            vLastPunch
          From Dual;
else
				Select 	
            N_WorkedHrs(lpad(trim(p_EmpNo),5,'0'), p_PDate,p_ShiftCode) ,
            Get_Punch_Num(lpad(p_EmpNo,5,'0'),p_PDate,'OK','DHRS'),
            Get_Punch_Num(lpad(p_EmpNo,5,'0'),p_PDate,'KO','DHRS')
            --FirstLastPunch1(p_empno,p_pdate,0),
            --FirstLastPunch1(p_empno,p_pdate,1)
					InTo 
            v_WrkHrs,
            vFirstPunch,
            vLastPunch
          From Dual;
end if;
				Select Count(*) InTo v_Count From SS_IntegratedPunch 
						Where EmpNo = Trim(p_EmpNo) 
						And PDate = p_PDate and falseflag =1;
				If v_Count > 0 Then
						v_EstHrs := shift_work_hrs(p_EmpNo,p_PDate,p_Shiftcode);
				Else
						v_EstHrs := 0;
				End If;
        If v_ITime < vFirstPunch Then
            vLComeEGoHrs := vFirstPunch - v_ITime;
        End If;
        If v_OTime > vLastPunch Then
            vLComeEGoHrs := Nvl(vLComeEGoHrs,0) + (v_OTime - vLastPunch);
        End If;
        If p_pdate >= '31-OCT-11' Then
          If v_PLevHrs > 0 Then
              If (v_PLevHrs * 60) < vLComeEGoHrs Then
                vLComeEGoHrs := v_PLevHrs * 60;
              End If;
          Else
              vLComeEGoHrs := 0;
          End If;
          v_RetVal := vLComeEGoHrs + v_WrkHrs - v_EstHrs;
        Else
          v_RetVal := v_WrkHrs + (v_PLevHrs * 60) - v_EstHrs;
        End If;
/*
          If v_PLevHrs > 0 Then
            If v_RetVal < 0 And v_RetVal + (60 * v_PLevHrs) < 0 Then
                v_RetVal := v_WrkHrs + (v_PLevHrs * 60) - v_EstHrs;
            ElsIf v_RetVal < 0 And v_RetVal + (60 * v_PLevHrs) > 0 Then
                v_RetVal := 0;
            End If;
          Else
            v_RetVal := v_WrkHrs - v_EstHrs;
          End If;
*/
		End If;
    Select Count(*) InTo vPunchCount From SS_IntegratedPUnch Where EmpNo = Trim(P_Empno)
      and PDate = p_PDate And falseflag = 1;
    If mod(vPunchCount ,2) <> 0 And v_RetVal > 0 And p_pdate >= '31-OCT-11' Then
      v_RetVal := 0;
    End If;
		Return Nvl(v_RetVal,0);



END;


/
