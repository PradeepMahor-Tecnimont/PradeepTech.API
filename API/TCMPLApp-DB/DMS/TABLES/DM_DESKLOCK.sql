--------------------------------------------------------
--  DDL for Table DM_DESKLOCK
--------------------------------------------------------

  CREATE TABLE "DM_DESKLOCK" 
   (	"UNQID" VARCHAR2(20), 
	"EMPNO" CHAR(5), 
	"DESKID" VARCHAR2(7), 
	"TARGETDESK" NUMBER(1,0), 
	"BLOCKFLAG" NUMBER(1,0) DEFAULT 0, 
	"BLOCKREASON" NUMBER(2,0) DEFAULT 0
   ) ;
