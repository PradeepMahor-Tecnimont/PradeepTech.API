--------------------------------------------------------
--  DDL for View DM_VU_DESK_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_VU_DESK_LIST" ("DESKID", "OFFICE", "FLOOR", "SEATNO", "WING", "ASSETCODE", "NOEXIST", "CABIN", "REMARKS", "DESKID_OLD", "WORK_AREA", "BAY") AS 
  SELECT "DESKID","OFFICE","FLOOR","SEATNO","WING","ASSETCODE","NOEXIST","CABIN","REMARKS","DESKID_OLD","WORK_AREA","BAY"
    
FROM 
    
dms.dm_deskmaster
;
