--------------------------------------------------------
--  DDL for View INV_VU_ASSETS_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."INV_VU_ASSETS_LIST" ("ASSET_OBJ_ID", "MFG_SR_NO", "TICB_BAR_CODE", "CAT_ID", "CAT_MAKE", "CAT_MODEL", "TYPE_ID", "TYPE_DESC") AS 
  select "ASSET_OBJ_ID","MFG_SR_NO","TICB_BAR_CODE","CAT_ID","CAT_MAKE","CAT_MODEL","TYPE_ID","TYPE_DESC" from inv_assets
;
