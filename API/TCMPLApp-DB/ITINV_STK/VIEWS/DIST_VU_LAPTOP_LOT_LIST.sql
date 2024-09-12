--------------------------------------------------------
--  DDL for View DIST_VU_LAPTOP_LOT_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."DIST_VU_LAPTOP_LOT_LIST" ("AMS_ASSET_ID", "SAP_ASSET_CODE", "LOT_DESC") AS 
  select b.ams_asset_id,b.sap_asset_code,a.lot_desc from dist_laptop_lot_mast a, dist_laptop_lot_details b
    where a.key_id=b.key_id
;
