--------------------------------------------------------
--  Constraints for Table SS_HEALTH_BILL
--------------------------------------------------------

  ALTER TABLE "SELFSERVICE"."SS_HEALTH_BILL" ADD CONSTRAINT "SS_HEALTH_BILL_PK" PRIMARY KEY ("BILLNO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE;
  ALTER TABLE "SELFSERVICE"."SS_HEALTH_BILL" MODIFY ("BILLNO" NOT NULL ENABLE);
