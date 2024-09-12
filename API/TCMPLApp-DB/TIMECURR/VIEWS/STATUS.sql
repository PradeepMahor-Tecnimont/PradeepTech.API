--------------------------------------------------------
--  DDL for View STATUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."STATUS" ("EMPNO", "NAME", "ASSIGN", "YYMM", "ZERO", "ONE", "TWO", "THREE", "FOUR") AS 
  (
select "EMPNO","NAME","ASSIGN","YYMM","ZERO","ONE","TWO","THREE","FOUR" from testing
 pivot
 (
 sum(rem)
 for status in (0 as Zero,1 as One,2 as Two,3 as Three,4 as Four)
 )
 )
;
