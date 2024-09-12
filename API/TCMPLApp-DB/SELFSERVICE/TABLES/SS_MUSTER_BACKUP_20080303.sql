--------------------------------------------------------
--  DDL for Table SS_MUSTER_BACKUP_20080303
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."SS_MUSTER_BACKUP_20080303" 
   (	"MNTH" CHAR(6 BYTE), 
	"EMPNO" CHAR(5 BYTE), 
	"SHIFT_4ALLOWANCE" CHAR(62 BYTE), 
	"S_MRK" CHAR(62 BYTE), 
	"W_TM" CHAR(186 BYTE), 
	"O_TM" CHAR(186 BYTE), 
	"LCO_TM" CHAR(186 BYTE), 
	"LGO_TM" CHAR(186 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
