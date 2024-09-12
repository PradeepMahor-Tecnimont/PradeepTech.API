--------------------------------------------------------
--  DDL for Table ASSETADMIN
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."ASSETADMIN" 
   (	"REGNUM" VARCHAR2(18 BYTE), 
	"COMPANY" VARCHAR2(5 BYTE), 
	"YYYY" CHAR(4 BYTE), 
	"PONUM" VARCHAR2(20 BYTE), 
	"PODATE" DATE, 
	"INVOICENUM" VARCHAR2(20 BYTE), 
	"INVOICEDATE" DATE, 
	"GRNUM" VARCHAR2(20 BYTE), 
	"GRDATE" DATE, 
	"SAPASSETCODE" VARCHAR2(20 BYTE), 
	"PRINTFLAG" NUMBER(1,0) DEFAULT 0
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
