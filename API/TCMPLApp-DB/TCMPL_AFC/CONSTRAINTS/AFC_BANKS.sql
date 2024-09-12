--------------------------------------------------------
--  Constraints for Table AFC_BANKS
--------------------------------------------------------

  ALTER TABLE "AFC_BANKS" MODIFY ("IS_ACTIVE" NOT NULL ENABLE);
  ALTER TABLE "AFC_BANKS" ADD PRIMARY KEY ("BANK_KEY_ID")
  USING INDEX  ENABLE;
  ALTER TABLE "AFC_BANKS" MODIFY ("BANK_DESC" NOT NULL ENABLE);
