--------------------------------------------------------
--  DDL for Procedure DEL_HA_APP
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "DEL_HA_APP" 
(
  param_app_no IN VARCHAR2  
) AS 
BEGIN
  Delete from ss_holiday_attendance Where app_no = param_app_no ;
  Commit;
Exception
  When Others then
    Null;
END DEL_HA_APP;

/
