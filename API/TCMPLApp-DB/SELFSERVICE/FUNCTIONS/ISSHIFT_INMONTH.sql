--------------------------------------------------------
--  DDL for Function ISSHIFT_INMONTH
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."ISSHIFT_INMONTH" ( p_EmpNo IN VARCHAR, p_YYYYMM IN VARCHAR )  RETURN  NUMBER IS 

   -- Declare program variables as shown above
   /*
   blank_param Exception; -- If the in Parameters r blank then this exception is raised
   PRAGMA EXCEPTION_INIT(blank_param, -60);
   */

   vCounter Number;
   v_ReturnValue Number := 0;----If there are shifts othere than General Shift in a month then the
                        ----the return value is set to 1 If only general shift exists during month
                        ----for an employee then 0 is returned
BEGIN
    If Length( Ltrim(Rtrim( p_EmpNo )) ) = 0 Or Length( Ltrim(Rtrim(p_YYYYMM)) )= 0 Then
       Return -1;
    End If;
    Select Count(*) InTo vCounter From  (
    Select sa.getshift4allowance(p_EmpNo,A.d_Date) As ShiftCode From SS_Days_Details A
      Where A.d_mm = Substr(p_YYYYMM,5,2) And A.d_yyyy = Substr(p_YYYYMM,1,4) ) B
      Where B.ShiftCode In (Select ShiftCode From SS_ShiftMast where shift4allowance=1);
    If vCounter > 0 Then
        v_ReturnValue := 1;
    End If;

    --statements ;
    RETURN v_ReturnValue;
Exception
    When  no_data_found then
       v_ReturnValue := 0;
END;


/
