--------------------------------------------------------
--  Constraints for Table XDM_LAPTOP_PERMT
--------------------------------------------------------

  ALTER TABLE "SELFSERVICE"."XDM_LAPTOP_PERMT" ADD CONSTRAINT "DM_LAPTOP_PERMT_PK" PRIMARY KEY ("EMPNO", "BARCODE", "ISSUEDATE")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE;
  ALTER TABLE "SELFSERVICE"."XDM_LAPTOP_PERMT" MODIFY ("EMPNO" NOT NULL ENABLE);
  ALTER TABLE "SELFSERVICE"."XDM_LAPTOP_PERMT" MODIFY ("BARCODE" NOT NULL ENABLE);
  ALTER TABLE "SELFSERVICE"."XDM_LAPTOP_PERMT" MODIFY ("ISSUEDATE" NOT NULL ENABLE);
