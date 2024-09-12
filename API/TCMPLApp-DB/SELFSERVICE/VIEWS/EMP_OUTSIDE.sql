--------------------------------------------------------
--  DDL for View EMP_OUTSIDE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."EMP_OUTSIDE" ("COMPANY", "EMPNO", "NAME", "PARENT", "ASSIGN", "GRADE", "EMPTYPE") AS 
  select company,empno,name,parent,assign,grade,emptype from commonmasters.emplmast where status=1 and assign in ('0236','0237','0232','0296','0297')
;
