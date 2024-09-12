--------------------------------------------------------
--  DDL for Function GETLEAVEPERIOD
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GETLEAVEPERIOD" (EmpNum In Varchar2, StartDate In Date, EndDate In Date, 
				 leavehours In Number, Mnth In Varchar2, Years In Varchar2) RETURN Number IS
	v_GetLeavePeriod 		Number(3);	
	v_LastDay 					Date;
	v_DiffInDays 				Number;
	v_GetDate 					Varchar2(2);
	v_GetDates 					Number(2);
	v_LeavePerDay 			Number;
	v_mod 							Number(8,2);
	v_LeaveTillLastDay 	Number;
	v_balance 					Number;
BEGIN
	If To_Char(StartDate, 'MON') = Trim(Mnth) And (To_Char(EndDate, 'MON') = Trim(Mnth) Or EndDate Is Null) Then
			v_GetLeavePeriod := leavehours;		
	ElsIf To_Char(StartDate, 'MON') <> Trim(Mnth) And To_Char(EndDate, 'MON') = Trim(Mnth) Then	
			v_GetDate := To_Char(EndDate, 'DD');
			v_mod := Mod(leavehours, 8);
				If v_mod <> 0 Then
					 v_LeaveTillLastDay := (To_Number(v_GetDate) - 1) * 8;					 
					 v_balance := leavehours - Floor(v_mod);	
					 v_LeavePerDay := v_LeaveTillLastDay + v_balance;
				Else	 
					v_LeavePerDay := To_Number(v_GetDate) * 8;
				End If;	
			v_GetLeavePeriod := v_LeavePerDay;
	ElsIf To_Char(StartDate, 'MON') <> Trim(Mnth) And To_Char(EndDate, 'MON') <> Trim(Mnth) Then								
			Select Last_Day('01-'||Trim(Mnth)||'-'||Years) Into v_LastDay From dual;
			v_GetDate := To_Char(v_LastDay, 'DD');
			v_LeavePerDay := To_Number(v_GetDate) * 8;
			v_GetLeavePeriod := v_LeavePerDay;
	ElsIf To_Char(StartDate, 'MON') = Trim(Mnth) And To_Char(EndDate, 'MON') <> Trim(Mnth) Then	
			v_LastDay := Last_Day(StartDate);
			v_GetDates := To_Number(To_Char(v_LastDay, 'DD')) - (To_Number(To_Char(StartDate, 'DD')) - 1);
			v_LeavePerDay := v_GetDates * 8;
			v_GetLeavePeriod := v_LeavePerDay;
	End If;					
	Return v_GetLeavePeriod;	
END;


/
