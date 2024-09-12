--------------------------------------------------------
--  DDL for View INVOICED_SUMM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."INVOICED_SUMM" ("TCM_NO", "PROJNO", "SUBORDER_NO", "LOA_NO", "INVOICE_NO", "MANHOURS", "AMOUNT", "BALANCE") AS 
  select tcm_no,projno,suborder_no,loa_no,invoice_no,sum(nvl(invoiced_current,0)) as manhours,sum(nvl(invoiced_current,0)*rate) as amount,case when sum(nvl(invoiced_current,0)) > sum(nvl(budget, 0)) then
sum(nvl(invoiced_current, 0)) - sum(nvl(budget, 0)) else 0 end balance from inv_workfile1 group by tcm_no,projno,suborder_no,loa_no,invoice_no
;
