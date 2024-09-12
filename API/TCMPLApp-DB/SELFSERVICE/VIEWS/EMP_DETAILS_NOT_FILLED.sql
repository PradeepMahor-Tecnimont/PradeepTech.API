--------------------------------------------------------
--  DDL for View EMP_DETAILS_NOT_FILLED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."EMP_DETAILS_NOT_FILLED" ("EMPNO", "NAME", "PARENT", "ASSIGN", "CO_BUS") AS 
  select "EMPNO","NAME","PARENT","ASSIGN","CO_BUS" from commonmasters.EMP_DETAILS_NOT_FILLED
;
