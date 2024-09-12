--------------------------------------------------------
--  Constraints for Table DIST_PC_2_EMP_EXTRA
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."DIST_PC_2_EMP_EXTRA" MODIFY ("AMS_ID" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."DIST_PC_2_EMP_EXTRA" MODIFY ("EMPNO" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."DIST_PC_2_EMP_EXTRA" ADD CONSTRAINT "DIST_PC_2_EMP_EXTRA_PK" PRIMARY KEY ("EMPNO", "AMS_ID")
  USING INDEX  ENABLE;
