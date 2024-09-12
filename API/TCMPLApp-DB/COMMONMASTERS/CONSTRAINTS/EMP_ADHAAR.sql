--------------------------------------------------------
--  Constraints for Table EMP_ADHAAR
--------------------------------------------------------

  ALTER TABLE "COMMONMASTERS"."EMP_ADHAAR" ADD CONSTRAINT "EMP_ADHAAR_PK" PRIMARY KEY ("EMPNO")
  USING INDEX  ENABLE;
  ALTER TABLE "COMMONMASTERS"."EMP_ADHAAR" MODIFY ("EMPNO" NOT NULL ENABLE);
