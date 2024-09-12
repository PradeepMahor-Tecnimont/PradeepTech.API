--------------------------------------------------------
--  DDL for View INV_TIMETRAN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."INV_TIMETRAN" ("YYMM", "PROJNO", "COSTCODE", "ACTIVITY", "TICB_HRS", "SUBC_HRS") AS 
  select a.yymm,a.projno,c.groups as costcode,
a.activity,sum(nvl(a.hours,0)+nvl(a.othours,0))
as TICB_HRS, 00000000.00 as SUBC_HRS
from timecurr.timetran a,emplmast b,costmast c
where a.empno = b.empno and a.costcode = c.costcode
and (b.emptype = 'R' or b.emptype = 'C' or b.emptype = 'S')   AND yymm              >='201904'
  AND yymm              <='202003' group by
a.yymm,a.projno,c.groups,a.activity union all
select a.yymm,a.projno,c.groups as costcode,a.activity,
0000000.00 as TICB_HRS,
sum(nvl(a.hours,0)+nvl(a.othours,0)) as SUBC_HRS
from timecurr.timetran a,emplmast b,costmast c
where a.empno = b.empno and a.costcode = c.costcode
and b.emptype = 'X'   AND yymm              >='201904'
  AND yymm              <='202003' group by
a.yymm,a.projno,c.groups,a.activity union all
select yymm,projno,costcode,activity,ticb_hrs,subc_hrs from
inv_timetran_tcm_open WITH READ ONLY
;
