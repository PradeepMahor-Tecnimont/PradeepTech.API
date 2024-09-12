--------------------------------------------------------
--  Constraints for Table DM_NEWJOIN_EMP
--------------------------------------------------------

  ALTER TABLE "DM_NEWJOIN_EMP" ADD CONSTRAINT "DM_NEWJOIN_EMP_PK" PRIMARY KEY ("SID", "EMPNO")
  USING INDEX  ENABLE;
  ALTER TABLE "DM_NEWJOIN_EMP" MODIFY ("EMPNO" NOT NULL ENABLE);
  ALTER TABLE "DM_NEWJOIN_EMP" MODIFY ("SID" NOT NULL ENABLE);
