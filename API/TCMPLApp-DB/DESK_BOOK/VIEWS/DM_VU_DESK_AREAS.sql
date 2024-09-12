--------------------------------------------------------
--  DDL for View DM_VU_DESK_AREAS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DESK_BOOK"."DM_VU_DESK_AREAS" ("AREA_KEY_ID", "AREA_DESC", "AREA_CATG_CODE", "AREA_INFO") AS 
  SELECT 
    "AREA_KEY_ID","AREA_DESC","AREA_CATG_CODE","AREA_INFO"
FROM 
    
dms.dm_desk_areas
;
