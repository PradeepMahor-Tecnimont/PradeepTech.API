--------------------------------------------------------
--  Constraints for Table SS_LEAVE_BAL_MAX_LIMIT
--------------------------------------------------------

  ALTER TABLE "SELFSERVICE"."SS_LEAVE_BAL_MAX_LIMIT" ADD CONSTRAINT "SS_LEAVE_BAL_MAX_LIMIT_PK" PRIMARY KEY ("YYYYMM")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE;
  ALTER TABLE "SELFSERVICE"."SS_LEAVE_BAL_MAX_LIMIT" MODIFY ("YYYYMM" NOT NULL ENABLE);
