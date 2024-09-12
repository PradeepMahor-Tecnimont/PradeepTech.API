--------------------------------------------------------
--  DDL for View SS_OTDET_4_ANITA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_OTDET_4_ANITA" ("YYMM", "DT", "EMPNO", "MAXOT", "CLAIMOT") AS 
  select yyyy || mon as yymm, DAY DT ,EMPNO, nvl(W_OT_MAX,0)/60 as MAXOT,
nvl(W_OT_CLAIM,0)/60 as CLAIMOT
 from ss_otDETAIL where
 nvl(w_ot_max,0) <> 0
;
