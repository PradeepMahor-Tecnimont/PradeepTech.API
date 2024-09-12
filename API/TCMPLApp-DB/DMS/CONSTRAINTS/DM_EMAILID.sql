--------------------------------------------------------
--  Constraints for Table DM_EMAILID
--------------------------------------------------------

  ALTER TABLE "DM_EMAILID" ADD CONSTRAINT "DM_EMAILID_PK" PRIMARY KEY ("NAME", "EMPNO")
  USING INDEX  ENABLE;
  ALTER TABLE "DM_EMAILID" MODIFY ("EMPNO" NOT NULL ENABLE);
  ALTER TABLE "DM_EMAILID" MODIFY ("NAME" NOT NULL ENABLE);
