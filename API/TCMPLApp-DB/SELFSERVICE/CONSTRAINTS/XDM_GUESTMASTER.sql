--------------------------------------------------------
--  Constraints for Table XDM_GUESTMASTER
--------------------------------------------------------

  ALTER TABLE "SELFSERVICE"."XDM_GUESTMASTER" ADD CONSTRAINT "DM_GUESTMASTER_PK" PRIMARY KEY ("GNUM")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE;
  ALTER TABLE "SELFSERVICE"."XDM_GUESTMASTER" MODIFY ("GNUM" NOT NULL ENABLE);
  ALTER TABLE "SELFSERVICE"."XDM_GUESTMASTER" MODIFY ("GNAME" NOT NULL ENABLE);
  ALTER TABLE "SELFSERVICE"."XDM_GUESTMASTER" MODIFY ("GFROMDATE" NOT NULL ENABLE);
  ALTER TABLE "SELFSERVICE"."XDM_GUESTMASTER" MODIFY ("GTODATE" NOT NULL ENABLE);
