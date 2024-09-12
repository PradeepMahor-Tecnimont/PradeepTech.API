--------------------------------------------------------
--  DDL for View DM_VU_ASSET_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "DM_VU_ASSET_LIST" ("BARCODE", "MODEL", "COMPNAME", "ASSETTYPE", "MFG_SR_NO", "SCRAP") AS 
  select barcode, model, compname,assettype,SERIALNUM mfg_sr_no,SCRAP from dm_assetcode
;
