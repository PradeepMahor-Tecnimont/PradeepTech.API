--------------------------------------------------------
--  DDL for Function GET_TIME_SHEET_WORK_HRS_TOT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GET_TIME_SHEET_WORK_HRS_TOT" (param_empno varchar2,param_mm varchar2, param_yyyy varchar2)
RETURN VARCHAR2 AS 
  vRetVal Number;
BEGIN
Select Sum(Work_Hours) InTo vRetVal From (
  select get_time_sheet_work_Hrs(param_empno,d_date) as Work_hours from ss_days_details 
    where d_date >= n_getstartdate(param_mm,param_yyyy)
    and d_date <= n_getenddate(param_mm,param_yyyy) );
    Return vRetVal;
    Exception
    When Others then return null;
END GET_TIME_SHEET_WORK_HRS_TOT;

/
