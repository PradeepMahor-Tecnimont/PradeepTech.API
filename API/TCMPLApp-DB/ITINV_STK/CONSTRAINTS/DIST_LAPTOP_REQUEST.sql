--------------------------------------------------------
--  Constraints for Table DIST_LAPTOP_REQUEST
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."DIST_LAPTOP_REQUEST" MODIFY ("EMPNO" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."DIST_LAPTOP_REQUEST" ADD CONSTRAINT "DIST_LAPTOP_REQUEST_PK" PRIMARY KEY ("EMPNO")
  USING INDEX  ENABLE;
