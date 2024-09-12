--------------------------------------------------------
--  DDL for Index SS_DMS_STATUS2020_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "SELFSERVICE"."SS_DMS_STATUS2020_PK" ON "SELFSERVICE"."SS_DMS_STATUS2020" ("EMPNO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
