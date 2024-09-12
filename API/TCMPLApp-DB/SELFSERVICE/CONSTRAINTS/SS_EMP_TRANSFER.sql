--------------------------------------------------------
--  Constraints for Table SS_EMP_TRANSFER
--------------------------------------------------------

  ALTER TABLE "SELFSERVICE"."SS_EMP_TRANSFER" ADD CONSTRAINT "SS_EMP_TRANSF_PK11112264442918" PRIMARY KEY ("EMPNO", "TRANSFERDATE")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE;
