--------------------------------------------------------
--  DDL for View VU_USERIDS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."VU_USERIDS" ("EMPNO", "NAME", "OFFICE", "USERID", "DATETIME", "EMAIL", "DOMAIN", "MODIFIED_ON", "INSERT_ON") AS 
  SELECT 
    "EMPNO","NAME","OFFICE","USERID","DATETIME","EMAIL","DOMAIN","MODIFIED_ON","INSERT_ON"
FROM 
    
selfservice.userids
;
