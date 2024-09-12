--------------------------------------------------------
--  DDL for View INV_LOA_SUMMARY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."INV_LOA_SUMMARY" ("PROJNO", "COSTCODE", "BUDGET", "TICB", "SUBC", "INVOICED", "DELTA", "RLBACK") AS 
  select projno,costcode,sum(nvl(budgetted_hours,0)) as budget,sum(nvl(ticbconsumed_hours,0)) as ticb,sum(nvl(subcconsumed_hours,0)) as subc,sum(nvl(invoiced_hours,0)) as invoiced,sum(nvl(delta_hours,0)) as delta,sum(nvl(rollback_overbudget,0)) as rlback from inv_loa_details where nvl(loa_closed,0) = 0 group by projno,costcode

;
