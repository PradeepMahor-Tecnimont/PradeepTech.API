--------------------------------------------------------
--  DDL for View DM_VU_DESKALLOCAITON
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."DM_VU_DESKALLOCAITON" ("DESKID", "ASSETID", "BARCODE_OLD") AS 
  SELECT 
    "DESKID","ASSETID","BARCODE_OLD"
FROM 
    
dms.dm_deskallocation
;
