--------------------------------------------------------
--  DDL for Function SHIFT_WORK_HRS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."SHIFT_WORK_HRS" 
(
  P_EMPNO IN VARCHAR2  
, P_PDATE IN DATE  
, P_SHIFT_CODE IN VARCHAR2  
) RETURN NUMBER AS 
  vCntr Number;
  vLunchTime Number;
  vShiftInTime Number;
  vShiftOutTime Number;
  vRetVal Number;
BEGIN

    Select Count(*) InTo vCntr From SS_LeaveLedg 
    Where EmpNo=Ltrim(Rtrim(p_EmpNo)) And HD_Date = p_PDate;
    If vCntr > 0 Then
      vLunchTime := 0;
    Else
      Select nvl(LUNCH_MN,0) into vLunchTime  From ss_shiftmast Where shiftcode = trim(p_shift_code);
    End If;
    vShiftInTime := GETSHIFTINTIME(p_empno,p_pdate,p_shift_code);
    vShiftOutTime := getshiftouttime(p_empno,p_pdate,p_shift_code);
    vRetVal := vshiftouttime - vshiftintime - vlunchtime;
    RETURN vRetVal;
END SHIFT_WORK_HRS;


/
