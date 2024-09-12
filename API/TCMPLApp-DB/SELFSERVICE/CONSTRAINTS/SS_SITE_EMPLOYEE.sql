--------------------------------------------------------
--  Constraints for Table SS_SITE_EMPLOYEE
--------------------------------------------------------

  ALTER TABLE "SELFSERVICE"."SS_SITE_EMPLOYEE" ADD CONSTRAINT "SS_SITE_MOBI_PK" PRIMARY KEY ("EMPNO", "SITECODE", "MOBI_DATE")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE;
  ALTER TABLE "SELFSERVICE"."SS_SITE_EMPLOYEE" MODIFY ("EMPNO" NOT NULL ENABLE);
  ALTER TABLE "SELFSERVICE"."SS_SITE_EMPLOYEE" MODIFY ("SITECODE" NOT NULL ENABLE);
  ALTER TABLE "SELFSERVICE"."SS_SITE_EMPLOYEE" MODIFY ("MOBI_DATE" NOT NULL ENABLE);
