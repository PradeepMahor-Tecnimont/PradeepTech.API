--------------------------------------------------------
--  DDL for Function SS_MONTH_WRK_HRS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."SS_MONTH_WRK_HRS" 
  ( pEmpNo IN VARCHAR2,
    pMM IN VARCHAR2,
    pYYYY IN VARCHAR2)
  RETURN  Number IS
--
-- To modify this template, edit file FUNC.TXT in TEMPLATE 
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the function
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  -------------------------------------------       
   vWrkTime                 Number;
--   vWrkHrs                  Number;
--   vWrkMin                  Number;
   -- Declare program variables as shown above
BEGIN
    select  sum(N_WorkedHrs(pEmpNo,D_Date, GetShift1(pEmpNo,D_Date)) ) InTo vWrkTime from ss_days_details
        where d_yyyy = pYYYY and d_mm = pMM ;
    RETURN nvl(vWrkTime,0)/60 ;
/*EXCEPTION
   WHEN others THEN
       Return 0;*/
END;


/
