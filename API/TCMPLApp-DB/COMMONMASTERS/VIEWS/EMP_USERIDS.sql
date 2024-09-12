--------------------------------------------------------
--  DDL for View EMP_USERIDS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."EMP_USERIDS" ("EMPNO", "NAME", "OFFICE", "USERID", "DATETIME", "EMAIL", "DOMAIN") AS 
  SELECT a.EMPNO,
    a.NAME,
    a.OFFICE,
    a.USERID,
    a.DATETIME,
    a.EMAIL,
    a.DOMAIN
  FROM selfservice.userids a, emplmast b
  where a.empno=b.empno and b.emptype='R' and status=1
;
