--------------------------------------------------------
--  DDL for Table DM_PENDING_PC_LOCK
--------------------------------------------------------

  CREATE TABLE "DM_PENDING_PC_LOCK" 
   (	"EMPNO" CHAR(5), 
	"TDATE" DATE, 
	"PCNAME" VARCHAR2(20), 
	"LOGINID" VARCHAR2(50), 
	"ADD_IN_PC" NUMBER(1,0), 
	"FLAG_UPDATE" NUMBER(1,0), 
	"DESKID" CHAR(6)
   ) ;

   COMMENT ON COLUMN "DM_PENDING_PC_LOCK"."ADD_IN_PC" IS '-1 Stands for user to be removed from Machine  
1  Stands for user to be added to Machine';
