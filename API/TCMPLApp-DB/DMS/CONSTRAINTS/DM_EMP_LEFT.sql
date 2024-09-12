--------------------------------------------------------
--  Constraints for Table DM_EMP_LEFT
--------------------------------------------------------

  ALTER TABLE "DM_EMP_LEFT" ADD CONSTRAINT "DM_EMP_LEFT_PK" PRIMARY KEY ("EMPNO")
  USING INDEX  ENABLE;
  ALTER TABLE "DM_EMP_LEFT" MODIFY ("EMPNO" NOT NULL ENABLE);
  ALTER TABLE "DM_EMP_LEFT" MODIFY ("REQNUM" NOT NULL ENABLE);
