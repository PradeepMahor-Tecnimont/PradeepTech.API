--------------------------------------------------------
--  Constraints for Table AFC_COMPANYS
--------------------------------------------------------

  ALTER TABLE "AFC_COMPANYS" MODIFY ("IS_ACTIVE" NOT NULL ENABLE);
  ALTER TABLE "AFC_COMPANYS" ADD PRIMARY KEY ("COMPANY_CODE")
  USING INDEX  ENABLE;
  ALTER TABLE "AFC_COMPANYS" MODIFY ("COMPANY_SHORT_NAME" NOT NULL ENABLE);
  ALTER TABLE "AFC_COMPANYS" MODIFY ("COMPANY_FULL_NAME" NOT NULL ENABLE);
