--------------------------------------------------------
--  DDL for Index SS_LEAVELEDG_IDX_002
--------------------------------------------------------

  CREATE INDEX "SELFSERVICE"."SS_LEAVELEDG_IDX_002" ON "SELFSERVICE"."SS_LEAVELEDG" ("EMPNO", "ADJ_TYPE", "BDATE", "HD_DATE", "DB_CR", "LEAVETYPE", "LEAVEPERIOD") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
