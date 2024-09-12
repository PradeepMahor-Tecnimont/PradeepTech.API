--------------------------------------------------------
--  Constraints for Table DM_ASSETTYPE
--------------------------------------------------------

  ALTER TABLE "DM_ASSETTYPE" ADD CONSTRAINT "DM_ASSETTYPE_PK" PRIMARY KEY ("ASSET_TYPE")
  USING INDEX  ENABLE;
  ALTER TABLE "DM_ASSETTYPE" MODIFY ("ASSET_TYPE" NOT NULL ENABLE);
