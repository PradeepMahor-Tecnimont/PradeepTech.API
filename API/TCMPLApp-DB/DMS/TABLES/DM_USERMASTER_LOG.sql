--------------------------------------------------------
--  DDL for Table DM_USERMASTER_LOG
--------------------------------------------------------

  CREATE TABLE "DM_USERMASTER_LOG" 
   (	"EMPNO" CHAR(5), 
	"DESKID" VARCHAR2(7), 
	"COSTCODE" CHAR(4), 
	"DEP_FLAG" NUMBER(1,0), 
	"FLAG" CHAR(1), 
	"LOG_DATE" DATE, 
	"REMARK" VARCHAR2(60)
   ) ;

   COMMENT ON COLUMN "DM_USERMASTER_LOG"."FLAG" IS 'I = Insert; D = Delete';
