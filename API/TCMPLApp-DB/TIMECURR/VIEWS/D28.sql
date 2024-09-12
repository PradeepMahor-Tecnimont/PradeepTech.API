--------------------------------------------------------
--  DDL for View D28
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."D28" ("YYMM", "EMPNO", "NAME", "ASSIGN", "PROJNO", "ADJUSTMENTS", "UPTOCUTOFF", "ESTIMATES") AS 
  (select a.yymm,a.empno,b.name,a.assign,a.projno,sum(a.adj) Adjustments ,sum(a.actual_1)+ sum(a.actual_2) UptoCutoff, sum(a.estimate_1) + sum(a.estimate_2 ) Estimates
 from dddd_28 a , emplmast b  where a.empno = b.empno  group by a.yymm,a.empno,b.name,a.assign,a.projno )
;
