--------------------------------------------------------
--  Constraints for Table AFC_VENDORS
--------------------------------------------------------

  ALTER TABLE "AFC_VENDORS" MODIFY ("IS_ACTIVE" NOT NULL ENABLE);
  ALTER TABLE "AFC_VENDORS" ADD PRIMARY KEY ("VENDOR_KEY_ID")
  USING INDEX  ENABLE;
  ALTER TABLE "AFC_VENDORS" MODIFY ("VENDOR_NAME" NOT NULL ENABLE);
