--------------------------------------------------------
--  Constraints for Table DM_DESK_AREAS
--------------------------------------------------------

  ALTER TABLE "DM_DESK_AREAS" ADD CONSTRAINT "DM_DESK_AREA_MASTER_PK" PRIMARY KEY ("AREA_KEY_ID")
  USING INDEX  ENABLE;
  ALTER TABLE "DM_DESK_AREAS" MODIFY ("AREA_KEY_ID" NOT NULL ENABLE);
