--------------------------------------------------------
--  DDL for View JOBWISE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."JOBWISE" ("YYMM", "ASSIGN", "PROJNO", "EMPNO", "ACTIVITY", "NHRS", "OHRS") AS 
  select yymm,assign,projno,empno,activity,sum(total) as nhrs,000.00 as ohrs from time_daily group by yymm,assign,projno,empno,activity union all
select yymm,assign,projno,empno,activity,000.00 as nhrs,sum(total) as ohrs from time_ot group by yymm,assign,projno,empno,activity

;
