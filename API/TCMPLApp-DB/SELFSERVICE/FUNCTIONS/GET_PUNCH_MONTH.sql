--------------------------------------------------------
--  DDL for Function GET_PUNCH_MONTH
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GET_PUNCH_MONTH" (param_date In date) RETURN VARCHAR2 AS 
  vRetVal Varchar2(3);
  vDate Date;
BEGIN

    Select MAX(D_Date) InTo vDate From SS_Days_Details Where
    Wk_Of_Year in (select wk_of_year from ss_days_details where d_date=param_date) 
    AND D_dATE <= PARAM_DATE + 7;
    vRetVal := to_char(vDate,'MON');
    return vRetVal;
END GET_PUNCH_MONTH;


/
