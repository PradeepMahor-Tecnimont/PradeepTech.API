--------------------------------------------------------
--  DDL for View PIPING_EMP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PIPING_EMP" ("COMPANY", "PARENT", "ASSIGN", "EMPNO", "NAME", "PASSWORD", "SEX", "GRADE") AS 
  select company,parent,assign,empno,name,password,sex,grade from emplmast where parent = '0221' and status=1

;
