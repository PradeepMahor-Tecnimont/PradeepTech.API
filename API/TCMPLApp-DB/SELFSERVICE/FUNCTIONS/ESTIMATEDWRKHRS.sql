--------------------------------------------------------
--  DDL for Function ESTIMATEDWRKHRS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."ESTIMATEDWRKHRS" (p_EmpNo Varchar2, p_DAte Date) RETURN Number IS
		v_Cntr Number;
		v_InTime Number;
		v_OutTime Number;
		v_LunchTime Number;
		v_ShiftCode Varchar2(2);
		v_RetVal Number := 0;
BEGIN

		v_ShiftCode := GetShift1(p_EmpNo, p_Date);
		v_InTime := GetShiftInTime(p_EmpNo, p_Date, v_ShiftCode);
		v_OutTime := GetShiftOutTime(p_EmpNo, p_Date, v_ShiftCode);
		v_LunchTime := AvailedLunchTime1(p_EmpNo, p_Date, v_ShiftCode);
		v_RetVal := v_OutTime - v_InTime - v_LunchTime;
		Return v_RetVal;

Exception
		When Others Then
			Return 0;  			
END;


/
