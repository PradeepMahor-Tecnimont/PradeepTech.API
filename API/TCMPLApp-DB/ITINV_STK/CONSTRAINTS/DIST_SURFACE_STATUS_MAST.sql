--------------------------------------------------------
--  Constraints for Table DIST_SURFACE_STATUS_MAST
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."DIST_SURFACE_STATUS_MAST" MODIFY ("STATUS_CODE" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."DIST_SURFACE_STATUS_MAST" ADD CONSTRAINT "DIST_SURFACE_STATUS_MAST_PK" PRIMARY KEY ("STATUS_CODE")
  USING INDEX  ENABLE;
