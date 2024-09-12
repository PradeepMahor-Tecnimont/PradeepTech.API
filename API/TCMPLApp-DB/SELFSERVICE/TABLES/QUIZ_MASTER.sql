--------------------------------------------------------
--  DDL for Table QUIZ_MASTER
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."QUIZ_MASTER" 
   (	"QUIZID" VARCHAR2(6 BYTE), 
	"QID" NUMBER, 
	"QTEXT" VARCHAR2(250 BYTE), 
	"OP1" VARCHAR2(150 BYTE), 
	"OP2" VARCHAR2(150 BYTE), 
	"OP3" VARCHAR2(150 BYTE), 
	"OP4" VARCHAR2(150 BYTE), 
	"ANS" VARCHAR2(150 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
