--------------------------------------------------------
--  DDL for View BOOKEDLESS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."BOOKEDLESS" ("YYMM", "EMPNO", "HOURS", "WORKING_HRS") AS 
  (select a."YYMM",a."EMPNO",a."HOURS" ,b.WORKING_HRS  from bookedhours a,wrkhours b where a.yymm = b.yymm and b.OFFICE = 'BO'
  and a.hours < b.WORKING_HRS )
;
