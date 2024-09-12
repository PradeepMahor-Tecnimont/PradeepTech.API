--------------------------------------------------------
--  DDL for Table DM_ACTION_TYPE
--------------------------------------------------------

  CREATE TABLE "DM_ACTION_TYPE" 
   (	"TYPEID" NUMBER(2,0), 
	"DESCRIPTION" VARCHAR2(50), 
	"OUTOFSERVICE_FLAG" NUMBER(1,0)
   ) ;

   COMMENT ON COLUMN "DM_ACTION_TYPE"."OUTOFSERVICE_FLAG" IS '1 is out_of_service, -1 is non ou_of_service';
