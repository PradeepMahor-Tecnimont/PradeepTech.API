--------------------------------------------------------
--  DDL for View OFB_VU_USERIDS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TCMPL_HR"."OFB_VU_USERIDS" ("EMPNO", "NAME", "OFFICE", "USERID", "DATETIME", "EMAIL", "DOMAIN", "MODIFIED_ON", "INSERT_ON") AS 
  SELECT 
    "EMPNO","NAME","OFFICE","USERID","DATETIME","EMAIL","DOMAIN","MODIFIED_ON","INSERT_ON"
FROM 
    
selfservice.userids
;
  GRANT SELECT ON "TCMPL_HR"."OFB_VU_USERIDS" TO "TCMPL_APP_CONFIG";
