--------------------------------------------------------
--  Constraints for Table AFC_LC_STATUS_MASTER
--------------------------------------------------------

  ALTER TABLE "AFC_LC_STATUS_MASTER" MODIFY ("IS_ACTIVE" NOT NULL ENABLE);
  ALTER TABLE "AFC_LC_STATUS_MASTER" ADD PRIMARY KEY ("STATUS_KEY_ID")
  USING INDEX  ENABLE;
  ALTER TABLE "AFC_LC_STATUS_MASTER" MODIFY ("STATUS_DESC" NOT NULL ENABLE);
