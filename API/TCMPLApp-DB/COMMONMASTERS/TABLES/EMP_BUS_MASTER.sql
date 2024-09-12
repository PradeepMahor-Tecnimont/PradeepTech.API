--------------------------------------------------------
--  DDL for Table EMP_BUS_MASTER
--------------------------------------------------------

  CREATE TABLE "COMMONMASTERS"."EMP_BUS_MASTER" 
   (	"CODE" CHAR(5), 
	"DESCRIPTION" VARCHAR2(60)
   ) ;

   COMMENT ON COLUMN "COMMONMASTERS"."EMP_BUS_MASTER"."CODE" IS 'Code of the Office Bus';
   COMMENT ON COLUMN "COMMONMASTERS"."EMP_BUS_MASTER"."DESCRIPTION" IS 'Description of the Bus';
