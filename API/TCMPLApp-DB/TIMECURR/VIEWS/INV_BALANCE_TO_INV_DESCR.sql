--------------------------------------------------------
--  DDL for View INV_BALANCE_TO_INV_DESCR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."INV_BALANCE_TO_INV_DESCR" ("COMPANY", "PROJECT", "DEPT", "TCMNO", "PROJNO", "PROJNAME", "COSTCODE", "COSTNAME", "BUDGET", "BOOKED", "BILLED", "BALANCE") AS 
  select 
decode(b.co,'T','TICB','E','EDTICB','X') as Company,
a.projno||' '||b.name as project,
a.costcode||' '||c.name as dept,
b.tcmno,
a.projno,
b.name as projname,
a.costcode,
c.name as costname,
a.budget,
a.booked,
a.billed,
case when nvl(a.booked,0) > nvl(a.budget, 0) then
nvl(a.booked, 0) - nvl(a.budget, 0) else 0 end balance
from inv_balance_to_inv a,
projmast b,costmast c 
where a.projno = b.projno 
and a.costcode = c.costcode
;
