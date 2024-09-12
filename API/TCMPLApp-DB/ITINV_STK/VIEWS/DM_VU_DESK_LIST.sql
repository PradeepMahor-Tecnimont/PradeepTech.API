--------------------------------------------------------
--  DDL for View DM_VU_DESK_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."DM_VU_DESK_LIST" ("DESKID", "OFFICE", "FLOOR", "WING") AS 
  SELECT "DESKID","OFFICE","FLOOR","WING"
    
FROM 
    
DM_DESK_LIST
;
