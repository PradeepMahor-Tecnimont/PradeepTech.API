--------------------------------------------------------
--  DDL for Index SS_CONTMAST_PK51086329176495
--------------------------------------------------------

  CREATE UNIQUE INDEX "SELFSERVICE"."SS_CONTMAST_PK51086329176495" ON "SELFSERVICE"."SS_CONTMAST" ("EMPNO", "PUNCHNO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
