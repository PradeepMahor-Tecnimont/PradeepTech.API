--------------------------------------------------------
--  DDL for View INV_COST_PROJ_SUMM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."INV_COST_PROJ_SUMM" ("COSTCODE", "PROJNO", "YYMM", "WITHINBUDGET_HOURS", "WITHINBUDGET_AMOUNT", "OVERBUDGET_HOURS", "OVERBUDGET_AMOUNT", "ROLLBACK_HOURS", "DELTA_HOURS", "DELTA_AMOUNT") AS 
  select costcode,projno,yymm,
sum(WithinBudget_Hours) as WithinBudget_Hours,
sum(WithinBudget_Amount) as WithinBudget_Amount,
sum(OverBudget_Hours) as OverBudget_Hours,
sum(OverBudget_Amount) as OverBudget_Amount,
sum(Rollback_Hours) as Rollback_Hours,
sum(Delta_Hours) as Delta_Hours,
sum(Delta_Amount) as Delta_Amount
from
(select costcode,projno,yymm,
sum(decode(nvl(overbudget,0),0,nvl(invoiced_current,0),0)) as WithinBudget_Hours,
sum(decode(nvl(overbudget,0),0,nvl(invoiced_current,0)*nvl(rate,0),0)) as WithinBudget_Amount,
sum(decode(nvl(overbudget,0),1,nvl(invoiced_current,0),0)) as OverBudget_Hours,
sum(decode(nvl(overbudget,0),1,nvl(invoiced_current,0)*nvl(rate,0),0)) as OverBudget_Amount,
0 as Rollback_Hours,
0 as Delta_Hours,
0 as Delta_Amount
from inv_invoice_master
where nvl(additional,0) = 0
and nvl(delta_inv,0) = 0
group by costcode,projno,yymm
union all
select costcode,projno,yymm,
0 as WithinBudget_Hours,
0 as WithinBudget_Amount,
0 as OverBudget_Hours,
0 as OverBudget_Amount,
sum(nvl(rollback_overbudget,0)+nvl(rollback_current,0)) as Rollback_Hours,
0 as Delta_Hours,
0 as Delta_Amount
from inv_invoice_master
where nvl(additional,0) = 0 and
nvl(delta_inv,0) = 0 and
nvl(overbudget,0) = 1
group by costcode,projno,yymm
union all
select costcode,projno,yymm,
0 as WithinBudget_Hours,
0 as WithinBudget_Amount,
0 as OverBudget_Hours,
0 as OverBudget_Amount,
0 as Rollback_Hours,
sum(decode(old_invoice_no,null,nvl(Invoiced_Current,0),' ',nvl(Invoiced_Current,0),0)) as Delta_Hours,
sum(nvl(invoiced_current,0)*nvl(rate,0)) as Delta_Amount
from inv_invoice_master
where nvl(additional,0) = 0
and nvl(delta_inv,0) = 1
group by costcode,projno,yymm)
group by costcode,projno,yymm

;
