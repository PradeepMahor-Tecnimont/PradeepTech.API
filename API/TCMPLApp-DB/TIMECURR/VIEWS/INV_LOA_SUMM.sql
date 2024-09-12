--------------------------------------------------------
--  DDL for View INV_LOA_SUMM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."INV_LOA_SUMM" ("PROJNO", "SUBORDER_NO", "COSTCODE", "CONSUMED", "INVOICED", "BUDGET") AS 
  select projno,suborder_no,costcode,sum(nvl(ticbconsumed_hours,0)) as consumed,sum(nvl(invoiced_hours,0)) as invoiced,sum(nvl(budgetted_hours,0)) as budget from inv_loa_details group by projno,suborder_no,costcode order by projno,suborder_no,costcode

;
