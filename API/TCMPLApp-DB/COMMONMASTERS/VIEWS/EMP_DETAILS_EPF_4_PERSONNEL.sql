--------------------------------------------------------
--  DDL for View EMP_DETAILS_EPF_4_PERSONNEL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."EMP_DETAILS_EPF_4_PERSONNEL" ("EMPNO", "NOM_NAME", "RELATION") AS 
  select empno, nom_name, relation from emp_epf
;
