--------------------------------------------------------
--  Constraints for Table SWP_VACCINATION_OFFICE_FAMILY
--------------------------------------------------------

  ALTER TABLE "SELFSERVICE"."SWP_VACCINATION_OFFICE_FAMILY" ADD CONSTRAINT "SWP_VACCINATION_OFFICE_FAM_PK" PRIMARY KEY ("EMPNO", "FAMILY_MEMBER_NAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE;
  ALTER TABLE "SELFSERVICE"."SWP_VACCINATION_OFFICE_FAMILY" MODIFY ("FAMILY_MEMBER_NAME" NOT NULL ENABLE);
  ALTER TABLE "SELFSERVICE"."SWP_VACCINATION_OFFICE_FAMILY" MODIFY ("EMPNO" NOT NULL ENABLE);
