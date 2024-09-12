--------------------------------------------------------
--  DDL for View CLOSEDBUDG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."CLOSEDBUDG" ("PROJNO", "PHASE", "COSTCODE", "OPEN04", "SHORT_DESC", "CLIENT_NAME", "INDUSTRY", "JOB_OPEN_DATE", "ACTUAL_CLOSING_DATE") AS 
  (select a.projno,a.phase,b.costcode,b.open04 ,
a.short_desc,a.client_name,a.industry,
a.job_open_date,a.actual_closing_date from jobmaster a , openmast b
 where a.projno||a.phase = b.projno and a.actual_closing_date is not null )

;
