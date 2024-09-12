--------------------------------------------------------
--  DDL for View DM_VU_DESK_AREAS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "DM_VU_DESK_AREAS" ("AREA_KEY_ID", "AREA_DESC", "IS_SHARED_AREA") AS 
  SELECT 
    "AREA_KEY_ID","AREA_DESC","IS_SHARED_AREA"
FROM 
    
dm_desk_areas
;
