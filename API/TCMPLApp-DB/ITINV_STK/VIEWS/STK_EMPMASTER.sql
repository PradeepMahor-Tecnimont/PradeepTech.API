--------------------------------------------------------
--  DDL for View STK_EMPMASTER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."STK_EMPMASTER" ("EMPNO", "NAME", "ASSIGN", "PARENT", "STATUS", "EMPTYPE", "MNGR", "EMP_HOD", "GRADE") AS 
  select 
empno,name,assign,parent,status,emptype, mngr,emp_hod,grade from commonmasters.emplmast
;
