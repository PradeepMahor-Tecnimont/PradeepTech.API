--------------------------------------------------------
--  DDL for View DIST_VU_DOCKING_STATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."DIST_VU_DOCKING_STATION" ("SAP_ASSET_CODE", "AMS_ASSET_ID", "MFG_SR_NO", "ASSET_MODEL") AS 
  Select
    a.sap_asset_code,
    b.ams_asset_id,
    b.mfg_sr_no,
    asset_model
From
    dist_dock_station_mast  a,
    ams_asset_master        b
Where
    a.sap_asset_code = b.sap_asset_code
;
