--------------------------------------------------------
--  DDL for Function N_SUM_SLAPP_COUNT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."N_SUM_SLAPP_COUNT" 
  ( P_EmpNo IN VARCHAR2,
    p_Date IN Date)
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
   vRetValue                Number;
   vDate                    DATE;
   vDateTemp                DATE;
   vFirstDate               DATE;
   vDum                     CHAR(1);
   -- Declare program variables as shown above
BEGIN 
    vRetValue := 0;
    vDateTemp := p_Date - 7;
    Select Max(D_Date) InTo vDate From SS_Days_Details Where
    Wk_Of_Year = (select wk_of_year from ss_days_details where d_date=p_date) and d_date <= p_date +7;
    --and d_Date >= (p_date-7);
    vFirstDate := N_GetStartDate(To_Char(vDate,'MM'), to_char(vDate,'YYYY')) ;
  	Select sum(IsSLeaveApp(p_EmpNo,d_date)) Into vRetValue
  	    From SS_Days_details
  		Where d_Date >= vFirstDate And d_Date <= p_Date  ;
    RETURN vRetValue;
EXCEPTION
   WHEN others THEN
      return 0;
END;


/
