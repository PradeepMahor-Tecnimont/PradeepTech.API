--------------------------------------------------------
--  DDL for View MYVIEW4
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."MYVIEW4" ("EMPNO", "YYMM", "COSTCODE", "PARENT") AS 
  (
select distinct empno,yymm,costcode,parent from myview3 )
;
