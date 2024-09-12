--------------------------------------------------------
--  DDL for View VU_EMPL_APPROVER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."VU_EMPL_APPROVER" ("EMPNO", "APPROVER") AS 
  select empno, approver from RWM2.rw2_empl_approver
;
