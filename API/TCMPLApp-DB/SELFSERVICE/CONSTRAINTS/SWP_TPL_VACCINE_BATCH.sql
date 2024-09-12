--------------------------------------------------------
--  Constraints for Table SWP_TPL_VACCINE_BATCH
--------------------------------------------------------

  ALTER TABLE "SELFSERVICE"."SWP_TPL_VACCINE_BATCH" ADD CONSTRAINT "SWP_TPL_VACINE_BATCH_PK" PRIMARY KEY ("BATCH_KEY_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE;
  ALTER TABLE "SELFSERVICE"."SWP_TPL_VACCINE_BATCH" ADD CONSTRAINT "SWP_TPL_VACINE_BATCH_UK1" UNIQUE ("VACCINE_DATE")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE;
  ALTER TABLE "SELFSERVICE"."SWP_TPL_VACCINE_BATCH" MODIFY ("BATCH_KEY_ID" NOT NULL ENABLE);
