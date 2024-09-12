
  CREATE TABLE "SELFSERVICE"."HSE_QUIZ_QUESTION_MASTER" 
   (	"QUIZ_ID" VARCHAR2(4 BYTE) NOT NULL ENABLE, 
	"QUESTION_ID" VARCHAR2(5 BYTE) NOT NULL ENABLE, 
	"QUESTION_NAME" VARCHAR2(200 BYTE) NOT NULL ENABLE, 
	"CORRECT_ANSWER_ID" NUMBER(2,0) NOT NULL ENABLE, 
	 CONSTRAINT "HSE_QUESTION_MASTER_PK" PRIMARY KEY ("QUIZ_ID", "QUESTION_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE, 
	 CONSTRAINT "HSE_QUESTION_FOREIGN_KEY" FOREIGN KEY ("QUIZ_ID")
	  REFERENCES "SELFSERVICE"."HSE_QUIZ_MASTER" ("QUIZ_ID") ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;

