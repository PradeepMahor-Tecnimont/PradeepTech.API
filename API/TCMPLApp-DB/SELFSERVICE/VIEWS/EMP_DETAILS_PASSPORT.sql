--------------------------------------------------------
--  DDL for View EMP_DETAILS_PASSPORT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."EMP_DETAILS_PASSPORT" ("EMPNO", "NAME", "PARENT", "ASSIGN", "PASSPORT_NO", "ISSUE_DATE", "EXPIRY_DATE", "PASSPORT_ISSUED_AT") AS 
  select "EMPNO","NAME","PARENT","ASSIGN","PASSPORT_NO","ISSUE_DATE","EXPIRY_DATE","PASSPORT_ISSUED_AT" from commonmasters.EMP_DETAILS_PASSPORT
;
