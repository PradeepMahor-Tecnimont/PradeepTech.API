--------------------------------------------------------
--  DDL for View TESTING
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TESTING" ("EMPNO", "NAME", "ASSIGN", "YYMM", "REM", "STATUS") AS 
  (
select empno,name,assign,yymm,rem,decode(remarks,'Eligible',0,'Filled',1,'Locked' ,2,'Approved',3,'Posted',4) as status from tm_status_upd
)
;
