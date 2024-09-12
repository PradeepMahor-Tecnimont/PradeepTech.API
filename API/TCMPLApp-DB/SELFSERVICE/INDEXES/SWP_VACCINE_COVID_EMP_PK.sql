--------------------------------------------------------
--  DDL for Index SWP_VACCINE_COVID_EMP_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "SELFSERVICE"."SWP_VACCINE_COVID_EMP_PK" ON "SELFSERVICE"."SWP_VACCINE_COVID_EMP" ("EMPNO", "COVID_START_DATE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
