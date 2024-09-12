--------------------------------------------------------
--  Constraints for Table DIST_DOCK_STATION_MAST
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."DIST_DOCK_STATION_MAST" MODIFY ("SAP_ASSET_CODE" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."DIST_DOCK_STATION_MAST" ADD CONSTRAINT "DIST_DOCK_STATION_MAST_PK" PRIMARY KEY ("SAP_ASSET_CODE")
  USING INDEX  ENABLE;
