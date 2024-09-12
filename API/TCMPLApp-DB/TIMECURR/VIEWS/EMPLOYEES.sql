--------------------------------------------------------
--  DDL for View EMPLOYEES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."EMPLOYEES" ("EMPNO", "NAME") AS 
  select empno,name from emplmast

;
