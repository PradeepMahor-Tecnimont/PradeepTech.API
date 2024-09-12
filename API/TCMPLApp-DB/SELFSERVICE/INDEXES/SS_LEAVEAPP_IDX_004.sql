--------------------------------------------------------
--  DDL for Index SS_LEAVEAPP_IDX_004
--------------------------------------------------------

  CREATE INDEX "SELFSERVICE"."SS_LEAVEAPP_IDX_004" ON "SELFSERVICE"."SS_LEAVEAPP" ("EMPNO", "BDATE", "APP_DATE", "EDATE", "LEAVEPERIOD", "APP_NO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
