--------------------------------------------------------
--  DDL for View SS_User_Dept_Rights
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SS_User_Dept_Rights" ("EMPNO", "PARENT") AS 
  SELECT "EMPNO","PARENT" 
FROM selfservice.SS_User_Dept_Rights
;
