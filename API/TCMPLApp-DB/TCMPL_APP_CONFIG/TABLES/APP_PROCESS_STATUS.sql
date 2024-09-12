--------------------------------------------------------
--  DDL for Table APP_PROCESS_STATUS
--------------------------------------------------------
CREATE TABLE "TCMPL_APP_CONFIG"."APP_PROCESS_STATUS" 
   (	"STATUS" NUMBER(1,0) NOT NULL ENABLE, 
	"STATUS_DESC" VARCHAR2(20 BYTE) NOT NULL ENABLE, 
	 CONSTRAINT "APP_PROCESS_STATUS_PK" PRIMARY KEY ("STATUS")
   );