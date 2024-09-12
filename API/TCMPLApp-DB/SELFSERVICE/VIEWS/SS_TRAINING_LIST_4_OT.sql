--------------------------------------------------------
--  DDL for View SS_TRAINING_LIST_4_OT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_TRAINING_LIST_4_OT" ("TR_NO", "EMPNO", "TRDATE_T", "DFLAG_T", "OTFLAG_T") AS 
  select "TR_NO","EMPNO","TRDATE_T","DFLAG_T","OTFLAG_T" from trainingnew.tr_date_trans
;
