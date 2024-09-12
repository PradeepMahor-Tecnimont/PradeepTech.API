--------------------------------------------------------
--  DDL for Table DM_EMP_LEFT
--------------------------------------------------------

  CREATE TABLE "DM_EMP_LEFT" 
   (	"REQNUM" CHAR(11), 
	"REQDATE" DATE, 
	"REQBY" CHAR(5), 
	"EMPNO" CHAR(5), 
	"DOL" DATE, 
	"ACTION_FLAG" NUMBER DEFAULT 0, 
	"ACTIONBY" CHAR(5), 
	"ACTIONDATE" DATE
   ) ;

   COMMENT ON COLUMN "DM_EMP_LEFT"."ACTION_FLAG" IS '"0" means Live; "1" means Close';
