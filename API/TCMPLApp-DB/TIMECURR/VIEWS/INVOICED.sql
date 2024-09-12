--------------------------------------------------------
--  DDL for View INVOICED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."INVOICED" ("PROJNO", "COSTCODE", "INVOICED") AS 
  select projno,costcode,sum(nvl(invoiced_sofar,0)+nvl(invoiced_current,0)) as invoiced from inv_workfile1 group by projno,costcode

;
