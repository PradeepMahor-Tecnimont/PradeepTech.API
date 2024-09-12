--------------------------------------------------------
--  DDL for Function N_TIMESHEETALLOWED
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."N_TIMESHEETALLOWED" (param_empno varchar2) RETURN Number AS 
  vCount Number;
  vAssign varchar2(4);
  v_Ret_Val Number;
  v_TimeSheet_Allowed constant Number := 1;
  v_TimeSheet_NotAllowed constant Number := 0;
BEGIN
  Select Assign Into vAssign from ss_emplmast where empno=param_empno;
  Select count(*) InTo vCount From SS_CostMast Where phase <> '99' And costcode = vAssign;
  If vCount > 0 Then
    v_Ret_Val := v_timesheet_allowed;
  else
    v_Ret_Val := v_timesheet_notallowed;
  end If;
  return v_ret_val;
  Exception
  When Others then
    return v_timesheet_notallowed;
END N_TIMESHEETALLOWED;


/
