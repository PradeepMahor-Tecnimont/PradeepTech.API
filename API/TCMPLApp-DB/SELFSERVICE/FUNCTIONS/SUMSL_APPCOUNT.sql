--------------------------------------------------------
--  DDL for Function SUMSL_APPCOUNT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."SUMSL_APPCOUNT" (p_EmpNo IN Varchar2, p_PDate IN Date) RETURN Number IS
		v_RetVal Number := 0;
		v_FirstDate Date;
		v_Dum Varchar2(1);
BEGIN
		v_FirstDate := To_Date('01-' || To_Char(p_PDate,'mm-yyyy'),'dd-mm-yyyy');
  	--v_LComeApp := IsLComeEGoApp(lpad(trim(p_EmpNo),5,'0'),p_PDate);
  	--v_LCome := LateCome(p_EmpNo,p_PDate);

  	Select Sum(IsSLeaveApp(p_EmpNo,(v_FirstDate + (Days-1)))), 'A' as Dum
  			InTo v_RetVal, v_Dum
  			From SS_Days
  				Where Days >= 1 And Days <= To_Number(To_Char(p_PDate,'dd')) Group by 'A';

  	Return v_RetVal;
END;


/
