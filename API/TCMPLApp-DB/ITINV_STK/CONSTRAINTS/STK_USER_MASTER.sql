--------------------------------------------------------
--  Constraints for Table STK_USER_MASTER
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."STK_USER_MASTER" MODIFY ("EMPNO" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."STK_USER_MASTER" ADD CONSTRAINT "STK_USER_MASTER_PK" PRIMARY KEY ("EMPNO")
  USING INDEX  ENABLE;
