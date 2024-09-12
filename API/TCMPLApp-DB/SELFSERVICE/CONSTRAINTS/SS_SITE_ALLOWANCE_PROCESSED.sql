--------------------------------------------------------
--  Constraints for Table SS_SITE_ALLOWANCE_PROCESSED
--------------------------------------------------------

  ALTER TABLE "SELFSERVICE"."SS_SITE_ALLOWANCE_PROCESSED" ADD CONSTRAINT "SS_SITE_ALLOWANCE_PROCESS_PK" PRIMARY KEY ("EMPNO", "SITE_CODE", "SYS_PROC_MONTH")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE;
  ALTER TABLE "SELFSERVICE"."SS_SITE_ALLOWANCE_PROCESSED" ADD CONSTRAINT "SS_SITE_ALLOWANCE_PROCES_CHK1" CHECK (PROCESSED_MONTH IS NOT NULL) ENABLE;
  ALTER TABLE "SELFSERVICE"."SS_SITE_ALLOWANCE_PROCESSED" MODIFY ("EMPNO" NOT NULL ENABLE);
  ALTER TABLE "SELFSERVICE"."SS_SITE_ALLOWANCE_PROCESSED" MODIFY ("SITE_CODE" NOT NULL ENABLE);
  ALTER TABLE "SELFSERVICE"."SS_SITE_ALLOWANCE_PROCESSED" MODIFY ("DELETED" NOT NULL ENABLE);
  ALTER TABLE "SELFSERVICE"."SS_SITE_ALLOWANCE_PROCESSED" MODIFY ("MODIFIED_ON" NOT NULL ENABLE);
  ALTER TABLE "SELFSERVICE"."SS_SITE_ALLOWANCE_PROCESSED" MODIFY ("SYS_PROC_MONTH" NOT NULL ENABLE);
