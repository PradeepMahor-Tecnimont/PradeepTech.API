--------------------------------------------------------
--  DDL for Function ISLDT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."ISLDT" (V_Date IN Date, V_EmpNo IN Varchar2, pHalfDay IN Number default 0) RETURN number IS
	V_Cntr Number;
	V_RetVal number := 0;
BEGIN
    --Return Value - 1  For Leave -> Full Day
    --Return Value - 2  For Deputation
    --Return Value - 3  For Tour 
    --Return Valee - 4  For Leave -> Half Dau
    --Return Value - 5  For SWP Leave Deduction
    --
  Select count(*) into V_Cntr from SS_LeaveLedg 
  	where EmpNo = trim(V_EmpNo) and BDate <= V_Date and nvl(EDate,BDate) >= V_Date
  	and ADJ_Type in ('LA' ,'LC','SW') ;
  If V_Cntr > 0 then
    If pHalfDay = 0 Then
        Select Count(*) InTo v_Cntr From SS_LeaveLedg 
          Where EmpNo=Ltrim(Rtrim(v_EmpNo)) And HD_Date = v_Date;
        If v_Cntr > 0 Then
            v_RetVal := 4;
        Else
            v_RetVal := 1;
        End If;
    Else
        v_RetVal := 1;
    End If;
  Else
        Select count(*) into V_Cntr from SS_Depu 
            where EmpNo = trim(V_EmpNo) and BDate <= V_Date and nvl(EDate,BDate) >= V_Date
            and (Hod_Apprl = 1 and  Hrd_Apprl = 1) And Type='DP';
        If V_Cntr > 0 then
            V_RetVal := 2;
        Else
            Select count(*) into V_Cntr from SS_Depu 
                    where EmpNo = trim(V_EmpNo) and BDate <= V_Date and nvl(EDate,BDate) >= V_Date
                    and (Hod_Apprl = 1 and  Hrd_Apprl = 1) And Type='TR';
            If V_Cntr > 0 then
                            V_RetVal := 3;
            End If;
        End If;
  End If;
  Return V_RetVal;
Exception
  	when others then Return V_RetVal;
END;


/
