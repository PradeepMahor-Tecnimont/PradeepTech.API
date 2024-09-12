--------------------------------------------------------
--  Constraints for Table DM_ASSET_OFFICE
--------------------------------------------------------

  ALTER TABLE "DM_ASSET_OFFICE" ADD CONSTRAINT "DM_ASSET_OFFICE_PK" PRIMARY KEY ("ASSETID", "OFFICE")
  USING INDEX  ENABLE;
  ALTER TABLE "DM_ASSET_OFFICE" MODIFY ("OFFICE" NOT NULL ENABLE);
  ALTER TABLE "DM_ASSET_OFFICE" MODIFY ("ASSETID" NOT NULL ENABLE);
