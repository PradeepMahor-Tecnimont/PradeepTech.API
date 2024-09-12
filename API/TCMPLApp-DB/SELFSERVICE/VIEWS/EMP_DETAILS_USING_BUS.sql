--------------------------------------------------------
--  DDL for View EMP_DETAILS_USING_BUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."EMP_DETAILS_USING_BUS" ("EMPNO", "NAME", "PARENT", "ASSIGN", "DESCRIPTION", "CODE", "PICK_UP_POINT", "R_ADD_1", "R_ADD_2", "R_ADD_3", "R_ADD_4", "P_ADD_1", "P_ADD_2", "P_ADD_3", "P_ADD_4") AS 
  select "EMPNO","NAME","PARENT","ASSIGN","DESCRIPTION","CODE","PICK_UP_POINT","R_ADD_1","R_ADD_2","R_ADD_3","R_ADD_4","P_ADD_1","P_ADD_2","P_ADD_3","P_ADD_4" from commonmasters.EMP_DETAILS_USING_BUS
;
