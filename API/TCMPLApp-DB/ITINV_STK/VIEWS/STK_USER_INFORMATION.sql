--------------------------------------------------------
--  DDL for View STK_USER_INFORMATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."STK_USER_INFORMATION" ("DOMAIN", "USER_ID", "EMP_NO") AS 
  SELECT 
    domain, userid user_id,empno emp_no
FROM selfservice.userids
;
