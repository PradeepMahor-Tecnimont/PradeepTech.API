--------------------------------------------------------
--  Constraints for Table DM_LOGINRIGHT
--------------------------------------------------------

  ALTER TABLE "DM_LOGINRIGHT" ADD CONSTRAINT "DM_LOGINRIGHT_PK" PRIMARY KEY ("TRANS_ID", "EMPNO", "TO_DESK")
  USING INDEX  ENABLE;
  ALTER TABLE "DM_LOGINRIGHT" MODIFY ("EMPNO" NOT NULL ENABLE);
  ALTER TABLE "DM_LOGINRIGHT" MODIFY ("TO_DESK" NOT NULL ENABLE);
  ALTER TABLE "DM_LOGINRIGHT" MODIFY ("TRANS_ID" NOT NULL ENABLE);
