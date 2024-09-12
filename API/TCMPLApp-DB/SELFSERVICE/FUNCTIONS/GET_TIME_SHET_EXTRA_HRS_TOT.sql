--------------------------------------------------------
--  DDL for Function GET_TIME_SHET_EXTRA_HRS_TOT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GET_TIME_SHET_EXTRA_HRS_TOT" 
(
  PARAM_MM IN VARCHAR2  
, PARAM_YYYY IN VARCHAR2  
, PARAM_EMPNO IN VARCHAR2  
) RETURN NUMBER AS 
  vRetVal Number;
BEGIN
Select Sum(Extra_Hours) InTo vRetVal From (
  select get_time_sheet_Extra_Hrs(param_empno,d_date) as Extra_Hours from ss_days_details 
    where d_date >= n_getstartdate(param_mm,param_yyyy)
    and d_date <= n_getenddate(param_mm,param_yyyy) );
    Return vRetVal;
    Exception
    When Others then return null;
END GET_TIME_SHET_EXTRA_HRS_TOT;

/
