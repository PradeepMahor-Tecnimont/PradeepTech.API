--------------------------------------------------------
--  DDL for View LICENSES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."LICENSES" ("EMPTYPE", "EMPNO", "NAME", "PARENT", "ASSIGN") AS 
  (select emptype,empno,name,parent,assign from emplmast where emptype in ('C','R') and status = 1)
;
