--------------------------------------------------------
--  DDL for View SS_9794_VU_BT_PUNCH_COUNT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_9794_VU_BT_PUNCH_COUNT" ("EMPNO", "PDATE", "REC_COUNT") AS 
  select empno,pdate,count(*) rec_count from ss_9794_punch group by empno,pdate having count(*) > 5 and count(*) <25
;
