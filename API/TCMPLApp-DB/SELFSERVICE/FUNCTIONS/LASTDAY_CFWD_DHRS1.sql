--------------------------------------------------------
--  DDL for Function LASTDAY_CFWD_DHRS1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."LASTDAY_CFWD_DHRS1" (p_DeltaHrs IN Number, p_EGo IN Number,
   p_SLApp IN Number, p_SLAppCntr IN Number,
  p_isLWD IN Number) 
											
RETURN Number IS
		v_RetVal Number := 0;
BEGIN
        If p_isLWD = 1 Then
            If p_EGo > 0 And p_DeltaHrs < 0 Then
                If (p_EGo <= 60) Then
                    Select Greatest(p_EGo*-1,p_DeltaHrs) InTo v_RetVal From Dual;
                ElsIf (p_SLApp = 1 And p_SLAppCntr <= 2) And (p_EGo > 60 And p_EGo <= 240) Then
                    Select Greatest(p_EGo*-1,p_DeltaHrs) InTo v_RetVal From Dual;
                End If;
            End If;
        End If;
  	Return v_RetVal;
END;


/
