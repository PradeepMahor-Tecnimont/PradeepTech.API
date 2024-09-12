--------------------------------------------------------
--  DDL for Table SS_USER_DEPT_RIGHTS
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."SS_USER_DEPT_RIGHTS" 
   (	"EMPNO" CHAR(5 BYTE), 
	"PARENT" CHAR(4 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON TABLE "SELFSERVICE"."SS_USER_DEPT_RIGHTS"  IS 'This table is used to identify the user rights for various departments';
  GRANT SELECT ON "SELFSERVICE"."SS_USER_DEPT_RIGHTS" TO "DMS";
  GRANT UPDATE ON "SELFSERVICE"."SS_USER_DEPT_RIGHTS" TO "TCMPL_APP_CONFIG";
  GRANT SELECT ON "SELFSERVICE"."SS_USER_DEPT_RIGHTS" TO "TCMPL_APP_CONFIG";
  GRANT INSERT ON "SELFSERVICE"."SS_USER_DEPT_RIGHTS" TO "TCMPL_APP_CONFIG";
  GRANT DELETE ON "SELFSERVICE"."SS_USER_DEPT_RIGHTS" TO "TCMPL_APP_CONFIG";
  GRANT SELECT ON "SELFSERVICE"."SS_USER_DEPT_RIGHTS" TO "RWM3";
  GRANT SELECT ON "SELFSERVICE"."SS_USER_DEPT_RIGHTS" TO "REMOTEWORKING";
