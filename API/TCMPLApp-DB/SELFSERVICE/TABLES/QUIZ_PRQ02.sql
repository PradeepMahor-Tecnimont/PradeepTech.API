--------------------------------------------------------
--  DDL for Table QUIZ_PRQ02
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."QUIZ_PRQ02" 
   (	"EMPNO" VARCHAR2(5 BYTE), 
	"Q01" VARCHAR2(150 BYTE), 
	"Q02" VARCHAR2(150 BYTE), 
	"Q03" VARCHAR2(150 BYTE), 
	"Q04" VARCHAR2(150 BYTE), 
	"Q05" VARCHAR2(150 BYTE), 
	"Q06" VARCHAR2(150 BYTE), 
	"Q07" VARCHAR2(150 BYTE), 
	"Q08" VARCHAR2(150 BYTE), 
	"Q09" VARCHAR2(150 BYTE), 
	"Q10" VARCHAR2(150 BYTE), 
	"Q11" VARCHAR2(150 BYTE), 
	"Q12" VARCHAR2(150 BYTE), 
	"Q13" VARCHAR2(150 BYTE), 
	"Q14" VARCHAR2(150 BYTE), 
	"Q15" VARCHAR2(150 BYTE), 
	"Q16" VARCHAR2(150 BYTE), 
	"Q17" VARCHAR2(150 BYTE), 
	"Q18" VARCHAR2(150 BYTE), 
	"Q19" VARCHAR2(150 BYTE), 
	"Q20" VARCHAR2(150 BYTE), 
	"QUIZSTATUS" NUMBER(1,0), 
	"Quizdate" DATE DEFAULT NULL
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;

   COMMENT ON COLUMN "SELFSERVICE"."QUIZ_PRQ02"."QUIZSTATUS" IS 'null - Not attempted, 0 - Partial attepted, 1 - Done';
