--------------------------------------------------------
--  DDL for View TEMPVIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TEMPVIEW" ("EMPNO", "EMPLOYEENAME", "NAME") AS 
  (
select a.empno,a.name as employeename,b.name from emplmast a ,costmast b where a.parent =
b.costcode )

;
