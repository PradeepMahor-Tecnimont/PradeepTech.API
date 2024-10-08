--------------------------------------------------------
--  Constraints for Table SS_ABSENT_MASTER
--------------------------------------------------------

  ALTER TABLE "SELFSERVICE"."SS_ABSENT_MASTER" ADD CONSTRAINT "SS_ABSENT_MASTER_PK" PRIMARY KEY ("ABSENT_YYYYMM", "PAYSLIP_YYYYMM")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE;
  ALTER TABLE "SELFSERVICE"."SS_ABSENT_MASTER" MODIFY ("PAYSLIP_YYYYMM" NOT NULL ENABLE);
  ALTER TABLE "SELFSERVICE"."SS_ABSENT_MASTER" MODIFY ("ABSENT_YYYYMM" NOT NULL ENABLE);
