--------------------------------------------------------
--  DDL for View EMP_DETAILS_FAMILY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."EMP_DETAILS_FAMILY" ("EMPNO", "NAME", "ASSIGN", "PARENT", "MEMBER", "DOB", "REMARKS", "OCCUPATION", "RELATION") AS 
  select "EMPNO","NAME","ASSIGN","PARENT","MEMBER","DOB","REMARKS","OCCUPATION","RELATION" from commonmasters.EMP_DETAILS_FAMILY
;
