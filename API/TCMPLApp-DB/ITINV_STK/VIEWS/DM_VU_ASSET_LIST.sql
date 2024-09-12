--------------------------------------------------------
--  DDL for View DM_VU_ASSET_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."DM_VU_ASSET_LIST" ("BARCODE", "MODEL", "COMPNAME", "ASSETTYPE", "MFG_SR_NO", "SCRAP") AS 
  SELECT "BARCODE","MODEL","COMPNAME","ASSETTYPE",mfg_sr_no,"SCRAP" 
FROM dm_asset_list
;
