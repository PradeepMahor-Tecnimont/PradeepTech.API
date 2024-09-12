--------------------------------------------------------
--  DDL for Table EMP_LOCK_STATUS
--------------------------------------------------------

  CREATE TABLE "COMMONMASTERS"."EMP_LOCK_STATUS" 
   (	"EMPNO" VARCHAR2(5), 
	"PRIM_LOCK_OPEN" NUMBER(1,0), 
	"FMLY_LOCK_OPEN" NUMBER(1,0), 
	"NOM_LOCK_OPEN" NUMBER(1,0), 
	"MODIFIED_ON" DATE, 
	"LOGIN_LOCK_OPEN" NUMBER(1,0), 
	"ADHAAR_LOCK" NUMBER(1,0), 
	"PP_LOCK" NUMBER(1,0), 
	"GTLI_LOCK" NUMBER(1,0)
   ) ;
