--------------------------------------------------------
--  DDL for View INV_TIMETRAN_TCM2
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."INV_TIMETRAN_TCM2" ("YYMM", "PROJNO", "COSTCODE", "ACTIVITY", "TICB_HRS", "SUBC_HRS") AS 
  select a.yymm,a.projno,a.costcode,a.activity,sum(a.ticb_hrs) as ticb_hrs,sum(a.subc_hrs) as subc_hrs from inv_timetran a,projmast b where a.projno = b.projno and nvl(b.tcm_jobs,0) > 0 and nvl(b.reimb_job,0) > 0 and nvl(b.excl_billing,0)=0 group by
a.yymm,a.projno,a.costcode,a.activity WITH READ ONLY

;
