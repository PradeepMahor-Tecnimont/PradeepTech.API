--------------------------------------------------------
--  DDL for View TM_KALLO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TM_KALLO" ("YYMM", "TS_DATE", "EMPNO", "PARENT", "ASSIGN", "WPCODE", "ACTIVITY", "HOURS", "OTHOURS", "PROJNO", "OT", "NAME", "TOTHOURS", "AREA", "WK_ID", "WK_DAY", "WK_DATE", "WK_PERIOD", "WK_WEEK") AS 
  (
SELECT a."YYMM",a."TS_DATE",a."EMPNO",a."PARENT",a."ASSIGN",a."WPCODE",a."ACTIVITY",a."HOURS",a."OTHOURS",a."PROJNO",a."OT",b.name,nvl(a.hours,0)+nvl(a.othours,0) TotHours,decode(a.wpcode,5,'Brown','Green') Area ,c."WK_ID",c."WK_DAY",c."WK_DATE",c."WK_PERIOD",c."WK_WEEK" FROM DATEWISE_TIMESHEET a,emplmast b ,TM_WK_KALLO c  where c.wk_date = a.ts_date and a.empno = b.empno and a.projno like '09050%' 
)
;
