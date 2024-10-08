--------------------------------------------------------
--  DDL for Index DM_ASSETMOVE_TRAN_HIS_IND1
--------------------------------------------------------

  CREATE INDEX "SELFSERVICE"."DM_ASSETMOVE_TRAN_HIS_IND1" ON "SELFSERVICE"."XDM_ASSETMOVE_TRAN_HIST_051216" ("DESKID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
