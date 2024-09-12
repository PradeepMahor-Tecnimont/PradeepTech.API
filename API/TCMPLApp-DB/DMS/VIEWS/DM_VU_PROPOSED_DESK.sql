--------------------------------------------------------
--  DDL for View DM_VU_PROPOSED_DESK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "DM_VU_PROPOSED_DESK" ("EMPNO", "TARGETDESK", "OFFICE", "FLOOR", "WING") AS 
  select a.empno, a.targetdesk, b.office, b.floor, b.wing from dm_assetmove_tran a, dm_deskmaster b 
where a.targetdesk = b.deskid and a.it_cord_apprl = 0
;
