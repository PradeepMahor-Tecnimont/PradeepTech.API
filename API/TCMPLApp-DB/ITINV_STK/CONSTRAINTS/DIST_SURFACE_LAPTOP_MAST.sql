--------------------------------------------------------
--  Constraints for Table DIST_SURFACE_LAPTOP_MAST
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."DIST_SURFACE_LAPTOP_MAST" MODIFY ("SAP_ASSET_CODE" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."DIST_SURFACE_LAPTOP_MAST" ADD CONSTRAINT "DIST_LAPTOP_MAST_PK" PRIMARY KEY ("SAP_ASSET_CODE")
  USING INDEX  ENABLE;
