--------------------------------------------------------
--  Constraints for Table DIST_ROLE_MAST
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."DIST_ROLE_MAST" MODIFY ("ROLE_ID" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."DIST_ROLE_MAST" ADD CONSTRAINT "DIST_ROLE_MAST_PK" PRIMARY KEY ("ROLE_ID")
  USING INDEX  ENABLE;
