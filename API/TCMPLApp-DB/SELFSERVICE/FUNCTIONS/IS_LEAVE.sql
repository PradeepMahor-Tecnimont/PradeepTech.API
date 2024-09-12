--------------------------------------------------------
--  DDL for Function IS_LEAVE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."IS_LEAVE" 
(
  PARAM_EMPNO IN VARCHAR2 
, PARAM_DATE IN DATE 
) RETURN NUMBER AS 
  v_cntr number;
BEGIN
    Select count(*) into v_cntr from ss_holidays where holiday = param_date;
    if v_cntr <> 0 then return 0; end if;
    Select count(*) into V_Cntr from SS_LeaveLedg 
  	where EmpNo = trim(PARAM_EMPNO) and BDate <= param_date and nvl(EDate,BDate) >= param_date
  	and (ADJ_Type = 'LA' or ADJ_Type = 'LC') ;
    If v_cntr > 0 Then
        Return 1;
    Else
        Return 0; 
    End If;
END IS_LEAVE;


/
