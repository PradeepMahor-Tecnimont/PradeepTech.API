--------------------------------------------------------
--  Constraints for Table LAPTOPSTATUS
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."LAPTOPSTATUS" MODIFY ("SAP_CODE" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."LAPTOPSTATUS" ADD CONSTRAINT "LAPTOPSTATUS_PK" PRIMARY KEY ("SAP_CODE")
  USING INDEX  ENABLE;
