--------------------------------------------------------
--  DDL for View DATEWISE_TS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."DATEWISE_TS" ("YYMM", "EMPNO", "PARENT", "ASSIGN", "TS_DATE", "PROJNO", "WPCODE", "ACTIVITY", "HOURS", "OTHOURS") AS 
  select yymm,empno,parent,assign,ts_date,
projno,wpcode,activity,sum(hours) as hours,
sum(othours) as othours from datewise_timesheet
group by yymm,empno,parent,assign,ts_date,
projno,wpcode,activity

;
