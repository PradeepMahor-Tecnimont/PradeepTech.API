--------------------------------------------------------
--  DDL for View SS_BB_LOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_BB_LOG" ("EMPNO", "INSTALL_DATE") AS 
  select empno,min(install_date) install_date from ITINV_STK.bb_emp_pc_log group by empno
;
