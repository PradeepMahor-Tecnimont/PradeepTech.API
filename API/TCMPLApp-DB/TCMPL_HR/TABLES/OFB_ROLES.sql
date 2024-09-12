--------------------------------------------------------
--  DDL for Table OFB_ROLES
--------------------------------------------------------

  CREATE TABLE "TCMPL_HR"."OFB_ROLES" 
   (	"ROLE_ID" CHAR(5), 
	"ROLE_NAME" VARCHAR2(30), 
	"ROLE_DESC" VARCHAR2(200)
   ) ;
  GRANT UPDATE ON "TCMPL_HR"."OFB_ROLES" TO "TCMPL_APP_CONFIG";
  GRANT SELECT ON "TCMPL_HR"."OFB_ROLES" TO "TCMPL_APP_CONFIG";
  GRANT INSERT ON "TCMPL_HR"."OFB_ROLES" TO "TCMPL_APP_CONFIG";
  GRANT DELETE ON "TCMPL_HR"."OFB_ROLES" TO "TCMPL_APP_CONFIG";
