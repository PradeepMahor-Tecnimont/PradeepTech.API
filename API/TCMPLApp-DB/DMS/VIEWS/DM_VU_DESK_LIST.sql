--------------------------------------------------------
--  DDL for View DM_VU_DESK_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "DM_VU_DESK_LIST" ("DESKID", "OFFICE", "FLOOR", "WING") AS 
  SELECT deskid, office, floor, wing
    
FROM 
    
dm_deskmaster
;
