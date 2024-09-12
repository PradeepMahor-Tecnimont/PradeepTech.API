
  CREATE TABLE "TIMECURR"."RAP_OSC_HOURS" 
   (	"OSCH_ID" VARCHAR2(10 BYTE) NOT NULL ENABLE, 
	"OSCD_ID" VARCHAR2(10 BYTE) NOT NULL ENABLE, 
	"YYYYMM" VARCHAR2(6 BYTE) NOT NULL ENABLE, 
	"ORIG_EST_HRS" NUMBER(13,2) NOT NULL ENABLE, 
	"CUR_EST_HRS" NUMBER(13,2) NOT NULL ENABLE, 
	 CONSTRAINT "RAP_OUTSIDE_SUBCONTRACT_HO_PK" PRIMARY KEY ("OSCH_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE, 
	 CONSTRAINT "RAP_OUTSIDE_SUBCONTRACT_H_UK1" UNIQUE ("OSCD_ID", "YYYYMM")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE, 
	 CONSTRAINT "RAP_OUTSIDE_SUBCONTRACT_H_FK1" FOREIGN KEY ("OSCD_ID")
	  REFERENCES "TIMECURR"."RAP_OSC_DETAIL" ("OSCD_ID") ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;

