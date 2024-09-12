--------------------------------------------------------
--  DDL for View INVOICED_SOFAR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."INVOICED_SOFAR" ("PROJNO", "COSTCODE", "YYMM", "BUDGET_HRS", "BUDGET_AMT", "OVERBUDGET_HRS", "OVERBUDGET_AMT") AS 
  select projno,costcode,yymm,sum(invoiced_current) as budget_hrs,sum(invoiced_current*rate) as budget_amt,0 as overbudget_hrs,0 as overbudget_amt from inv_invoice_master where nvl(overbudget,0)=0 and nvl(additional,0)=0 and nvl(delta_inv,0)=0 group by projno,costcode,yymm
union all
select projno,costcode,yymm,0 as budget_hrs,0 as budget_amt,sum(invoiced_current-(rollback_overbudget+rollback_current)) as overbudget_hrs,sum((invoiced_current-(rollback_overbudget+rollback_current))*rate) as overbudget_amt from inv_invoice_master where nvl(overbudget,0)=1 and nvl(additional,0)=0  and nvl(delta_inv,0)=0 group by projno,costcode,yymm

;
