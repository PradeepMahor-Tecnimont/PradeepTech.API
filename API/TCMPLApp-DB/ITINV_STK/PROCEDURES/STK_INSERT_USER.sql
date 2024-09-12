--------------------------------------------------------
--  DDL for Procedure STK_INSERT_USER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "ITINV_STK"."STK_INSERT_USER" (
    param_domain  IN VARCHAR2,
    param_userId  IN VARCHAR2 ,
    param_empname IN VARCHAR2)
IS
BEGIN
  INSERT
  INTO STK_USER_INFORMATION VALUES
    (
      upper(param_domain) ,
      upper(param_userId) ,
      upper(param_empname)
    );
END;

/
