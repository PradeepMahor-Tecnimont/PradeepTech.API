--------------------------------------------------------
--  DDL for Table APP_PROCESS_QUEUE_LOG
--------------------------------------------------------
CREATE TABLE "TCMPL_APP_CONFIG"."APP_PROCESS_QUEUE_LOG" 
   (	"KEY_ID" VARCHAR2(8 BYTE) NOT NULL ENABLE, 
	"PROCESS_LOG" VARCHAR2(4000 BYTE) NOT NULL ENABLE, 
	"PROCESS_LOG_TYPE" CHAR(1 BYTE) NOT NULL ENABLE, 
	"CREATED_ON" DATE NOT NULL ENABLE, 
	 CONSTRAINT "FK_REPORT_PROCESS_KEY_ID" FOREIGN KEY ("KEY_ID")
	  REFERENCES "TCMPL_APP_CONFIG"."APP_PROCESS_QUEUE" ("KEY_ID") ENABLE
   ) ;