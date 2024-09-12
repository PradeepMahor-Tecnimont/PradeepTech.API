--------------------------------------------------------
--  DDL for Table DM_DESKMASTER
--------------------------------------------------------

  
  CREATE TABLE "DMS"."DM_DESKMASTER" 
   (	"DESKID" VARCHAR2(7 BYTE) NOT NULL ENABLE, 
	"OFFICE" CHAR(5 BYTE) NOT NULL ENABLE, 
	"FLOOR" VARCHAR2(8 BYTE) NOT NULL ENABLE, 
	"SEATNO" VARCHAR2(10 BYTE) NOT NULL ENABLE, 
	"WING" VARCHAR2(5 BYTE), 
	"ASSETCODE" VARCHAR2(20 BYTE), 
	"NOEXIST" CHAR(1 BYTE), 
	"CABIN" CHAR(1 BYTE), 
	"REMARKS" VARCHAR2(20 BYTE), 
	"DESKID_OLD" VARCHAR2(7 BYTE), 
	"WORK_AREA" CHAR(3 BYTE), 
	"BAY" VARCHAR2(20 BYTE), 
	 CONSTRAINT "DM_DESKMASTER_PK" PRIMARY KEY ("DESKID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE, 
	 CONSTRAINT "DM_DESKMASTER_UK1" UNIQUE ("SEATNO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE, 
	 CONSTRAINT "DM_DESKMASTER_FK1" FOREIGN KEY ("WORK_AREA")
	  REFERENCES "DMS"."DM_DESK_AREAS" ("AREA_KEY_ID") ENABLE, 
	 CONSTRAINT "DM_DESKMASTER_FK2" FOREIGN KEY ("BAY")
	  REFERENCES "DMS"."DM_DESK_BAYS" ("BAY_DESC") ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 262144 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;


  GRANT SELECT ON "DMS"."DM_DESKMASTER" TO "SELFSERVICE" WITH GRANT OPTION;
