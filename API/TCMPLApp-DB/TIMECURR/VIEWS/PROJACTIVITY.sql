--------------------------------------------------------
--  DDL for View PROJACTIVITY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PROJACTIVITY" ("PROJNO", "YYMM", "COSTCODE", "TLPCODE", "TOTHOURS") AS 
  select a.projno,a.yymm,b.costcode,b.tlpcode,sum(nvl(a.hours,0)+nvl(a.othours,0)) as tothours
from timetran a,act_mast b where
a.costcode||a.activity = b.costcode||b.activity
group by a.projno,a.yymm,b.costcode,b.tlpcode

;
