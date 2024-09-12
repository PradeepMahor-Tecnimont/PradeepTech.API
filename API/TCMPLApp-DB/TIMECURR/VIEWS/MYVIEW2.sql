--------------------------------------------------------
--  DDL for View MYVIEW2
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."MYVIEW2" ("EMPNO", "YYMM", "COSTCODE", "PROJNO", "HOURS", "OTHOURS", "PARENT") AS 
  (
select "EMPNO","YYMM","COSTCODE","PROJNO","HOURS","OTHOURS","PARENT" from myview1 where parent <> costcode)
;
