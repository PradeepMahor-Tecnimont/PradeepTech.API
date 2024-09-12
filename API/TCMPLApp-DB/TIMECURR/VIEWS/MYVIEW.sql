--------------------------------------------------------
--  DDL for View MYVIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."MYVIEW" ("EMPNO", "YYMM", "COSTCODE", "PROJNO", "HOURS", "OTHOURS", "PARENT") AS 
  (
select timetran.empno,timetran.yymm,timetran.costcode,timetran.projno,hours,
othours, emplmast.parent 
 from timetran , emplmast where timetran.empno = emplmast.empno ) 
;
