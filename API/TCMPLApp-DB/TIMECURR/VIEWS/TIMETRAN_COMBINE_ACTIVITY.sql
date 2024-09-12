--------------------------------------------------------
--  DDL for View TIMETRAN_COMBINE_ACTIVITY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TIMETRAN_COMBINE_ACTIVITY" ("YYMM", "EMPNO", "COSTCODE", "PROJNO", "WPCODE", "ACTIVITY", "GRP", "HOURS", "OTHOURS", "NAME") AS 
  select a."YYMM",a."EMPNO",a."COSTCODE",a."PROJNO",a."WPCODE",a."ACTIVITY",a."GRP",a."HOURS",a."OTHOURS",b.name from timetran_combine a,act_mast b where a.costcode = b.costcode(+) and a.activity = b.activity(+)

;
