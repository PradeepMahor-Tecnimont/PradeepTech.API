--------------------------------------------------------
--  Constraints for Table EMP
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."EMP" ADD PRIMARY KEY ("EMPNO")
  USING INDEX  ENABLE;
  ALTER TABLE "ITINV_STK"."EMP" MODIFY ("EMPNO" NOT NULL ENABLE);
